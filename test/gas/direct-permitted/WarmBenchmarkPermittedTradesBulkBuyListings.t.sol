pragma solidity 0.8.24;

import "./BenchmarkPermittedTradesBase.t.sol";

contract WarmBenchmarkPermittedTradesBulkBuyListings is BenchmarkPermittedTradesBaseTest {

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
    }

    /****************************************/
    /*  BULK BUY LISTINGS FOR SELF WITH ETH */
    /****************************************/

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    /**********************************/
    /*  BUY LISTING FOR SELF WITH WETH */
    /**********************************/

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    /*****************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH */
    /*****************************************/

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    /******************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH */
    /******************************************/

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    /*******************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH */
    /*******************************************/

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    /********************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH */
    /********************************************/

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    /*************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH */
    /*************************************************/

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    /**************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH */
    /**************************************************/

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    /*********************************************/
    /*  BUY LISTING FOR SELF WITH ETH FEE ON TOP */
    /*********************************************/

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    /**********************************************/
    /*  BUY LISTING FOR SELF WITH WETH FEE ON TOP */
    /**********************************************/

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    /****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH FEE ON TOP */
    /****************************************************/

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    /*****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH FEE ON TOP */
    /*****************************************************/

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    /***************************************************/
    /*  BUY LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /***************************************************/

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    /****************************************************/
    /*  BUY LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /****************************************************/

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    /**********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH EMPTY FEE ON TOP */
    /**********************************************************/

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    /***********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH EMPTY FEE ON TOP */
    /***********************************************************/

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    /******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH FEE ON TOP */
    /******************************************************/

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    /*******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*******************************************************/

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    /************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH FEE ON TOP */
    /************************************************************/

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    /*************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*************************************************************/

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    /************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /************************************************************/

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    /*************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    /******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    /*******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

        /****************************************/
    /*  BULK BUY LISTINGS FOR SELF WITH ETH */
    /****************************************/

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    /**********************************/
    /*  BUY LISTING FOR SELF WITH WETH */
    /**********************************/

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    /*****************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH */
    /*****************************************/

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    /******************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH */
    /******************************************/

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    /*******************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH */
    /*******************************************/

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    /********************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH */
    /********************************************/

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    /*************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH */
    /*************************************************/

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    /**************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH */
    /**************************************************/

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    /*********************************************/
    /*  BUY LISTING FOR SELF WITH ETH FEE ON TOP */
    /*********************************************/

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    /**********************************************/
    /*  BUY LISTING FOR SELF WITH WETH FEE ON TOP */
    /**********************************************/

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    /****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH FEE ON TOP */
    /****************************************************/

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    /*****************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH FEE ON TOP */
    /*****************************************************/

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    /***************************************************/
    /*  BUY LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /***************************************************/

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    /****************************************************/
    /*  BUY LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /****************************************************/

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkBuyListings);
    }

    /**********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH ETH EMPTY FEE ON TOP */
    /**********************************************************/

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    /***********************************************************/
    /*  BUY LISTING FOR BENEFICIARY WITH WETH EMPTY FEE ON TOP */
    /***********************************************************/

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    function testBenchmarkBulkBuyListingsPermittedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkBuyListings);
    }

    /******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH FEE ON TOP */
    /******************************************************/

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    /*******************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*******************************************************/

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    /************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH FEE ON TOP */
    /************************************************************/

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    /*************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH FEE ON TOP */
    /*************************************************************/

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    /************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /************************************************************/

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    /*************************************************************/
    /*  BUY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkBuyListingsCosigned);
    }

    /******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH ETH EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_ETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(0), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    /*******************************************************************/
    /*  BUY EMPTY COSIGNED LISTING FOR SELF WITH WETH EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }

    function testBenchmarkBulkBuyListingsPermittedEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WETH_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkBuyListingsCosigned);
    }
}