pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "src/interfaces/IPaymentProcessorEvents.sol";
import "src/Constants.sol";
import "src/PaymentProcessor.sol";
import "src/PaymentProcessorConfiguration.sol";
import "src/PaymentProcessorEncoder.sol";
import "src/modules/ModuleOnChainCancellation.sol";
import "src/modules/ModuleBuyListings.sol";
import "src/modules/ModuleAcceptOffers.sol";
import "src/modules/ModuleSweeps.sol";
import {
    CollectionSettingsRegistry, 
    CollectionRegistryPaymentSettings,
    RegistryPricingBounds,
    CollectionRegistryPaymentSettings,
    RegistryPricingBounds,
    CollectionSettingsRegistry__PaymentMethodWhitelistOwnershipCannotBeTransferredToZeroAddress,
    CollectionSettingsRegistry__CallerDoesNotOwnPaymentMethodWhitelist
} from "src/settings-registry/CollectionSettingsRegistry.sol";
import "src/settings-registry/ICollectionSettingsRegistry.sol";

import "../mocks/ContractMock.sol";
import "../mocks/SeaportTestERC20.sol";
import {SeaportTestERC721} from "test/mocks/SeaportTestERC721.sol";
import {SeaportTestERC721Without2981} from "test/mocks/SeaportTestERC721Without2981.sol";
import {SeaportTestERC1155} from "test/mocks/SeaportTestERC1155.sol";
import {SeaportTestERC1155Without2981} from "test/mocks/SeaportTestERC1155Without2981.sol";

import {TrustedForwarder} from "@limitbreak/trusted-forwarder/TrustedForwarder.sol";
import {TrustedForwarderFactory} from "@limitbreak/trusted-forwarder/TrustedForwarderFactory.sol";

import { PermitC } from "@limitbreak/permit-c/PermitC.sol";
import "@limitbreak/permit-c/Errors.sol";

import {IWrappedNativeExtended} from "@limitbreak/wrapped-native/interfaces/IWrappedNativeExtended.sol";
import {RoleServer} from "@limitbreak/tm-role-server/RoleServer.sol";

