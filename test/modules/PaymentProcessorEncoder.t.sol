pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "src/Constants.sol";
import "src/DataTypes.sol";
import "src/PaymentProcessorEncoder.sol";

contract PaymentProcessorEncoderTest is Test {

    PaymentProcessorEncoder encoder;

    function setUp() public {
        encoder = new PaymentProcessorEncoder();
    }

    function testAcceptOfferAdvancedCalldata() public {
        AdvancedBidOrder memory advancedBidOrder;
        BulkOrderProof memory bulkOrderProof;
        TokenSetProof memory tokenSetProof;
        FeeOnTop memory feeOnTop;
        bulkOrderProof.proof = new bytes32[](0);
        bytes memory calldataToPP = encoder.encodeAcceptOfferAdvancedCalldata(address(0), advancedBidOrder, bulkOrderProof, feeOnTop, tokenSetProof);
        bulkOrderProof.proof = new bytes32[](1);
        bytes memory calldataToPPWithProofs = encoder.encodeAcceptOfferAdvancedCalldata(address(0), advancedBidOrder, bulkOrderProof, feeOnTop, tokenSetProof);
        uint256 calldataDiff = (calldataToPPWithProofs.length - calldataToPP.length);
        console.log("Accept Offer Advanced Length: %s", (calldataToPP.length + 4));
        console.log("Accept Offer Advanced Per Proof Item: %s", calldataDiff);
        assertEq((calldataToPP.length + 4), BASE_MSG_LENGTH_ACCEPT_OFFER_ADVANCED);
        assertEq(calldataDiff, PROOF_ELEMENT_SIZE);
        bulkOrderProof.proof = new bytes32[](10);
        calldataToPPWithProofs = encoder.encodeAcceptOfferAdvancedCalldata(address(0), advancedBidOrder, bulkOrderProof, feeOnTop, tokenSetProof);
        bulkOrderProof.proof = new bytes32[](20);
        tokenSetProof.proof = new bytes32[](5);
        calldataToPPWithProofs = encoder.encodeAcceptOfferAdvancedCalldata(address(0), advancedBidOrder, bulkOrderProof, feeOnTop, tokenSetProof);
        assertEq(calldataDiff * 25, calldataToPPWithProofs.length - calldataToPP.length);
    }

    function testAcceptOfferCalldata() public {
        Order memory order;
        SignatureECDSA memory signature;
        Cosignature memory cosignature;
        FeeOnTop memory feeOnTop;
        TokenSetProof memory tokenSetProof;

        bytes memory calldataToPP = encoder.encodeAcceptOfferCalldata(address(0), OFFER_TYPE_COLLECTION_OFFER, order, signature, tokenSetProof, cosignature, feeOnTop);
        console.log("Accept Offer Length: %s", (calldataToPP.length + 4));
        assertEq((calldataToPP.length + 4), BASE_MSG_LENGTH_ACCEPT_OFFER);

        tokenSetProof.proof = new bytes32[](10);
        bytes memory calldataToPPWithProof = encoder.encodeAcceptOfferCalldata(address(0), OFFER_TYPE_COLLECTION_OFFER, order, signature, tokenSetProof, cosignature, feeOnTop);
        uint256 calldataDiff = (calldataToPPWithProof.length - calldataToPP.length) / 10;
        console.log("Accept Offer Per Proof Item: %s", calldataDiff);
        assertEq(calldataDiff, PROOF_ELEMENT_SIZE);
        tokenSetProof.proof = new bytes32[](15);
        calldataToPPWithProof = encoder.encodeAcceptOfferCalldata(address(0), OFFER_TYPE_COLLECTION_OFFER, order, signature, tokenSetProof, cosignature, feeOnTop);
        assertEq(calldataDiff * 15, (calldataToPPWithProof.length - calldataToPP.length));
    }

    function testBulkAcceptOffersAdvancedCalldata() public {
        BulkOrderProof[] memory bulkOrderProofArray = new BulkOrderProof[](1);
        TokenSetProof[] memory tokenSetProofArray = new TokenSetProof[](1);
        bytes memory calldataToPPBulk1 = encoder.encodeBulkAcceptOffersAdvancedCalldata(address(0), new AdvancedBidOrder[](1), bulkOrderProofArray, new FeeOnTop[](1), tokenSetProofArray);
        bulkOrderProofArray = new BulkOrderProof[](10);
        tokenSetProofArray = new TokenSetProof[](10);
        bytes memory calldataToPPBulk10 = encoder.encodeBulkAcceptOffersAdvancedCalldata(address(0), new AdvancedBidOrder[](10), bulkOrderProofArray, new FeeOnTop[](10), tokenSetProofArray);
        uint256 calldataDiff = (calldataToPPBulk10.length - calldataToPPBulk1.length) / 9;
        console.log("Bulk Accept Offer Advanced Base Length: %s", (calldataToPPBulk1.length - calldataDiff + 4));
        console.log("Bulk Accept Offer Advanced Per Item Length: %s", calldataDiff);
        assertEq((calldataToPPBulk1.length - calldataDiff + 4), BASE_MSG_LENGTH_BULK_ACCEPT_OFFERS_ADVANCED);
        assertEq(calldataDiff, BASE_MSG_LENGTH_BULK_ACCEPT_OFFERS_ADVANCED_PER_ITEM);
        bulkOrderProofArray[0].proof = new bytes32[](10);
        bytes memory calldataToPPBulk10_WithProofs = encoder.encodeBulkAcceptOffersAdvancedCalldata(address(0), new AdvancedBidOrder[](10), bulkOrderProofArray, new FeeOnTop[](10), tokenSetProofArray);
        calldataDiff = (calldataToPPBulk10_WithProofs.length - calldataToPPBulk10.length) / 10;
        console.log("Bulk Accept Offer Advanced Per Proof Item: %s", calldataDiff);
        assertEq(calldataDiff, PROOF_ELEMENT_SIZE);
        bulkOrderProofArray[0].proof = new bytes32[](3);
        bulkOrderProofArray[5].proof = new bytes32[](2);
        bulkOrderProofArray[7].proof = new bytes32[](6);
        tokenSetProofArray[1].proof = new bytes32[](1);
        tokenSetProofArray[3].proof = new bytes32[](4);
        tokenSetProofArray[8].proof = new bytes32[](9);
        calldataToPPBulk10_WithProofs = encoder.encodeBulkAcceptOffersAdvancedCalldata(address(0), new AdvancedBidOrder[](10), bulkOrderProofArray, new FeeOnTop[](10), tokenSetProofArray);
        assertEq(calldataDiff * 25, (calldataToPPBulk10_WithProofs.length - calldataToPPBulk10.length));
    }

    function testBulkAcceptOffersCalldata() public {
        bytes memory calldataToPPBulk1 = encoder.encodeBulkAcceptOffersCalldata(address(0), new uint256[](1), new Order[](1), new SignatureECDSA[](1), new TokenSetProof[](1), new Cosignature[](1), new FeeOnTop[](1));
        TokenSetProof[] memory tokenSetProofArray = new TokenSetProof[](1);
        tokenSetProofArray[0].proof = new bytes32[](10);
        bytes memory calldataToPPBulk1With10Proofs = encoder.encodeBulkAcceptOffersCalldata(address(0), new uint256[](1), new Order[](1), new SignatureECDSA[](1), tokenSetProofArray, new Cosignature[](1), new FeeOnTop[](1));
        bytes memory calldataToPPBulk10 = encoder.encodeBulkAcceptOffersCalldata(address(0), new uint256[](10), new Order[](10), new SignatureECDSA[](10), new TokenSetProof[](10), new Cosignature[](10), new FeeOnTop[](10));
        tokenSetProofArray = new TokenSetProof[](10);
        tokenSetProofArray[1].proof = new bytes32[](3);
        tokenSetProofArray[4].proof = new bytes32[](2);
        tokenSetProofArray[6].proof = new bytes32[](6);
        tokenSetProofArray[8].proof = new bytes32[](1);
        bytes memory calldataToPPBulk10With12Proofs = encoder.encodeBulkAcceptOffersCalldata(address(0), new uint256[](10), new Order[](10), new SignatureECDSA[](10), tokenSetProofArray, new Cosignature[](10), new FeeOnTop[](10));
        uint256 calldataDiff = (calldataToPPBulk10.length - calldataToPPBulk1.length) / 9;
        console.log("Bulk Accept Offer Base Length: %s", (calldataToPPBulk1.length - calldataDiff + 4));
        console.log("Bulk Accept Offer Per Item Length: %s", calldataDiff);
        assertEq((calldataToPPBulk1.length - calldataDiff + 4), BASE_MSG_LENGTH_BULK_ACCEPT_OFFERS);
        assertEq(calldataDiff, BASE_MSG_LENGTH_BULK_ACCEPT_OFFERS_PER_ITEM);
        calldataDiff = (calldataToPPBulk1With10Proofs.length - calldataToPPBulk1.length) / 10;
        console.log("Bulk Accept Offer Per Proof Item: %s", calldataDiff);
        assertEq(calldataDiff, PROOF_ELEMENT_SIZE);
        assertEq(calldataDiff * 12, calldataToPPBulk10With12Proofs.length - calldataToPPBulk10.length);
    }

    function testBulkBuylistingsAdvancedCalldata() public {
        BulkOrderProof[] memory bulkOrderProofArray = new BulkOrderProof[](1);
        bytes memory calldataToPPBulk1 = encoder.encodeBulkBuyListingsAdvancedCalldata(address(0), new AdvancedOrder[](1), bulkOrderProofArray, new FeeOnTop[](1));
        bulkOrderProofArray = new BulkOrderProof[](10);
        bytes memory calldataToPPBulk10 = encoder.encodeBulkBuyListingsAdvancedCalldata(address(0), new AdvancedOrder[](10), bulkOrderProofArray, new FeeOnTop[](10));
        uint256 calldataDiff = (calldataToPPBulk10.length - calldataToPPBulk1.length) / 9;
        console.log("Bulk Buy Listing Advanced Base Length: %s", (calldataToPPBulk1.length - calldataDiff + 4));
        console.log("Bulk Buy Listing Advanced Per Item Length: %s", calldataDiff);
        assertEq((calldataToPPBulk1.length - calldataDiff + 4), BASE_MSG_LENGTH_BULK_BUY_LISTINGS_ADVANCED);
        assertEq(calldataDiff, BASE_MSG_LENGTH_BULK_BUY_LISTINGS_ADVANCED_PER_ITEM);
        bulkOrderProofArray[0].proof = new bytes32[](10);
        bytes memory calldataToPPBulk10_WithProofs = encoder.encodeBulkBuyListingsAdvancedCalldata(address(0), new AdvancedOrder[](10), bulkOrderProofArray, new FeeOnTop[](10));
        calldataDiff = (calldataToPPBulk10_WithProofs.length - calldataToPPBulk10.length) / 10;
        console.log("Bulk Buy Listing Advanced Per Proof Item: %s", calldataDiff);
        assertEq(calldataDiff, PROOF_ELEMENT_SIZE);
        bulkOrderProofArray[0].proof = new bytes32[](3);
        bulkOrderProofArray[5].proof = new bytes32[](2);
        bulkOrderProofArray[7].proof = new bytes32[](6);
        calldataToPPBulk10_WithProofs = encoder.encodeBulkBuyListingsAdvancedCalldata(address(0), new AdvancedOrder[](10), bulkOrderProofArray, new FeeOnTop[](10));
        assertEq(calldataDiff * 11, (calldataToPPBulk10_WithProofs.length - calldataToPPBulk10.length));
    }

    function testBulkBuyListingsCalldata() public {
        bytes memory calldataToPPBulk1 = encoder.encodeBulkBuyListingsCalldata(address(0), new Order[](1), new SignatureECDSA[](1), new Cosignature[](1), new FeeOnTop[](1));
        bytes memory calldataToPPBulk10 = encoder.encodeBulkBuyListingsCalldata(address(0), new Order[](10), new SignatureECDSA[](10), new Cosignature[](10), new FeeOnTop[](10));
        uint256 calldataDiff = (calldataToPPBulk10.length - calldataToPPBulk1.length) / 9;
        console.log("Bulk Buy Listing Base Length: %s", (calldataToPPBulk1.length - calldataDiff + 4));
        console.log("Bulk Buy Listing Per Item Length: %s", calldataDiff);
        assertEq((calldataToPPBulk1.length - calldataDiff + 4), BASE_MSG_LENGTH_BULK_BUY_LISTINGS);
        assertEq(calldataDiff, BASE_MSG_LENGTH_BULK_BUY_LISTINGS_PER_ITEM);
    }

    function testBuyListingCalldata() public {
        Order memory order;
        SignatureECDSA memory signature;
        Cosignature memory cosignature;
        FeeOnTop memory feeOnTop;

        bytes memory calldataToPP = encoder.encodeBuyListingCalldata(address(0), order, signature, cosignature, feeOnTop);
        console.log("Buy Listing Length: %s", (calldataToPP.length + 4));
        assertEq((calldataToPP.length + 4), BASE_MSG_LENGTH_BUY_LISTING);
    }

    function testSweepCollectionCalldata() public {
        SweepOrder memory sweepOrder;
        FeeOnTop memory feeOnTop;
        bytes memory calldataToPPBulk1 = encoder.encodeSweepCollectionCalldata(address(0), feeOnTop, sweepOrder, new SweepItem[](1), new SignatureECDSA[](1), new Cosignature[](1));
        bytes memory calldataToPPBulk10 = encoder.encodeSweepCollectionCalldata(address(0), feeOnTop, sweepOrder, new SweepItem[](10), new SignatureECDSA[](10), new Cosignature[](10));
        uint256 calldataDiff = (calldataToPPBulk10.length - calldataToPPBulk1.length) / 9;
        console.log("Sweep Base Length: %s", (calldataToPPBulk1.length - calldataDiff + 4));
        console.log("Sweep Per Item Length: %s", calldataDiff);
        assertEq((calldataToPPBulk1.length - calldataDiff + 4), BASE_MSG_LENGTH_SWEEP_COLLECTION);
        assertEq(calldataDiff, BASE_MSG_LENGTH_SWEEP_COLLECTION_PER_ITEM);
    }

    function testBuyListingAdvancedCalldata() public {
        AdvancedOrder memory advancedOrder;
        BulkOrderProof memory bulkOrderProof;
        FeeOnTop memory feeOnTop;
        bytes memory calldataToPP = encoder.encodeBuyListingAdvancedCalldata(address(0), advancedOrder, bulkOrderProof, feeOnTop);
        bulkOrderProof.proof = new bytes32[](1);
        bytes memory calldataToPPWithProofs = encoder.encodeBuyListingAdvancedCalldata(address(0), advancedOrder, bulkOrderProof, feeOnTop);
        uint256 calldataDiff = (calldataToPPWithProofs.length - calldataToPP.length);
        console.log("Buy Listing Advanced Length: %s", (calldataToPP.length + 4));
        console.log("Buy Listing Advanced Per Proof Item: %s", calldataDiff);
        assertEq((calldataToPP.length + 4), BASE_MSG_LENGTH_BUY_LISTING_ADVANCED);
        assertEq(calldataDiff, PROOF_ELEMENT_SIZE);
        bulkOrderProof.proof = new bytes32[](10);
        calldataToPPWithProofs = encoder.encodeBuyListingAdvancedCalldata(address(0), advancedOrder, bulkOrderProof, feeOnTop);
        assertEq(calldataDiff * 10, calldataToPPWithProofs.length - calldataToPP.length);
    }

    function testSweepCollectionAdvancedCalldata() public {
        AdvancedSweep memory advancedSweep;
        advancedSweep.items = new AdvancedSweepItem[](1);
        bytes memory calldataToPPBulk1 = encoder.encodeSweepCollectionAdvancedCalldata(address(0), advancedSweep);
        advancedSweep.items = new AdvancedSweepItem[](10);
        bytes memory calldataToPPBulk10 = encoder.encodeSweepCollectionAdvancedCalldata(address(0), advancedSweep);
        uint256 calldataDiff = (calldataToPPBulk10.length - calldataToPPBulk1.length) / 9;
        console.log("Sweep Collection Advanced Base Length: %s", (calldataToPPBulk1.length - calldataDiff + 4));
        console.log("Sweep Collection Advanced Per Item Length: %s", calldataDiff);
        assertEq((calldataToPPBulk1.length - calldataDiff + 4), BASE_MSG_LENGTH_SWEEP_COLLECTION_ADVANCED);
        assertEq(calldataDiff, BASE_MSG_LENGTH_SWEEP_COLLECTION_ADVANCED_PER_ITEM);
        advancedSweep.items[0].bulkOrderProof.proof = new bytes32[](10);
        bytes memory calldataToPPBulk10_WithProofs = encoder.encodeSweepCollectionAdvancedCalldata(address(0), advancedSweep);
        calldataDiff = (calldataToPPBulk10_WithProofs.length - calldataToPPBulk10.length) / 10;
        console.log("Sweep Collection Advanced Per Proof Item: %s", calldataDiff);
        assertEq(calldataDiff, PROOF_ELEMENT_SIZE);
        advancedSweep.items[0].bulkOrderProof.proof = new bytes32[](3);
        advancedSweep.items[5].bulkOrderProof.proof = new bytes32[](2);
        advancedSweep.items[7].bulkOrderProof.proof = new bytes32[](6);
        calldataToPPBulk10_WithProofs = encoder.encodeSweepCollectionAdvancedCalldata(address(0), advancedSweep);
        assertEq(calldataDiff * 11, (calldataToPPBulk10_WithProofs.length - calldataToPPBulk10.length));
    }
}