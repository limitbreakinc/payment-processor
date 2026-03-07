pragma solidity 0.8.24;

import "./BenchmarkForwardedAdvancedTradesBase.t.sol";

contract WarmBenchmarkAdvancedTradesBuyListing is BenchmarkForwardedAdvancedTradesBaseTest {

    function setUp() public virtual override {
        super.setUp();

        vm.startPrank(alice);
        uint256 nextAliceNonce = _getNextNonce(alice);
        _paymentProcessor.revokeSingleNonce(_paymentProcessorEncoder.encodeRevokeSingleNonceCalldata(address(_paymentProcessor), nextAliceNonce));
        permitC.invalidateUnorderedNonce(nextAliceNonce);
        vm.stopPrank();

        vm.startPrank(bob);
        uint256 nextBobNonce = _getNextNonce(bob);
        _paymentProcessor.revokeSingleNonce(_paymentProcessorEncoder.encodeRevokeSingleNonceCalldata(address(_paymentProcessor), nextBobNonce));
        permitC.invalidateUnorderedNonce(nextBobNonce);
        vm.stopPrank();

        test721.mint(alice, 10000001);
        test721.mint(bob, 10000002);
        test721.mint(benchmarkBeneficiary, 10000003);

        test1155.mint(alice, 10000001, 10000);
        test1155.mint(bob, 10000002, 10000);
        test1155.mint(benchmarkBeneficiary, 10000003, 10000);
    }

    /**********************************/
    /*  BUY LISTING FOR SELF WITH ETH */
    /**********************************/

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_ETH() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_ETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /**********************************/
    /*  BUY LISTING FOR SELF WITH WETH */
    /**********************************/

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_WETH() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_WETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /*****************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH */
    /*****************************************/

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_ETH() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /******************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH */
    /******************************************/

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_WETH() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /*******************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH */
    /*******************************************/

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /********************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH */
    /********************************************/

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /*************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH */
    /*************************************************/

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /**************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH */
    /**************************************************/

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*********************************************/
    /*  BUY LISTING FOR SELF WITH ETH FEE ON TOP */
    /*********************************************/

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /**********************************************/
    /*  BUY LISTING FOR SELF WITH WETH FEE ON TOP */
    /**********************************************/

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH FEE ON TOP */
    /****************************************************/

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /*****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH FEE ON TOP */
    /*****************************************************/

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /***************************************************/
    /*  BUY LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /***************************************************/

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /****************************************************/
    /*  BUY LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /****************************************************/

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /**********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH EMPTY FEE ON TOP */
    /**********************************************************/

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /***********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH EMPTY FEE ON TOP */
    /***********************************************************/

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH FEE ON TOP */
    /******************************************************/

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /*******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*******************************************************/

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH FEE ON TOP */
    /************************************************************/

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*************************************************************/

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /************************************************************/

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /*************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /**********************************/
    /*  BUY LISTING FOR SELF WITH ETH */
    /**********************************/

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /**********************************/
    /*  BUY LISTING FOR SELF WITH WETH */
    /**********************************/

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /*****************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH */
    /*****************************************/

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /******************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH */
    /******************************************/

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /*******************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH */
    /*******************************************/

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /********************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH */
    /********************************************/

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /*************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH */
    /*************************************************/

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /**************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH */
    /**************************************************/

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*********************************************/
    /*  BUY LISTING FOR SELF WITH ETH FEE ON TOP */
    /*********************************************/

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /**********************************************/
    /*  BUY LISTING FOR SELF WITH WETH FEE ON TOP */
    /**********************************************/

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH FEE ON TOP */
    /****************************************************/

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /*****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH FEE ON TOP */
    /*****************************************************/

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /***************************************************/
    /*  BUY LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /***************************************************/

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /****************************************************/
    /*  BUY LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /****************************************************/

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /**********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH EMPTY FEE ON TOP */
    /**********************************************************/

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /***********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH EMPTY FEE ON TOP */
    /***********************************************************/

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkForwardedBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH FEE ON TOP */
    /******************************************************/

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /*******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*******************************************************/

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH FEE ON TOP */
    /************************************************************/

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*************************************************************/

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /************************************************************/

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /*************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkForwardedBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*******************************************************************/
    /*  PARTIAL FILL ERC1155 */
    /*******************************************************************/

    /**********************************/
    /*  BUY LISTING FOR SELF WITH WETH */
    /**********************************/

    function testBenchmarkForwardedBuyListingForSelfNoFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    /******************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH */
    /******************************************/

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    /********************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH */
    /********************************************/

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /**************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH */
    /**************************************************/

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /**********************************************/
    /*  BUY LISTING FOR SELF WITH WETH FEE ON TOP */
    /**********************************************/

    function testBenchmarkForwardedBuyListingForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    /*****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH FEE ON TOP */
    /*****************************************************/

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    /****************************************************/
    /*  BUY LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /****************************************************/

    function testBenchmarkForwardedBuyListingForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    /***********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH EMPTY FEE ON TOP */
    /***********************************************************/

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    /*******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*******************************************************/

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /*************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*************************************************************/

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /*************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /*******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /**********************************/
    /*  BUY LISTING FOR SELF WITH WETH */
    /**********************************/

    function testBenchmarkForwardedBuyListingForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    /******************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH */
    /******************************************/

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    /********************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH */
    /********************************************/

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /**************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH */
    /**************************************************/

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /**********************************************/
    /*  BUY LISTING FOR SELF WITH WETH FEE ON TOP */
    /**********************************************/

    function testBenchmarkForwardedBuyListingForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    /*****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH FEE ON TOP */
    /*****************************************************/

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    /****************************************************/
    /*  BUY LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /****************************************************/

    function testBenchmarkForwardedBuyListingForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    /***********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH EMPTY FEE ON TOP */
    /***********************************************************/

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkForwardedBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    /*******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*******************************************************/

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /*************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*************************************************************/

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /*************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /*******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkForwardedBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }
}