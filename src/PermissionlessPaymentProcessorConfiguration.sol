//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "./DataTypes.sol";
import "./Errors.sol";
import "./interfaces/IPaymentProcessorConfiguration.sol";

import "@limitbreak/tm-core-lib/src/licenses/LicenseRef-PolyForm-Strict-1.0.0.sol";
import "@limitbreak/tm-core-lib/src/utils/security/RoleClient.sol";

/*
                                                     @@@@@@@@@@@@@@             
                                                    @@@@@@@@@@@@@@@@@@(         
                                                   @@@@@@@@@@@@@@@@@@@@@        
                                                  @@@@@@@@@@@@@@@@@@@@@@@@      
                                                           #@@@@@@@@@@@@@@      
                                                               @@@@@@@@@@@@     
                            @@@@@@@@@@@@@@*                    @@@@@@@@@@@@     
                           @@@@@@@@@@@@@@@     @               @@@@@@@@@@@@     
                          @@@@@@@@@@@@@@@     @                @@@@@@@@@@@      
                         @@@@@@@@@@@@@@@     @@               @@@@@@@@@@@@      
                        @@@@@@@@@@@@@@@     #@@             @@@@@@@@@@@@/       
                        @@@@@@@@@@@@@@.     @@@@@@@@@@@@@@@@@@@@@@@@@@@         
                       @@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@            
                      @@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@             
                     @@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@           
                    @@@@@@@@@@@@@@@     @@@@@&%%%%%%%%&&@@@@@@@@@@@@@@          
                    @@@@@@@@@@@@@@      @@@@@               @@@@@@@@@@@         
                   @@@@@@@@@@@@@@@     @@@@@                 @@@@@@@@@@@        
                  @@@@@@@@@@@@@@@     @@@@@@                 @@@@@@@@@@@        
                 @@@@@@@@@@@@@@@     @@@@@@@                 @@@@@@@@@@@        
                @@@@@@@@@@@@@@@     @@@@@@@                 @@@@@@@@@@@&        
                @@@@@@@@@@@@@@     *@@@@@@@               (@@@@@@@@@@@@         
               @@@@@@@@@@@@@@@     @@@@@@@@             @@@@@@@@@@@@@@          
              @@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           
             @@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@            
            @@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@              
           .@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                 
           @@@@@@@@@@@@@@%     @@@@@@@@@@@@@@@@@@@@@@@@(                        
          @@@@@@@@@@@@@@@                                                       
         @@@@@@@@@@@@@@@                                                        
        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                         
       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                          
       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&                                          
      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                           
 
* @title PermissionlessPaymentProcessorConfiguration
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 

contract PermissionlessPaymentProcessorConfiguration is RoleClient, IPaymentProcessorConfiguration {

    bytes32 private constant PP_V3_MODULE_ON_CHAIN_CANCELLATION = keccak256("PP_V3_MODULE_ON_CHAIN_CANCELLATION");
    bytes32 private constant PP_V3_MODULE_BUY_LISTINGS = keccak256("PP_V3_MODULE_BUY_LISTINGS");
    bytes32 private constant PP_V3_MODULE_ACCEPT_OFFERS = keccak256("PP_V3_MODULE_ACCEPT_OFFERS");
    bytes32 private constant PP_V3_MODULE_SWEEPS = keccak256("PP_V3_MODULE_SWEEPS");
    bytes32 private constant PP_V3_MAIN_DETERMINISTIC_ADDRESS = keccak256("PP_V3_MAIN_DETERMINISTIC_ADDRESS");

    ///@dev Configuration Values For Payment Processor Modules
    address private immutable _trustedForwarderFactory;
    address private immutable _wrappedNativeCoin;
    address private immutable defaultPaymentMethod1;
    address private immutable defaultPaymentMethod2;
    address private immutable defaultPaymentMethod3;
    address private immutable defaultPaymentMethod4;
    address private immutable permitProcessor1;
    address private immutable permitProcessor2;
    address private immutable _collectionSettingsRegistry;
    address private immutable _infrastructureFeeReceiver;

    /// @dev Configuration Values For Payment Processor Main Contract
    address private _infrastructureAdmin;

    constructor(
        address roleServer,
        address infrastructureAdmin,
        address infrastructureFeeReceiver,
        address wrappedNative, 
        address trustedForwarderFactory,
        address collectionSettingsRegistry,
        address permitProcessor1_,
        address permitProcessor2_) 
    RoleClient(roleServer) {
        if (roleServer == address(0) ||
            infrastructureAdmin == address(0) ||
            infrastructureFeeReceiver == address(0) ||
            wrappedNative == address(0) ||
            trustedForwarderFactory == address(0) || 
            collectionSettingsRegistry == address(0) ||
            permitProcessor1_ == address(0) ||
            permitProcessor2_ == address(0)) {
            revert PaymentProcessor__InvalidConstructorArguments();
        }

        _infrastructureAdmin = infrastructureAdmin;
        _infrastructureFeeReceiver = infrastructureFeeReceiver;
        _wrappedNativeCoin = wrappedNative;
        _trustedForwarderFactory = trustedForwarderFactory;
        _collectionSettingsRegistry = collectionSettingsRegistry;
        permitProcessor1 = permitProcessor1_;
        permitProcessor2 = permitProcessor2_;

        if (block.chainid == 1) { // ETH MAINNET
            defaultPaymentMethod1 = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
            defaultPaymentMethod2 = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
            defaultPaymentMethod3 = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 10) { // OPTIMISM MAINNET
            defaultPaymentMethod1 = address(0x4200000000000000000000000000000000000006);
            defaultPaymentMethod2 = address(0x4200000000000000000000000000000000000006);
            defaultPaymentMethod3 = address(0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85);
            defaultPaymentMethod4 = address(0x7F5c764cBc14f9669B88837ca1490cCa17c31607);
        } else if (block.chainid == 56) { // BSC MAINNET
            defaultPaymentMethod1 = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
            defaultPaymentMethod2 = address(0x2170Ed0880ac9A755fd29B2688956BD959F933F8);
            defaultPaymentMethod3 = address(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 137) { // POLYGON MAINNET
            defaultPaymentMethod1 = address(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270);
            defaultPaymentMethod2 = address(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619);
            defaultPaymentMethod3 = address(0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359);
            defaultPaymentMethod4 = address(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174);
        } else if (block.chainid == 324) { // ZKSYNC MAINNET
            defaultPaymentMethod1 = address(0x5AEa5775959fBC2557Cc8789bC1bf90A239D9a91);
            defaultPaymentMethod2 = address(0x5AEa5775959fBC2557Cc8789bC1bf90A239D9a91);
            defaultPaymentMethod3 = address(0x0000000000000000000000000000000000000000);
            defaultPaymentMethod4 = address(0x3355df6D4c9C3035724Fd0e3914dE96A5a83aaf4);
        } else if (block.chainid == 1101) { // POLYGON ZKEVM MAINNET
            defaultPaymentMethod1 = address(0x4F9A0e7FD2Bf6067db6994CF12E4495Df938E6e9);
            defaultPaymentMethod2 = address(0x4F9A0e7FD2Bf6067db6994CF12E4495Df938E6e9);
            defaultPaymentMethod3 = address(0xA8CE8aee21bC2A48a5EF670afCc9274C7bbbC035);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 8453) { // BASE MAINNET
            defaultPaymentMethod1 = address(0x4200000000000000000000000000000000000006);
            defaultPaymentMethod2 = address(0x4200000000000000000000000000000000000006);
            defaultPaymentMethod3 = address(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913);
            defaultPaymentMethod4 = address(0xd9aAEc86B65D86f6A7B5B1b0c42FFA531710b6CA);
        } else if (block.chainid == 42161) { // ARBITRUM MAINNET
            defaultPaymentMethod1 = address(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1);
            defaultPaymentMethod2 = address(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1);
            defaultPaymentMethod3 = address(0xaf88d065e77c8cC2239327C5EDb3A432268e5831);
            defaultPaymentMethod4 = address(0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8);
        } else if (block.chainid == 42170) { // ARBITRUM NOVA MAINNET
            defaultPaymentMethod1 = address(0x722E8BdD2ce80A4422E880164f2079488e115365);
            defaultPaymentMethod2 = address(0x722E8BdD2ce80A4422E880164f2079488e115365);
            defaultPaymentMethod3 = address(0x0000000000000000000000000000000000000000);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 43114) { // AVALANCHE MAINNET
            defaultPaymentMethod1 = address(0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7);
            defaultPaymentMethod2 = address(0x49D5c2BdFfac6CE2BFdB6640F4F80f226bc10bAB);
            defaultPaymentMethod3 = address(0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 59144) { // LINEA MAINNET
            defaultPaymentMethod1 = address(0xe5D7C2a44FfDDf6b295A15c148167daaAf5Cf34f);
            defaultPaymentMethod2 = address(0xe5D7C2a44FfDDf6b295A15c148167daaAf5Cf34f);
            defaultPaymentMethod3 = address(0x0000000000000000000000000000000000000000);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 7777777) { // ZORA MAINNET
            defaultPaymentMethod1 = address(0x4200000000000000000000000000000000000006);
            defaultPaymentMethod2 = address(0x4200000000000000000000000000000000000006);
            defaultPaymentMethod3 = address(0x0000000000000000000000000000000000000000);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 534352) { // SCROLL MAINNET
            defaultPaymentMethod1 = address(0x5300000000000000000000000000000000000004);
            defaultPaymentMethod2 = address(0x5300000000000000000000000000000000000004);
            defaultPaymentMethod3 = address(0x0000000000000000000000000000000000000000);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 5) { // GOERLI TESTNET
            defaultPaymentMethod1 = address(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6);
            defaultPaymentMethod2 = address(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6);
            defaultPaymentMethod3 = address(0x07865c6E87B9F70255377e024ace6630C1Eaa37F);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 999) { // ZORA TESTNET
            defaultPaymentMethod1 = address(0x4200000000000000000000000000000000000006);
            defaultPaymentMethod2 = address(0x4200000000000000000000000000000000000006);
            defaultPaymentMethod3 = address(0x0000000000000000000000000000000000000000);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 5001) { // MANTLE TESTNET
            defaultPaymentMethod1 = address(0xbAAFeC4B6eF4F5E0bAFA850CBC48364B953EFCf9);
            defaultPaymentMethod2 = address(0xbAAFeC4B6eF4F5E0bAFA850CBC48364B953EFCf9);
            defaultPaymentMethod3 = address(0x0000000000000000000000000000000000000000);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 59140) { // LINEA TESTNET
            defaultPaymentMethod1 = address(0x2C1b868d6596a18e32E61B901E4060C872647b6C);
            defaultPaymentMethod2 = address(0x2C1b868d6596a18e32E61B901E4060C872647b6C);
            defaultPaymentMethod3 = address(0x0000000000000000000000000000000000000000);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 80001) { // MUMBAI TESTNET
            defaultPaymentMethod1 = address(0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889);
            defaultPaymentMethod2 = address(0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa);
            defaultPaymentMethod3 = address(0x9999f7Fea5938fD3b1E26A12c3f2fb024e194f97);
            defaultPaymentMethod4 = address(0x0FA8781a83E46826621b3BC094Ea2A0212e71B23);
        } else if (block.chainid == 84531) { // BASE GOERLI TESTNET
            defaultPaymentMethod1 = address(0x4200000000000000000000000000000000000006);
            defaultPaymentMethod2 = address(0x4200000000000000000000000000000000000006);
            defaultPaymentMethod3 = address(0x0000000000000000000000000000000000000000);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 534353) { // SCROLL ALPHA TESTNET
            defaultPaymentMethod1 = address(0x7160570BB153Edd0Ea1775EC2b2Ac9b65F1aB61B);
            defaultPaymentMethod2 = address(0x7160570BB153Edd0Ea1775EC2b2Ac9b65F1aB61B);
            defaultPaymentMethod3 = address(0x0000000000000000000000000000000000000000);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        } else if (block.chainid == 11155111) { // SEPOLIA TESTNET
            defaultPaymentMethod1 = address(0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9);
            defaultPaymentMethod2 = address(0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9);
            defaultPaymentMethod3 = address(0x8267cF9254734C6Eb452a7bb9AAF97B392258b21);
            defaultPaymentMethod4 = address(0x0000000000000000000000000000000000000000);
        }
    }

    /**
     * @notice Returns the ERC2771 context setup params for payment processor modules.
     */
    function getPaymentProcessorModuleERC2771ContextParams() external view returns (address trustedForwarderFactory) {
        trustedForwarderFactory = _trustedForwarderFactory;
    }

    /**
     * @notice Returns the setup params for payment processor modules.
     */
    function getPaymentProcessorModuleDeploymentParams() 
        external 
        view 
        returns (
            address deterministicPaymentProcessorAddress,
            address wrappedNativeCoin,
            DefaultPaymentMethods memory defaultPaymentMethods,
            TrustedPermitProcessors memory trustedPermitProcessors,
            address collectionSettingsRegistry,
            address infrastructureFeeReceiver
        ) 
    {
        deterministicPaymentProcessorAddress = _getRoleHolderView(PP_V3_MAIN_DETERMINISTIC_ADDRESS);

        if (deterministicPaymentProcessorAddress == address(0)) {
            revert PaymentProcessor__UninitializedConfiguration();
        }

        wrappedNativeCoin = _wrappedNativeCoin;
        defaultPaymentMethods = DefaultPaymentMethods({
            defaultPaymentMethod1: defaultPaymentMethod1,
            defaultPaymentMethod2: defaultPaymentMethod2,
            defaultPaymentMethod3: defaultPaymentMethod3,
            defaultPaymentMethod4: defaultPaymentMethod4
        });
        trustedPermitProcessors = TrustedPermitProcessors({
            permitProcessor1: permitProcessor1,
            permitProcessor2: permitProcessor2
        });
        collectionSettingsRegistry = _collectionSettingsRegistry;
        infrastructureFeeReceiver = _infrastructureFeeReceiver;
    }

    /**
     * @notice Returns the setup params for payment processor.
     */
    function getPaymentProcessorDeploymentParams()
        external
        view
        returns (
            address defaultContractOwner,
            PaymentProcessorModules memory paymentProcessorModules
        )
    {
        defaultContractOwner = _infrastructureAdmin;

        paymentProcessorModules = PaymentProcessorModules({
            moduleOnChainCancellation: _getRoleHolderView(PP_V3_MODULE_ON_CHAIN_CANCELLATION),
            moduleBuyListings: _getRoleHolderView(PP_V3_MODULE_BUY_LISTINGS),
            moduleAcceptOffers: _getRoleHolderView(PP_V3_MODULE_ACCEPT_OFFERS),
            moduleSweeps: _getRoleHolderView(PP_V3_MODULE_SWEEPS)
        });

        if (paymentProcessorModules.moduleOnChainCancellation == address(0) ||
            paymentProcessorModules.moduleBuyListings == address(0) ||
            paymentProcessorModules.moduleAcceptOffers == address(0) ||
            paymentProcessorModules.moduleSweeps == address(0)) {
            revert PaymentProcessor__UninitializedConfiguration();
        }
    }

    function _setupRoles() internal virtual override {
        _setupRole(PP_V3_MODULE_ON_CHAIN_CANCELLATION, 0);
        _setupRole(PP_V3_MODULE_BUY_LISTINGS, 0);
        _setupRole(PP_V3_MODULE_ACCEPT_OFFERS, 0);
        _setupRole(PP_V3_MODULE_SWEEPS, 0);
        _setupRole(PP_V3_MAIN_DETERMINISTIC_ADDRESS, 0);
    }
}