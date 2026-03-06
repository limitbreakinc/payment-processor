pragma solidity 0.8.24;

import "./BenchmarkAdvancedTradesBase.t.sol";

contract WarmBenchmarkAdvancedTradesBuyListing is BenchmarkAdvancedTradesBaseTest {

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

    function testBenchmarkBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_ETH() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_ETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /**********************************/
    /*  BUY LISTING FOR SELF WITH WETH */
    /**********************************/

    function testBenchmarkBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_WETH() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_WETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /*****************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH */
    /*****************************************/

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_ETH() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /******************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH */
    /******************************************/

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_WETH() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /*******************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH */
    /*******************************************/

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /********************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH */
    /********************************************/

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /*************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH */
    /*************************************************/

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /**************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH */
    /**************************************************/

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*********************************************/
    /*  BUY LISTING FOR SELF WITH ETH FEE ON TOP */
    /*********************************************/

    function testBenchmarkBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /**********************************************/
    /*  BUY LISTING FOR SELF WITH WETH FEE ON TOP */
    /**********************************************/

    function testBenchmarkBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH FEE ON TOP */
    /****************************************************/

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /*****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH FEE ON TOP */
    /*****************************************************/

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /***************************************************/
    /*  BUY LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /***************************************************/

    function testBenchmarkBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /****************************************************/
    /*  BUY LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /****************************************************/

    function testBenchmarkBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /**********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH EMPTY FEE ON TOP */
    /**********************************************************/

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /***********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH EMPTY FEE ON TOP */
    /***********************************************************/

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH FEE ON TOP */
    /******************************************************/

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /*******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*******************************************************/

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH FEE ON TOP */
    /************************************************************/

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*************************************************************/

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /************************************************************/

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /*************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /**********************************/
    /*  BUY LISTING FOR SELF WITH ETH */
    /**********************************/

    function testBenchmarkBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /**********************************/
    /*  BUY LISTING FOR SELF WITH WETH */
    /**********************************/

    function testBenchmarkBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /*****************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH */
    /*****************************************/

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /******************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH */
    /******************************************/

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /*******************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH */
    /*******************************************/

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /********************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH */
    /********************************************/

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /*************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH */
    /*************************************************/

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /**************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH */
    /**************************************************/

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*********************************************/
    /*  BUY LISTING FOR SELF WITH ETH FEE ON TOP */
    /*********************************************/

    function testBenchmarkBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /**********************************************/
    /*  BUY LISTING FOR SELF WITH WETH FEE ON TOP */
    /**********************************************/

    function testBenchmarkBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH FEE ON TOP */
    /****************************************************/

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /*****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH FEE ON TOP */
    /*****************************************************/

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /***************************************************/
    /*  BUY LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /***************************************************/

    function testBenchmarkBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /****************************************************/
    /*  BUY LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /****************************************************/

    function testBenchmarkBuyListingAdvancedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListing);
    }

    /**********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH EMPTY FEE ON TOP */
    /**********************************************************/

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /***********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH EMPTY FEE ON TOP */
    /***********************************************************/

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    function testBenchmarkBuyListingAdvancedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListing);
    }

    /******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH FEE ON TOP */
    /******************************************************/

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /*******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*******************************************************/

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH FEE ON TOP */
    /************************************************************/

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*************************************************************/

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /************************************************************/

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /*************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosigned);
    }

    /******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    function testBenchmarkBuyListingAdvancedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosigned);
    }

    /*******************************************************************/
    /*  PARTIAL FILL ERC1155 */
    /*******************************************************************/

    /**********************************/
    /*  BUY LISTING FOR SELF WITH WETH */
    /**********************************/

    function testBenchmarkBuyListingForSelfNoFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    /******************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH */
    /******************************************/

    function testBenchmarkBuyListingForBeneficiaryNoFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    /********************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH */
    /********************************************/

    function testBenchmarkBuyListingCosignedForSelfNoFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /**************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH */
    /**************************************************/

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /**********************************************/
    /*  BUY LISTING FOR SELF WITH WETH FEE ON TOP */
    /**********************************************/

    function testBenchmarkBuyListingForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    /*****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH FEE ON TOP */
    /*****************************************************/

    function testBenchmarkBuyListingForBeneficiaryNoFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    /****************************************************/
    /*  BUY LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /****************************************************/

    function testBenchmarkBuyListingForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    /***********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH EMPTY FEE ON TOP */
    /***********************************************************/

    function testBenchmarkBuyListingForBeneficiaryNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    /*******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*******************************************************/

    function testBenchmarkBuyListingCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /*************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*************************************************************/

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /*************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkBuyListingCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /*******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /**********************************/
    /*  BUY LISTING FOR SELF WITH WETH */
    /**********************************/

    function testBenchmarkBuyListingForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    /******************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH */
    /******************************************/

    function testBenchmarkBuyListingForBeneficiaryNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    /********************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH */
    /********************************************/

    function testBenchmarkBuyListingCosignedForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /**************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH */
    /**************************************************/

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /**********************************************/
    /*  BUY LISTING FOR SELF WITH WETH FEE ON TOP */
    /**********************************************/

    function testBenchmarkBuyListingForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    /*****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH FEE ON TOP */
    /*****************************************************/

    function testBenchmarkBuyListingForBeneficiaryNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    /****************************************************/
    /*  BUY LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /****************************************************/

    function testBenchmarkBuyListingForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBuyListingPartialFill);
    }

    /***********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH EMPTY FEE ON TOP */
    /***********************************************************/

    function testBenchmarkBuyListingForBeneficiaryNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmark(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkAllowAnyPaymentMethod(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCustomPaymentMethodWhitelist(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCollectionLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    function testBenchmarkBuyListingForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkTokenLevelPricingConstraints(BenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBuyListingPartialFill);
    }

    /*******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*******************************************************/

    function testBenchmarkBuyListingCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /*************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*************************************************************/

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /*************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkBuyListingCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBuyListingCosignedPartialFill);
    }

    /*******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosigned(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedAllowAnyPaymentMethod(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCustomPaymentMethodWhitelist(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedCollectionLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }

    function testBenchmarkBuyListingEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty_PartialFill() public {
        _runBenchmarkCosignedTokenLevelPricingConstraints(CosignedBenchmarkParams(1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBuyListingCosignedPartialFill);
    }
}