pragma solidity 0.8.24;

import "./BenchmarkAdvancedTradesBase.t.sol";

contract WarmBenchmarkAdvancedTradesBulkAcceptOffers is BenchmarkAdvancedTradesBaseTest {

    function setUp() public virtual override {
        super.setUp();

        vm.startPrank(alice);
        _paymentProcessor.revokeSingleNonce(_paymentProcessorEncoder.encodeRevokeSingleNonceCalldata(address(_paymentProcessor), _getNextNonce(alice)));
        vm.stopPrank();

        vm.startPrank(bob);
        _paymentProcessor.revokeSingleNonce(_paymentProcessorEncoder.encodeRevokeSingleNonceCalldata(address(_paymentProcessor), _getNextNonce(bob)));
        vm.stopPrank();

        test721.mint(alice, 10000001);
        test721.mint(bob, 10000002);
        test721.mint(benchmarkBeneficiary, 10000003);
    }

    /**********************************/
    /*     ACCEPT ITEM OFFER FOR SELF */
    /**********************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    /*****************************************/
    /*     ACCEPT ITEM OFFER FOR BENEFICIARY */
    /*****************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    /*************************************/
    /*  ACCEPT COLLECTION OFFER FOR SELF */
    /*************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /********************************************/
    /*  ACCEPT COLLECTION OFFER FOR BENEFICIARY */
    /********************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /***************************************/
    /*     ACCEPT TOKEN SET OFFER FOR SELF */
    /***************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /**********************************************/
    /*     ACCEPT TOKEN SET OFFER FOR BENEFICIARY */
    /**********************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /*******************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR SELF */
    /*******************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /**************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR BENEFICIARY */
    /**************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR SELF */
    /*************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /********************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR BENEFICIARY */
    /********************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR SELF  */
    /*************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /********************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR BENEFICIARY  */
    /********************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /*************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR SELF */
    /*************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /********************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR BENEFICIARY */
    /********************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*******************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR SELF */
    /*******************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /**************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR BENEFICIARY */
    /**************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*******************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR SELF  */
    /*******************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /**************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR BENEFICIARY  */
    /**************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /*********************************************/
    /*     ACCEPT ITEM OFFER FOR SELF FEE ON TOP */
    /*********************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    /****************************************************/
    /*     ACCEPT ITEM OFFER FOR BENEFICIARY FEE ON TOP */
    /****************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    /************************************************/
    /*  ACCEPT COLLECTION OFFER FOR SELF FEE ON TOP */
    /************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /*******************************************************/
    /*  ACCEPT COLLECTION OFFER FOR BENEFICIARY FEE ON TOP */
    /*******************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /**************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR SELF FEE ON TOP */
    /**************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /*********************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR BENEFICIARY FEE ON TOP */
    /*********************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /******************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR SELF FEE ON TOP */
    /******************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*************************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR BENEFICIARY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR SELF FEE ON TOP */
    /************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*******************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR BENEFICIARY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR SELF  FEE ON TOP */
    /************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR BENEFICIARY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR SELF FEE ON TOP */
    /************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*******************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR BENEFICIARY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR SELF FEE ON TOP */
    /******************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*************************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR BENEFICIARY FEE ON TOP */
    /*************************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*****************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR SELF FEE ON TOP */
    /*****************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /************************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR BENEFICIARY FEE ON TOP */
    /************************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /***************************************************/
    /*     ACCEPT ITEM OFFER FOR SELF EMPTY FEE ON TOP */
    /***************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    /**********************************************************/
    /*     ACCEPT ITEM OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /**********************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    /******************************************************/
    /*  ACCEPT COLLECTION OFFER FOR SELF EMPTY FEE ON TOP */
    /******************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /*************************************************************/
    /*  ACCEPT COLLECTION OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /********************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR SELF EMPTY FEE ON TOP */
    /********************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /***************************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /***************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /************************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR SELF EMPTY FEE ON TOP */
    /************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*******************************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR SELF EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*************************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*************************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*****************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR SELF EMPTY FEE ON TOP */
    /*****************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /************************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /************************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR SELF EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*************************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*************************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /************************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR SELF EMPTY FEE ON TOP */
    /************************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*******************************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*******************************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /***********************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR SELF EMPTY FEE ON TOP */
    /***********************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /******************************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /******************************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /**********************************/
    /*     ACCEPT ITEM OFFER FOR SELF */
    /**********************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    /*****************************************/
    /*     ACCEPT ITEM OFFER FOR BENEFICIARY */
    /*****************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    /*************************************/
    /*  ACCEPT COLLECTION OFFER FOR SELF */
    /*************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /********************************************/
    /*  ACCEPT COLLECTION OFFER FOR BENEFICIARY */
    /********************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /***************************************/
    /*     ACCEPT TOKEN SET OFFER FOR SELF */
    /***************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /**********************************************/
    /*     ACCEPT TOKEN SET OFFER FOR BENEFICIARY */
    /**********************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /*******************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR SELF */
    /*******************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /**************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR BENEFICIARY */
    /**************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR SELF */
    /*************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /********************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR BENEFICIARY */
    /********************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR SELF  */
    /*************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /********************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR BENEFICIARY  */
    /********************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /*************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR SELF */
    /*************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /********************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR BENEFICIARY */
    /********************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*******************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR SELF */
    /*******************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /**************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR BENEFICIARY */
    /**************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*******************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR SELF  */
    /*******************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /**************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR BENEFICIARY  */
    /**************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /*********************************************/
    /*     ACCEPT ITEM OFFER FOR SELF FEE ON TOP */
    /*********************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    /****************************************************/
    /*     ACCEPT ITEM OFFER FOR BENEFICIARY FEE ON TOP */
    /****************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    /************************************************/
    /*  ACCEPT COLLECTION OFFER FOR SELF FEE ON TOP */
    /************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /*******************************************************/
    /*  ACCEPT COLLECTION OFFER FOR BENEFICIARY FEE ON TOP */
    /*******************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /**************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR SELF FEE ON TOP */
    /**************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /*********************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR BENEFICIARY FEE ON TOP */
    /*********************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /******************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR SELF FEE ON TOP */
    /******************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*************************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR BENEFICIARY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR SELF FEE ON TOP */
    /************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*******************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR BENEFICIARY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR SELF  FEE ON TOP */
    /************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR BENEFICIARY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR SELF FEE ON TOP */
    /************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*******************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR BENEFICIARY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR SELF FEE ON TOP */
    /******************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*************************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR BENEFICIARY FEE ON TOP */
    /*************************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*****************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR SELF FEE ON TOP */
    /*****************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /************************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR BENEFICIARY FEE ON TOP */
    /************************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /***************************************************/
    /*     ACCEPT ITEM OFFER FOR SELF EMPTY FEE ON TOP */
    /***************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    /**********************************************************/
    /*     ACCEPT ITEM OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /**********************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    /******************************************************/
    /*  ACCEPT COLLECTION OFFER FOR SELF EMPTY FEE ON TOP */
    /******************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /*************************************************************/
    /*  ACCEPT COLLECTION OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /********************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR SELF EMPTY FEE ON TOP */
    /********************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /***************************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /***************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /************************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR SELF EMPTY FEE ON TOP */
    /************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*******************************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR SELF EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*************************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*************************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*****************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR SELF EMPTY FEE ON TOP */
    /*****************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /************************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /************************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR SELF EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*************************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*************************************************************************/

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /************************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR SELF EMPTY FEE ON TOP */
    /************************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*******************************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*******************************************************************************/

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /***********************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR SELF EMPTY FEE ON TOP */
    /***********************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /******************************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /******************************************************************************/

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkAdvancedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }
}