contract PaymentProcessorModuleTest is Test, IPaymentProcessorEvents {

    struct FuzzedOrder721 {
        bool buyerIsContract;
        uint24  marketplaceFeeRate;
        uint24  royaltyFeeRate;
        uint160 sellerKey;
        uint32  expirationSeconds;
        uint160 buyerKey;
        uint256 tokenId;
        uint128 itemPrice;
        address beneficiary;
        uint160 cosignerKey;
        address marketplace;
        address royaltyReceiver;
    }

    struct FuzzedFeeOnTop {
        uint24 rate;
        address receiver;
    }

    struct TestTradeSingleItemParams {
        uint8 paymentSettings;
        uint256 orderProtocol;
        bool cosigned;
        bool isCosignatureEmpty;
        address paymentMethod;
        uint248 amount;
        uint248 fillAmount;
        FuzzedOrder721 fuzzedOrderInputs;
    }

    struct TestTokenSetProof {
        bytes32 rootHash;
        bytes32[] proof;
    }

    bytes4 internal constant EMPTY_SELECTOR = bytes4(0x00000000);

    uint256 constant MAX_INT = ~uint256(0);

    uint256 internal alicePk = 0xa11ce;
    uint256 internal bobPk = 0xb0b;
    uint256 internal calPk = 0xca1;
    uint256 internal abePk = 0xabe;
    uint256 internal benchmarkBeneficiaryPk = 0xbe2ef;
    uint256 internal cosignerPk = 0xc0519;
    uint256 internal feePk = 0xfee3;
    uint256 internal infraFeePk = 0xfee4;
    address payable internal alice = payable(vm.addr(alicePk));
    address payable internal bob = payable(vm.addr(bobPk));
    address payable internal cal = payable(vm.addr(calPk));
    address payable internal abe = payable(vm.addr(abePk));
    address payable internal benchmarkBeneficiary = payable(vm.addr(benchmarkBeneficiaryPk));
    address payable internal cosigner = payable(vm.addr(cosignerPk));
    address payable internal benchmarkFeeRecipient = payable(vm.addr(feePk));
    address payable internal infrastructureFeeRecipient = payable(vm.addr(infraFeePk));

    PaymentProcessorConfiguration public _paymentProcessorConfiguration;
    PaymentProcessor public _paymentProcessor;
    PaymentProcessorEncoder public _paymentProcessorEncoder;

    IWrappedNativeExtended public nativeWrapper;

    SeaportTestERC20 public weth;
    SeaportTestERC20 public usdc;
    SeaportTestERC20 public usdt;
    SeaportTestERC20 public dai;
    SeaportTestERC20 public memecoin;

    SeaportTestERC721 public test721;
    SeaportTestERC1155 public test1155;
    SeaportTestERC721Without2981 public test721Without2981;
    SeaportTestERC1155Without2981 public test1155Without2981;

    SeaportTestERC20[] erc20s;
    SeaportTestERC721[] erc721s;
    SeaportTestERC1155[] erc1155s;

    TrustedForwarderFactory public factory;
    address public forwarderImplementation;
    TrustedForwarder public forwarder;
    address channel;
    address trustedChannel;
    address untrustedChannel;

    PermitC public permitC;
    RoleServer public roleServer;

    CollectionSettingsRegistry public collectionSettingsRegistry;
    PaymentProcessorModule public moduleOnChainCancellation;
    PaymentProcessorModule public moduleBuyListings;
    PaymentProcessorModule public moduleAcceptOffers;
    PaymentProcessorModule public moduleSweeps;

    address contractMock;

    uint32 public customPaymentMethodWhitelistId;

    mapping (address => uint256) internal _nextAvailableTokenId;
    mapping (address => uint256) internal _nonces;

    function setUp() public virtual {
        roleServer = new RoleServer(address(this));
        roleServer.setRoleHolder(FEE_MANAGER, address(this), new IRoleClient[](0));

        permitC = new PermitC("Test", "1", address(0), 0);
        permitC.registerAdditionalDataHash("SaleApproval approval)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)");

        bytes memory wrappedNativeBytecode = hex"60806040526004361015610026575b361561001e5761001c610caa565b005b61001c610a8d565b5f3560e01c8063095ea7b31461010557806323b872dd146101005780632e1a7d4d146100fb57806370a08231146100f6578063a9059cbb146100f1578063b760faf9146100ec578063c2b1a472146100e7578063d0e30db0146100e2578063d4229c24146100dd578063dd62ed3e146100d8578063e06cbc62146100d3578063e5fe69fe146100ce578063f38e809d146100c95763facb18e30361000e576109a0565b610906565b6108cb565b61072d565b6106ac565b610500565b6104a0565b610458565b61041a565b610375565b61030e565b6102d2565b6101c2565b61012c565b73ffffffffffffffffffffffffffffffffffffffff81160361012857565b5f80fd5b60407ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc360112610128576004356101628161010a565b602435346101b4575b335f52600360205260405f20602052815f528060405f20555f52337f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b92560205fa360015f5260205ff35b6101bd33610a51565b61016b565b60607ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc360112610128576004356101f88161010a565b602435906102058261010a565b604435346102c4575b825f52600260205260405f20818154019055815f5260405f20805482811061012857829003905533820361026d575b5f527fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef60205fa360015f5260205ff35b600360205260405f20602052335f5260405f2080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff81036102b1575b505061023d565b8281106101285782900390555f806102aa565b6102cd82610a51565b61020e565b346101285760207ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc3601126101285761001c6004353333610ef9565b346101285760207ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc3601126101285773ffffffffffffffffffffffffffffffffffffffff60043561035e8161010a565b165f526002602052602060405f2054604051908152f35b60407ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc360112610128576004356103ab8161010a565b6024353461040c575b815f52600260205260405f20818154019055335f5260405f2080548281106101285782900390555f52337fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef60205fa360015f5260205ff35b61041533610a51565b6103b4565b60207ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc3601126101285761001c6004356104538161010a565b610a51565b346101285760407ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc3601126101285761001c6004356104968161010a565b6024359033610ef9565b5f7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc3601126101285761001c33610a51565b9181601f840112156101285782359167ffffffffffffffff8311610128576020838186019501011161012857565b60e07ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc360112610128576004356105368161010a565b6024356105428161010a565b604435906064359260843560a4359060c43567ffffffffffffffff8111610128576105719036906004016104d2565b913461069e575b8342118015610695575b8015610677575b6101285761001c9761067294610664836105a661066c958a610f4a565b73ffffffffffffffffffffffffffffffffffffffff89165f525f60205261063860405f205460405194859360208501973389919260a093969594919673ffffffffffffffffffffffffffffffffffffffff60c08501987f3c038916d033a3e04838da5aca7b9a42656eeae3b520daf7ed52ec02fd37fb9486521660208501526040840152606083015260808201520152565b037fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe08101835282610afe565b519020610fda565b8461101b565b611116565b5073ffffffffffffffffffffffffffffffffffffffff851615610589565b50878711610582565b6106a785610a51565b610578565b346101285760407ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc360112610128576004356106e78161010a565b602435906106f48261010a565b73ffffffffffffffffffffffffffffffffffffffff8091165f52600360205260405f2091165f52602052602060405f2054604051908152f35b3461012857610100807ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc360112610128576004359061076b8261010a565b6024356107778161010a565b6084359260a4359260443560643561078e8661010a565b60c4359160e43567ffffffffffffffff8111610128576107b29036906004016104d2565b899199421180156108ad575b6101285761001c9961086a8561087094610875996107dd8e998d610f4a565b8c8c73ffffffffffffffffffffffffffffffffffffffff91828092165f525f60205260405f20546040519560208701977fe55aaa79350b0eb9ee70c987c9b0603c46531ab71d2b7c5404835db2f60e220c89523360408901528d6060890152608088015260a087015260c08601521660e08401528916908201526101208981830152815261066481610ae1565b8861101b565b611168565b9194908061089c575b50508061088c575b50610ef9565b61089690826110a8565b5f610886565b6108a69184611116565b5f8061087e565b5073ffffffffffffffffffffffffffffffffffffffff8716156107be565b346101285760207ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc3601126101285761001c60043533610f4a565b34610128575f7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc36011261012857335f525f60205260405f20805490816001019055337f9614574d6542397172c19ba2bf4588434feeb977576e92b7b59b38242ab596095f80a3005b9181601f840112156101285782359167ffffffffffffffff8311610128576020808501948460051b01011161012857565b346101285760407ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc3601126101285767ffffffffffffffff600435818111610128576109f090369060040161096f565b909160243590811161012857610a0a90369060040161096f565b90818303610128575f5b838110610a1d57005b80610a4b610a2e6001938789610b3f565b35610a388161010a565b610a43838787610b3f565b359033610ef9565b01610a14565b805f52600260205260405f20348154019055345f527fe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c60205fa2565b610a9633610a51565b565b6040810190811067ffffffffffffffff821117610ab457604052565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52604160045260245ffd5b610140810190811067ffffffffffffffff821117610ab457604052565b90601f7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0910116810190811067ffffffffffffffff821117610ab457604052565b9190811015610b4f5760051b0190565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52603260045260245ffd5b60405190610b8982610a98565b600782527f574e4154495645000000000000000000000000000000000000000000000000006020830152565b6020808252825181830181905293925f5b858110610c05575050507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0601f845f6040809697860101520116010190565b818101830151848201604001528201610bc6565b60405190610c2682610a98565b600e82527f57726170706564204e61746976650000000000000000000000000000000000006020830152565b91909182600411610128578211610128577ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc6004920190565b91908260409103126101285760208235610ca48161010a565b92013590565b3415610cb857610a96610a8d565b5f357fffffffff00000000000000000000000000000000000000000000000000000000167fcab7e8eb000000000000000000000000000000000000000000000000000000008103610d9c5760018073ffffffffffffffffffffffffffffffffffffffff60ff610d8f610d5e610d38610d303636610c52565b810190610c8b565b941673ffffffffffffffffffffffffffffffffffffffff165f52600160205260405f2090565b8360081c7effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff165f5260205260405f2090565b5491161c16145f5260205ff35b7f45253c53000000000000000000000000000000000000000000000000000000008103610dee5773ffffffffffffffffffffffffffffffffffffffff600435165f525f60205260405f20545f5260205ff35b7f18160ddd000000000000000000000000000000000000000000000000000000008103610e1d57475f5260205ff35b7f78e890ba000000000000000000000000000000000000000000000000000000008103610e5357610e4c611226565b5f5260205ff35b7f06fdde03000000000000000000000000000000000000000000000000000000008103610e9b57610e82610c19565b604051610e9781610638602082019485610bb5565b5190f35b7f95d89b41000000000000000000000000000000000000000000000000000000008103610eca57610e82610b7c565b7f313ce56700000000000000000000000000000000000000000000000000000000036101285760125f5260205ff35b90915f80808093858252600260205260408220968754968288038099558284527f7fcf532c15f0a6db0bd6d0e038bea71d30d808c7d98cb3bf7268a95bf5081b65602085a25af11591111761012857565b600160ff83161b73ffffffffffffffffffffffffffffffffffffffff82165f526001602052610fa760405f208460081c7effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff165f5260205260405f2090565b818154188091551615610128577f8dc5a0b2e80f26187d38744e9559150e3bd6e06fccefbe737fd33411cfb151515f80a3565b604290610fe5611226565b90604051917f19010000000000000000000000000000000000000000000000000000000000008352600283015260228201522090565b929190604183036110875761103d6020830135833560408501355f1a8461136e565b73ffffffffffffffffffffffffffffffffffffffff8681169116148015919061107f575b5061106d575b50505050565b61107693611318565b5f808080611067565b90505f611061565b6040830361109f5761103d6020830135833583611332565b610a9693611318565b60026020527fac33ff75c19e70fe83507db0d683fd3465c996598dc972688b7ace676c89077b8054830190555f818152604090208054929081841061012857815f9403905582527fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef602083a3565b9091825f52600260205260405f20818154019055815f5260405f2080548281106101285782900390555f527fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef60205fa3565b915f61271092838311610128577dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff85116101285773ffffffffffffffffffffffffffffffffffffffff161561121e575b60098211156111d757508190830204906103e8820204808092038093030392565b9291811561121457829350807fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff9304928392018402048093030392565b9050810480910392565b5f91506111b6565b467f000000000000000000000000000000000000000000000000000000000000000003611271577f000000000000000000000000000000000000000000000000000000000000000090565b60405160208101907f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f82527f000000000000000000000000000000000000000000000000000000000000000060408201527f000000000000000000000000000000000000000000000000000000000000000060608201524660808201523060a082015260a0815260c0810181811067ffffffffffffffff821117610ab45760405251902090565b929190833b156101285761132b936113f3565b1561012857565b9061136a929160ff601b7f7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff851694821c01169061136e565b9091565b7f7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a084116113e8576020935f9360ff60809460405194855216868401526040830152606082015282805260015afa156113dd575f5173ffffffffffffffffffffffffffffffffffffffff81161591565b6040513d5f823e3d90fd5b505050506001905f90565b5f90602092937fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0601f5f989780604051947f1626ba7e00000000000000000000000000000000000000000000000000000000998a875260048701526040602487015281604487015260648601370116606481830101604052606401915afa60203d10151661147e5750565b5f5114915056fea2646970667358221220a6c6bbfb568165691c251ee317c72b8c42ef405cf848fff5e19d5f2f94dcf38664736f6c63430008180033";
        vm.etch(address(0x1234567812345678123456781234567812345678), wrappedNativeBytecode);
        nativeWrapper = IWrappedNativeExtended(address(0x1234567812345678123456781234567812345678));

        weth = new SeaportTestERC20();
        usdc = new SeaportTestERC20();
        usdt = new SeaportTestERC20();
        dai = new SeaportTestERC20();
        memecoin = new SeaportTestERC20();

        erc20s = [weth, usdc, usdt, dai, memecoin];

        test721 = new SeaportTestERC721();
        test721Without2981 = new SeaportTestERC721Without2981();

        erc721s = [test721];

        test1155 = new SeaportTestERC1155();
        test1155Without2981 = new SeaportTestERC1155Without2981();

        erc1155s = [test1155];

        _paymentProcessorConfiguration = new PaymentProcessorConfiguration(address(this));

        forwarderImplementation = address(new TrustedForwarder());
        TrustedForwarder(forwarderImplementation).__TrustedForwarder_init(address(this), address(this));

        factory = new TrustedForwarderFactory(forwarderImplementation);
        channel = factory.cloneTrustedForwarder(address(this), address(0), bytes32(0));
        trustedChannel = factory.cloneTrustedForwarder(address(this), address(0), bytes32(0x0000000000000000000000000000000000000000000000000000000000000001));
        untrustedChannel = factory.cloneTrustedForwarder(address(this), address(0), bytes32(0x0000000000000000000000000000000000000000000000000000000000000002));

        contractMock = address(new ContractMock());

        _paymentProcessorEncoder = new PaymentProcessorEncoder();

        collectionSettingsRegistry = new CollectionSettingsRegistry(address(this));

        _paymentProcessorConfiguration.setPaymentProcessorModuleConfiguration(
            address(this), // NOTE: This will be a deterministic address in production
            address(factory),
            address(nativeWrapper),
            address(weth),
            address(usdc),
            address(usdt),
            address(dai),
            address(permitC),
            address(permitC),
            address(collectionSettingsRegistry),
            infrastructureFeeRecipient
        );

        moduleOnChainCancellation = new ModuleOnChainCancellation(address(_paymentProcessorConfiguration));
        moduleBuyListings = new ModuleBuyListings(address(_paymentProcessorConfiguration));
        moduleAcceptOffers = new ModuleAcceptOffers(address(_paymentProcessorConfiguration));
        moduleSweeps = new ModuleSweeps(address(_paymentProcessorConfiguration));

        _paymentProcessorConfiguration.setPaymentProcessorConfiguration(
            address(this),
            PaymentProcessorModules({
                moduleOnChainCancellation: address(moduleOnChainCancellation),
                moduleBuyListings: address(moduleBuyListings),
                moduleAcceptOffers: address(moduleAcceptOffers),
                moduleSweeps: address(moduleSweeps)
            })
        );

        _paymentProcessor = new PaymentProcessor(address(_paymentProcessorConfiguration), address(roleServer));

        vm.label(alice, "alice");
        vm.label(bob, "bob");
        vm.label(cal, "cal");
        vm.label(abe, "abe");
        vm.label(address(this), "testContract");

        _allocateTokensAndApprovals(address(this), uint128(MAX_INT));
        _allocateTokensAndApprovals(alice, uint128(MAX_INT));
        _allocateTokensAndApprovals(bob, uint128(MAX_INT));
        _allocateTokensAndApprovals(cal, uint128(MAX_INT));
        _allocateTokensAndApprovals(abe, uint128(MAX_INT));
        _allocateTokensAndApprovals(benchmarkFeeRecipient, uint128(MAX_INT));
        _allocateTokensAndApprovals(infrastructureFeeRecipient, uint128(MAX_INT));

        customPaymentMethodWhitelistId = collectionSettingsRegistry.createPaymentMethodWhitelist("Test Whitelist");

        _whitelistPaymentMethod(address(this), customPaymentMethodWhitelistId, address(0), true);
        _whitelistPaymentMethod(address(this), customPaymentMethodWhitelistId, address(weth), true);
        _whitelistPaymentMethod(address(this), customPaymentMethodWhitelistId, address(usdc), true);
        _whitelistPaymentMethod(address(this), customPaymentMethodWhitelistId, address(usdt), true);
        _whitelistPaymentMethod(address(this), customPaymentMethodWhitelistId, address(dai), true);
    }

    function _whitelistPaymentMethod(address caller, uint32 whitelistId, address paymentMethod, bool sync) internal {
        address[] memory paymentMethods = new address[](1);
        paymentMethods[0] = paymentMethod;

        address[] memory paymentProcessorsToSync;
        if(sync) {
            paymentProcessorsToSync = new address[](1);
            paymentProcessorsToSync[0] = address(_paymentProcessor);
        }

        vm.prank(caller);
        collectionSettingsRegistry.whitelistPaymentMethod(whitelistId, paymentMethods, paymentProcessorsToSync);
    }

    function _unwhitelistPaymentMethod(address caller, uint32 whitelistId, address paymentMethod, bool sync) internal {
        address[] memory paymentMethods = new address[](1);
        paymentMethods[0] = paymentMethod;

        address[] memory paymentProcessorsToSync;
        if(sync) {
            paymentProcessorsToSync = new address[](1);
            paymentProcessorsToSync[0] = address(_paymentProcessor);
        }

        vm.prank(caller);
        collectionSettingsRegistry.unwhitelistPaymentMethod(whitelistId, paymentMethods, paymentProcessorsToSync);
    }

    function _addTrustedChannelForCollection(address caller, address tokenAddress, address channel, bool sync) internal {
        address[] memory channels = new address[](1);
        channels[0] = channel;

        address[] memory paymentProcessorsToSync;
        if(sync) {
            paymentProcessorsToSync = new address[](1);
            paymentProcessorsToSync[0] = address(_paymentProcessor);
        }

        vm.prank(caller);
        collectionSettingsRegistry.addTrustedChannelForCollection(tokenAddress, channels, paymentProcessorsToSync);
    }

    function _removeTrustedChannelForCollection(address caller, address tokenAddress, address channel, bool sync) internal {
        address[] memory channels = new address[](1);
        channels[0] = channel;

        address[] memory paymentProcessorsToSync;
        if(sync) {
            paymentProcessorsToSync = new address[](1);
            paymentProcessorsToSync[0] = address(_paymentProcessor);
        }

        vm.prank(caller);
        collectionSettingsRegistry.removeTrustedChannelForCollection(tokenAddress, channels, paymentProcessorsToSync);
    }

    function _addTrustedPermitProcessor(address caller, address permitProcessor, bool sync) internal {
        address[] memory permitProcessors = new address[](1);
        permitProcessors[0] = permitProcessor;

        address[] memory paymentProcessorsToSync;
        if(sync) {
            paymentProcessorsToSync = new address[](1);
            paymentProcessorsToSync[0] = address(_paymentProcessor);
        }

        vm.prank(caller);
        collectionSettingsRegistry.addTrustedPermitProcessors(permitProcessors, paymentProcessorsToSync);
    }

    function _removeTrustedPermitProcessor(address caller, address permitProcessor, bool sync) internal {
        address[] memory permitProcessors = new address[](1);
        permitProcessors[0] = permitProcessor;

        address[] memory paymentProcessorsToSync;
        if(sync) {
            paymentProcessorsToSync = new address[](1);
            paymentProcessorsToSync[0] = address(_paymentProcessor);
        }

        vm.prank(caller);
        collectionSettingsRegistry.removeTrustedPermitProcessors(permitProcessors, paymentProcessorsToSync);
    }

    /**
     * @dev allocate amount of each token, 1 of each 721, and 1, 5, and 10 of respective 1155s
     */
    function _allocateTokensAndApprovals(address _to, uint256 _amount) internal {
        vm.deal(_to, _amount);
        for (uint256 i = 0; i < erc20s.length; ++i) {
            erc20s[i].mint(_to, _amount);
        }
        _setApprovals(_to);
    }

    function _setApprovals(address _owner) internal virtual {
        vm.startPrank(_owner);
        IERC20(address(nativeWrapper)).approve(address(_paymentProcessor), MAX_INT);
        for (uint256 i = 0; i < erc20s.length; ++i) {
            erc20s[i].approve(address(_paymentProcessor), MAX_INT);
        }
        for (uint256 i = 0; i < erc721s.length; ++i) {
            erc721s[i].setApprovalForAll(address(_paymentProcessor), true);
            erc721s[i].setApprovalForAll(address(permitC), true);
        }
        for (uint256 i = 0; i < erc1155s.length; ++i) {
            erc1155s[i].setApprovalForAll(address(_paymentProcessor), true);
            erc1155s[i].setApprovalForAll(address(permitC), true);
        }
        test721Without2981.setApprovalForAll(address(_paymentProcessor), true);
        test721Without2981.setApprovalForAll(address(permitC), true);
        test1155Without2981.setApprovalForAll(address(_paymentProcessor), true);
        test1155Without2981.setApprovalForAll(address(permitC), true);
        vm.stopPrank();
    }

    function _getNextNonce(address account) internal returns (uint256) {
        uint256 nextUnusedNonce = _nonces[account];
        ++_nonces[account];
        return nextUnusedNonce;
    }
    
    function _getNextAvailableTokenId(address collection) internal returns (uint256) {
        uint256 nextTokenId = _nextAvailableTokenId[collection];
        ++_nextAvailableTokenId[collection];
        return nextTokenId;
    }

    function _getSignedSaleApproval(uint256 sellerKey_, Order memory saleDetails) internal view returns (SignatureECDSA memory) {
        (SignatureECDSA memory signedListing,) = _getSignedSaleApprovalAndDigest(sellerKey_, saleDetails);
        return signedListing;
    }

    function _getSignedSaleApprovalAndDigest(uint256 sellerKey_, Order memory saleDetails) internal view returns (SignatureECDSA memory, bytes32 orderHash) {
        orderHash = 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            SALE_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            address(0),
                            saleDetails.maker,
                            saleDetails.marketplace,
                            saleDetails.fallbackRoyaltyRecipient,
                            saleDetails.paymentMethod,
                            saleDetails.tokenAddress,
                            saleDetails.tokenId
                        ),
                        abi.encode(
                            saleDetails.amount,
                            saleDetails.itemPrice,
                            saleDetails.expiration,
                            saleDetails.marketplaceFeeNumerator,
                            saleDetails.maxRoyaltyFeeNumerator,
                            saleDetails.nonce,
                            _paymentProcessor.masterNonces(saleDetails.maker),
                            saleDetails.protocolFeeVersion
                        )
                    )
                );
        
        bytes32 digest = 
            ECDSA.toTypedDataHash(
                _paymentProcessor.getDomainSeparator(), 
                orderHash
            );
    
        (uint8 listingV, bytes32 listingR, bytes32 listingS) = vm.sign(sellerKey_, digest);
        SignatureECDSA memory signedListing = SignatureECDSA({v: listingV, r: listingR, s: listingS});
    
        return (signedListing, orderHash);
    }

    function _getCosignature(uint256 cosignerKey_, SignatureECDSA memory signature, uint256 cosignatureExpiration, address cosignatureTaker) internal view returns (Cosignature memory) {
        bytes32 cosignatureDigest = 
            ECDSA.toTypedDataHash(
                _paymentProcessor.getDomainSeparator(), 
                keccak256(
                    abi.encode(
                        COSIGNATURE_HASH,
                        signature.v,
                        signature.r,
                        signature.s,
                        cosignatureExpiration,
                        cosignatureTaker
                    )
                )
            );

        (uint8 cosignatureV, bytes32 cosignatureR, bytes32 cosignatureS) = vm.sign(cosignerKey_, cosignatureDigest);
        Cosignature memory cosignature = 
            Cosignature({
                signer: vm.addr(cosignerKey_), 
                taker: cosignatureTaker,
                expiration: cosignatureExpiration, 
                v: cosignatureV, 
                r: cosignatureR, 
                s: cosignatureS
            });

        return cosignature;
    }

    function _getCosignedSaleApproval(uint256 signerKey_, uint256 cosignerKey_, Order memory saleDetails, address taker) internal view returns (SignatureECDSA memory, Cosignature memory) {
        
        bytes32 listingDigest = 
            ECDSA.toTypedDataHash(
                _paymentProcessor.getDomainSeparator(), 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            SALE_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            vm.addr(cosignerKey_),
                            saleDetails.maker,
                            saleDetails.marketplace,
                            saleDetails.fallbackRoyaltyRecipient,
                            saleDetails.paymentMethod,
                            saleDetails.tokenAddress,
                            saleDetails.tokenId
                        ),
                        abi.encode(
                            saleDetails.amount,
                            saleDetails.itemPrice,
                            saleDetails.expiration,
                            saleDetails.marketplaceFeeNumerator,
                            saleDetails.maxRoyaltyFeeNumerator,
                            saleDetails.nonce,
                            _paymentProcessor.masterNonces(saleDetails.maker),
                            saleDetails.protocolFeeVersion
                        )
                    )
                )
            );
    
        (uint8 listingV, bytes32 listingR, bytes32 listingS) = vm.sign(signerKey_, listingDigest);
        SignatureECDSA memory signedSaleApproval = SignatureECDSA({v: listingV, r: listingR, s: listingS});
    
        return (
            signedSaleApproval, 
            _getCosignature(cosignerKey_, signedSaleApproval, block.timestamp + 10 minutes, taker));
    }

    function _getCosignedItemOffer(uint256 signerKey_, uint256 cosignerKey_, Order memory saleDetails, address taker) internal view returns (SignatureECDSA memory, Cosignature memory) {
        bytes32 offerDigest = 
            ECDSA.toTypedDataHash(
                _paymentProcessor.getDomainSeparator(), 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            ITEM_OFFER_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            vm.addr(cosignerKey_),
                            saleDetails.maker,
                            saleDetails.beneficiary,
                            saleDetails.marketplace,
                            saleDetails.fallbackRoyaltyRecipient,
                            saleDetails.paymentMethod,
                            saleDetails.tokenAddress
                        ),
                        abi.encode(
                            saleDetails.tokenId,
                            saleDetails.amount,
                            saleDetails.itemPrice,
                            saleDetails.expiration,
                            saleDetails.marketplaceFeeNumerator,
                            saleDetails.nonce,
                            _paymentProcessor.masterNonces(saleDetails.maker)
                        )
                    )
                )
            );
    
        (uint8 offerV, bytes32 offerR, bytes32 offerS) = vm.sign(signerKey_, offerDigest);
        SignatureECDSA memory signedOffer = SignatureECDSA({v: offerV, r: offerR, s: offerS});

        return (
            signedOffer, 
            _getCosignature(cosignerKey_, signedOffer, block.timestamp + 10 minutes, taker));
    }

    function _getCosignedCollectionOffer(uint256 signerKey_, uint256 cosignerKey_, Order memory saleDetails, address taker) internal view returns (SignatureECDSA memory, Cosignature memory) {
        bytes32 offerDigest = 
            ECDSA.toTypedDataHash(
                _paymentProcessor.getDomainSeparator(), 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            COLLECTION_OFFER_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            vm.addr(cosignerKey_),
                            saleDetails.maker,
                            saleDetails.beneficiary,
                            saleDetails.marketplace,
                            saleDetails.fallbackRoyaltyRecipient,
                            saleDetails.paymentMethod,
                            saleDetails.tokenAddress
                        ),
                        abi.encode(
                            saleDetails.amount,
                            saleDetails.itemPrice,
                            saleDetails.expiration,
                            saleDetails.marketplaceFeeNumerator,
                            saleDetails.nonce,
                            _paymentProcessor.masterNonces(saleDetails.maker)
                        )
                    )
                )
            );
    
        (uint8 offerV, bytes32 offerR, bytes32 offerS) = vm.sign(signerKey_, offerDigest);
        SignatureECDSA memory signedOffer = SignatureECDSA({v: offerV, r: offerR, s: offerS});

        return (
            signedOffer, 
            _getCosignature(cosignerKey_, signedOffer, block.timestamp + 10 minutes, taker));
    }

    function _getCosignedTokenSetOffer(uint256 signerKey_, uint256 cosignerKey_, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, address taker) internal view returns (SignatureECDSA memory, Cosignature memory) {
        bytes32 offerDigest = 
            ECDSA.toTypedDataHash(
                _paymentProcessor.getDomainSeparator(), 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            TOKEN_SET_OFFER_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            vm.addr(cosignerKey_),
                            saleDetails.maker,
                            saleDetails.beneficiary,
                            saleDetails.marketplace,
                            saleDetails.fallbackRoyaltyRecipient,
                            saleDetails.paymentMethod,
                            saleDetails.tokenAddress
                        ),
                        abi.encode(
                            saleDetails.amount,
                            saleDetails.itemPrice,
                            saleDetails.expiration,
                            saleDetails.marketplaceFeeNumerator,
                            saleDetails.nonce,
                            _paymentProcessor.masterNonces(saleDetails.maker),
                            tokenSetProof.rootHash
                        )
                    )
                )
            );
    
        (uint8 offerV, bytes32 offerR, bytes32 offerS) = vm.sign(signerKey_, offerDigest);
        SignatureECDSA memory signedOffer = SignatureECDSA({v: offerV, r: offerR, s: offerS});

        return (
            signedOffer, 
            _getCosignature(cosignerKey_, signedOffer, block.timestamp + 10 minutes, taker));
    }

    function _getSignedItemOffer(uint256 buyerKey_, Order memory saleDetails) internal view returns (SignatureECDSA memory) {
        bytes32 offerDigest = 
            ECDSA.toTypedDataHash(
                _paymentProcessor.getDomainSeparator(), 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            ITEM_OFFER_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            address(0),
                            saleDetails.maker,
                            saleDetails.beneficiary,
                            saleDetails.marketplace,
                            saleDetails.fallbackRoyaltyRecipient,
                            saleDetails.paymentMethod,
                            saleDetails.tokenAddress
                        ),
                        abi.encode(
                            saleDetails.tokenId,
                            saleDetails.amount,
                            saleDetails.itemPrice,
                            saleDetails.expiration,
                            saleDetails.marketplaceFeeNumerator,
                            saleDetails.nonce,
                            _paymentProcessor.masterNonces(saleDetails.maker)
                        )
                    )
                )
            );
    
        (uint8 offerV, bytes32 offerR, bytes32 offerS) = vm.sign(buyerKey_, offerDigest);
        SignatureECDSA memory signedOffer = SignatureECDSA({v: offerV, r: offerR, s: offerS});
    
        return signedOffer;
    }

    function _getSignedItemOfferAndDigest(uint256 buyerKey_, Order memory saleDetails) internal view returns (SignatureECDSA memory signedOffer, bytes32 offerHash) {
        offerHash = 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            ITEM_OFFER_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            address(0),
                            saleDetails.maker,
                            saleDetails.beneficiary,
                            saleDetails.marketplace,
                            saleDetails.fallbackRoyaltyRecipient,
                            saleDetails.paymentMethod,
                            saleDetails.tokenAddress
                        ),
                        abi.encode(
                            saleDetails.tokenId,
                            saleDetails.amount,
                            saleDetails.itemPrice,
                            saleDetails.expiration,
                            saleDetails.marketplaceFeeNumerator,
                            saleDetails.nonce,
                            _paymentProcessor.masterNonces(saleDetails.maker)
                        )
                    )
                );
        bytes32 offerDigest =
            ECDSA.toTypedDataHash(
                _paymentProcessor.getDomainSeparator(), 
                offerHash
            );
    
        (uint8 offerV, bytes32 offerR, bytes32 offerS) = vm.sign(buyerKey_, offerDigest);
        signedOffer = SignatureECDSA({v: offerV, r: offerR, s: offerS});
    }

    function _getSignedCollectionOffer(uint256 buyerKey_, Order memory saleDetails) internal view returns (SignatureECDSA memory) {
        bytes32 offerDigest = 
            ECDSA.toTypedDataHash(
                _paymentProcessor.getDomainSeparator(), 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            COLLECTION_OFFER_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            address(0),
                            saleDetails.maker,
                            saleDetails.beneficiary,
                            saleDetails.marketplace,
                            saleDetails.fallbackRoyaltyRecipient,
                            saleDetails.paymentMethod,
                            saleDetails.tokenAddress
                        ),
                        abi.encode(
                            saleDetails.amount,
                            saleDetails.itemPrice,
                            saleDetails.expiration,
                            saleDetails.marketplaceFeeNumerator,
                            saleDetails.nonce,
                            _paymentProcessor.masterNonces(saleDetails.maker)
                        )
                    )
                )
            );
    
        (uint8 offerV, bytes32 offerR, bytes32 offerS) = vm.sign(buyerKey_, offerDigest);
        SignatureECDSA memory signedOffer = SignatureECDSA({v: offerV, r: offerR, s: offerS});
    
        return signedOffer;
    }

    function _getSignedTokenSetOffer(uint256 buyerKey_, Order memory saleDetails, TestTokenSetProof memory tokenSetProof) internal view returns (SignatureECDSA memory) {
        bytes32 offerDigest = 
            ECDSA.toTypedDataHash(
                _paymentProcessor.getDomainSeparator(), 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            TOKEN_SET_OFFER_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            address(0),
                            saleDetails.maker,
                            saleDetails.beneficiary,
                            saleDetails.marketplace,
                            saleDetails.fallbackRoyaltyRecipient,
                            saleDetails.paymentMethod,
                            saleDetails.tokenAddress
                        ),
                        abi.encode(
                            saleDetails.amount,
                            saleDetails.itemPrice,
                            saleDetails.expiration,
                            saleDetails.marketplaceFeeNumerator,
                            saleDetails.nonce,
                            _paymentProcessor.masterNonces(saleDetails.maker),
                            tokenSetProof.rootHash
                        )
                    )
                )
            );
    
        (uint8 offerV, bytes32 offerR, bytes32 offerS) = vm.sign(buyerKey_, offerDigest);
        SignatureECDSA memory signedOffer = SignatureECDSA({v: offerV, r: offerR, s: offerS});
    
        return signedOffer;
    }

    function _reassignOwnershipOfPaymentMethodWhitelist(address caller, uint32 id, address newOwner, bytes4 expectedRevertSelector) internal {
        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        } else {
            vm.expectEmit(true, true, false, false);
            emit ICollectionSettingsRegistry.ReassignedPaymentMethodWhitelistOwnership(id, newOwner);
        }

        vm.startPrank(caller, caller);
        collectionSettingsRegistry.reassignOwnershipOfPaymentMethodWhitelist(id, newOwner);
        vm.stopPrank();
    }

    function _renounceOwnershipOfPaymentMethodWhitelist(address caller, uint32 id, bytes4 expectedRevertSelector) internal {
        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        } else {
            vm.expectEmit(true, true, false, false);
            emit ICollectionSettingsRegistry.ReassignedPaymentMethodWhitelistOwnership(id, address(0));
        }

        vm.startPrank(caller, caller);
        collectionSettingsRegistry.renounceOwnershipOfPaymentMethodWhitelist(id);
        vm.stopPrank();
    }

    function _destroyCosigner(address caller, uint160 cosignerKey, bytes4 expectedRevertSelector) internal {
        vm.assume(cosignerKey > 0 && cosignerKey < type(uint160).max);
        address cosignerAddr = vm.addr(cosignerKey);
        (uint8 v, bytes32 r, bytes32 s) =
            vm.sign(cosignerKey, ECDSA.toEthSignedMessageHash(bytes(COSIGNER_SELF_DESTRUCT_MESSAGE_TO_SIGN)));

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeDestroyCosignerCalldata(
                address(_paymentProcessor), 
                cosignerAddr,
                SignatureECDSA({v: v, r: r, s: s}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        } else {
            vm.expectEmit(true, false, false, false);
            emit DestroyedCosigner(cosignerAddr);
        }

        vm.prank(caller, caller);
        _paymentProcessor.destroyCosigner(fnCalldata);
    }

    function _revokeMasterNonce(address caller, uint256 previousMasterNonce, bytes4 expectedRevertSelector) internal {
        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        } else {
            vm.expectEmit(true, false, false, true);
            emit MasterNonceInvalidated(caller, previousMasterNonce);
        }

        vm.prank(caller, caller);
        _paymentProcessor.revokeMasterNonce();
    }

    function _revokeMasterNonce(address channel, address caller, uint256 previousMasterNonce, bytes4 expectedRevertSelector) internal {
        if(expectedRevertSelector == bytes4(0x00000000)) {
            vm.expectEmit(true, false, false, true);
            emit MasterNonceInvalidated(caller, previousMasterNonce);
        }

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.revokeMasterNonce.selector, "", expectedRevertSelector);
    }

    function _revokeSingleNonce(address caller, uint256 nonce, bytes4 expectedRevertSelector) internal {
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeRevokeSingleNonceCalldata(
                address(_paymentProcessor), 
                nonce);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        } else {
            vm.expectEmit(true, true, false, true);
            emit NonceInvalidated(nonce, caller, true);
        }

        vm.prank(caller, caller);
        _paymentProcessor.revokeSingleNonce(fnCalldata);
    }

    function _revokeSingleNonce(address channel, address caller, uint256 nonce, bytes4 expectedRevertSelector) internal {
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeRevokeSingleNonceCalldata(
                address(_paymentProcessor), 
                nonce);

        if(expectedRevertSelector == bytes4(0x00000000)) {
            vm.expectEmit(true, true, false, true);
            emit NonceInvalidated(nonce, caller, true);
        }

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.revokeSingleNonce.selector, fnCalldata, expectedRevertSelector);
    }

    function _revokeOrderDigest(address caller, bytes32 digest, bytes4 expectedRevertSelector) internal {
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeRevokeOrderDigestCalldata(
                address(_paymentProcessor), 
                digest);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.revokeOrderDigest(fnCalldata);
    }

    function _revokeOrderDigest(address channel, address caller, bytes32 digest, bytes4 expectedRevertSelector) internal {
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeRevokeOrderDigestCalldata(
                address(_paymentProcessor), 
                digest);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.revokeOrderDigest.selector, fnCalldata, expectedRevertSelector);
    }

    // TODO: Start

    function _buyCosignedListing(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory sellerSignature, Cosignature memory cosignature) = _getCosignedSaleApproval(fuzzedOrderInputs.sellerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingCalldata(
                address(_paymentProcessor), 
                saleDetails, 
                sellerSignature,
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.buyListing{value: nativePaymentValue}(fnCalldata);
    }

    function _buyEmptyCosignedListing(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory sellerSignature = _getSignedSaleApproval(fuzzedOrderInputs.sellerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingCalldata(
                address(_paymentProcessor), 
                saleDetails, 
                sellerSignature,
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.buyListing{value: nativePaymentValue}(fnCalldata);
    }

    function _buySignedListing(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory sellerSignature = _getSignedSaleApproval(fuzzedOrderInputs.sellerKey, saleDetails);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingCalldata(
                address(_paymentProcessor), 
                saleDetails, 
                sellerSignature,
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListing{value: nativePaymentValue}(fnCalldata);
    }

    function _buyCosignedListingWithFeeOnTop(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory sellerSignature, Cosignature memory cosignature) = _getCosignedSaleApproval(fuzzedOrderInputs.sellerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);

        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingCalldata(
                address(_paymentProcessor), 
                saleDetails, 
                sellerSignature,
                cosignature,
                feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListing{value: nativePaymentValue}(fnCalldata);
    }

    function _buyEmptyCosignedListingWithFeeOnTop(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory sellerSignature = _getSignedSaleApproval(fuzzedOrderInputs.sellerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingCalldata(
                address(_paymentProcessor), 
                saleDetails, 
                sellerSignature,
                cosignature,
                feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListing{value: nativePaymentValue}(fnCalldata);
    }

    function _buySignedListingWithFeeOnTop(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory sellerSignature = _getSignedSaleApproval(fuzzedOrderInputs.sellerKey, saleDetails);

        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingCalldata(
                address(_paymentProcessor), 
                saleDetails, 
                sellerSignature,
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListing{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuyCosignedListings(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            (sellerSignaturesArray[i], cosignatureArray[i]) = _getCosignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsCalldata(
                address(_paymentProcessor), 
                saleDetailsArray, 
                sellerSignaturesArray,
                cosignatureArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListings{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuyCosignedListingsWithFeesOnTop(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            (sellerSignaturesArray[i], cosignatureArray[i]) = _getCosignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);

            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsCalldata(
                address(_paymentProcessor), 
                saleDetailsArray, 
                sellerSignaturesArray,
                cosignatureArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListings{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuyEmptyCosignedListingsWithFeesOnTop(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            cosignatureArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsCalldata(
                address(_paymentProcessor), 
                saleDetailsArray, 
                sellerSignaturesArray,
                cosignatureArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListings{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuyEmptyCosignedListings(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            cosignatureArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsCalldata(
                address(_paymentProcessor), 
                saleDetailsArray, 
                sellerSignaturesArray,
                cosignatureArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListings{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepSignedListings(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        SweepItem[] memory sweepItems = new SweepItem[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);
        FeeOnTop memory feeOnTop = FeeOnTop({recipient: address(0), amount: 0});

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            sweepItems[i] = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionCalldata(
                address(_paymentProcessor), 
                feeOnTop,
                sweepOrder,
                sweepItems, 
                sellerSignaturesArray,
                cosignatures);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.sweepCollection{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepSignedListingsWithFeeOnTop(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        SweepItem[] memory sweepItems = new SweepItem[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);

        if (saleDetailsArray[0].paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + uint128(feeOnTop.amount);
        }

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            sweepItems[i] = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionCalldata(
                address(_paymentProcessor), 
                feeOnTop,
                sweepOrder,
                sweepItems, 
                sellerSignaturesArray,
                cosignatures);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.sweepCollection{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepCosignedListings(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignaturesArray = new Cosignature[](saleDetailsArray.length);
        SweepItem[] memory sweepItems = new SweepItem[](saleDetailsArray.length);
        FeeOnTop memory feeOnTop = FeeOnTop({recipient: address(0), amount: 0});

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            (sellerSignaturesArray[i], cosignaturesArray[i]) = _getCosignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
            sweepItems[i] = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionCalldata(
                address(_paymentProcessor), 
                feeOnTop,
                sweepOrder,
                sweepItems, 
                sellerSignaturesArray,
                cosignaturesArray);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.sweepCollection{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepEmptyCosignedListings(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignaturesArray = new Cosignature[](saleDetailsArray.length);
        SweepItem[] memory sweepItems = new SweepItem[](saleDetailsArray.length);
        FeeOnTop memory feeOnTop = FeeOnTop({recipient: address(0), amount: 0});

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            cosignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            sweepItems[i] = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionCalldata(
                address(_paymentProcessor), 
                feeOnTop,
                sweepOrder,
                sweepItems, 
                sellerSignaturesArray,
                cosignaturesArray);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.sweepCollection{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepCosignedListingsWithFeeOnTop(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignaturesArray = new Cosignature[](saleDetailsArray.length);
        SweepItem[] memory sweepItems = new SweepItem[](saleDetailsArray.length);

        if (saleDetailsArray[0].paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + uint128(feeOnTop.amount);
        }

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            (sellerSignaturesArray[i], cosignaturesArray[i]) = _getCosignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
            sweepItems[i] = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionCalldata(
                address(_paymentProcessor), 
                feeOnTop,
                sweepOrder,
                sweepItems, 
                sellerSignaturesArray,
                cosignaturesArray);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.sweepCollection{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepEmptyCosignedListingsWithFeeOnTop(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignaturesArray = new Cosignature[](saleDetailsArray.length);
        SweepItem[] memory sweepItems = new SweepItem[](saleDetailsArray.length);

        if (saleDetailsArray[0].paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + uint128(feeOnTop.amount);
        }

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            cosignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            sweepItems[i] = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionCalldata(
                address(_paymentProcessor), 
                feeOnTop,
                sweepOrder,
                sweepItems, 
                sellerSignaturesArray,
                cosignaturesArray);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.sweepCollection{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuySignedListings(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsCalldata(
                address(_paymentProcessor), 
                saleDetailsArray, 
                sellerSignaturesArray,
                cosignatures,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListings{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuySignedListingsWithFeeOnTop(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsCalldata(
                address(_paymentProcessor), 
                saleDetailsArray, 
                sellerSignaturesArray,
                cosignatures,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListings{value: nativePaymentValue}(fnCalldata);
    }

    function _acceptCosignedItemOffer(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedItemOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_ITEM_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptEmptyCosignedItemOffer(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_ITEM_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptEmptyCosignedItemOfferWithFeeOnTop(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_ITEM_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptSignedItemOffer(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_ITEM_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptCosignedItemOfferWithFeeOnTop(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedItemOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_ITEM_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptSignedItemOfferWithFeeOnTop(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_ITEM_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptCosignedCollectionOffer(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedCollectionOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptEmptyCosignedCollectionOffer(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptEmptyCosignedCollectionOfferWithFeeOnTop(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptSignedCollectionOffer(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptCosignedCollectionOfferWithFeeOnTop(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedCollectionOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptSignedCollectionOfferWithFeeOnTop(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptCosignedTokenSetOffer(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedTokenSetOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, tokenSetProof, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({proof: tokenSetProof.proof}),
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptEmptyCosignedTokenSetOffer(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({proof: tokenSetProof.proof}),
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptEmptyCosignedTokenSetOfferWithFeeOnTop(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({proof: tokenSetProof.proof}),
                cosignature,
                feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptSignedTokenSetOffer(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({proof: tokenSetProof.proof}),
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptCosignedTokenSetOfferWithFeeOnTop(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedTokenSetOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, tokenSetProof, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({proof: tokenSetProof.proof}),
                cosignature,
                feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _acceptSignedTokenSetOfferWithFeeOnTop(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({proof: tokenSetProof.proof}),
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOffer(fnCalldata);
    }

    function _bulkAcceptCosignedItemOffers(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_ITEM_OFFER;
            (buyerSignaturesArray[i], cosignerSignaturesArray[i]) = _getCosignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedItemOffers(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_ITEM_OFFER;
            buyerSignaturesArray[i] = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            cosignerSignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptCosignedItemOffersWithFeesOnTop(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_ITEM_OFFER;
            (buyerSignaturesArray[i], cosignerSignaturesArray[i]) = _getCosignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedItemOffersWithFeesOnTop(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_ITEM_OFFER;
            buyerSignaturesArray[i] = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            cosignerSignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptSignedItemOffers(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_ITEM_OFFER;
            buyerSignaturesArray[i] = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignatures,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptSignedItemOffersWithFeesOnTop(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_ITEM_OFFER;
            buyerSignaturesArray[i] = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignatures,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptCosignedCollectionOffers(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_COLLECTION_OFFER;
            (buyerSignaturesArray[i], cosignerSignaturesArray[i]) = _getCosignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptCosignedCollectionOffersWithFeesOnTop(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_COLLECTION_OFFER;
            (buyerSignaturesArray[i], cosignerSignaturesArray[i]) = _getCosignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedCollectionOffers(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_COLLECTION_OFFER;
            buyerSignaturesArray[i] = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            cosignerSignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedCollectionOffersWithFeesOnTop(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_COLLECTION_OFFER;
            buyerSignaturesArray[i] = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            cosignerSignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptSignedCollectionOffers(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_COLLECTION_OFFER;
            buyerSignaturesArray[i] = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignatures,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptSignedCollectionOffersWithFeesOnTop(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_COLLECTION_OFFER;
            buyerSignaturesArray[i] = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignatures,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptCosignedTokenSetOffers(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_TOKEN_SET_OFFER;
            (buyerSignaturesArray[i], cosignerSignaturesArray[i]) = _getCosignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], tokenSetProofsArray[i], caller);
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofs,
                cosignerSignaturesArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptCosignedTokenSetOffersWithFeesOnTop(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_TOKEN_SET_OFFER;
            (buyerSignaturesArray[i], cosignerSignaturesArray[i]) = _getCosignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], tokenSetProofsArray[i], caller);
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofs,
                cosignerSignaturesArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedTokenSetOffersWithFeesOnTop(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_TOKEN_SET_OFFER;
            buyerSignaturesArray[i] = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            cosignerSignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofs,
                cosignerSignaturesArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedTokenSetOffers(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_TOKEN_SET_OFFER;
            buyerSignaturesArray[i] = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            cosignerSignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofs,
                cosignerSignaturesArray,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptSignedTokenSetOffers(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_TOKEN_SET_OFFER;
            buyerSignaturesArray[i] = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofs,
                cosignatures,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    function _bulkAcceptSignedTokenSetOffersWithFeesOnTop(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypeArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypeArray[i] = OFFER_TYPE_TOKEN_SET_OFFER;
            buyerSignaturesArray[i] = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypeArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofs,
                cosignatures,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffers(fnCalldata);
    }

    // TODO: End

    // TODO: Start - Forwarded

    function _forwardCall(address channel, address caller, address target, uint256 value, bytes4 selector, bytes memory message, bytes4 expectedRevertSelector) internal {
        bytes memory messageData = abi.encodeWithSelector(selector, message);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        TrustedForwarder(channel).forwardCall{value: value}(target, messageData);
    }

    function _buyCosignedListing(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory sellerSignature, Cosignature memory cosignature) = _getCosignedSaleApproval(fuzzedOrderInputs.sellerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingCalldata(
                address(_paymentProcessor), 
                saleDetails, 
                sellerSignature,
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListing.selector, fnCalldata, expectedRevertSelector);
    }

    function _buyEmptyCosignedListing(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory sellerSignature = _getSignedSaleApproval(fuzzedOrderInputs.sellerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingCalldata(
                address(_paymentProcessor), 
                saleDetails, 
                sellerSignature,
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListing.selector, fnCalldata, expectedRevertSelector);
    }

    function _buySignedListing(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory sellerSignature = _getSignedSaleApproval(fuzzedOrderInputs.sellerKey, saleDetails);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingCalldata(
                address(_paymentProcessor), 
                saleDetails, 
                sellerSignature,
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListing.selector, fnCalldata, expectedRevertSelector);
    }

    function _buyCosignedListingWithFeeOnTop(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory sellerSignature, Cosignature memory cosignature) = _getCosignedSaleApproval(fuzzedOrderInputs.sellerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);

        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingCalldata(
                address(_paymentProcessor), 
                saleDetails, 
                sellerSignature,
                cosignature,
                feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListing.selector, fnCalldata, expectedRevertSelector);
    }

    function _buyEmptyCosignedListingWithFeeOnTop(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory sellerSignature = _getSignedSaleApproval(fuzzedOrderInputs.sellerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingCalldata(
                address(_paymentProcessor), 
                saleDetails, 
                sellerSignature,
                cosignature,
                feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListing.selector, fnCalldata, expectedRevertSelector);
    }

    function _buySignedListingWithFeeOnTop(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory sellerSignature = _getSignedSaleApproval(fuzzedOrderInputs.sellerKey, saleDetails);

        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingCalldata(
                address(_paymentProcessor), 
                saleDetails, 
                sellerSignature,
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListing.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkBuyCosignedListings(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            (sellerSignaturesArray[i], cosignatureArray[i]) = _getCosignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsCalldata(
                address(_paymentProcessor), 
                saleDetailsArray, 
                sellerSignaturesArray,
                cosignatureArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListings.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkBuyCosignedListingsWithFeesOnTop(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            (sellerSignaturesArray[i], cosignatureArray[i]) = _getCosignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);

            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsCalldata(
                address(_paymentProcessor), 
                saleDetailsArray, 
                sellerSignaturesArray,
                cosignatureArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListings.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkBuyEmptyCosignedListingsWithFeesOnTop(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            cosignatureArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsCalldata(
                address(_paymentProcessor), 
                saleDetailsArray, 
                sellerSignaturesArray,
                cosignatureArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListings.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkBuyEmptyCosignedListings(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            cosignatureArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsCalldata(
                address(_paymentProcessor), 
                saleDetailsArray, 
                sellerSignaturesArray,
                cosignatureArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListings.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepSignedListings(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        SweepItem[] memory sweepItems = new SweepItem[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);
        FeeOnTop memory feeOnTop = FeeOnTop({recipient: address(0), amount: 0});

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            sweepItems[i] = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionCalldata(
                address(_paymentProcessor), 
                feeOnTop,
                sweepOrder,
                sweepItems, 
                sellerSignaturesArray,
                cosignatures);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollection.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepSignedListingsWithFeeOnTop(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        SweepItem[] memory sweepItems = new SweepItem[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);

        if (saleDetailsArray[0].paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + uint128(feeOnTop.amount);
        }

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            sweepItems[i] = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionCalldata(
                address(_paymentProcessor), 
                feeOnTop,
                sweepOrder,
                sweepItems, 
                sellerSignaturesArray,
                cosignatures);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollection.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepCosignedListings(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignaturesArray = new Cosignature[](saleDetailsArray.length);
        SweepItem[] memory sweepItems = new SweepItem[](saleDetailsArray.length);
        FeeOnTop memory feeOnTop = FeeOnTop({recipient: address(0), amount: 0});

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            (sellerSignaturesArray[i], cosignaturesArray[i]) = _getCosignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
            sweepItems[i] = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionCalldata(
                address(_paymentProcessor), 
                feeOnTop,
                sweepOrder,
                sweepItems, 
                sellerSignaturesArray,
                cosignaturesArray);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollection.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepEmptyCosignedListings(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignaturesArray = new Cosignature[](saleDetailsArray.length);
        SweepItem[] memory sweepItems = new SweepItem[](saleDetailsArray.length);
        FeeOnTop memory feeOnTop = FeeOnTop({recipient: address(0), amount: 0});

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            cosignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            sweepItems[i] = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionCalldata(
                address(_paymentProcessor), 
                feeOnTop,
                sweepOrder,
                sweepItems, 
                sellerSignaturesArray,
                cosignaturesArray);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollection.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepCosignedListingsWithFeeOnTop(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignaturesArray = new Cosignature[](saleDetailsArray.length);
        SweepItem[] memory sweepItems = new SweepItem[](saleDetailsArray.length);

        if (saleDetailsArray[0].paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + uint128(feeOnTop.amount);
        }

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            (sellerSignaturesArray[i], cosignaturesArray[i]) = _getCosignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
            sweepItems[i] = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionCalldata(
                address(_paymentProcessor), 
                feeOnTop,
                sweepOrder,
                sweepItems, 
                sellerSignaturesArray,
                cosignaturesArray);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollection.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepEmptyCosignedListingsWithFeeOnTop(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignaturesArray = new Cosignature[](saleDetailsArray.length);
        SweepItem[] memory sweepItems = new SweepItem[](saleDetailsArray.length);

        if (saleDetailsArray[0].paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + uint128(feeOnTop.amount);
        }

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            cosignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            sweepItems[i] = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionCalldata(
                address(_paymentProcessor), 
                feeOnTop,
                sweepOrder,
                sweepItems, 
                sellerSignaturesArray,
                cosignaturesArray);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollection.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkBuySignedListings(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsCalldata(
                address(_paymentProcessor), 
                saleDetailsArray, 
                sellerSignaturesArray,
                cosignatures,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListings.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkBuySignedListingsWithFeeOnTop(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            sellerSignaturesArray[i] = _getSignedSaleApproval(fuzzedOrderInputsArray[i].sellerKey, saleDetailsArray[i]);
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsCalldata(
                address(_paymentProcessor), 
                saleDetailsArray, 
                sellerSignaturesArray,
                cosignatures,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListings.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptCosignedItemOffer(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedItemOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_ITEM_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptEmptyCosignedItemOffer(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_ITEM_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptEmptyCosignedItemOfferWithFeeOnTop(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_ITEM_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptSignedItemOffer(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_ITEM_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptCosignedItemOfferWithFeeOnTop(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedItemOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_ITEM_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptSignedItemOfferWithFeeOnTop(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_ITEM_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptCosignedCollectionOffer(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedCollectionOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptEmptyCosignedCollectionOffer(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptEmptyCosignedCollectionOfferWithFeeOnTop(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptSignedCollectionOffer(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptCosignedCollectionOfferWithFeeOnTop(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedCollectionOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                cosignature,
                feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptSignedCollectionOfferWithFeeOnTop(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({
                    proof: new bytes32[](0)
                }),
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptCosignedTokenSetOffer(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedTokenSetOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, tokenSetProof, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({proof: tokenSetProof.proof}),
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptEmptyCosignedTokenSetOffer(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({proof: tokenSetProof.proof}),
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptEmptyCosignedTokenSetOfferWithFeeOnTop(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({proof: tokenSetProof.proof}),
                cosignature,
                feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptSignedTokenSetOffer(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({proof: tokenSetProof.proof}),
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptCosignedTokenSetOfferWithFeeOnTop(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedTokenSetOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, tokenSetProof, caller);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({proof: tokenSetProof.proof}),
                cosignature,
                feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptSignedTokenSetOfferWithFeeOnTop(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferCalldata(
                address(_paymentProcessor), 
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails, 
                buyerSignature,
                TokenSetProof({proof: tokenSetProof.proof}),
                Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOffer.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptCosignedItemOffers(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_ITEM_OFFER;
            (buyerSignaturesArray[i], cosignerSignaturesArray[i]) = _getCosignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptEmptyCosignedItemOffers(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_ITEM_OFFER;
            buyerSignaturesArray[i] = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            cosignerSignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptCosignedItemOffersWithFeesOnTop(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_ITEM_OFFER;
            (buyerSignaturesArray[i], cosignerSignaturesArray[i]) = _getCosignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptEmptyCosignedItemOffersWithFeesOnTop(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_ITEM_OFFER;
            buyerSignaturesArray[i] = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            cosignerSignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptSignedItemOffers(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_ITEM_OFFER;
            buyerSignaturesArray[i] = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,            
                cosignatures,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptSignedItemOffersWithFeesOnTop(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_ITEM_OFFER;
            buyerSignaturesArray[i] = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignatures,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptCosignedCollectionOffers(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_COLLECTION_OFFER;
            (buyerSignaturesArray[i], cosignerSignaturesArray[i]) = _getCosignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptCosignedCollectionOffersWithFeesOnTop(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_COLLECTION_OFFER;
            (buyerSignaturesArray[i], cosignerSignaturesArray[i]) = _getCosignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptEmptyCosignedCollectionOffers(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_COLLECTION_OFFER;
            buyerSignaturesArray[i] = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptEmptyCosignedCollectionOffersWithFeesOnTop(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_COLLECTION_OFFER;
            buyerSignaturesArray[i] = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignerSignaturesArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptSignedCollectionOffers(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_COLLECTION_OFFER;
            buyerSignaturesArray[i] = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofsArray,
                cosignatures,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptSignedCollectionOffersWithFeesOnTop(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_COLLECTION_OFFER;
            buyerSignaturesArray[i] = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofs,
                cosignatures,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptCosignedTokenSetOffers(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_TOKEN_SET_OFFER;
            (buyerSignaturesArray[i], cosignerSignaturesArray[i]) = _getCosignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], tokenSetProofsArray[i], caller);
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofs,
                cosignerSignaturesArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptCosignedTokenSetOffersWithFeesOnTop(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_TOKEN_SET_OFFER;
            (buyerSignaturesArray[i], cosignerSignaturesArray[i]) = _getCosignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], tokenSetProofsArray[i], caller);
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofs,
                cosignerSignaturesArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptEmptyCosignedTokenSetOffersWithFeesOnTop(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_TOKEN_SET_OFFER;
            buyerSignaturesArray[i] = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            cosignerSignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofs,
                cosignerSignaturesArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptEmptyCosignedTokenSetOffers(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignerSignaturesArray = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_TOKEN_SET_OFFER;
            buyerSignaturesArray[i] = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            cosignerSignaturesArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofs,
                cosignerSignaturesArray,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptSignedTokenSetOffers(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_TOKEN_SET_OFFER;
            buyerSignaturesArray[i] = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofs,
                cosignatures,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptSignedTokenSetOffersWithFeesOnTop(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        uint256[] memory offerTypesArray = new uint256[](saleDetailsArray.length);
        SignatureECDSA[] memory buyerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatures = new Cosignature[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            offerTypesArray[i] = OFFER_TYPE_TOKEN_SET_OFFER;
            buyerSignaturesArray[i] = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            cosignatures[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersCalldata(
                address(_paymentProcessor), 
                offerTypesArray,
                saleDetailsArray, 
                buyerSignaturesArray,
                tokenSetProofs,
                cosignatures,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffers.selector, fnCalldata, expectedRevertSelector);
    }

    // TODO: End - Forwarded

    function _sanitizeAddress(address addr, address[] memory exclusionList) internal view {
        _sanitizeAddressNoPrecompiles(addr);
        vm.assume(uint160(addr) > 0xFF);
        vm.assume(addr != address(0));
        vm.assume(addr != address(0x000000000000000000636F6e736F6c652e6c6f67));
        vm.assume(addr != address(0xDDc10602782af652bB913f7bdE1fD82981Db7dd9));
        vm.assume(addr != address(_paymentProcessor));
        vm.assume(addr != address(_paymentProcessorEncoder));
        vm.assume(addr != address(nativeWrapper));
        vm.assume(addr.code.length == 0);

        for (uint256 i = 0; i < exclusionList.length; ++i) {
            vm.assume(addr != exclusionList[i]);
        }
    }

    function _sanitizeAddressNoPrecompiles(address addr) internal view {
        vm.assume(addr != address(0x01));
        vm.assume(addr != address(0x02));
        vm.assume(addr != address(0x03));
        vm.assume(addr != address(0x04));
        vm.assume(addr != address(0x05));
        vm.assume(addr != address(0x06));
        vm.assume(addr != address(0x07));
        vm.assume(addr != address(0x08));
        vm.assume(addr != address(0x09));
        vm.assume(addr != address(0x0a));
        vm.assume(addr != address(0x4200000000000000000000000000000000000016));
        vm.assume(addr != address(0x4200000000000000000000000000000000000002));
        vm.assume(addr != address(0xDeadDeAddeAddEAddeadDEaDDEAdDeaDDeAD0000));
        vm.assume(addr != address(0x4200000000000000000000000000000000000006));
        vm.assume(addr != address(0x4200000000000000000000000000000000000007));
        vm.assume(addr != address(0x4200000000000000000000000000000000000010));
        vm.assume(addr != address(0x4200000000000000000000000000000000000011));
        vm.assume(addr != address(0x4200000000000000000000000000000000000012));
        vm.assume(addr != address(0x4200000000000000000000000000000000000013));
        vm.assume(addr != address(0x420000000000000000000000000000000000000F));
        vm.assume(addr != address(0x4200000000000000000000000000000000000015));
        vm.assume(addr != address(0x4200000000000000000000000000000000000042));
        vm.assume(addr != address(0x4200000000000000000000000000000000000000));
        vm.assume(addr != address(0x4200000000000000000000000000000000000014));
        vm.assume(addr != address(0x4200000000000000000000000000000000000017));
        vm.assume(addr != address(0x4200000000000000000000000000000000000018));
        vm.assume(addr != address(0x0000000000000000000000000000000000000064));
        vm.assume(addr != address(0x000000000000000000000000000000000000006E));
        vm.assume(addr != address(0x000000000000000000000000000000000000006C));
        vm.assume(addr != address(0x0000000000000000000000000000000000000066));
        vm.assume(addr != address(0x000000000000000000000000000000000000006F));
        vm.assume(addr != address(0x00000000000000000000000000000000000000C8));
        vm.assume(addr != address(0x0000000000000000000000000000000000000067));
        vm.assume(addr != address(0x0000000000000000000000000000000000000065));
        vm.assume(addr != address(0x000000000000000000000000000000000000006D));
        vm.assume(addr != address(0x0000000000000000000000000000000000000068));
        vm.assume(addr != address(0x0200000000000000000000000000000000000000));
        vm.assume(addr != address(0x0200000000000000000000000000000000000001));
        vm.assume(addr != address(0x0200000000000000000000000000000000000002));
        vm.assume(addr != address(0x0200000000000000000000000000000000000003));
        vm.assume(addr != address(0x4e59b44847b379578588920cA78FbF26c0B4956C));
        vm.assume(addr != address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
        vm.assume(addr != address(0x000000000000000000636F6e736F6c652e6c6f67));
    }

    function _scrubFuzzedOrderInputs(FuzzedOrder721 memory fuzzedOrderInputs) internal view {
        fuzzedOrderInputs.marketplaceFeeRate = uint24(_bound(fuzzedOrderInputs.marketplaceFeeRate, 0, 5000));
        fuzzedOrderInputs.royaltyFeeRate = uint24(_bound(fuzzedOrderInputs.royaltyFeeRate, 0, 5000));

        fuzzedOrderInputs.sellerKey = uint160(_bound(fuzzedOrderInputs.sellerKey, 1, type(uint160).max));
        fuzzedOrderInputs.buyerKey = uint160(_bound(fuzzedOrderInputs.buyerKey, 1, type(uint160).max));
        fuzzedOrderInputs.cosignerKey = uint160(_bound(fuzzedOrderInputs.cosignerKey, 1, type(uint160).max));

        fuzzedOrderInputs.expirationSeconds = uint32(_bound(fuzzedOrderInputs.expirationSeconds, 1, type(uint32).max));

        vm.assume(fuzzedOrderInputs.sellerKey != fuzzedOrderInputs.buyerKey);
        vm.assume(fuzzedOrderInputs.sellerKey != fuzzedOrderInputs.cosignerKey);
        vm.assume(fuzzedOrderInputs.buyerKey != fuzzedOrderInputs.cosignerKey);

        address[] memory exclusionList = new address[](12);
        exclusionList[0] = alice;
        exclusionList[1] = bob;
        exclusionList[2] = cal;
        exclusionList[3] = abe;
        exclusionList[4] = benchmarkBeneficiary;
        exclusionList[5] = cosigner;
        exclusionList[6] = benchmarkFeeRecipient;
        exclusionList[7] = address(nativeWrapper);
        exclusionList[8] = channel;
        exclusionList[9] = trustedChannel;
        exclusionList[10] = untrustedChannel;
        exclusionList[11] = contractMock;

        _sanitizeAddress(vm.addr(fuzzedOrderInputs.sellerKey), exclusionList);
        _sanitizeAddress(vm.addr(fuzzedOrderInputs.buyerKey), exclusionList);
        _sanitizeAddress(vm.addr(fuzzedOrderInputs.cosignerKey), exclusionList);
        _sanitizeAddress(fuzzedOrderInputs.beneficiary, exclusionList);
        _sanitizeAddress(fuzzedOrderInputs.marketplace, exclusionList);
        _sanitizeAddress(fuzzedOrderInputs.royaltyReceiver, exclusionList);

        vm.assume(fuzzedOrderInputs.beneficiary != fuzzedOrderInputs.marketplace);
        vm.assume(fuzzedOrderInputs.beneficiary != fuzzedOrderInputs.royaltyReceiver);
        vm.assume(fuzzedOrderInputs.marketplace != fuzzedOrderInputs.royaltyReceiver);
        vm.assume(fuzzedOrderInputs.royaltyReceiver != vm.addr(fuzzedOrderInputs.sellerKey));
        vm.assume(fuzzedOrderInputs.royaltyReceiver != vm.addr(fuzzedOrderInputs.buyerKey));
        vm.assume(fuzzedOrderInputs.marketplace != vm.addr(fuzzedOrderInputs.sellerKey));
        vm.assume(fuzzedOrderInputs.marketplace != vm.addr(fuzzedOrderInputs.buyerKey));
        vm.assume(fuzzedOrderInputs.beneficiary != vm.addr(fuzzedOrderInputs.sellerKey));
        vm.assume(fuzzedOrderInputs.beneficiary != vm.addr(fuzzedOrderInputs.buyerKey));
        
        vm.assume(fuzzedOrderInputs.marketplace.balance == 0);
        vm.assume(fuzzedOrderInputs.royaltyReceiver.balance == 0);
        vm.assume(vm.addr(fuzzedOrderInputs.sellerKey).balance == 0);
        vm.assume(vm.addr(fuzzedOrderInputs.buyerKey).balance == 0);
    }

    function _scrubFuzzedOrderInputs(
        FuzzedOrder721 memory fuzzedOrderInputs, 
        FuzzedFeeOnTop memory fuzzedFeeOnTop
    ) internal view {
        _scrubFuzzedOrderInputs(fuzzedOrderInputs);

        address[] memory exclusionList = new address[](18);
        exclusionList[0] = alice;
        exclusionList[1] = bob;
        exclusionList[2] = cal;
        exclusionList[3] = abe;
        exclusionList[4] = benchmarkBeneficiary;
        exclusionList[5] = cosigner;
        exclusionList[6] = benchmarkFeeRecipient;
        exclusionList[7] = vm.addr(fuzzedOrderInputs.sellerKey);
        exclusionList[8] = vm.addr(fuzzedOrderInputs.buyerKey);
        exclusionList[9] = vm.addr(fuzzedOrderInputs.cosignerKey);
        exclusionList[10] = fuzzedOrderInputs.beneficiary;
        exclusionList[11] = fuzzedOrderInputs.marketplace;
        exclusionList[12] = fuzzedOrderInputs.royaltyReceiver;
        exclusionList[13] = address(nativeWrapper);
        exclusionList[14] = channel;
        exclusionList[15] = trustedChannel;
        exclusionList[16] = untrustedChannel;
        exclusionList[17] = contractMock;

        _sanitizeAddress(fuzzedFeeOnTop.receiver, exclusionList);
        vm.assume(fuzzedFeeOnTop.receiver.balance == 0);

        fuzzedFeeOnTop.rate = uint24(_bound(fuzzedFeeOnTop.rate, 0, 10000));

        uint256 feeAmount = uint256(fuzzedOrderInputs.itemPrice) * fuzzedFeeOnTop.rate / 10000;

        vm.assume(uint256(fuzzedOrderInputs.itemPrice) + feeAmount < type(uint128).max);
    }

    function _getProtocolFeeReceiver() internal view returns (address) {
        return _paymentProcessor.getProtocolFees().protocolFeeReceiver;
    }

    function _getMiniumumProtocolFeeBps() internal view returns (uint16) {
        return _paymentProcessor.getProtocolFees().minimumProtocolFeeBps;
    }

    function _getMarketplaceFeeProtocolTaxBps() internal view returns (uint16) {
        return _paymentProcessor.getProtocolFees().marketplaceFeeProtocolTaxBps;
    }

    function _getFeeOnTopProtocolTaxBps() internal view returns (uint16) {
        return _paymentProcessor.getProtocolFees().feeOnTopProtocolTaxBps;
    }

    struct Payments {
        uint256 expectedRoyalty;
        uint256 expectedMarketplaceFee;
        uint256 expectedInfrastructureFee;
        uint256 expectedSellerProceeds;
        uint256 expectedFeeOnTopInfrastructure;
    }

    function _getExpectedProceeds(
        Order memory order, 
        FeeOnTop memory feeOnTop) 
        internal
        returns (Payments memory payments) 
    {
        uint16 minimumProtocolFeeBps = _getMiniumumProtocolFeeBps();
        uint16 marketplaceTaxBps = _getMarketplaceFeeProtocolTaxBps();
        uint16 feeOnTopTaxBps = _getFeeOnTopProtocolTaxBps();
        (uint16 royaltyBountyNumerator, address exclusiveBountyReceiver) = 
            _paymentProcessor.collectionBountySettings(order.tokenAddress);

        payments.expectedRoyalty = uint256(order.itemPrice) * order.maxRoyaltyFeeNumerator / FEE_DENOMINATOR;
        payments.expectedSellerProceeds = order.itemPrice - payments.expectedRoyalty;

        if (order.marketplace != address(0)) {
            payments.expectedMarketplaceFee = uint256(order.itemPrice) * order.marketplaceFeeNumerator / FEE_DENOMINATOR;
            payments.expectedSellerProceeds -= payments.expectedMarketplaceFee;

            if (exclusiveBountyReceiver == address(0) ||
                exclusiveBountyReceiver == order.marketplace) {
                uint256 royaltyBountyProceeds = payments.expectedRoyalty * royaltyBountyNumerator / FEE_DENOMINATOR;
                if (royaltyBountyProceeds > 0) {
                    payments.expectedRoyalty -= royaltyBountyProceeds;
                    payments.expectedMarketplaceFee += royaltyBountyProceeds;
                }
            }

            payments.expectedInfrastructureFee = payments.expectedMarketplaceFee * marketplaceTaxBps / FEE_DENOMINATOR;
            payments.expectedMarketplaceFee -= payments.expectedInfrastructureFee;
        } else {
            payments.expectedMarketplaceFee = 0;
        }

        uint256 minInfrastructureFee = uint256(order.itemPrice) * minimumProtocolFeeBps / FEE_DENOMINATOR;
        if (payments.expectedInfrastructureFee < minInfrastructureFee) {
            uint256 shortfall = minInfrastructureFee - payments.expectedInfrastructureFee;
            if (shortfall > payments.expectedSellerProceeds) {
                payments.expectedInfrastructureFee += payments.expectedSellerProceeds;
                payments.expectedSellerProceeds = 0;
            } else {
                payments.expectedSellerProceeds -= shortfall;
                payments.expectedInfrastructureFee = minInfrastructureFee;
            }
        }

        if (order.protocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
            uint256 unitPrice = order.itemPrice / order.amount;
            uint256 adjustedPrice = unitPrice * order.requestedFillAmount;

            payments.expectedRoyalty = 0;
            payments.expectedMarketplaceFee = 0;
            payments.expectedInfrastructureFee = 0;
            payments.expectedSellerProceeds = 0;

            payments.expectedRoyalty = uint256(adjustedPrice) * order.maxRoyaltyFeeNumerator / FEE_DENOMINATOR;
            payments.expectedSellerProceeds = adjustedPrice - payments.expectedRoyalty;
    
            if (order.marketplace != address(0)) {
                payments.expectedMarketplaceFee = uint256(adjustedPrice) * order.marketplaceFeeNumerator / FEE_DENOMINATOR;
                payments.expectedSellerProceeds -= payments.expectedMarketplaceFee;
    
                if (exclusiveBountyReceiver == address(0) ||
                    exclusiveBountyReceiver == order.marketplace) {
                    uint256 royaltyBountyProceeds = payments.expectedRoyalty * royaltyBountyNumerator / FEE_DENOMINATOR;
                    if (royaltyBountyProceeds > 0) {
                        payments.expectedRoyalty -= royaltyBountyProceeds;
                        payments.expectedMarketplaceFee += royaltyBountyProceeds;
                    }
                }
    
                payments.expectedInfrastructureFee = payments.expectedMarketplaceFee * marketplaceTaxBps / FEE_DENOMINATOR;
                payments.expectedMarketplaceFee -= payments.expectedInfrastructureFee;
            } else {
                payments.expectedMarketplaceFee = 0;
            }
    
            uint256 minInfrastructureFee = uint256(adjustedPrice) * minimumProtocolFeeBps / FEE_DENOMINATOR;
            if (payments.expectedInfrastructureFee < minInfrastructureFee) {
                uint256 shortfall = minInfrastructureFee - payments.expectedInfrastructureFee;
                if (shortfall > payments.expectedSellerProceeds) {
                    payments.expectedInfrastructureFee += payments.expectedSellerProceeds;
                    payments.expectedSellerProceeds = 0;
                } else {
                    payments.expectedSellerProceeds -= shortfall;
                    payments.expectedInfrastructureFee = minInfrastructureFee;
                }
            }

            assertEq(
                adjustedPrice,
                payments.expectedRoyalty + 
                payments.expectedMarketplaceFee +
                payments.expectedInfrastructureFee +
                payments.expectedSellerProceeds
            );
        } else {
            assertEq(
                order.itemPrice,
                payments.expectedRoyalty + 
                payments.expectedMarketplaceFee +
                payments.expectedInfrastructureFee +
                payments.expectedSellerProceeds
            );
        }

        payments.expectedFeeOnTopInfrastructure = feeOnTop.amount * feeOnTopTaxBps / FEE_DENOMINATOR;
    }

    function _verifyExpectedPayoutsForOrder(address[] memory addresses, Payments memory payments, Order memory order, FuzzedOrder721 memory fuzzedOrderInputs, FeeOnTop memory feeOnTop, bool acceptOfferFlow) internal {
        for (uint256 i;i < addresses.length; ++i) {
            address indexAddress = addresses[i];
            if (indexAddress == address(0)) { break; }
            uint256 totalExpectedPayment;
            if (indexAddress == vm.addr(fuzzedOrderInputs.sellerKey)) {
                totalExpectedPayment = payments.expectedSellerProceeds;
                if (acceptOfferFlow) {
                    vm.assume(totalExpectedPayment >= feeOnTop.amount);
                    totalExpectedPayment -= feeOnTop.amount;
                }
                console.log("Seller Receiver: ", totalExpectedPayment);
            }
            if (indexAddress == fuzzedOrderInputs.royaltyReceiver) {
                totalExpectedPayment += payments.expectedRoyalty;
                console.log("Royalty Receiver: ", totalExpectedPayment);
            }
            if (indexAddress == fuzzedOrderInputs.marketplace) {
                totalExpectedPayment += payments.expectedMarketplaceFee;
                console.log("Marketplace Receiver: ", totalExpectedPayment);
            }
            if (indexAddress == feeOnTop.recipient) {
                totalExpectedPayment += feeOnTop.amount - payments.expectedFeeOnTopInfrastructure;
                console.log("Fee On Top Receiver: ", totalExpectedPayment);
            }
            if (indexAddress == _getProtocolFeeReceiver()) {
                totalExpectedPayment += payments.expectedInfrastructureFee;
                totalExpectedPayment += payments.expectedFeeOnTopInfrastructure;
                console.log("Protocol Fee Receiver: ", totalExpectedPayment);
            }

            if (totalExpectedPayment == 0) { continue; }
            
            if (order.paymentMethod == address(0)) {
                assertEq(indexAddress.balance - _cachedUserBalances[_getBalanceKey(address(0), indexAddress)], totalExpectedPayment);
            } else {
                assertEq(IERC20(order.paymentMethod).balanceOf(indexAddress) - _cachedUserBalances[_getBalanceKey(order.paymentMethod, indexAddress)], totalExpectedPayment);
            }
        }
    }

    function _verifyExpectedPayoutsForTwoOrders(
        address[] memory addresses, 
        Payments memory expectedPayments1, 
        Payments memory expectedPayments2, 
        Order memory order1, 
        Order memory order2, 
        FuzzedOrder721 memory fuzzedOrderInputs1, 
        FuzzedOrder721 memory fuzzedOrderInputs2, 
        FeeOnTop memory feeOnTop1, 
        FeeOnTop memory feeOnTop2, 
        bool acceptOfferFlow) internal {
        for (uint256 i;i < addresses.length; ++i) {
            address indexAddress = addresses[i];
            if (indexAddress == address(0)) { break; }
            uint256 totalExpectedPayment;
            if (indexAddress == vm.addr(fuzzedOrderInputs1.sellerKey)) {
                totalExpectedPayment = expectedPayments1.expectedSellerProceeds;
                if (acceptOfferFlow) {
                    vm.assume(totalExpectedPayment >= feeOnTop1.amount);
                    totalExpectedPayment -= feeOnTop1.amount;
                }
            }
            if (indexAddress == vm.addr(fuzzedOrderInputs2.sellerKey)) {
                totalExpectedPayment += expectedPayments2.expectedSellerProceeds;
                if (acceptOfferFlow) {
                    vm.assume(totalExpectedPayment >= feeOnTop2.amount);
                    totalExpectedPayment -= feeOnTop2.amount;
                }
            }
            if (indexAddress == fuzzedOrderInputs1.royaltyReceiver) {
                totalExpectedPayment += expectedPayments1.expectedRoyalty;
            }
            if (indexAddress == fuzzedOrderInputs2.royaltyReceiver) {
                totalExpectedPayment += expectedPayments2.expectedRoyalty;
            }
            if (indexAddress == fuzzedOrderInputs1.marketplace) {
                totalExpectedPayment += expectedPayments1.expectedMarketplaceFee;
            }
            if (indexAddress == fuzzedOrderInputs2.marketplace) {
                totalExpectedPayment += expectedPayments2.expectedMarketplaceFee;
            }
            if (indexAddress == feeOnTop1.recipient) {
                totalExpectedPayment += feeOnTop1.amount - expectedPayments1.expectedFeeOnTopInfrastructure;
            }
            if (indexAddress == feeOnTop2.recipient) {
                totalExpectedPayment += feeOnTop2.amount - expectedPayments2.expectedFeeOnTopInfrastructure;
            }
            if (indexAddress == _getProtocolFeeReceiver()) {
                totalExpectedPayment += expectedPayments1.expectedInfrastructureFee;
                totalExpectedPayment += expectedPayments2.expectedInfrastructureFee;
                totalExpectedPayment += expectedPayments1.expectedFeeOnTopInfrastructure;
                totalExpectedPayment += expectedPayments2.expectedFeeOnTopInfrastructure;
            }
    
            if (totalExpectedPayment == 0) { continue; }
            
            if (order1.paymentMethod == address(0)) {
                assertEq(indexAddress.balance - _cachedUserBalances[_getBalanceKey(address(0), indexAddress)], totalExpectedPayment);
            } else {
                assertEq(IERC20(order1.paymentMethod).balanceOf(indexAddress) - _cachedUserBalances[_getBalanceKey(order1.paymentMethod, indexAddress)], totalExpectedPayment);
            }
        }
    }

    function _verifyExpectedTradeStateChanges(address buyer, Order memory order, FuzzedOrder721 memory fuzzedOrderInputs, FeeOnTop memory feeOnTop) internal {
        _verifyExpectedTradeStateChanges(buyer, order, fuzzedOrderInputs, feeOnTop, false);
    }

    function _verifyExpectedTradeStateChangesAcceptOffer(address buyer, Order memory order, FuzzedOrder721 memory fuzzedOrderInputs, FeeOnTop memory feeOnTop) internal {
        _verifyExpectedTradeStateChanges(buyer, order, fuzzedOrderInputs, feeOnTop, true);
    }

    function _verifyExpectedTradeStateChanges(address buyer, Order memory order, FuzzedOrder721 memory fuzzedOrderInputs, FeeOnTop memory feeOnTop, bool acceptOfferFlow) internal {
        if (order.protocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
            assertEq(IERC721(order.tokenAddress).ownerOf(order.tokenId), order.beneficiary);
        } else if (order.protocol == ORDER_PROTOCOLS_ERC1155_FILL_OR_KILL) {
            assertEq(IERC1155(order.tokenAddress).balanceOf(order.beneficiary, order.tokenId), order.amount);
        } else if (order.protocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
            assertEq(IERC1155(order.tokenAddress).balanceOf(order.beneficiary, order.tokenId), order.requestedFillAmount);
        }

        _verifyExpectedPayoutsForOrder(
            _getAddressesForExpectedPaymentChecks1(fuzzedOrderInputs, feeOnTop),
            _getExpectedProceeds(order, feeOnTop),
            order,
            fuzzedOrderInputs,
            feeOnTop,
            acceptOfferFlow
        );
    }

    function _getAddressesForExpectedPaymentChecks1(
        FuzzedOrder721 memory fuzzedOrderInputs, 
        FeeOnTop memory feeOnTop
    ) private view returns (address[] memory addresses) {
        addresses = new address[](5);
        addresses[0] = vm.addr(fuzzedOrderInputs.sellerKey);
        address tmpAddress = fuzzedOrderInputs.royaltyReceiver;
        for (uint256 i;i < 5; ++i) {
            address indexAddress = addresses[i];
            if (indexAddress == tmpAddress) { break; }
            if (indexAddress == address(0)) { addresses[i] = tmpAddress; break; }
        }
        tmpAddress = fuzzedOrderInputs.marketplace;
        for (uint256 i;i < 5; ++i) {
            address indexAddress = addresses[i];
            if (indexAddress == tmpAddress) { break; }
            if (indexAddress == address(0)) { addresses[i] = tmpAddress; break; }
        }
        tmpAddress = feeOnTop.recipient;
        for (uint256 i;i < 5; ++i) {
            address indexAddress = addresses[i];
            if (indexAddress == tmpAddress) { break; }
            if (indexAddress == address(0)) { addresses[i] = tmpAddress; break; }
        }
        tmpAddress = _getProtocolFeeReceiver();
        for (uint256 i;i < 5; ++i) {
            address indexAddress = addresses[i];
            if (indexAddress == tmpAddress) { break; }
            if (indexAddress == address(0)) { addresses[i] = tmpAddress; break; }
        }
    }

    function _verifyExpectedTradeStateChanges(
        address buyer, 
        Order memory order, 
        FuzzedOrder721 memory fuzzedOrderInputs
    ) internal {
        FeeOnTop memory emptyFeeOnTop;
        _verifyExpectedTradeStateChanges(buyer, order, fuzzedOrderInputs, emptyFeeOnTop);
    }

    function _verifyExpectedTradeStateChangesAcceptOffer(
        address buyer, 
        Order memory order, 
        FuzzedOrder721 memory fuzzedOrderInputs
    ) internal {
        FeeOnTop memory emptyFeeOnTop;
        _verifyExpectedTradeStateChangesAcceptOffer(buyer, order, fuzzedOrderInputs, emptyFeeOnTop);
    }

    function _getExpectedBeneficiaryBalance1155(Order memory order) private returns (uint256 expectedBalance1155) {
        if (order.protocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
            return 0;
        } else if (order.protocol == ORDER_PROTOCOLS_ERC1155_FILL_OR_KILL) {
            return order.amount;
        } else if (order.protocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
            return order.requestedFillAmount;
        }
        return 0;
    }

    function _buildTradeStateChangeAddressArray(
        Order memory order1, 
        Order memory order2, 
        FuzzedOrder721 memory fuzzedOrderInputs1, 
        FuzzedOrder721 memory fuzzedOrderInputs2,
        FeeOnTop memory feeOnTop1,
        FeeOnTop memory feeOnTop2
    ) internal returns (address[] memory addresses) {
        addresses = new address[](9);

        addresses[0] = vm.addr(fuzzedOrderInputs1.sellerKey);
        address tmpAddress = vm.addr(fuzzedOrderInputs2.sellerKey);
        if (tmpAddress != addresses[0]) {
            addresses[1] = tmpAddress;
        }
        tmpAddress = fuzzedOrderInputs1.royaltyReceiver;
        for (uint256 i;i < 9; ++i) {
            address indexAddress = addresses[i];
            if (indexAddress == tmpAddress) { break; }
            if (indexAddress == address(0)) { addresses[i] = tmpAddress; break; }
        }
        tmpAddress = fuzzedOrderInputs2.royaltyReceiver;
        for (uint256 i;i < 9; ++i) {
            address indexAddress = addresses[i];
            if (indexAddress == tmpAddress) { break; }
            if (indexAddress == address(0)) { addresses[i] = tmpAddress; break; }
        }
        tmpAddress = fuzzedOrderInputs1.marketplace;
        for (uint256 i;i < 9; ++i) {
            address indexAddress = addresses[i];
            if (indexAddress == tmpAddress) { break; }
            if (indexAddress == address(0)) { addresses[i] = tmpAddress; break; }
        }
        tmpAddress = fuzzedOrderInputs2.marketplace;
        for (uint256 i;i < 9; ++i) {
            address indexAddress = addresses[i];
            if (indexAddress == tmpAddress) { break; }
            if (indexAddress == address(0)) { addresses[i] = tmpAddress; break; }
        }
        tmpAddress = feeOnTop1.recipient;
        for (uint256 i;i < 9; ++i) {
            address indexAddress = addresses[i];
            if (indexAddress == tmpAddress) { break; }
            if (indexAddress == address(0)) { addresses[i] = tmpAddress; break; }
        }
        tmpAddress = feeOnTop2.recipient;
        for (uint256 i;i < 9; ++i) {
            address indexAddress = addresses[i];
            if (indexAddress == tmpAddress) { break; }
            if (indexAddress == address(0)) { addresses[i] = tmpAddress; break; }
        }
        tmpAddress = _getProtocolFeeReceiver();
        for (uint256 i;i < 9; ++i) {
            address indexAddress = addresses[i];
            if (indexAddress == tmpAddress) { break; }
            if (indexAddress == address(0)) { addresses[i] = tmpAddress; break; }
        }
    }

    struct ExpectedTradeStateChangeParams {
        Order order1;
        Order order2;
        FuzzedOrder721 fuzzedOrderInputs1;
        FuzzedOrder721 fuzzedOrderInputs2;
        FeeOnTop feeOnTop1;
        FeeOnTop feeOnTop2;
    }

    mapping(bytes32 => uint256) private _cachedUserBalances;

    function _getBalanceKey(address paymentMethod, address account) internal returns (bytes32) {
        return keccak256(abi.encode(paymentMethod, account));
    }

    function _cacheAccountBalancesForExpectedStateChange(
        address paymentMethod,
        FuzzedOrder721 memory fuzzedOrderInputs1, 
        FuzzedOrder721 memory fuzzedOrderInputs2,
        FeeOnTop memory feeOnTop1,
        FeeOnTop memory feeOnTop2) internal {

        if (paymentMethod != address(0)) {
            address tmpAddress;
            if (fuzzedOrderInputs1.sellerKey != 0) {
                tmpAddress = vm.addr(fuzzedOrderInputs1.sellerKey);
                _cachedUserBalances[_getBalanceKey(paymentMethod, tmpAddress)] = IERC20(paymentMethod).balanceOf(tmpAddress);
            }
            if (fuzzedOrderInputs2.sellerKey != 0) {
                tmpAddress = vm.addr(fuzzedOrderInputs2.sellerKey);
                _cachedUserBalances[_getBalanceKey(paymentMethod, tmpAddress)] = IERC20(paymentMethod).balanceOf(tmpAddress);
            }
            tmpAddress = fuzzedOrderInputs1.royaltyReceiver;
            _cachedUserBalances[_getBalanceKey(paymentMethod, tmpAddress)] = IERC20(paymentMethod).balanceOf(tmpAddress);
            tmpAddress = fuzzedOrderInputs2.royaltyReceiver;
            _cachedUserBalances[_getBalanceKey(paymentMethod, tmpAddress)] = IERC20(paymentMethod).balanceOf(tmpAddress);
            tmpAddress = fuzzedOrderInputs1.marketplace;
            _cachedUserBalances[_getBalanceKey(paymentMethod, tmpAddress)] = IERC20(paymentMethod).balanceOf(tmpAddress);
            tmpAddress = fuzzedOrderInputs2.marketplace;
            _cachedUserBalances[_getBalanceKey(paymentMethod, tmpAddress)] = IERC20(paymentMethod).balanceOf(tmpAddress);
            tmpAddress = feeOnTop1.recipient;
            _cachedUserBalances[_getBalanceKey(paymentMethod, tmpAddress)] = IERC20(paymentMethod).balanceOf(tmpAddress);
            tmpAddress = feeOnTop2.recipient;
            _cachedUserBalances[_getBalanceKey(paymentMethod, tmpAddress)] = IERC20(paymentMethod).balanceOf(tmpAddress);
            tmpAddress = _getProtocolFeeReceiver();
            _cachedUserBalances[_getBalanceKey(paymentMethod, tmpAddress)] = IERC20(paymentMethod).balanceOf(tmpAddress);
        } else {
            address tmpAddress;
            if (fuzzedOrderInputs1.sellerKey != 0) {
                tmpAddress = vm.addr(fuzzedOrderInputs1.sellerKey);
                _cachedUserBalances[_getBalanceKey(address(0), tmpAddress)] = tmpAddress.balance;
            }
            if (fuzzedOrderInputs2.sellerKey != 0) {
                tmpAddress = vm.addr(fuzzedOrderInputs2.sellerKey);
                _cachedUserBalances[_getBalanceKey(address(0), tmpAddress)] = tmpAddress.balance;
            }
            tmpAddress = fuzzedOrderInputs1.royaltyReceiver;
            _cachedUserBalances[_getBalanceKey(address(0), tmpAddress)] = tmpAddress.balance;
            tmpAddress = fuzzedOrderInputs2.royaltyReceiver;
            _cachedUserBalances[_getBalanceKey(address(0), tmpAddress)] = tmpAddress.balance;
            tmpAddress = fuzzedOrderInputs1.marketplace;
            _cachedUserBalances[_getBalanceKey(address(0), tmpAddress)] = tmpAddress.balance;
            tmpAddress = fuzzedOrderInputs2.marketplace;
            _cachedUserBalances[_getBalanceKey(address(0), tmpAddress)] = tmpAddress.balance;
            tmpAddress = feeOnTop1.recipient;
            _cachedUserBalances[_getBalanceKey(address(0), tmpAddress)] = tmpAddress.balance;
            tmpAddress = feeOnTop2.recipient;
            _cachedUserBalances[_getBalanceKey(address(0), tmpAddress)] = tmpAddress.balance;
            tmpAddress = _getProtocolFeeReceiver();
            _cachedUserBalances[_getBalanceKey(address(0), tmpAddress)] = tmpAddress.balance;
        }
    }

    function _verifyExpectedTradeStateChanges(
        address buyer, 
        Order memory order1, 
        Order memory order2, 
        FuzzedOrder721 memory fuzzedOrderInputs1, 
        FuzzedOrder721 memory fuzzedOrderInputs2,
        FeeOnTop memory feeOnTop1,
        FeeOnTop memory feeOnTop2,
        bool acceptOfferFlow) internal {
        
        if (order1.protocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
            assertEq(test721.ownerOf(order1.tokenId), order1.beneficiary);
        }

        if (order2.protocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
            assertEq(test721.ownerOf(order2.tokenId), order2.beneficiary);
        }

        assertEq(test1155.balanceOf(order1.beneficiary, order1.tokenId), _getExpectedBeneficiaryBalance1155(order1));
        assertEq(test1155.balanceOf(order2.beneficiary, order2.tokenId), _getExpectedBeneficiaryBalance1155(order2));

        Payments memory expectedPayments1 = _getExpectedProceeds(order1, feeOnTop1);
        Payments memory expectedPayments2 = _getExpectedProceeds(order2, feeOnTop2);

        address[] memory addresses = _buildTradeStateChangeAddressArray(order1, order2, fuzzedOrderInputs1, fuzzedOrderInputs2, feeOnTop1, feeOnTop2);

        if (order1.paymentMethod == order2.paymentMethod) {
            _verifyExpectedPayoutsForTwoOrders(
                addresses,
                expectedPayments1,
                expectedPayments2,
                order1,
                order2,
                fuzzedOrderInputs1,
                fuzzedOrderInputs2,
                feeOnTop1,
                feeOnTop2,
                acceptOfferFlow
            );
        } else {
            _verifyExpectedPayoutsForOrder(
                addresses,
                expectedPayments1,
                order1,
                fuzzedOrderInputs1,
                feeOnTop1,
                acceptOfferFlow
            );

            _verifyExpectedPayoutsForOrder(
                addresses,
                expectedPayments2,
                order2,
                fuzzedOrderInputs2,
                feeOnTop2,
                acceptOfferFlow
            );
        }
    }

    function _verifyExpectedTradeStateChanges(
        address buyer, 
        Order memory order1, 
        Order memory order2, 
        FuzzedOrder721 memory fuzzedOrderInputs1, 
        FuzzedOrder721 memory fuzzedOrderInputs2,
        FeeOnTop memory feeOnTop1,
        FeeOnTop memory feeOnTop2) internal {
        _verifyExpectedTradeStateChanges(
            buyer,
            order1,
            order2, 
            fuzzedOrderInputs1,
            fuzzedOrderInputs2,
            feeOnTop1,
            feeOnTop2,
            false
        );
    }

    //

    function _verifyExpectedTradeStateChangesAcceptOffer(
        address buyer, 
        Order memory order1, 
        Order memory order2, 
        FuzzedOrder721 memory fuzzedOrderInputs1, 
        FuzzedOrder721 memory fuzzedOrderInputs2,
        FeeOnTop memory feeOnTop1,
        FeeOnTop memory feeOnTop2) internal {
        _verifyExpectedTradeStateChanges(
            buyer,
            order1,
            order2, 
            fuzzedOrderInputs1,
            fuzzedOrderInputs2,
            feeOnTop1,
            feeOnTop2,
            true
        );
    }

    //

    function _verifyExpectedTradeStateChanges(
        address buyer, 
        Order memory order1, 
        Order memory order2, 
        FuzzedOrder721 memory fuzzedOrderInputs1, 
        FuzzedOrder721 memory fuzzedOrderInputs2) internal {
        FeeOnTop memory emptyFeeOnTop;
        _verifyExpectedTradeStateChanges(buyer, order1, order2, fuzzedOrderInputs1, fuzzedOrderInputs2, emptyFeeOnTop, emptyFeeOnTop);
    }

    function _verifyExpectedTradeStateChangesAcceptOffer(
        address buyer, 
        Order memory order1, 
        Order memory order2, 
        FuzzedOrder721 memory fuzzedOrderInputs1, 
        FuzzedOrder721 memory fuzzedOrderInputs2) internal {
        FeeOnTop memory emptyFeeOnTop;
        _verifyExpectedTradeStateChangesAcceptOffer(buyer, order1, order2, fuzzedOrderInputs1, fuzzedOrderInputs2, emptyFeeOnTop, emptyFeeOnTop);
    }

    function _verifyExpectedTradeStateChanges(
        Order memory order1, 
        Order memory order2, 
        FuzzedOrder721 memory fuzzedOrderInputs1, 
        FuzzedOrder721 memory fuzzedOrderInputs2,
        FeeOnTop memory feeOnTop1,
        FeeOnTop memory feeOnTop2) internal {
        _verifyExpectedTradeStateChanges(
            address(0),
            order1,
            order2, 
            fuzzedOrderInputs1,
            fuzzedOrderInputs2,
            feeOnTop1,
            feeOnTop2,
            false
        );
    }

    //

    function _verifyExpectedTradeStateChangesAcceptOffer(
        Order memory order1, 
        Order memory order2, 
        FuzzedOrder721 memory fuzzedOrderInputs1, 
        FuzzedOrder721 memory fuzzedOrderInputs2,
        FeeOnTop memory feeOnTop1,
        FeeOnTop memory feeOnTop2) internal {
        _verifyExpectedTradeStateChanges(
            address(0),
            order1,
            order2, 
            fuzzedOrderInputs1,
            fuzzedOrderInputs2,
            feeOnTop1,
            feeOnTop2,
            true
        );
    }

    //

    function _verifyExpectedTradeStateChanges(
        Order memory order1, 
        Order memory order2, 
        FuzzedOrder721 memory fuzzedOrderInputs1, 
        FuzzedOrder721 memory fuzzedOrderInputs2) internal {
        FeeOnTop memory emptyFeeOnTop;
        _verifyExpectedTradeStateChanges(order1, order2, fuzzedOrderInputs1, fuzzedOrderInputs2, emptyFeeOnTop, emptyFeeOnTop);
    }

    function _verifyExpectedTradeStateChangesAcceptOffer(
        Order memory order1, 
        Order memory order2, 
        FuzzedOrder721 memory fuzzedOrderInputs1, 
        FuzzedOrder721 memory fuzzedOrderInputs2) internal {
        FeeOnTop memory emptyFeeOnTop;
        _verifyExpectedTradeStateChangesAcceptOffer(order1, order2, fuzzedOrderInputs1, fuzzedOrderInputs2, emptyFeeOnTop, emptyFeeOnTop);
    }

    function _getFeeOnTop(
        uint256 totalSalePrice, 
        FuzzedFeeOnTop memory fuzzedFeeOnTop
    ) internal view returns (FeeOnTop memory feeOnTop) {
        feeOnTop = _getFeeOnTop(totalSalePrice, fuzzedFeeOnTop, false);
    }

    function _getFeeOnTop(
        uint256 totalSalePrice, 
        FuzzedFeeOnTop memory fuzzedFeeOnTop,
        bool allowCodeRecipient
    ) internal view returns (FeeOnTop memory feeOnTop) {
        feeOnTop = FeeOnTop({
            amount: totalSalePrice * fuzzedFeeOnTop.rate / 100_00,
            recipient: fuzzedFeeOnTop.receiver
        });

        uint256 recipientCodeSize;
        address recipient = feeOnTop.recipient;
        assembly {
            recipientCodeSize := extcodesize(recipient)
        }
        if (recipientCodeSize > 0) {
            if (!allowCodeRecipient) {
                feeOnTop.recipient = address(1234);
            }
        }

        if (feeOnTop.recipient == address(0)) {
            feeOnTop.amount = 0;
        }

        if (feeOnTop.amount == 0) {
            feeOnTop.recipient = address(0);
        }
    }

    function _pauseCollectionTrading(address tokenAddress) internal {
        vm.startPrank(tokenAddress);
        _setCollectionPaymentSettingsPaymentSettingsOnly(tokenAddress, PaymentSettings.Paused, true);
        vm.stopPrank();
    }

    function _setCollectionPaymentSettings(
        address tokenAddress, 
        PaymentSettings paymentSettings,
        uint32 paymentMethodWhitelistId,
        address constrainedPricingPaymentMethod,
        uint16 royaltyBackfillNumerator,
        address royaltyBackfillReceiver,
        uint16 royaltyBountyNumerator,
        address exclusiveBountyReceiver,
        bool blockTradesFromUntrustedChannels,
        bool useRoyaltyBackfillAsRoyaltySource
    ) internal {
        _setCollectionPaymentSettings(
            tokenAddress,
            paymentSettings,
            paymentMethodWhitelistId,
            constrainedPricingPaymentMethod,
            royaltyBackfillNumerator,
            royaltyBackfillReceiver,
            royaltyBountyNumerator,
            exclusiveBountyReceiver,
            blockTradesFromUntrustedChannels,
            useRoyaltyBackfillAsRoyaltySource,
            true
        );
    }

    function _setCollectionPaymentSettings(
        address tokenAddress, 
        PaymentSettings paymentSettings,
        uint32 paymentMethodWhitelistId,
        address constrainedPricingPaymentMethod,
        uint16 royaltyBackfillNumerator,
        address royaltyBackfillReceiver,
        uint16 royaltyBountyNumerator,
        address exclusiveBountyReceiver,
        bool blockTradesFromUntrustedChannels,
        bool useRoyaltyBackfillAsRoyaltySource,
        bool sync
    ) internal {

        CollectionPaymentSettingsParams memory settingsParams;
        settingsParams.paymentSettings = uint8(paymentSettings);
        settingsParams.paymentMethodWhitelistId = paymentMethodWhitelistId;
        settingsParams.constrainedPricingPaymentMethod = constrainedPricingPaymentMethod;
        settingsParams.royaltyBackfillNumerator = royaltyBackfillNumerator;
        settingsParams.royaltyBackfillReceiver = royaltyBackfillReceiver;
        settingsParams.royaltyBountyNumerator = royaltyBountyNumerator;
        settingsParams.exclusiveBountyReceiver = exclusiveBountyReceiver;

        address tmpTokenAddress = tokenAddress;

        bytes32[] memory emptyBytes32;
        (
            ,RegistryPricingBounds memory collectionPricingBounds,,,,
        ) = collectionSettingsRegistry.getCollectionSettings(tmpTokenAddress, emptyBytes32, emptyBytes32);

        uint8 flags;
        flags = _setFlag(flags, FLAG_IS_ROYALTY_BOUNTY_EXCLUSIVE, (exclusiveBountyReceiver != address(0)));
        flags = _setFlag(flags, FLAG_BLOCK_TRADES_FROM_UNTRUSTED_CHANNELS, blockTradesFromUntrustedChannels);
        flags = _setFlag(flags, FLAG_USE_BACKFILL_AS_ROYALTY_SOURCE, useRoyaltyBackfillAsRoyaltySource);

        settingsParams.extraData = flags;
        settingsParams.collectionMinimumFloorPrice = collectionPricingBounds.floorPrice;
        settingsParams.collectionMaximumCeilingPrice = collectionPricingBounds.ceilingPrice;

        bytes32[] memory emptyBytes32_2;
        bytes[] memory emptyBytes;

        address[] memory paymentProcessorsToSync;
        if(sync) {
            paymentProcessorsToSync = new address[](1);
            paymentProcessorsToSync[0] = address(_paymentProcessor);
        }

        collectionSettingsRegistry.setCollectionPaymentSettings(tmpTokenAddress, settingsParams, emptyBytes32_2, emptyBytes, emptyBytes32_2, emptyBytes32_2, paymentProcessorsToSync);
    }

    function _setCollectionPaymentSettingsPaymentSettingsOnly(
        address tokenAddress, 
        PaymentSettings paymentSettings,
        bool sync
    ) internal {
        bytes32[] memory emptyBytes32;
        (
            CollectionRegistryPaymentSettings memory collectionCoreSettings,
            RegistryPricingBounds memory collectionPricingBounds,
            address constrainedPricingPaymentMethod,
            address exclusiveBountyReceiver,,
        ) = collectionSettingsRegistry.getCollectionSettings(tokenAddress, emptyBytes32, emptyBytes32);

        uint8 flags = uint8(collectionCoreSettings.extraData);

        CollectionPaymentSettingsParams memory settingsParams = CollectionPaymentSettingsParams({
            paymentSettings: uint8(paymentSettings),
            paymentMethodWhitelistId: collectionCoreSettings.paymentMethodWhitelistId,
            constrainedPricingPaymentMethod: constrainedPricingPaymentMethod,
            royaltyBackfillNumerator: collectionCoreSettings.royaltyBackfillNumerator,
            royaltyBackfillReceiver: collectionCoreSettings.royaltyBackfillReceiver,
            royaltyBountyNumerator: collectionCoreSettings.royaltyBountyNumerator,
            exclusiveBountyReceiver: exclusiveBountyReceiver,
            extraData: flags,
            collectionMinimumFloorPrice: collectionPricingBounds.floorPrice,
            collectionMaximumCeilingPrice: collectionPricingBounds.ceilingPrice
        });

        bytes32[] memory emptyBytes32_2;
        bytes[] memory emptyBytes;

        address[] memory paymentProcessorsToSync;
        if(sync) {
            paymentProcessorsToSync = new address[](1);
            paymentProcessorsToSync[0] = address(_paymentProcessor);
        }

        collectionSettingsRegistry.setCollectionPaymentSettings(tokenAddress, settingsParams, emptyBytes32_2, emptyBytes, emptyBytes32_2, emptyBytes32_2, paymentProcessorsToSync);
    }

    function _setCollectionPaymentSettingsCollectionPricingBounds(
        address tokenAddress, 
        PricingBounds memory collectionPricingBounds,
        bool sync
    ) internal {
        bytes32[] memory emptyBytes32;
        (
            CollectionRegistryPaymentSettings memory collectionCoreSettings,,
            address constrainedPricingPaymentMethod,
            address exclusiveBountyReceiver,,
        ) = collectionSettingsRegistry.getCollectionSettings(tokenAddress, emptyBytes32, emptyBytes32);

        uint8 flags = uint8(collectionCoreSettings.extraData);

        CollectionPaymentSettingsParams memory settingsParams = CollectionPaymentSettingsParams({
            paymentSettings: collectionCoreSettings.paymentSettingsType,
            paymentMethodWhitelistId: collectionCoreSettings.paymentMethodWhitelistId,
            constrainedPricingPaymentMethod: constrainedPricingPaymentMethod,
            royaltyBackfillNumerator: collectionCoreSettings.royaltyBackfillNumerator,
            royaltyBackfillReceiver: collectionCoreSettings.royaltyBackfillReceiver,
            royaltyBountyNumerator: collectionCoreSettings.royaltyBountyNumerator,
            exclusiveBountyReceiver: exclusiveBountyReceiver,
            extraData: flags,
            collectionMinimumFloorPrice: collectionPricingBounds.floorPrice,
            collectionMaximumCeilingPrice: collectionPricingBounds.ceilingPrice
        });

        bytes32[] memory emptyBytes32_2;
        bytes[] memory emptyBytes;

        address[] memory paymentProcessorsToSync;
        if(sync) {
            paymentProcessorsToSync = new address[](1);
            paymentProcessorsToSync[0] = address(_paymentProcessor);
        }

        collectionSettingsRegistry.setCollectionPaymentSettings(tokenAddress, settingsParams, emptyBytes32_2, emptyBytes, emptyBytes32_2, emptyBytes32_2, paymentProcessorsToSync);
    }

    function _setCollectionPaymentSettingsTokenPricingBounds(
        address tokenAddress,
        uint256[] memory tokenIds,
        PricingBounds[] memory pricingBounds
    ) internal {
        _setCollectionPaymentSettingsTokenPricingBounds(tokenAddress, tokenIds, pricingBounds, true);
    }

    function _setCollectionPaymentSettingsTokenPricingBounds(
        address tokenAddress,
        uint256[] memory tokenIds,
        PricingBounds[] memory pricingBounds,
        bool sync
    ) internal {
        address[] memory paymentProcessorsToSync;
        RegistryPricingBounds[] memory registryPricingBounds = new RegistryPricingBounds[](pricingBounds.length);
        for(uint256 i; i < registryPricingBounds.length; ++i) {
            registryPricingBounds[i] = RegistryPricingBounds({
                isSet: pricingBounds[i].isSet,
                floorPrice: pricingBounds[i].floorPrice,
                ceilingPrice: pricingBounds[i].ceilingPrice
            });
        }

        if(sync) {
            paymentProcessorsToSync = new address[](1);
            paymentProcessorsToSync[0] = address(_paymentProcessor);
        }

        collectionSettingsRegistry.setTokenPricingBounds(tokenAddress, tokenIds, registryPricingBounds, paymentProcessorsToSync);
    }

    function _setPaymentSettings(
        uint8 paymentSettings,
        uint256 itemPrice,
        address token, 
        address paymentMethod,
        uint16 royaltyBackfillNumerator,
        address royaltyBackfillReceiver,
        uint16 royaltyBountyNumerator,
        address exclusiveBountyReceiver,
        bool blockTradesFromUntrustedChannels
    ) internal {
        _setPaymentSettings(
            paymentSettings,
            itemPrice,
            token,
            paymentMethod,
            royaltyBackfillNumerator,
            royaltyBackfillReceiver,
            royaltyBountyNumerator,
            exclusiveBountyReceiver,
            blockTradesFromUntrustedChannels,
            false,
            true
        );
    }

    function _setPaymentSettings(
        uint8 paymentSettings,
        uint256 itemPrice,
        address token, 
        address paymentMethod,
        uint16 royaltyBackfillNumerator,
        address royaltyBackfillReceiver,
        uint16 royaltyBountyNumerator,
        address exclusiveBountyReceiver,
        bool blockTradesFromUntrustedChannels,
        bool useRoyaltyBackfillAsRoyaltySource
    ) internal {
        _setPaymentSettings(
            paymentSettings,
            itemPrice,
            token,
            paymentMethod,
            royaltyBackfillNumerator,
            royaltyBackfillReceiver,
            royaltyBountyNumerator,
            exclusiveBountyReceiver,
            blockTradesFromUntrustedChannels,
            useRoyaltyBackfillAsRoyaltySource,
            true
        );
    }

    function _setPaymentSettings(
        uint8 paymentSettings,
        uint256 itemPrice,
        address token, 
        address paymentMethod,
        uint16 royaltyBackfillNumerator,
        address royaltyBackfillReceiver,
        uint16 royaltyBountyNumerator,
        address exclusiveBountyReceiver,
        bool blockTradesFromUntrustedChannels,
        bool useRoyaltyBackfillAsRoyaltySource,
        bool sync
    ) internal {
        paymentSettings = paymentSettings % 5;
        PaymentSettings paymentSettingsEnum = PaymentSettings(paymentSettings);

        if (paymentSettingsEnum == PaymentSettings.DefaultPaymentMethodWhitelist) {
            _setCollectionPaymentSettings(
                token, 
                PaymentSettings.DefaultPaymentMethodWhitelist, 
                0, 
                paymentMethod, 
                royaltyBackfillNumerator, 
                royaltyBackfillReceiver, 
                royaltyBountyNumerator, 
                exclusiveBountyReceiver,
                blockTradesFromUntrustedChannels,
                useRoyaltyBackfillAsRoyaltySource,
                sync);
        } else if (paymentSettingsEnum == PaymentSettings.AllowAnyPaymentMethod) {
            _setCollectionPaymentSettings(
                token, 
                PaymentSettings.AllowAnyPaymentMethod, 
                0, 
                paymentMethod, 
                royaltyBackfillNumerator, 
                royaltyBackfillReceiver, 
                royaltyBountyNumerator, 
                exclusiveBountyReceiver,
                blockTradesFromUntrustedChannels,
                useRoyaltyBackfillAsRoyaltySource,
                sync);
        } else if (paymentSettingsEnum == PaymentSettings.CustomPaymentMethodWhitelist) {
            _setCollectionPaymentSettings(
                token, 
                PaymentSettings.CustomPaymentMethodWhitelist, 
                customPaymentMethodWhitelistId, 
                paymentMethod, 
                royaltyBackfillNumerator, 
                royaltyBackfillReceiver, 
                royaltyBountyNumerator, 
                exclusiveBountyReceiver,
                blockTradesFromUntrustedChannels,
                useRoyaltyBackfillAsRoyaltySource,
                sync);
        } else if (paymentSettingsEnum == PaymentSettings.PricingConstraints || paymentSettingsEnum == PaymentSettings.PricingConstraintsCollectionOnly) {
            _setCollectionPaymentSettings(
                token, 
                paymentSettingsEnum, 
                0, 
                paymentMethod, 
                royaltyBackfillNumerator, 
                royaltyBackfillReceiver, 
                royaltyBountyNumerator, 
                exclusiveBountyReceiver,
                blockTradesFromUntrustedChannels,
                useRoyaltyBackfillAsRoyaltySource,
                sync);

            _setCollectionPaymentSettingsCollectionPricingBounds(
                token, 
                PricingBounds({
                    initialized: true,
                    isSet: true,
                    floorPrice: 1 ether,
                    ceilingPrice: 500 ether
                }),
                sync);
        }
    }

    function _isFlagSet(uint8 flagValue, uint8 flag) internal pure returns (bool flagSet) {
        flagSet = ((flagValue & flag) != 0);
    }

    function _setFlag(uint8 flagValue, uint8 flag, bool flagSet) internal pure returns (uint8) {
        if(flagSet) {
            return (flagValue | flag);
        } else {
            return (flagValue & (255 - flag));
        }
    }

    // Advanced



    function _buyCosignedListingPermitted(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        (SignatureECDSA memory sellerSignature, Cosignature memory cosignature) = _getCosignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, fuzzedOrderInputs.cosignerKey, permitContext, saleDetails, caller);

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingAdvancedCalldata(
                address(_paymentProcessor), 
                AdvancedOrder(
                    saleDetails, 
                    sellerSignature,
                    cosignature,
                    permitContext
                ),
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0})
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.buyListingAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _buyCosignedListingPermitted(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        (SignatureECDSA memory sellerSignature, Cosignature memory cosignature) = _getCosignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, fuzzedOrderInputs.cosignerKey, permitContext, saleDetails, caller);

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingAdvancedCalldata(
                address(_paymentProcessor), 
                AdvancedOrder(
                    saleDetails, 
                    sellerSignature,
                    cosignature,
                    permitContext
                ),
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0})
            );

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListingAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _buyEmptyCosignedListingPermitted(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory sellerSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingAdvancedCalldata(
                address(_paymentProcessor), 
                AdvancedOrder(
                    saleDetails, 
                    sellerSignature,
                    cosignature,
                    permitContext
                ),
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0})
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.buyListingAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _buyEmptyCosignedListingPermitted(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory sellerSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingAdvancedCalldata(
                address(_paymentProcessor), 
                AdvancedOrder(
                    saleDetails, 
                    sellerSignature,
                    cosignature,
                    permitContext
                ),
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0})
            );

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListingAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _buySignedListingPermitted(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory sellerSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingAdvancedCalldata(
                address(_paymentProcessor), 
                AdvancedOrder(
                    saleDetails, 
                    sellerSignature,
                    cosignature,
                    permitContext
                ),
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0})
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListingAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _buySignedListingPermitted(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory sellerSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingAdvancedCalldata(
                address(_paymentProcessor), 
                AdvancedOrder(
                    saleDetails, 
                    sellerSignature,
                    cosignature,
                    permitContext
                ),
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0})
            );

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListingAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _buyCosignedListingWithFeeOnTopPermitted(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        (SignatureECDSA memory sellerSignature, Cosignature memory cosignature) = _getCosignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, fuzzedOrderInputs.cosignerKey, permitContext, saleDetails, caller);

        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingAdvancedCalldata(
                address(_paymentProcessor), 
                AdvancedOrder(
                    saleDetails, 
                    sellerSignature,
                    cosignature,
                    permitContext
                ),
                bulkOrderProof,
                feeOnTop
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListingAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _buyCosignedListingWithFeeOnTopPermitted(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        (SignatureECDSA memory sellerSignature, Cosignature memory cosignature) = _getCosignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, fuzzedOrderInputs.cosignerKey, permitContext, saleDetails, caller);

        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingAdvancedCalldata(
                address(_paymentProcessor), 
                AdvancedOrder(
                    saleDetails, 
                    sellerSignature,
                    cosignature,
                    permitContext
                ),
                bulkOrderProof,
                feeOnTop
            );

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListingAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _buyEmptyCosignedListingWithFeeOnTopPermitted(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory sellerSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingAdvancedCalldata(
                address(_paymentProcessor), 
                AdvancedOrder(
                    saleDetails, 
                    sellerSignature,
                    cosignature,
                    permitContext
                ),
                bulkOrderProof,
                feeOnTop
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListingAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _buyEmptyCosignedListingWithFeeOnTopPermitted(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory sellerSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingAdvancedCalldata(
                address(_paymentProcessor), 
                AdvancedOrder(
                    saleDetails, 
                    sellerSignature,
                    cosignature,
                    permitContext
                ),
                bulkOrderProof,
                feeOnTop
            );

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListingAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _buySignedListingWithFeeOnTopPermitted(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory sellerSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingAdvancedCalldata(
                address(_paymentProcessor), 
                AdvancedOrder(
                    saleDetails, 
                    sellerSignature,
                    Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                    permitContext
                ),
                bulkOrderProof,
                feeOnTop
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListingAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _buySignedListingWithFeeOnTopPermitted(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory sellerSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingAdvancedCalldata(
                address(_paymentProcessor), 
                AdvancedOrder(
                    saleDetails, 
                    sellerSignature,
                    Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)}),
                    permitContext
                ),
                bulkOrderProof,
                feeOnTop
            );

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListingAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    // Bulk Buy Listings Advanced

    function _bulkBuyCosignedListingsPermitted(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedOrder[] memory matchedOrders = new AdvancedOrder[](saleDetailsArray.length);
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            (sellerSignaturesArray[i], cosignatureArray[i]) = _getCosignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, permitContext, saleDetailsArray[i], caller);
            AdvancedOrder memory advancedOrder = matchedOrders[i];
            advancedOrder.permitContext = permitContext;
            advancedOrder.saleDetails = saleDetailsArray[i];
            advancedOrder.signature = sellerSignaturesArray[i];
            advancedOrder.cosignature = cosignatureArray[i];
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOrders,
                bulkOrderProofs,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListingsAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuyCosignedListingsPermitted(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedOrder[] memory matchedOrders = new AdvancedOrder[](saleDetailsArray.length);
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            (sellerSignaturesArray[i], cosignatureArray[i]) = _getCosignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, permitContext, saleDetailsArray[i], caller);
            AdvancedOrder memory advancedOrder = matchedOrders[i];
            advancedOrder.permitContext = permitContext;
            advancedOrder.saleDetails = saleDetailsArray[i];
            advancedOrder.signature = sellerSignaturesArray[i];
            advancedOrder.cosignature = cosignatureArray[i];
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOrders,
                bulkOrderProofs,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListingsAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkBuyCosignedListingsWithFeesOnTopPermitted(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedOrder[] memory matchedOrders = new AdvancedOrder[](saleDetailsArray.length);
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            (sellerSignaturesArray[i], cosignatureArray[i]) = _getCosignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, permitContext, saleDetailsArray[i], caller);

            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }

            AdvancedOrder memory advancedOrder = matchedOrders[i];
            advancedOrder.permitContext = permitContext;
            advancedOrder.saleDetails = saleDetailsArray[i];
            advancedOrder.signature = sellerSignaturesArray[i];
            advancedOrder.cosignature = cosignatureArray[i];
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOrders,
                bulkOrderProofs,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListingsAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuyCosignedListingsWithFeesOnTopPermitted(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedOrder[] memory matchedOrders = new AdvancedOrder[](saleDetailsArray.length);
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            (sellerSignaturesArray[i], cosignatureArray[i]) = _getCosignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, permitContext, saleDetailsArray[i], caller);

            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }

            AdvancedOrder memory advancedOrder = matchedOrders[i];
            advancedOrder.permitContext = permitContext;
            advancedOrder.saleDetails = saleDetailsArray[i];
            advancedOrder.signature = sellerSignaturesArray[i];
            advancedOrder.cosignature = cosignatureArray[i];
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOrders,
                bulkOrderProofs,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListingsAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkBuyEmptyCosignedListingsWithFeesOnTopPermitted(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedOrder[] memory matchedOrders = new AdvancedOrder[](saleDetailsArray.length);
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            sellerSignaturesArray[i] = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
            cosignatureArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }

            AdvancedOrder memory advancedOrder = matchedOrders[i];
            advancedOrder.permitContext = permitContext;
            advancedOrder.saleDetails = saleDetailsArray[i];
            advancedOrder.signature = sellerSignaturesArray[i];
            advancedOrder.cosignature = cosignatureArray[i];
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOrders,
                bulkOrderProofs,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListingsAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuyEmptyCosignedListingsWithFeesOnTopPermitted(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedOrder[] memory matchedOrders = new AdvancedOrder[](saleDetailsArray.length);
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);
        Cosignature[] memory cosignatureArray = new Cosignature[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            sellerSignaturesArray[i] = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
            cosignatureArray[i] = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }

            AdvancedOrder memory advancedOrder = matchedOrders[i];
            advancedOrder.permitContext = permitContext;
            advancedOrder.saleDetails = saleDetailsArray[i];
            advancedOrder.signature = sellerSignaturesArray[i];
            advancedOrder.cosignature = cosignatureArray[i];
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOrders,
                bulkOrderProofs,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListingsAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkBuyEmptyCosignedListingsPermitted(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedOrder[] memory matchedOrders = new AdvancedOrder[](saleDetailsArray.length);
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            sellerSignaturesArray[i] = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);

            AdvancedOrder memory advancedOrder = matchedOrders[i];
            advancedOrder.permitContext = permitContext;
            advancedOrder.saleDetails = saleDetailsArray[i];
            advancedOrder.signature = sellerSignaturesArray[i];
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOrders,
                bulkOrderProofs,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListingsAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuyEmptyCosignedListingsPermitted(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedOrder[] memory matchedOrders = new AdvancedOrder[](saleDetailsArray.length);
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            sellerSignaturesArray[i] = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);

            AdvancedOrder memory advancedOrder = matchedOrders[i];
            advancedOrder.permitContext = permitContext;
            advancedOrder.saleDetails = saleDetailsArray[i];
            advancedOrder.signature = sellerSignaturesArray[i];
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOrders,
                bulkOrderProofs,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListingsAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkBuySignedListingsPermitted(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedOrder[] memory matchedOrders = new AdvancedOrder[](saleDetailsArray.length);
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            sellerSignaturesArray[i] = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
            
            AdvancedOrder memory advancedOrder = matchedOrders[i];
            advancedOrder.permitContext = permitContext;
            advancedOrder.saleDetails = saleDetailsArray[i];
            advancedOrder.signature = sellerSignaturesArray[i];
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOrders,
                bulkOrderProofs,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListingsAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuySignedListingsPermitted(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedOrder[] memory matchedOrders = new AdvancedOrder[](saleDetailsArray.length);
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            sellerSignaturesArray[i] = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
            
            AdvancedOrder memory advancedOrder = matchedOrders[i];
            advancedOrder.permitContext = permitContext;
            advancedOrder.saleDetails = saleDetailsArray[i];
            advancedOrder.signature = sellerSignaturesArray[i];
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOrders,
                bulkOrderProofs,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListingsAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkBuySignedListingsWithFeeOnTopPermitted(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedOrder[] memory matchedOrders = new AdvancedOrder[](saleDetailsArray.length);
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            sellerSignaturesArray[i] = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
            
            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }

            AdvancedOrder memory advancedOrder = matchedOrders[i];
            advancedOrder.permitContext = permitContext;
            advancedOrder.saleDetails = saleDetailsArray[i];
            advancedOrder.signature = sellerSignaturesArray[i];
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOrders,
                bulkOrderProofs,
                feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListingsAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuySignedListingsWithFeeOnTopPermitted(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedOrder[] memory matchedOrders = new AdvancedOrder[](saleDetailsArray.length);
        SignatureECDSA[] memory sellerSignaturesArray = new SignatureECDSA[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            sellerSignaturesArray[i] = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
            
            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }

            AdvancedOrder memory advancedOrder = matchedOrders[i];
            advancedOrder.permitContext = permitContext;
            advancedOrder.saleDetails = saleDetailsArray[i];
            advancedOrder.signature = sellerSignaturesArray[i];
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOrders,
                bulkOrderProofs,
                feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListingsAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _getSignedSaleApprovalPermitted(uint256 sellerKey_, PermitContext memory permitContext, Order memory saleDetails) internal view returns (SignatureECDSA memory) {
        (SignatureECDSA memory signedListing,) = _getSignedSaleApprovalAndDigestPermitted(sellerKey_, permitContext, saleDetails);
        return signedListing;
    }

    function _getSignedSaleApprovalAndDigestPermitted(uint256 sellerKey_, PermitContext memory permitContext, Order memory saleDetails) internal view returns (SignatureECDSA memory, bytes32 digest) {
        address seller = vm.addr(sellerKey_);
        uint256 permittedAmount = saleDetails.amount;
        uint256 permittedItemPrice = saleDetails.itemPrice;
        if (saleDetails.maker != seller && saleDetails.protocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
            permittedAmount = saleDetails.requestedFillAmount;
            permittedItemPrice = saleDetails.itemPrice / saleDetails.amount * permittedAmount;
        }

        PermitC permitProcessor = PermitC(permitContext.permitProcessor);

        bytes32 additionalData = keccak256(
            bytes.concat(
                abi.encode(
                    SALE_APPROVAL_HASH,
                    uint8(saleDetails.protocol),
                    address(0),
                    seller,
                    saleDetails.marketplace,
                    saleDetails.fallbackRoyaltyRecipient,
                    saleDetails.paymentMethod,
                    saleDetails.tokenAddress,
                    saleDetails.tokenId
                ),
                abi.encode(
                    permittedAmount,
                    permittedItemPrice,
                    saleDetails.expiration,
                    saleDetails.marketplaceFeeNumerator,
                    saleDetails.maxRoyaltyFeeNumerator,
                    saleDetails.nonce,
                    _paymentProcessor.masterNonces(seller),
                    saleDetails.protocolFeeVersion
                )
            )
        );
        
        if (saleDetails.protocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
            permittedAmount = 1;
        }

        digest = 
            ECDSA.toTypedDataHash(
                permitProcessor.domainSeparatorV4(), 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            (saleDetails.protocol != ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL || saleDetails.maker != seller ? PERMITTED_TRANSFER_SALE_APPROVAL : PERMITTED_ORDER_SALE_APPROVAL),
                            (saleDetails.protocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? 721 : 1155),
                            saleDetails.tokenAddress,
                            saleDetails.tokenId,
                            permittedAmount,
                            permitContext.permitNonce
                        ),
                        abi.encode(
                            address(_paymentProcessor),
                            saleDetails.expiration,
                            permitProcessor.masterNonce(seller),
                            additionalData
                        )
                    )
                )
            );
    
        (uint8 listingV, bytes32 listingR, bytes32 listingS) = vm.sign(sellerKey_, digest);
        SignatureECDSA memory signedListing = SignatureECDSA({v: listingV, r: listingR, s: listingS});
    
        return (signedListing, digest);
    }

    function _getCosignedSaleApprovalPermitted(uint256 signerKey_, uint256 cosignerKey_, PermitContext memory permitContext, Order memory saleDetails, address taker) internal view returns (SignatureECDSA memory, Cosignature memory) {
        (
            bytes32 additionalData, 
            address seller, 
            uint256 permittedAmount
        ) = _getCosignedSaleApprovalAdditionalDataHash(signerKey_, cosignerKey_, permitContext, saleDetails, taker);

        if (saleDetails.protocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
            permittedAmount = 1;
        }

        bytes32 digest = 
            ECDSA.toTypedDataHash(
                PermitC(permitContext.permitProcessor).domainSeparatorV4(), 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            (saleDetails.protocol != ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL ? PERMITTED_TRANSFER_SALE_APPROVAL : PERMITTED_ORDER_SALE_APPROVAL),
                            (saleDetails.protocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? 721 : 1155),
                            saleDetails.tokenAddress,
                            saleDetails.tokenId,
                            permittedAmount,
                            permitContext.permitNonce
                        ),
                        abi.encode(
                            address(_paymentProcessor),
                            saleDetails.expiration,
                            PermitC(permitContext.permitProcessor).masterNonce(seller),
                            additionalData
                        )
                    )
                )
            );
    
        (uint8 listingV, bytes32 listingR, bytes32 listingS) = vm.sign(signerKey_, digest);
        SignatureECDSA memory signedListing = SignatureECDSA({v: listingV, r: listingR, s: listingS});
    
        return (
            signedListing, 
            _getCosignature(cosignerKey_, signedListing, block.timestamp + 10 minutes, taker));
    }

    function _getCosignedSaleApprovalAdditionalDataHash(uint256 signerKey_, uint256 cosignerKey_, PermitContext memory permitContext, Order memory saleDetails, address taker) internal view returns (bytes32 additionalData, address seller, uint256 permittedAmount) {
        seller = vm.addr(signerKey_);
        permittedAmount = saleDetails.amount;
        uint256 permittedItemPrice = saleDetails.itemPrice;
        if (saleDetails.maker != seller && saleDetails.protocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
            permittedAmount = saleDetails.requestedFillAmount;
            permittedItemPrice = saleDetails.itemPrice / saleDetails.amount * permittedAmount;
        }

        additionalData = keccak256(
            bytes.concat(
                abi.encode(
                    SALE_APPROVAL_HASH,
                    uint8(saleDetails.protocol),
                    vm.addr(cosignerKey_),
                    saleDetails.maker,
                    saleDetails.marketplace,
                    saleDetails.fallbackRoyaltyRecipient,
                    saleDetails.paymentMethod,
                    saleDetails.tokenAddress,
                    saleDetails.tokenId
                ),
                abi.encode(
                    permittedAmount,
                    permittedItemPrice,
                    saleDetails.expiration,
                    saleDetails.marketplaceFeeNumerator,
                    saleDetails.maxRoyaltyFeeNumerator,
                    saleDetails.nonce,
                    _paymentProcessor.masterNonces(seller),
                    saleDetails.protocolFeeVersion
                )
            )
        );
    }

    // Accept Offers

    function _acceptCosignedItemOfferPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedItemOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_ITEM_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                tokenSetProof
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptCosignedItemOfferPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedItemOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_ITEM_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                tokenSetProof
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptEmptyCosignedItemOfferPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_ITEM_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                tokenSetProof
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptEmptyCosignedItemOfferPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_ITEM_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                tokenSetProof
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptEmptyCosignedItemOfferWithFeeOnTopPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_ITEM_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptEmptyCosignedItemOfferWithFeeOnTopPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_ITEM_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptSignedItemOfferPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_ITEM_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                tokenSetProof
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptSignedItemOfferPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_ITEM_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                tokenSetProof
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptCosignedItemOfferWithFeeOnTopPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedItemOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_ITEM_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptCosignedItemOfferWithFeeOnTopPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedItemOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_ITEM_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptSignedItemOfferWithFeeOnTopPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_ITEM_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptSignedItemOfferWithFeeOnTopPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedItemOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_ITEM_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptCosignedCollectionOfferPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedCollectionOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_COLLECTION_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                tokenSetProof
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptCosignedCollectionOfferPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedCollectionOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_COLLECTION_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                tokenSetProof
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptEmptyCosignedCollectionOfferPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_COLLECTION_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                tokenSetProof
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptEmptyCosignedCollectionOfferPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_COLLECTION_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                tokenSetProof
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptEmptyCosignedCollectionOfferWithFeeOnTopPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_COLLECTION_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptEmptyCosignedCollectionOfferWithFeeOnTopPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_COLLECTION_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptSignedCollectionOfferPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_COLLECTION_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                tokenSetProof
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptSignedCollectionOfferPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_COLLECTION_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                tokenSetProof
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptCosignedCollectionOfferWithFeeOnTopPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedCollectionOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_COLLECTION_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptCosignedCollectionOfferWithFeeOnTopPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedCollectionOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, caller);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_COLLECTION_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.cosignature = cosignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptSignedCollectionOfferWithFeeOnTopPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_COLLECTION_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptSignedCollectionOfferWithFeeOnTopPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(permitC),
            permitNonce: saleDetails.nonce
        });

        SignatureECDSA memory buyerSignature = _getSignedCollectionOffer(fuzzedOrderInputs.buyerKey, saleDetails);
        SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

        AdvancedBidOrder memory advancedBidOrder;
        advancedBidOrder.offerType = OFFER_TYPE_COLLECTION_OFFER;
        advancedBidOrder.advancedOrder.saleDetails = saleDetails;
        advancedBidOrder.advancedOrder.signature = buyerSignature;
        advancedBidOrder.advancedOrder.permitContext = permitContext;
        advancedBidOrder.sellerPermitSignature = sellerPermitSignature;

        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptCosignedTokenSetOfferPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder memory advancedBidOrder;

        {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetails.nonce
            });

            (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedTokenSetOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, tokenSetProof, caller);
            SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

            advancedBidOrder.offerType = OFFER_TYPE_TOKEN_SET_OFFER;
            advancedBidOrder.advancedOrder.saleDetails = saleDetails;
            advancedBidOrder.advancedOrder.signature = buyerSignature;
            advancedBidOrder.advancedOrder.cosignature = cosignature;
            advancedBidOrder.advancedOrder.permitContext = permitContext;
            advancedBidOrder.sellerPermitSignature = sellerPermitSignature;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                TokenSetProof({proof: tokenSetProof.proof})
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptCosignedTokenSetOfferPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory testTokenSetProof, bytes4 expectedRevertSelector) internal {
        
        AdvancedBidOrder memory advancedBidOrder;
        
        {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetails.nonce
            });

            (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedTokenSetOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, testTokenSetProof, caller);
            SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

            advancedBidOrder.offerType = OFFER_TYPE_TOKEN_SET_OFFER;
            advancedBidOrder.advancedOrder.saleDetails = saleDetails;
            advancedBidOrder.advancedOrder.signature = buyerSignature;
            advancedBidOrder.advancedOrder.cosignature = cosignature;
            advancedBidOrder.advancedOrder.permitContext = permitContext;
            advancedBidOrder.sellerPermitSignature = sellerPermitSignature;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                TokenSetProof({proof: testTokenSetProof.proof})
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptEmptyCosignedTokenSetOfferPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder memory advancedBidOrder;
        
        {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetails.nonce
            });

            SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);
            Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

            advancedBidOrder.offerType = OFFER_TYPE_TOKEN_SET_OFFER;
            advancedBidOrder.advancedOrder.saleDetails = saleDetails;
            advancedBidOrder.advancedOrder.signature = buyerSignature;
            advancedBidOrder.advancedOrder.cosignature = cosignature;
            advancedBidOrder.advancedOrder.permitContext = permitContext;
            advancedBidOrder.sellerPermitSignature = sellerPermitSignature;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                TokenSetProof({proof: tokenSetProof.proof})
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptEmptyCosignedTokenSetOfferPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory testTokenSetProof, bytes4 expectedRevertSelector) internal {
        
        AdvancedBidOrder memory advancedBidOrder;
        
        {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetails.nonce
            });

            SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, testTokenSetProof);
            Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

            advancedBidOrder.offerType = OFFER_TYPE_TOKEN_SET_OFFER;
            advancedBidOrder.advancedOrder.saleDetails = saleDetails;
            advancedBidOrder.advancedOrder.signature = buyerSignature;
            advancedBidOrder.advancedOrder.cosignature = cosignature;
            advancedBidOrder.advancedOrder.permitContext = permitContext;
            advancedBidOrder.sellerPermitSignature = sellerPermitSignature;
        }

        BulkOrderProof memory bulkOrderProof;
        FeeOnTop memory feeOnTop;
        TokenSetProof memory tokenSetProof;
        tokenSetProof.proof = testTokenSetProof.proof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptEmptyCosignedTokenSetOfferWithFeeOnTopPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder memory advancedBidOrder;
        
        {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetails.nonce
            });

            SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);
            Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

            advancedBidOrder.offerType = OFFER_TYPE_TOKEN_SET_OFFER;
            advancedBidOrder.advancedOrder.saleDetails = saleDetails;
            advancedBidOrder.advancedOrder.signature = buyerSignature;
            advancedBidOrder.advancedOrder.cosignature = cosignature;
            advancedBidOrder.advancedOrder.permitContext = permitContext;
            advancedBidOrder.sellerPermitSignature = sellerPermitSignature;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                TokenSetProof({proof: tokenSetProof.proof})
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptEmptyCosignedTokenSetOfferWithFeeOnTopPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory testTokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        
        AdvancedBidOrder memory advancedBidOrder;
        
        {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetails.nonce
            });

            SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, testTokenSetProof);
            Cosignature memory cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});
            SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

            advancedBidOrder.offerType = OFFER_TYPE_TOKEN_SET_OFFER;
            advancedBidOrder.advancedOrder.saleDetails = saleDetails;
            advancedBidOrder.advancedOrder.signature = buyerSignature;
            advancedBidOrder.advancedOrder.cosignature = cosignature;
            advancedBidOrder.advancedOrder.permitContext = permitContext;
            advancedBidOrder.sellerPermitSignature = sellerPermitSignature;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                TokenSetProof({proof: testTokenSetProof.proof})
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptSignedTokenSetOfferPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder memory advancedBidOrder;

        {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetails.nonce
            });

            SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);
            SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

            advancedBidOrder.offerType = OFFER_TYPE_TOKEN_SET_OFFER;
            advancedBidOrder.advancedOrder.saleDetails = saleDetails;
            advancedBidOrder.advancedOrder.signature = buyerSignature;
            advancedBidOrder.advancedOrder.permitContext = permitContext;
            advancedBidOrder.sellerPermitSignature = sellerPermitSignature;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({amount: 0, recipient: address(0)}),
                TokenSetProof({proof: tokenSetProof.proof})
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptSignedTokenSetOfferPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        
        AdvancedBidOrder memory advancedBidOrder;
        
        {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetails.nonce
            });

            SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);
            SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

            advancedBidOrder.offerType = OFFER_TYPE_TOKEN_SET_OFFER;
            advancedBidOrder.advancedOrder.saleDetails = saleDetails;
            advancedBidOrder.advancedOrder.signature = buyerSignature;
            advancedBidOrder.advancedOrder.permitContext = permitContext;
            advancedBidOrder.sellerPermitSignature = sellerPermitSignature;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                FeeOnTop({amount: 0, recipient: address(0)}),
                TokenSetProof({proof: tokenSetProof.proof})
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptCosignedTokenSetOfferWithFeeOnTopPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        
        AdvancedBidOrder memory advancedBidOrder;
        
        {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetails.nonce
            });

            (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedTokenSetOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, tokenSetProof, caller);
            SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

            advancedBidOrder.offerType = OFFER_TYPE_TOKEN_SET_OFFER;
            advancedBidOrder.advancedOrder.saleDetails = saleDetails;
            advancedBidOrder.advancedOrder.signature = buyerSignature;
            advancedBidOrder.advancedOrder.cosignature = cosignature;
            advancedBidOrder.advancedOrder.permitContext = permitContext;
            advancedBidOrder.sellerPermitSignature = sellerPermitSignature;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                TokenSetProof({proof: tokenSetProof.proof})
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptCosignedTokenSetOfferWithFeeOnTopPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        
        AdvancedBidOrder memory advancedBidOrder;
        
        {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetails.nonce
            });

            (SignatureECDSA memory buyerSignature, Cosignature memory cosignature) = _getCosignedTokenSetOffer(fuzzedOrderInputs.buyerKey, fuzzedOrderInputs.cosignerKey, saleDetails, tokenSetProof, caller);
            SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

            advancedBidOrder.offerType = OFFER_TYPE_TOKEN_SET_OFFER;
            advancedBidOrder.advancedOrder.saleDetails = saleDetails;
            advancedBidOrder.advancedOrder.signature = buyerSignature;
            advancedBidOrder.advancedOrder.cosignature = cosignature;
            advancedBidOrder.advancedOrder.permitContext = permitContext;
            advancedBidOrder.sellerPermitSignature = sellerPermitSignature;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                TokenSetProof({proof: tokenSetProof.proof})
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _acceptSignedTokenSetOfferWithFeeOnTopPermitted(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        
        AdvancedBidOrder memory advancedBidOrder;
        
        {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetails.nonce
            });

            SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);
            SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

            advancedBidOrder.offerType = OFFER_TYPE_TOKEN_SET_OFFER;
            advancedBidOrder.advancedOrder.saleDetails = saleDetails;
            advancedBidOrder.advancedOrder.signature = buyerSignature;
            advancedBidOrder.advancedOrder.permitContext = permitContext;
            advancedBidOrder.sellerPermitSignature = sellerPermitSignature;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                TokenSetProof({proof: tokenSetProof.proof})
            );

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptSignedTokenSetOfferWithFeeOnTopPermitted(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        
        AdvancedBidOrder memory advancedBidOrder;
        
        {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetails.nonce
            });

            SignatureECDSA memory buyerSignature = _getSignedTokenSetOffer(fuzzedOrderInputs.buyerKey, saleDetails, tokenSetProof);
            SignatureECDSA memory sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputs.sellerKey, permitContext, saleDetails);

            advancedBidOrder.offerType = OFFER_TYPE_TOKEN_SET_OFFER;
            advancedBidOrder.advancedOrder.saleDetails = saleDetails;
            advancedBidOrder.advancedOrder.signature = buyerSignature;
            advancedBidOrder.advancedOrder.permitContext = permitContext;
            advancedBidOrder.sellerPermitSignature = sellerPermitSignature;
        }

        BulkOrderProof memory bulkOrderProof;
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor),
                advancedBidOrder,
                bulkOrderProof,
                feeOnTop,
                TokenSetProof({proof: tokenSetProof.proof})
            );

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    // Bulk Accept Offers

    function _bulkAcceptCosignedItemOffersPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_ITEM_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            (
                matchedOffers[i].advancedOrder.signature, 
                matchedOffers[i].advancedOrder.cosignature
            ) = _getCosignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptCosignedItemOffersPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_ITEM_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            (
                matchedOffers[i].advancedOrder.signature, 
                matchedOffers[i].advancedOrder.cosignature
            ) = _getCosignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptEmptyCosignedItemOffersPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_ITEM_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedItemOffersPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_ITEM_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptCosignedItemOffersWithFeesOnTopPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_ITEM_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            (
                matchedOffers[i].advancedOrder.signature, 
                matchedOffers[i].advancedOrder.cosignature
            ) = _getCosignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptCosignedItemOffersWithFeesOnTopPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_ITEM_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            (
                matchedOffers[i].advancedOrder.signature, 
                matchedOffers[i].advancedOrder.cosignature
            ) = _getCosignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptEmptyCosignedItemOffersWithFeesOnTopPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_ITEM_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedItemOffersWithFeesOnTopPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_ITEM_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptSignedItemOffersPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_ITEM_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptSignedItemOffersPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_ITEM_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptSignedItemOffersWithFeesOnTopPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_ITEM_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptSignedItemOffersWithFeesOnTopPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_ITEM_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedItemOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptCosignedCollectionOffersPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_COLLECTION_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            (
                matchedOffers[i].advancedOrder.signature, 
                matchedOffers[i].advancedOrder.cosignature
            ) = _getCosignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptCosignedCollectionOffersPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_COLLECTION_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            (
                matchedOffers[i].advancedOrder.signature, 
                matchedOffers[i].advancedOrder.cosignature
            ) = _getCosignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptCosignedCollectionOffersWithFeesOnTopPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_COLLECTION_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            (
                matchedOffers[i].advancedOrder.signature, 
                matchedOffers[i].advancedOrder.cosignature
            ) = _getCosignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptCosignedCollectionOffersWithFeesOnTopPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_COLLECTION_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            (
                matchedOffers[i].advancedOrder.signature, 
                matchedOffers[i].advancedOrder.cosignature
            ) = _getCosignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], caller);

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptEmptyCosignedCollectionOffersPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_COLLECTION_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedCollectionOffersPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_COLLECTION_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptEmptyCosignedCollectionOffersWithFeesOnTopPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_COLLECTION_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedCollectionOffersWithFeesOnTopPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_COLLECTION_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptSignedCollectionOffersPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_COLLECTION_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptSignedCollectionOffersPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_COLLECTION_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptSignedCollectionOffersWithFeesOnTopPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_COLLECTION_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptSignedCollectionOffersWithFeesOnTopPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_COLLECTION_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedCollectionOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptCosignedTokenSetOffersPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_TOKEN_SET_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            (
                matchedOffers[i].advancedOrder.signature, 
                matchedOffers[i].advancedOrder.cosignature
            ) = _getCosignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], tokenSetProofsArray[i], caller);

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        for (uint256 i; i < tokenSetProofs.length; ++i) {
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptCosignedTokenSetOffersPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_TOKEN_SET_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            (
                matchedOffers[i].advancedOrder.signature, 
                matchedOffers[i].advancedOrder.cosignature
            ) = _getCosignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], tokenSetProofsArray[i], caller);

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        for (uint256 i; i < tokenSetProofs.length; ++i) {
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptCosignedTokenSetOffersWithFeesOnTopPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_TOKEN_SET_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            (
                matchedOffers[i].advancedOrder.signature, 
                matchedOffers[i].advancedOrder.cosignature
            ) = _getCosignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], tokenSetProofsArray[i], caller);

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        for (uint256 i; i < tokenSetProofs.length; ++i) {
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptCosignedTokenSetOffersWithFeesOnTopPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_TOKEN_SET_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            (
                matchedOffers[i].advancedOrder.signature, 
                matchedOffers[i].advancedOrder.cosignature
            ) = _getCosignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, fuzzedOrderInputsArray[i].cosignerKey, saleDetailsArray[i], tokenSetProofsArray[i], caller);

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        for (uint256 i; i < tokenSetProofs.length; ++i) {
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptEmptyCosignedTokenSetOffersWithFeesOnTopPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_TOKEN_SET_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        for (uint256 i; i < tokenSetProofs.length; ++i) {
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedTokenSetOffersWithFeesOnTopPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_TOKEN_SET_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        for (uint256 i; i < tokenSetProofs.length; ++i) {
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptEmptyCosignedTokenSetOffersPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_TOKEN_SET_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        for (uint256 i; i < tokenSetProofs.length; ++i) {
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedTokenSetOffersPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_TOKEN_SET_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        for (uint256 i; i < tokenSetProofs.length; ++i) {
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptSignedTokenSetOffersPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_TOKEN_SET_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        for (uint256 i; i < tokenSetProofs.length; ++i) {
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptSignedTokenSetOffersPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_TOKEN_SET_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        for (uint256 i; i < tokenSetProofs.length; ++i) {
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _bulkAcceptSignedTokenSetOffersWithFeesOnTopPermitted(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_TOKEN_SET_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        for (uint256 i; i < tokenSetProofs.length; ++i) {
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptSignedTokenSetOffersWithFeesOnTopPermitted(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedBidOrder[] memory matchedOffers = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            PermitContext memory permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });

            matchedOffers[i].offerType = OFFER_TYPE_TOKEN_SET_OFFER;

            matchedOffers[i].advancedOrder.permitContext = permitContext;
            matchedOffers[i].advancedOrder.saleDetails = saleDetailsArray[i];
            matchedOffers[i].advancedOrder.signature = _getSignedTokenSetOffer(fuzzedOrderInputsArray[i].buyerKey, saleDetailsArray[i], tokenSetProofsArray[i]);
            matchedOffers[i].advancedOrder.cosignature = Cosignature({signer: address(0), taker: address(0), expiration: 0, v: 0, r: bytes32(0), s: bytes32(0)});

            matchedOffers[i].sellerPermitSignature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permitContext, saleDetailsArray[i]);
        }

        BulkOrderProof[] memory bulkOrderProofs = new BulkOrderProof[](saleDetailsArray.length);
        TokenSetProof[] memory tokenSetProofs = new TokenSetProof[](saleDetailsArray.length);
        for (uint256 i; i < tokenSetProofs.length; ++i) {
            tokenSetProofs[i] = TokenSetProof({proof: tokenSetProofsArray[i].proof});
        }
        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                matchedOffers,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    // Sweeps

    function _sweepSignedListingsPermitted(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory sweepItems = new AdvancedSweepItem[](saleDetailsArray.length);
        FeeOnTop memory feeOnTop = FeeOnTop({recipient: address(0), amount: 0});

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            AdvancedSweepItem memory permittedSweepItem = sweepItems[i];
            permittedSweepItem.permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            permittedSweepItem.signature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permittedSweepItem.permitContext, saleDetailsArray[i]);
            permittedSweepItem.sweepItem = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        AdvancedSweep memory advancedSweep;
        advancedSweep.sweepOrder = sweepOrder;
        advancedSweep.items = sweepItems;
        advancedSweep.feeOnTop = feeOnTop;

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionAdvancedCalldata(
                address(_paymentProcessor), 
                advancedSweep);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.sweepCollectionAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepSignedListingsPermitted(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory sweepItems = new AdvancedSweepItem[](saleDetailsArray.length);
        FeeOnTop memory feeOnTop = FeeOnTop({recipient: address(0), amount: 0});

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            AdvancedSweepItem memory permittedSweepItem = sweepItems[i];
            permittedSweepItem.permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            permittedSweepItem.signature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permittedSweepItem.permitContext, saleDetailsArray[i]);
            permittedSweepItem.sweepItem = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        AdvancedSweep memory advancedSweep;
        advancedSweep.sweepOrder = sweepOrder;
        advancedSweep.items = sweepItems;
        advancedSweep.feeOnTop = feeOnTop;

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionAdvancedCalldata(
                address(_paymentProcessor), 
                advancedSweep);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollectionAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepSignedListingsWithFeeOnTopPermitted(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory sweepItems = new AdvancedSweepItem[](saleDetailsArray.length);
        
        if (saleDetailsArray[0].paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + uint128(feeOnTop.amount);
        }

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            AdvancedSweepItem memory permittedSweepItem = sweepItems[i];
            permittedSweepItem.permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            permittedSweepItem.signature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permittedSweepItem.permitContext, saleDetailsArray[i]);
            permittedSweepItem.sweepItem = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        AdvancedSweep memory advancedSweep;
        advancedSweep.sweepOrder = sweepOrder;
        advancedSweep.items = sweepItems;
        advancedSweep.feeOnTop = feeOnTop;

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionAdvancedCalldata(
                address(_paymentProcessor), 
                advancedSweep);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.sweepCollectionAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepSignedListingsWithFeeOnTopPermitted(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory sweepItems = new AdvancedSweepItem[](saleDetailsArray.length);
        
        if (saleDetailsArray[0].paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + uint128(feeOnTop.amount);
        }

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            AdvancedSweepItem memory permittedSweepItem = sweepItems[i];
            permittedSweepItem.permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            permittedSweepItem.signature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permittedSweepItem.permitContext, saleDetailsArray[i]);
            permittedSweepItem.sweepItem = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        AdvancedSweep memory advancedSweep;
        advancedSweep.sweepOrder = sweepOrder;
        advancedSweep.items = sweepItems;
        advancedSweep.feeOnTop = feeOnTop;

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionAdvancedCalldata(
                address(_paymentProcessor), 
                advancedSweep);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollectionAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepCosignedListingsPermitted(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory sweepItems = new AdvancedSweepItem[](saleDetailsArray.length);
        FeeOnTop memory feeOnTop = FeeOnTop({recipient: address(0), amount: 0});

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            AdvancedSweepItem memory permittedSweepItem = sweepItems[i];
            permittedSweepItem.permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            (permittedSweepItem.signature, permittedSweepItem.cosignature) = _getCosignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, permittedSweepItem.permitContext, saleDetailsArray[i], caller);
            permittedSweepItem.sweepItem = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        AdvancedSweep memory advancedSweep;
        advancedSweep.sweepOrder = sweepOrder;
        advancedSweep.items = sweepItems;
        advancedSweep.feeOnTop = feeOnTop;

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionAdvancedCalldata(
                address(_paymentProcessor), 
                advancedSweep);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.sweepCollectionAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepCosignedListingsPermitted(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory sweepItems = new AdvancedSweepItem[](saleDetailsArray.length);
        FeeOnTop memory feeOnTop = FeeOnTop({recipient: address(0), amount: 0});

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            AdvancedSweepItem memory permittedSweepItem = sweepItems[i];
            permittedSweepItem.permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            (permittedSweepItem.signature, permittedSweepItem.cosignature) = _getCosignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, permittedSweepItem.permitContext, saleDetailsArray[i], caller);
            permittedSweepItem.sweepItem = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        AdvancedSweep memory advancedSweep;
        advancedSweep.sweepOrder = sweepOrder;
        advancedSweep.items = sweepItems;
        advancedSweep.feeOnTop = feeOnTop;

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionAdvancedCalldata(
                address(_paymentProcessor), 
                advancedSweep);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollectionAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepEmptyCosignedListingsPermitted(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory sweepItems = new AdvancedSweepItem[](saleDetailsArray.length);
        FeeOnTop memory feeOnTop = FeeOnTop({recipient: address(0), amount: 0});

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            AdvancedSweepItem memory permittedSweepItem = sweepItems[i];
            permittedSweepItem.permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            permittedSweepItem.signature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permittedSweepItem.permitContext, saleDetailsArray[i]);
            permittedSweepItem.sweepItem = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        AdvancedSweep memory advancedSweep;
        advancedSweep.sweepOrder = sweepOrder;
        advancedSweep.items = sweepItems;
        advancedSweep.feeOnTop = feeOnTop;

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionAdvancedCalldata(
                address(_paymentProcessor), 
                advancedSweep);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.sweepCollectionAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepEmptyCosignedListingsPermitted(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory sweepItems = new AdvancedSweepItem[](saleDetailsArray.length);
        FeeOnTop memory feeOnTop = FeeOnTop({recipient: address(0), amount: 0});

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            AdvancedSweepItem memory permittedSweepItem = sweepItems[i];
            permittedSweepItem.permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            permittedSweepItem.signature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permittedSweepItem.permitContext, saleDetailsArray[i]);
            permittedSweepItem.sweepItem = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        AdvancedSweep memory advancedSweep;
        advancedSweep.sweepOrder = sweepOrder;
        advancedSweep.items = sweepItems;
        advancedSweep.feeOnTop = feeOnTop;

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionAdvancedCalldata(
                address(_paymentProcessor), 
                advancedSweep);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollectionAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepCosignedListingsWithFeeOnTopPermitted(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory sweepItems = new AdvancedSweepItem[](saleDetailsArray.length);
        
        if (saleDetailsArray[0].paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + uint128(feeOnTop.amount);
        }

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            AdvancedSweepItem memory permittedSweepItem = sweepItems[i];
            permittedSweepItem.permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            (permittedSweepItem.signature, permittedSweepItem.cosignature) = _getCosignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, permittedSweepItem.permitContext, saleDetailsArray[i], caller);
            permittedSweepItem.sweepItem = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        AdvancedSweep memory advancedSweep;
        advancedSweep.sweepOrder = sweepOrder;
        advancedSweep.items = sweepItems;
        advancedSweep.feeOnTop = feeOnTop;

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionAdvancedCalldata(
                address(_paymentProcessor), 
                advancedSweep);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.sweepCollectionAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepCosignedListingsWithFeeOnTopPermitted(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory sweepItems = new AdvancedSweepItem[](saleDetailsArray.length);
        
        if (saleDetailsArray[0].paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + uint128(feeOnTop.amount);
        }

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            AdvancedSweepItem memory permittedSweepItem = sweepItems[i];
            permittedSweepItem.permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            (permittedSweepItem.signature, permittedSweepItem.cosignature) = _getCosignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, fuzzedOrderInputsArray[i].cosignerKey, permittedSweepItem.permitContext, saleDetailsArray[i], caller);
            permittedSweepItem.sweepItem = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        AdvancedSweep memory advancedSweep;
        advancedSweep.sweepOrder = sweepOrder;
        advancedSweep.items = sweepItems;
        advancedSweep.feeOnTop = feeOnTop;

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionAdvancedCalldata(
                address(_paymentProcessor), 
                advancedSweep);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollectionAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepEmptyCosignedListingsWithFeeOnTopPermitted(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory sweepItems = new AdvancedSweepItem[](saleDetailsArray.length);
        
        if (saleDetailsArray[0].paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + uint128(feeOnTop.amount);
        }

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            AdvancedSweepItem memory permittedSweepItem = sweepItems[i];
            permittedSweepItem.permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            permittedSweepItem.signature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permittedSweepItem.permitContext, saleDetailsArray[i]);
            permittedSweepItem.sweepItem = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        AdvancedSweep memory advancedSweep;
        advancedSweep.sweepOrder = sweepOrder;
        advancedSweep.items = sweepItems;
        advancedSweep.feeOnTop = feeOnTop;

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionAdvancedCalldata(
                address(_paymentProcessor), 
                advancedSweep);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }

        vm.prank(caller, caller);
        _paymentProcessor.sweepCollectionAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepEmptyCosignedListingsWithFeeOnTopPermitted(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory sweepItems = new AdvancedSweepItem[](saleDetailsArray.length);
        
        if (saleDetailsArray[0].paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + uint128(feeOnTop.amount);
        }

        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            AdvancedSweepItem memory permittedSweepItem = sweepItems[i];
            permittedSweepItem.permitContext = PermitContext({
                permitProcessor: address(permitC),
                permitNonce: saleDetailsArray[i].nonce
            });
            permittedSweepItem.signature = _getSignedSaleApprovalPermitted(fuzzedOrderInputsArray[i].sellerKey, permittedSweepItem.permitContext, saleDetailsArray[i]);
            permittedSweepItem.sweepItem = SweepItem({
                maker: saleDetailsArray[i].maker,
                marketplace: saleDetailsArray[i].marketplace,
                fallbackRoyaltyRecipient: saleDetailsArray[i].fallbackRoyaltyRecipient,
                tokenId: saleDetailsArray[i].tokenId,
                amount: saleDetailsArray[i].amount,
                itemPrice: saleDetailsArray[i].itemPrice,
                nonce: saleDetailsArray[i].nonce,
                expiration: saleDetailsArray[i].expiration,
                marketplaceFeeNumerator: saleDetailsArray[i].marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: saleDetailsArray[i].maxRoyaltyFeeNumerator,
                protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
            });
        }

        AdvancedSweep memory advancedSweep;
        advancedSweep.sweepOrder = sweepOrder;
        advancedSweep.items = sweepItems;
        advancedSweep.feeOnTop = feeOnTop;

        bytes memory fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionAdvancedCalldata(
                address(_paymentProcessor), 
                advancedSweep);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollectionAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    modifier fuzzProtocolFees(ProtocolFees memory protocolFees) {
        _santizeAndSetProtocolFees(protocolFees);
        _;
    }

    function _santizeAndSetProtocolFees(ProtocolFees memory protocolFees) internal {
        _sanitizeAddress(protocolFees.protocolFeeReceiver, new address[](0));

        protocolFees.minimumProtocolFeeBps = protocolFees.minimumProtocolFeeBps % 10001;
        protocolFees.marketplaceFeeProtocolTaxBps = protocolFees.marketplaceFeeProtocolTaxBps % 10001;
        protocolFees.feeOnTopProtocolTaxBps = protocolFees.feeOnTopProtocolTaxBps % 10001;

        _paymentProcessor.setProtocolFees(protocolFees, 30 days);
    }
}