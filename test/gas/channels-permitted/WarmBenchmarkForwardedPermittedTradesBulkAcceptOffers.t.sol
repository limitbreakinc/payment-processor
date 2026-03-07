pragma solidity 0.8.24;

import "./BenchmarkForwardedPermittedTradesBase.t.sol";

contract WarmBenchmarkPermittedTradesBulkAcceptOffers is BenchmarkForwardedPermittedTradesBaseTest {

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

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    /*****************************************/
    /*     ACCEPT ITEM OFFER FOR BENEFICIARY */
    /*****************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    /*************************************/
    /*  ACCEPT COLLECTION OFFER FOR SELF */
    /*************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /********************************************/
    /*  ACCEPT COLLECTION OFFER FOR BENEFICIARY */
    /********************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /***************************************/
    /*     ACCEPT TOKEN SET OFFER FOR SELF */
    /***************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /**********************************************/
    /*     ACCEPT TOKEN SET OFFER FOR BENEFICIARY */
    /**********************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /*******************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR SELF */
    /*******************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /**************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR BENEFICIARY */
    /**************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR SELF */
    /*************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /********************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR BENEFICIARY */
    /********************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR SELF  */
    /*************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /********************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR BENEFICIARY  */
    /********************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /*************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR SELF */
    /*************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /********************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR BENEFICIARY */
    /********************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*******************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR SELF */
    /*******************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /**************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR BENEFICIARY */
    /**************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*******************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR SELF  */
    /*******************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /**************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR BENEFICIARY  */
    /**************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /*********************************************/
    /*     ACCEPT ITEM OFFER FOR SELF FEE ON TOP */
    /*********************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    /****************************************************/
    /*     ACCEPT ITEM OFFER FOR BENEFICIARY FEE ON TOP */
    /****************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    /************************************************/
    /*  ACCEPT COLLECTION OFFER FOR SELF FEE ON TOP */
    /************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /*******************************************************/
    /*  ACCEPT COLLECTION OFFER FOR BENEFICIARY FEE ON TOP */
    /*******************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /**************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR SELF FEE ON TOP */
    /**************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /*********************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR BENEFICIARY FEE ON TOP */
    /*********************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /******************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR SELF FEE ON TOP */
    /******************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*************************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR BENEFICIARY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR SELF FEE ON TOP */
    /************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*******************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR BENEFICIARY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR SELF  FEE ON TOP */
    /************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR BENEFICIARY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR SELF FEE ON TOP */
    /************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*******************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR BENEFICIARY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR SELF FEE ON TOP */
    /******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*************************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR BENEFICIARY FEE ON TOP */
    /*************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*****************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR SELF FEE ON TOP */
    /*****************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /************************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR BENEFICIARY FEE ON TOP */
    /************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /***************************************************/
    /*     ACCEPT ITEM OFFER FOR SELF EMPTY FEE ON TOP */
    /***************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    /**********************************************************/
    /*     ACCEPT ITEM OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /**********************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    /******************************************************/
    /*  ACCEPT COLLECTION OFFER FOR SELF EMPTY FEE ON TOP */
    /******************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /*************************************************************/
    /*  ACCEPT COLLECTION OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /********************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR SELF EMPTY FEE ON TOP */
    /********************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /***************************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /***************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /************************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR SELF EMPTY FEE ON TOP */
    /************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*******************************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR SELF EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*************************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*****************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR SELF EMPTY FEE ON TOP */
    /*****************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /************************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR SELF EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*************************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /************************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR SELF EMPTY FEE ON TOP */
    /************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*******************************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*******************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /***********************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR SELF EMPTY FEE ON TOP */
    /***********************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /******************************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /******************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 0, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /**********************************/
    /*     ACCEPT ITEM OFFER FOR SELF */
    /**********************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    /*****************************************/
    /*     ACCEPT ITEM OFFER FOR BENEFICIARY */
    /*****************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    /*************************************/
    /*  ACCEPT COLLECTION OFFER FOR SELF */
    /*************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /********************************************/
    /*  ACCEPT COLLECTION OFFER FOR BENEFICIARY */
    /********************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /***************************************/
    /*     ACCEPT TOKEN SET OFFER FOR SELF */
    /***************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /**********************************************/
    /*     ACCEPT TOKEN SET OFFER FOR BENEFICIARY */
    /**********************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /*******************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR SELF */
    /*******************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /**************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR BENEFICIARY */
    /**************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR SELF */
    /*************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /********************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR BENEFICIARY */
    /********************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR SELF  */
    /*************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /********************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR BENEFICIARY  */
    /********************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /*************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR SELF */
    /*************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /********************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR BENEFICIARY */
    /********************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*******************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR SELF */
    /*******************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /**************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR BENEFICIARY */
    /**************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*******************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR SELF  */
    /*******************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /**************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR BENEFICIARY  */
    /**************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, type(uint96).max, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /*********************************************/
    /*     ACCEPT ITEM OFFER FOR SELF FEE ON TOP */
    /*********************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    /****************************************************/
    /*     ACCEPT ITEM OFFER FOR BENEFICIARY FEE ON TOP */
    /****************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    /************************************************/
    /*  ACCEPT COLLECTION OFFER FOR SELF FEE ON TOP */
    /************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /*******************************************************/
    /*  ACCEPT COLLECTION OFFER FOR BENEFICIARY FEE ON TOP */
    /*******************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /**************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR SELF FEE ON TOP */
    /**************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /*********************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR BENEFICIARY FEE ON TOP */
    /*********************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /******************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR SELF FEE ON TOP */
    /******************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*************************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR BENEFICIARY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR SELF FEE ON TOP */
    /************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*******************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR BENEFICIARY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR SELF  FEE ON TOP */
    /************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR BENEFICIARY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR SELF FEE ON TOP */
    /************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*******************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR BENEFICIARY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR SELF FEE ON TOP */
    /******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*************************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR BENEFICIARY FEE ON TOP */
    /*************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*****************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR SELF FEE ON TOP */
    /*****************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /************************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR BENEFICIARY FEE ON TOP */
    /************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_FeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 1000, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /***************************************************/
    /*     ACCEPT ITEM OFFER FOR SELF EMPTY FEE ON TOP */
    /***************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptItemOffers);
    }

    /**********************************************************/
    /*     ACCEPT ITEM OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /**********************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptItemOffers);
    }

    /******************************************************/
    /*  ACCEPT COLLECTION OFFER FOR SELF EMPTY FEE ON TOP */
    /******************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /*************************************************************/
    /*  ACCEPT COLLECTION OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptCollectionOffers);
    }

    /********************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR SELF EMPTY FEE ON TOP */
    /********************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /***************************************************************/
    /*     ACCEPT TOKEN SET OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /***************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulk(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkAllowAnyPaymentMethod(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCustomPaymentMethodWhitelist(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCollectionLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkTokenLevelPricingConstraints(BulkBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary), _runBenchmarkBulkAcceptTokenSetOffers);
    }

    /************************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR SELF EMPTY FEE ON TOP */
    /************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*******************************************************************/
    /*     ACCEPT COSIGNED ITEM OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR SELF EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*************************************************************************/
    /*     ACCEPT COSIGNED COLLECTION OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*****************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR SELF EMPTY FEE ON TOP */
    /*****************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /************************************************************************/
    /*     ACCEPT COSIGNED TOKEN SET OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, false), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /******************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR SELF EMPTY FEE ON TOP */
    /******************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /*************************************************************************/
    /*     ACCEPT EMPTY COSIGNED ITEM OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptItemOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptItemOffersCosigned);
    }

    /************************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR SELF EMPTY FEE ON TOP */
    /************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /*******************************************************************************/
    /*     ACCEPT EMPTY COSIGNED COLLECTION OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /*******************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptCollectionOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptCollectionOffersCosigned);
    }

    /***********************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR SELF EMPTY FEE ON TOP */
    /***********************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForSelfMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), bob, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    /******************************************************************************/
    /*     ACCEPT EMPTY COSIGNED TOKEN SET OFFER FOR BENEFICIARY EMPTY FEE ON TOP */
    /******************************************************************************/

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesDefaultPaymentMethods_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosigned(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesAllowAnyPaymentMethod_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedAllowAnyPaymentMethod(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCustomPaymentMethodWhitelist_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCustomPaymentMethodWhitelist(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesCollectionLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedCollectionLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryNoFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 0, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 0, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }

    function testBenchmarkForwardedPermittedBulkAcceptTokenSetOffersEmptyCosignedForBeneficiaryMarketplaceAndRoyaltyFeesTokenLevelPricingConstraints_EmptyFeeOnTop_WithRoyaltyBounty() public {
        _runBenchmarkBulkCosignedTokenLevelPricingConstraints(BulkCosignedBenchmarkParams(10, 1, 500, 1000, 0, 300, address(weth), uint160(bobPk), benchmarkBeneficiary, true), _runBenchmarkBulkAcceptTokenSetOffersCosigned);
    }
}