pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../PaymentProcessorModule.t.sol";

contract BuyListingNewPermitProcessor is PaymentProcessorModuleTest {

    function _runTestBuyListing(uint256 msgValue, TestTradeSingleItemParams memory params, bool sync) internal {
        FuzzedOrder721 memory fuzzedOrderInputs = params.fuzzedOrderInputs;

        _scrubFuzzedOrderInputs(fuzzedOrderInputs);
        vm.assume(params.amount > 0);

        address token = params.orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? address(test721) : address(test1155);
        address buyer = fuzzedOrderInputs.buyerIsContract ? contractMock : vm.addr(fuzzedOrderInputs.buyerKey);
        params.cosigned = false;

        Order memory saleDetails = Order({
            protocol: params.orderProtocol,
            maker: vm.addr(fuzzedOrderInputs.sellerKey),
            beneficiary: fuzzedOrderInputs.beneficiary,
            marketplace: fuzzedOrderInputs.marketplace,
            fallbackRoyaltyRecipient: address(0),
            paymentMethod: params.paymentMethod,
            tokenAddress: token,
            tokenId: fuzzedOrderInputs.tokenId,
            amount: params.amount,
            itemPrice: fuzzedOrderInputs.itemPrice,
            nonce: _getNextNonce(vm.addr(fuzzedOrderInputs.sellerKey)),
            expiration: block.timestamp + fuzzedOrderInputs.expirationSeconds,
            marketplaceFeeNumerator: fuzzedOrderInputs.marketplaceFeeRate,
            maxRoyaltyFeeNumerator: fuzzedOrderInputs.royaltyFeeRate,
            requestedFillAmount: params.fillAmount,
            minimumFillAmount: params.fillAmount,
            protocolFeeVersion: _paymentProcessor.getProtocolFeeVersion()
        });

        PermitC newPermitProcessor = new PermitC("Test", "1", address(0), 0);
        newPermitProcessor.registerAdditionalDataHash("SaleApproval approval)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)");

        PermitContext memory permitContext = PermitContext({
            permitProcessor: address(newPermitProcessor),
            permitNonce: saleDetails.nonce
        });

        if (saleDetails.itemPrice % saleDetails.amount != 0) {
            saleDetails.itemPrice -= (saleDetails.itemPrice % saleDetails.amount);
        }

        uint256 paymentAmount = saleDetails.itemPrice;

        if (params.orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
            test721.mint(saleDetails.maker, saleDetails.tokenId);
            test721.setTokenRoyalty(saleDetails.tokenId, fuzzedOrderInputs.royaltyReceiver, uint96(saleDetails.maxRoyaltyFeeNumerator));

            vm.prank(saleDetails.maker);
            test721.setApprovalForAll(address(newPermitProcessor), true);
        } else {
            test1155.mint(saleDetails.maker, saleDetails.tokenId, saleDetails.amount);
            test1155.setTokenRoyalty(saleDetails.tokenId, fuzzedOrderInputs.royaltyReceiver, uint96(saleDetails.maxRoyaltyFeeNumerator));

            vm.prank(saleDetails.maker);
            test1155.setApprovalForAll(address(newPermitProcessor), true);

            if (params.orderProtocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
                vm.assume(params.amount > 0);
                vm.assume(params.fillAmount > 0);
                vm.assume(params.fillAmount < params.amount);
                vm.assume(fuzzedOrderInputs.itemPrice > params.amount);
                fuzzedOrderInputs.itemPrice = fuzzedOrderInputs.itemPrice - (fuzzedOrderInputs.itemPrice % uint128(params.amount));

                uint256 unitPrice = saleDetails.itemPrice / saleDetails.amount;
                paymentAmount = unitPrice * saleDetails.requestedFillAmount;
            }
        }

        if (params.paymentMethod == address(0)) {
            vm.deal(buyer, msgValue);
        } else {
            _allocateTokensAndApprovals(buyer, msgValue);
        }

        _setPaymentSettings(
            params.paymentSettings,
            saleDetails.itemPrice,
            token,
            params.paymentMethod,
            0,
            address(0),
            0,
            address(0),
            false,
            false);

        if (params.paymentSettings % 5 == uint8(PaymentSettings.PricingConstraints) || params.paymentSettings % 5 == uint8(PaymentSettings.PricingConstraintsCollectionOnly)) {
            if (params.orderProtocol != ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
                uint256 unitPrice = saleDetails.itemPrice / saleDetails.amount;
                vm.assume(unitPrice >= 1 ether && unitPrice <= 500 ether);
            } else {
                vm.assume(saleDetails.itemPrice >= 1 ether && saleDetails.itemPrice <= 500 ether);
            }
        }

        _addTrustedPermitProcessor(address(this), address(newPermitProcessor), sync);

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
    
        vm.prank(buyer, buyer);
        _paymentProcessor.buyListingAdvanced{value: params.paymentMethod == address(0) ? paymentAmount: 0}(fnCalldata);
    }

    function testTrustedPermitProcessorAddedWithSync(
        uint8 paymentSettings, 
        uint8 orderProtocol,
        bool isCosigned,
        bool isCosignatureEmpty,
        FuzzedOrder721 memory fuzzedOrderInputs,
        uint248 amount, 
        uint248 fillAmount
    ) public {
        orderProtocol = orderProtocol % 3;

        if (uint256(orderProtocol) == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
            amount = 1;
            fillAmount = 1;
        } else if (uint256(orderProtocol) == ORDER_PROTOCOLS_ERC1155_FILL_OR_KILL) {
            vm.assume(amount > 0);
            vm.assume(fillAmount > 0);
            vm.assume(fillAmount < amount);
            vm.assume(fuzzedOrderInputs.itemPrice > amount);
            fillAmount = amount;
        } else if (uint256(orderProtocol) == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
            vm.assume(amount > 0);
            vm.assume(fillAmount > 0);
            vm.assume(fillAmount < amount);
            vm.assume(fuzzedOrderInputs.itemPrice > amount);
            fuzzedOrderInputs.itemPrice = fuzzedOrderInputs.itemPrice - (fuzzedOrderInputs.itemPrice % uint128(amount));

            uint256 unitPrice = fuzzedOrderInputs.itemPrice / amount;
            vm.assume(unitPrice < 1 ether);
        }

        _runTestBuyListing(
            fuzzedOrderInputs.itemPrice,
            TestTradeSingleItemParams({
                paymentSettings: paymentSettings,
                orderProtocol: uint256(orderProtocol), 
                cosigned: isCosigned,
                isCosignatureEmpty: isCosignatureEmpty,
                paymentMethod: address(0),
                amount: amount, 
                fillAmount: fillAmount, 
                fuzzedOrderInputs: fuzzedOrderInputs
            }),
            true
        );
    }

    function testTrustedPermitProcessorAddedWithoutSync(
        uint8 paymentSettings, 
        uint8 orderProtocol,
        bool isCosigned,
        bool isCosignatureEmpty,
        FuzzedOrder721 memory fuzzedOrderInputs,
        uint248 amount, 
        uint248 fillAmount
    ) public {
        orderProtocol = orderProtocol % 3;

        if (uint256(orderProtocol) == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
            amount = 1;
            fillAmount = 1;
        } else if (uint256(orderProtocol) == ORDER_PROTOCOLS_ERC1155_FILL_OR_KILL) {
            vm.assume(amount > 0);
            vm.assume(fillAmount > 0);
            vm.assume(fillAmount < amount);
            vm.assume(fuzzedOrderInputs.itemPrice > amount);
            fillAmount = amount;
        } else if (uint256(orderProtocol) == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
            vm.assume(amount > 0);
            vm.assume(fillAmount > 0);
            vm.assume(fillAmount < amount);
            vm.assume(fuzzedOrderInputs.itemPrice > amount);
            fuzzedOrderInputs.itemPrice = fuzzedOrderInputs.itemPrice - (fuzzedOrderInputs.itemPrice % uint128(amount));

            uint256 unitPrice = fuzzedOrderInputs.itemPrice / amount;
            vm.assume(unitPrice < 1 ether);
        }

        _runTestBuyListing(
            fuzzedOrderInputs.itemPrice,
            TestTradeSingleItemParams({
                paymentSettings: paymentSettings,
                orderProtocol: uint256(orderProtocol), 
                cosigned: isCosigned,
                isCosignatureEmpty: isCosignatureEmpty,
                paymentMethod: address(0),
                amount: amount, 
                fillAmount: fillAmount, 
                fuzzedOrderInputs: fuzzedOrderInputs
            }),
            false
        );
    }
}