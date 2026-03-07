pragma solidity 0.8.24;

import "./PaymentProcessorModule.t.sol";
import {MerkleTree} from "test/utils/MerkleTree.sol";

contract PaymentProcessorModuleBulkAdvancedTest is PaymentProcessorModuleTest {

    function setUp() public virtual override {
        super.setUp();
    }

    function _getAdvancedSweepItems(
        uint256 treeHeight,
        uint256 makerKey,
        uint256 cosignerKey,
        address taker,
        Order[] memory saleDetailsArray
    ) internal returns (AdvancedSweepItem[] memory advancedSweepItems) {
        PermitContext memory permitContext;
        advancedSweepItems = new AdvancedSweepItem[](saleDetailsArray.length);

        bytes32[] memory data = new bytes32[](2 ** treeHeight);

        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            Order memory saleDetails = saleDetailsArray[i];

            data[i] = 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            SALE_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            cosignerKey == 0 ? address(0) : vm.addr(cosignerKey),
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
                            _paymentProcessor.getProtocolFeeVersion()
                        )
                    )
                );
        }

        (
            BulkOrderProof[] memory bulkOrderProofs,
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfBulkOrderProofSignatureAndCosignature(
            data,
            saleDetailsArray.length,
            treeHeight,
            makerKey,
            cosignerKey,
            saleDetailsArray[0].expiration,
            taker,
            _getBulkSaleApprovalTypehash
        );

        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            advancedSweepItems[i] = AdvancedSweepItem({
                sweepItem: SweepItem({
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
                }),
                signature: signature,
                cosignature: cosignature,
                bulkOrderProof: bulkOrderProofs[i],
                permitContext: permitContext
            });
        }
    }

    function _getBatchOfAdvancedListingProofsAndSignature(
        uint256 treeHeight,
        uint256 makerKey,
        uint256 cosignerKey,
        address taker,
        Order[] memory saleDetailsArray
    ) internal returns (
        BulkOrderProof[] memory bulkOrderProofs, 
        SignatureECDSA memory signature,
        Cosignature memory cosignature
    ) {
        bytes32[] memory data = new bytes32[](2 ** treeHeight);

        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            Order memory saleDetails = saleDetailsArray[i];

            data[i] = 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            SALE_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            cosignerKey == 0 ? address(0) : vm.addr(cosignerKey),
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
                            _paymentProcessor.getProtocolFeeVersion()
                        )
                    )
                );
        }

        (
            bulkOrderProofs,
            signature,
            cosignature
        ) = _getBatchOfBulkOrderProofSignatureAndCosignature(
            data,
            saleDetailsArray.length,
            treeHeight,
            makerKey,
            cosignerKey,
            saleDetailsArray[0].expiration,
            taker,
            _getBulkSaleApprovalTypehash
        );
    }

    function _getBatchOfAdvancedBidProofsAndSignatureForItemOffer(
        uint256 treeHeight,
        uint256 makerKey,
        uint256 cosignerKey,
        address taker,
        Order[] memory saleDetailsArray
    ) internal returns (
        BulkOrderProof[] memory bulkOrderProofs, 
        SignatureECDSA memory signature,
        Cosignature memory cosignature
    ) {
        bytes32[] memory data = new bytes32[](2 ** treeHeight);

        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            Order memory saleDetails = saleDetailsArray[i];

            data[i] = 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            ITEM_OFFER_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            cosignerKey == 0 ? address(0) : vm.addr(cosignerKey),
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
        }

        (
            bulkOrderProofs,
            signature,
            cosignature
        ) = _getBatchOfBulkOrderProofSignatureAndCosignature(
            data,
            saleDetailsArray.length,
            treeHeight,
            makerKey,
            cosignerKey,
            saleDetailsArray[0].expiration,
            taker,
            _getBulkItemOfferApprovalTypehash
        );
    }

    function _getBatchOfAdvancedBidProofsAndSignatureForCollectionOffer(
        uint256 treeHeight,
        uint256 makerKey,
        uint256 cosignerKey,
        address taker,
        Order[] memory saleDetailsArray
    ) internal returns (
        BulkOrderProof[] memory bulkOrderProofs, 
        SignatureECDSA memory signature,
        Cosignature memory cosignature
    ) {
        bytes32[] memory data = new bytes32[](2 ** treeHeight);

        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            Order memory saleDetails = saleDetailsArray[i];

            data[i] = 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            COLLECTION_OFFER_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            cosignerKey == 0 ? address(0) : vm.addr(cosignerKey),
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
                );
        }

        (
            bulkOrderProofs,
            signature,
            cosignature
        ) = _getBatchOfBulkOrderProofSignatureAndCosignature(
            data,
            saleDetailsArray.length,
            treeHeight,
            makerKey,
            cosignerKey,
            saleDetailsArray[0].expiration,
            taker,
            _getBulkCollectionOfferApprovalTypehash
        );
    }

    function _getBatchOfAdvancedBidProofsAndSignatureForTokenSetOffer(
        uint256 treeHeight,
        uint256 makerKey,
        uint256 cosignerKey,
        address taker,
        Order[] memory saleDetailsArray,
        TestTokenSetProof[] memory tokenSetProofs
    ) internal returns (
        BulkOrderProof[] memory bulkOrderProofs, 
        SignatureECDSA memory signature,
        Cosignature memory cosignature
    ) {
        bytes32[] memory data = new bytes32[](2 ** treeHeight);

        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            Order memory saleDetails = saleDetailsArray[i];

            data[i] = 
                keccak256(
                    bytes.concat(
                        abi.encode(
                            TOKEN_SET_OFFER_APPROVAL_HASH,
                            uint8(saleDetails.protocol),
                            cosignerKey == 0 ? address(0) : vm.addr(cosignerKey),
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
                            tokenSetProofs[i].rootHash
                        )
                    )
                );
        }

        (
            bulkOrderProofs,
            signature,
            cosignature
        ) = _getBatchOfBulkOrderProofSignatureAndCosignature(
            data,
            saleDetailsArray.length,
            treeHeight,
            makerKey,
            cosignerKey,
            saleDetailsArray[0].expiration,
            taker,
            _getBulkTokenSetOfferApprovalTypehash
        );
    }

    function _getAdvancedOrderProofAndSignature(
        uint256 treeHeight,
        uint256 makerKey,
        uint256 cosignerKey,
        address taker,
        Order memory saleDetails
    ) internal returns (
        BulkOrderProof memory bulkOrderProof, 
        SignatureECDSA memory signature,
        Cosignature memory cosignature
    ) {
        bytes32 orderHash = 
            keccak256(
                bytes.concat(
                    abi.encode(
                        SALE_APPROVAL_HASH,
                        uint8(saleDetails.protocol),
                        cosignerKey == 0 ? address(0) : vm.addr(cosignerKey),
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
                        _paymentProcessor.getProtocolFeeVersion()
                    )
                )
            );

        bytes32[] memory data = new bytes32[](2 ** treeHeight);
        data[0] = orderHash;

        (
            bulkOrderProof,
            signature,
            cosignature
        ) = _getBulkOrderProofSignatureAndCosignature(
            data,
            treeHeight,
            makerKey,
            cosignerKey,
            saleDetails.expiration,
            taker,
            _getBulkSaleApprovalTypehash
        );
    }

    function _getAdvancedBidProofAndSignatureForItemOffer(
        uint256 treeHeight,
        uint256 makerKey,
        uint256 cosignerKey,
        address taker,
        Order memory saleDetails
    ) internal returns (
        BulkOrderProof memory bulkOrderProof, 
        SignatureECDSA memory signature,
        Cosignature memory cosignature
    ) {
        bytes32 orderHash = 
            keccak256(
                bytes.concat(
                    abi.encode(
                        ITEM_OFFER_APPROVAL_HASH,
                        uint8(saleDetails.protocol),
                        cosignerKey == 0 ? address(0) : vm.addr(cosignerKey),
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

        bytes32[] memory data = new bytes32[](2 ** treeHeight);
        data[0] = orderHash;

        (
            bulkOrderProof,
            signature,
            cosignature
        ) = _getBulkOrderProofSignatureAndCosignature(
            data,
            treeHeight,
            makerKey,
            cosignerKey,
            saleDetails.expiration,
            taker,
            _getBulkItemOfferApprovalTypehash
        );
    }

    function _getAdvancedBidProofAndSignatureForCollectionOffer(
        uint256 treeHeight,
        uint256 makerKey,
        uint256 cosignerKey,
        address taker,
        Order memory saleDetails
    ) internal returns (
        BulkOrderProof memory bulkOrderProof, 
        SignatureECDSA memory signature,
        Cosignature memory cosignature
    ) {
        bytes32 orderHash = 
            keccak256(
            bytes.concat(
                abi.encode(
                    COLLECTION_OFFER_APPROVAL_HASH,
                    uint8(saleDetails.protocol),
                    cosignerKey == 0 ? address(0) : vm.addr(cosignerKey),
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
        );

        bytes32[] memory data = new bytes32[](2 ** treeHeight);
        data[0] = orderHash;

        (
            bulkOrderProof,
            signature,
            cosignature
        ) = _getBulkOrderProofSignatureAndCosignature(
            data,
            treeHeight,
            makerKey,
            cosignerKey,
            saleDetails.expiration,
            taker,
            _getBulkCollectionOfferApprovalTypehash
        );
    }

    function _getAdvancedBidProofAndSignatureForTokenSetOffer(
        uint256 treeHeight,
        uint256 makerKey,
        uint256 cosignerKey,
        address taker,
        Order memory saleDetails,
        TestTokenSetProof memory tokenSetProof
    ) internal returns (
        BulkOrderProof memory bulkOrderProof, 
        SignatureECDSA memory signature,
        Cosignature memory cosignature
    ) {
        bytes32 orderHash = 
            keccak256(
            bytes.concat(
                abi.encode(
                    TOKEN_SET_OFFER_APPROVAL_HASH,
                    uint8(saleDetails.protocol),
                    cosignerKey == 0 ? address(0) : vm.addr(cosignerKey),
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
        );

        bytes32[] memory data = new bytes32[](2 ** treeHeight);
        data[0] = orderHash;

        (
            bulkOrderProof,
            signature,
            cosignature
        ) = _getBulkOrderProofSignatureAndCosignature(
            data,
            treeHeight,
            makerKey,
            cosignerKey,
            saleDetails.expiration,
            taker,
            _getBulkTokenSetOfferApprovalTypehash
        );
    }

    function _getBulkOrderProofSignatureAndCosignature(
        bytes32[] memory orderHashes,
        uint256 treeHeight,
        uint256 makerKey,
        uint256 cosignerKey,
        uint256 cosignatureExpiration,
        address taker,
        function(uint256) internal returns (bytes32) fnGetBulkOrderTypehash
    ) internal returns (
        BulkOrderProof memory bulkOrderProof, 
        SignatureECDSA memory signature,
        Cosignature memory cosignature
    ) {
        bulkOrderProof = BulkOrderProof({
            orderIndex: 0,
            proof: MerkleTree.getProofUnsorted(orderHashes, 0)
        });

        bytes32 bulkOrderDigest = 
            ECDSA.toTypedDataHash(
                _paymentProcessor.getDomainSeparator(),
                keccak256(
                    abi.encode(
                        fnGetBulkOrderTypehash(treeHeight),
                        MerkleTree.getRootUnsorted(orderHashes)
                    )
                )
            );

        (uint8 listingV, bytes32 listingR, bytes32 listingS) = vm.sign(makerKey, bulkOrderDigest);
        signature = SignatureECDSA({v: listingV, r: listingR, s: listingS});

        cosignature = cosignerKey == 0 ?
            Cosignature({
                signer: address(0),
                taker: address(0),
                expiration: 0,
                v: 0,
                r: bytes32(0),
                s: bytes32(0)
            
            }) :
            _getCosignature(
                cosignerKey,
                signature,
                cosignatureExpiration,
                taker
            );
    }

    function _getBatchOfBulkOrderProofSignatureAndCosignature(
        bytes32[] memory data,
        uint256 numberOfOrders,
        uint256 treeHeight,
        uint256 makerKey,
        uint256 cosignerKey,
        uint256 cosignatureExpiration,
        address taker,
        function(uint256) internal returns (bytes32) fnGetBulkOrderTypehash
    ) internal returns (
        BulkOrderProof[] memory bulkOrderProofs, 
        SignatureECDSA memory signature,
        Cosignature memory cosignature
    ) {
        bytes32 bulkOrderDigest;
        (
            bulkOrderProofs,
            bulkOrderDigest
        ) = _getBulkOrderProofsAndDigest(
            data,
            numberOfOrders,
            treeHeight,
            fnGetBulkOrderTypehash
        );

        (uint8 listingV, bytes32 listingR, bytes32 listingS) = vm.sign(makerKey, bulkOrderDigest);
        signature = SignatureECDSA({v: listingV, r: listingR, s: listingS});

        cosignature = cosignerKey == 0 ?
            Cosignature({
                signer: address(0),
                taker: address(0),
                expiration: 0,
                v: 0,
                r: bytes32(0),
                s: bytes32(0)
            
            }) :
            _getCosignature(
                cosignerKey,
                signature,
                cosignatureExpiration,
                taker
            );
    }

    function _getBulkOrderProofsAndDigest(
        bytes32[] memory data,
        uint256 numberOfOrders,
        uint256 treeHeight,
        function(uint256) internal returns (bytes32) fnGetBulkOrderTypehash
    ) internal returns (
        BulkOrderProof[] memory bulkOrderProofs, 
        bytes32 bulkOrderDigest
    ) {
        bulkOrderProofs = new BulkOrderProof[](numberOfOrders);

        for (uint256 i = 0; i < numberOfOrders; i++) {
            bulkOrderProofs[i] = BulkOrderProof({
                orderIndex:  i,
                proof: MerkleTree.getProofUnsorted(data, i)
            });
        }

        bulkOrderDigest = 
            ECDSA.toTypedDataHash(
                _paymentProcessor.getDomainSeparator(),
                keccak256(
                    abi.encode(
                        fnGetBulkOrderTypehash(treeHeight),
                        MerkleTree.getRootUnsorted(data)
                    )
                )
            );
    }

    function _getAdvancedOrder(
        Order memory saleDetails,
        SignatureECDSA memory signature,
        Cosignature memory cosignature,
        FeeOnTop memory feeOnTop,
        PermitContext memory permitContext,
        BulkOrderProof memory bulkOrderProof
    ) internal pure returns (AdvancedOrder memory advancedListing) {
        advancedListing = AdvancedOrder({
            saleDetails: saleDetails,
            signature: signature,
            cosignature: cosignature,
            permitContext: permitContext
        });
    }

    function _getAdvancedOrders(
        Order[] memory saleDetailsArray,
        SignatureECDSA memory signature,
        Cosignature memory cosignature,
        FeeOnTop[] memory feeOnTop,
        PermitContext[] memory permitContexts,
        BulkOrderProof[] memory bulkOrderProofs
    ) internal view returns (AdvancedOrder[] memory advancedListingsArray) {
        advancedListingsArray = new AdvancedOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < advancedListingsArray.length; i++) {
            advancedListingsArray[i] = AdvancedOrder({
                saleDetails: saleDetailsArray[i],
                signature: signature,
                cosignature: cosignature,
                permitContext: permitContexts[i]
            });
        }
    }

    function _getAdvancedBid(
        uint256 offerType,
        Order memory saleDetails,
        SignatureECDSA memory signature,
        Cosignature memory cosignature,
        TestTokenSetProof memory tokenSetProof,
        FeeOnTop memory feeOnTop,
        BulkOrderProof memory bulkOrderProof
    ) internal pure returns (AdvancedBidOrder memory advancedBid) {
        advancedBid = AdvancedBidOrder({
            offerType: offerType,
            advancedOrder: AdvancedOrder({
                saleDetails: saleDetails,
                signature: signature,
                cosignature: cosignature,
                permitContext: PermitContext({permitProcessor: address(0), permitNonce: 0})
            }),
            sellerPermitSignature: SignatureECDSA({v: 0, r: bytes32(0), s: bytes32(0)})
        });
    }

    function _getAdvancedBids(
        uint256 offerType,
        Order[] memory saleDetailsArray,
        SignatureECDSA memory signature,
        Cosignature memory cosignature,
        TestTokenSetProof[] memory tokenSetProofs,
        FeeOnTop[] memory feeOnTop,
        BulkOrderProof[] memory bulkOrderProofs
    ) internal view returns (AdvancedBidOrder[] memory advancedBidsArray) {
        advancedBidsArray = new AdvancedBidOrder[](saleDetailsArray.length);

        for (uint256 i = 0; i < advancedBidsArray.length; i++) {
            advancedBidsArray[i] = AdvancedBidOrder({
                offerType: offerType,
                advancedOrder: AdvancedOrder({
                    saleDetails: saleDetailsArray[i],
                    signature: signature,
                    cosignature: cosignature,
                    permitContext: PermitContext({permitProcessor: address(0), permitNonce: 0})
                }),
                sellerPermitSignature: SignatureECDSA({v: 0, r: bytes32(0), s: bytes32(0)})
            });
        }
    }

    function _getAdvancedSweep(
        FeeOnTop memory feeOnTop,
        SweepOrder memory sweepOrder,
        AdvancedSweepItem[] memory items
    ) internal view returns (AdvancedSweep memory advancedSweep) {
        advancedSweep = AdvancedSweep({
            feeOnTop: feeOnTop,
            sweepOrder: sweepOrder,
            items: items
        });
    }

    function _getBuyListingAdvancedFnCalldata(
        AdvancedOrder memory advancedListing,
        BulkOrderProof memory bulkOrderProof,
        FeeOnTop memory feeOnTop
    ) internal view returns (bytes memory fnCalldata) {
        fnCalldata = 
            _paymentProcessorEncoder.encodeBuyListingAdvancedCalldata(
                address(_paymentProcessor), 
                advancedListing,
                bulkOrderProof, 
                feeOnTop
            );
    }

    function _getAcceptOfferAdvancedFnCalldata(
        AdvancedBidOrder memory advancedBid,
        BulkOrderProof memory bulkOrderProof,
        FeeOnTop memory feeOnTop,
        TestTokenSetProof memory tokenSetProof
    ) internal view returns (bytes memory fnCalldata) {
        fnCalldata = 
            _paymentProcessorEncoder.encodeAcceptOfferAdvancedCalldata(
                address(_paymentProcessor), 
                advancedBid,
                bulkOrderProof,
                feeOnTop,
                TokenSetProof({proof: tokenSetProof.proof})
            );
    }

    function _getBulkBuyListingsAdvancedFnCalldata(
        AdvancedOrder[] memory advancedListingsArray,
        BulkOrderProof[] memory bulkOrderProofs,
        FeeOnTop[] memory feesOnTop
    ) internal view returns (bytes memory fnCalldata) {
        fnCalldata = 
            _paymentProcessorEncoder.encodeBulkBuyListingsAdvancedCalldata(
                address(_paymentProcessor), 
                advancedListingsArray,
                bulkOrderProofs,
                feesOnTop
            );
    }

    function _getBulkAcceptOffersAdvancedFnCalldata(
        AdvancedBidOrder[] memory advancedBidsArray,
        BulkOrderProof[] memory bulkOrderProofs,
        FeeOnTop[] memory feesOnTop,
        TestTokenSetProof[] memory tokenSetProofs
    ) internal view returns (bytes memory fnCalldata) {
        TokenSetProof[] memory tokenSetProofsArray = new TokenSetProof[](tokenSetProofs.length);
        for (uint256 i; i < tokenSetProofs.length; ++i) {
            tokenSetProofsArray[i] = TokenSetProof({proof: tokenSetProofs[i].proof});
        }

        fnCalldata = 
            _paymentProcessorEncoder.encodeBulkAcceptOffersAdvancedCalldata(
                address(_paymentProcessor), 
                advancedBidsArray,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofsArray
            );
    }

    function _getSweepCollectionAdvancedFnCalldata(
        AdvancedSweep memory advancedSweep
    ) internal view returns (bytes memory fnCalldata) {
        fnCalldata = 
            _paymentProcessorEncoder.encodeSweepCollectionAdvancedCalldata(
                address(_paymentProcessor), 
                advancedSweep
            );
    }

    function _buySignedListingAdvanced(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedOrderProofAndSignature(
            6,
            fuzzedOrderInputs.sellerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedOrder memory advancedListing =
             _getAdvancedOrder(
                saleDetails,
                signature,
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}),
                PermitContext({permitProcessor: address(0), permitNonce: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getBuyListingAdvancedFnCalldata(advancedListing, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListingAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _buySignedListingAdvanced(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedOrderProofAndSignature(
            6,
            fuzzedOrderInputs.sellerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedOrder memory advancedListing =
             _getAdvancedOrder(
                saleDetails,
                signature,
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}),
                PermitContext({permitProcessor: address(0), permitNonce: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getBuyListingAdvancedFnCalldata(advancedListing, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListingAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _buySignedListingWithFeeOnTopAdvanced(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedOrderProofAndSignature(
            6,
            fuzzedOrderInputs.sellerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedOrder memory advancedListing =
             _getAdvancedOrder(
                saleDetails,
                signature,
                cosignature,
                feeOnTop,
                PermitContext({permitProcessor: address(0), permitNonce: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getBuyListingAdvancedFnCalldata(advancedListing, bulkOrderProof, feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListingAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _buySignedListingWithFeeOnTopAdvanced(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedOrderProofAndSignature(
            6,
            fuzzedOrderInputs.sellerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedOrder memory advancedListing =
             _getAdvancedOrder(
                saleDetails,
                signature,
                cosignature,
                feeOnTop,
                PermitContext({permitProcessor: address(0), permitNonce: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getBuyListingAdvancedFnCalldata(advancedListing, bulkOrderProof, feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListingAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _buyCosignedListingAdvanced(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedOrderProofAndSignature(
            6,
            fuzzedOrderInputs.sellerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedOrder memory advancedListing =
             _getAdvancedOrder(
                saleDetails,
                signature,
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}),
                PermitContext({permitProcessor: address(0), permitNonce: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getBuyListingAdvancedFnCalldata(advancedListing, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListingAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _buyCosignedListingAdvanced(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedOrderProofAndSignature(
            6,
            fuzzedOrderInputs.sellerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedOrder memory advancedListing =
             _getAdvancedOrder(
                saleDetails,
                signature,
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}),
                PermitContext({permitProcessor: address(0), permitNonce: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getBuyListingAdvancedFnCalldata(advancedListing, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListingAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _buyCosignedListingWithFeeOnTopAdvanced(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedOrderProofAndSignature(
            6,
            fuzzedOrderInputs.sellerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedOrder memory advancedListing =
             _getAdvancedOrder(
                saleDetails,
                signature,
                cosignature,
                feeOnTop,
                PermitContext({permitProcessor: address(0), permitNonce: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getBuyListingAdvancedFnCalldata(advancedListing, bulkOrderProof, feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListingAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _buyCosignedListingWithFeeOnTopAdvanced(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedOrderProofAndSignature(
            6,
            fuzzedOrderInputs.sellerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedOrder memory advancedListing =
             _getAdvancedOrder(
                saleDetails,
                signature,
                cosignature,
                feeOnTop,
                PermitContext({permitProcessor: address(0), permitNonce: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getBuyListingAdvancedFnCalldata(advancedListing, bulkOrderProof, feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListingAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _buyEmptyCosignedListingAdvanced(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedOrderProofAndSignature(
            6,
            fuzzedOrderInputs.sellerKey,
            0,
            caller,
            saleDetails
        );

        AdvancedOrder memory advancedListing =
             _getAdvancedOrder(
                saleDetails,
                signature,
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}),
                PermitContext({permitProcessor: address(0), permitNonce: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getBuyListingAdvancedFnCalldata(advancedListing, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListingAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _buyEmptyCosignedListingAdvanced(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedOrderProofAndSignature(
            6,
            fuzzedOrderInputs.sellerKey,
            0,
            caller,
            saleDetails
        );

        AdvancedOrder memory advancedListing =
             _getAdvancedOrder(
                saleDetails,
                signature,
                cosignature,
                FeeOnTop({recipient: address(0), amount: 0}),
                PermitContext({permitProcessor: address(0), permitNonce: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getBuyListingAdvancedFnCalldata(advancedListing, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}));

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListingAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _buyEmptyCosignedListingWithFeeOnTopAdvanced(address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedOrderProofAndSignature(
            6,
            fuzzedOrderInputs.sellerKey,
            0,
            caller,
            saleDetails
        );

        AdvancedOrder memory advancedListing =
             _getAdvancedOrder(
                saleDetails,
                signature,
                cosignature,
                feeOnTop,
                PermitContext({permitProcessor: address(0), permitNonce: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getBuyListingAdvancedFnCalldata(advancedListing, bulkOrderProof, feeOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.buyListingAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _buyEmptyCosignedListingWithFeeOnTopAdvanced(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        if (saleDetails.paymentMethod == address(0)) {
            nativePaymentValue = nativePaymentValue + feeOnTop.amount;
        }

        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedOrderProofAndSignature(
            6,
            fuzzedOrderInputs.sellerKey,
            0,
            caller,
            saleDetails
        );

        AdvancedOrder memory advancedListing =
             _getAdvancedOrder(
                saleDetails,
                signature,
                cosignature,
                feeOnTop,
                PermitContext({permitProcessor: address(0), permitNonce: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getBuyListingAdvancedFnCalldata(advancedListing, bulkOrderProof, feeOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.buyListingAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    // Bulk Buy Listings

    function _bulkBuySignedListingsAdvanced(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedListingProofsAndSignature(
            6,
            fuzzedOrderInputsArray[0].sellerKey,
            0,
            caller,
            saleDetailsArray
        );

        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        PermitContext[] memory permitContexts = new PermitContext[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
            permitContexts[i] = PermitContext({permitProcessor: address(0), permitNonce: 0});
        }

        AdvancedOrder[] memory advancedListing =
             _getAdvancedOrders(
                saleDetailsArray,
                signature,
                cosignature,
                feesOnTop,
                permitContexts,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkBuyListingsAdvancedFnCalldata(advancedListing, bulkOrderProofs, feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListingsAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuySignedListingsAdvanced(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedListingProofsAndSignature(
            6,
            fuzzedOrderInputsArray[0].sellerKey,
            0,
            caller,
            saleDetailsArray
        );

        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        PermitContext[] memory permitContexts = new PermitContext[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
            permitContexts[i] = PermitContext({permitProcessor: address(0), permitNonce: 0});
        }

        AdvancedOrder[] memory advancedListing =
             _getAdvancedOrders(
                saleDetailsArray,
                signature,
                cosignature,
                feesOnTop,
                permitContexts,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkBuyListingsAdvancedFnCalldata(advancedListing, bulkOrderProofs, feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListingsAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkBuySignedListingsWithFeeOnTopAdvanced(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }
        }

        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedListingProofsAndSignature(
            6,
            fuzzedOrderInputsArray[0].sellerKey,
            0,
            caller,
            saleDetailsArray
        );

        PermitContext[] memory permitContexts = new PermitContext[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            permitContexts[i] = PermitContext({permitProcessor: address(0), permitNonce: 0});
        }

        AdvancedOrder[] memory advancedListing =
             _getAdvancedOrders(
                saleDetailsArray,
                signature,
                cosignature,
                feesOnTop,
                permitContexts,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkBuyListingsAdvancedFnCalldata(advancedListing, bulkOrderProofs, feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListingsAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuySignedListingsWithFeeOnTopAdvanced(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }
        }

        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedListingProofsAndSignature(
            6,
            fuzzedOrderInputsArray[0].sellerKey,
            0,
            caller,
            saleDetailsArray
        );

        PermitContext[] memory permitContexts = new PermitContext[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            permitContexts[i] = PermitContext({permitProcessor: address(0), permitNonce: 0});
        }

        AdvancedOrder[] memory advancedListing =
             _getAdvancedOrders(
                saleDetailsArray,
                signature,
                cosignature,
                feesOnTop,
                permitContexts,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkBuyListingsAdvancedFnCalldata(advancedListing, bulkOrderProofs, feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListingsAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkBuyCosignedListingsAdvanced(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedListingProofsAndSignature(
            6,
            fuzzedOrderInputsArray[0].sellerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray
        );

        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        PermitContext[] memory permitContexts = new PermitContext[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
            permitContexts[i] = PermitContext({permitProcessor: address(0), permitNonce: 0});
        }

        AdvancedOrder[] memory advancedListing =
             _getAdvancedOrders(
                saleDetailsArray,
                signature,
                cosignature,
                feesOnTop,
                permitContexts,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkBuyListingsAdvancedFnCalldata(advancedListing, bulkOrderProofs, feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListingsAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuyCosignedListingsAdvanced(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedListingProofsAndSignature(
            6,
            fuzzedOrderInputsArray[0].sellerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray
        );

        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        PermitContext[] memory permitContexts = new PermitContext[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
            permitContexts[i] = PermitContext({permitProcessor: address(0), permitNonce: 0});
        }

        AdvancedOrder[] memory advancedListing =
             _getAdvancedOrders(
                saleDetailsArray,
                signature,
                cosignature,
                feesOnTop,
                permitContexts,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkBuyListingsAdvancedFnCalldata(advancedListing, bulkOrderProofs, feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListingsAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkBuyCosignedListingsWithFeesOnTopAdvanced(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }
        }

        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedListingProofsAndSignature(
            6,
            fuzzedOrderInputsArray[0].sellerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray
        );

        PermitContext[] memory permitContexts = new PermitContext[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            permitContexts[i] = PermitContext({permitProcessor: address(0), permitNonce: 0});
        }

        AdvancedOrder[] memory advancedListing =
             _getAdvancedOrders(
                saleDetailsArray,
                signature,
                cosignature,
                feesOnTop,
                permitContexts,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkBuyListingsAdvancedFnCalldata(advancedListing, bulkOrderProofs, feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListingsAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuyCosignedListingsWithFeesOnTopAdvanced(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }
        }

        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedListingProofsAndSignature(
            6,
            fuzzedOrderInputsArray[0].sellerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray
        );

        PermitContext[] memory permitContexts = new PermitContext[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            permitContexts[i] = PermitContext({permitProcessor: address(0), permitNonce: 0});
        }

        AdvancedOrder[] memory advancedListing =
             _getAdvancedOrders(
                saleDetailsArray,
                signature,
                cosignature,
                feesOnTop,
                permitContexts,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkBuyListingsAdvancedFnCalldata(advancedListing, bulkOrderProofs, feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListingsAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkBuyEmptyCosignedListingsAdvanced(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedListingProofsAndSignature(
            6,
            fuzzedOrderInputsArray[0].sellerKey,
            0,
            caller,
            saleDetailsArray
        );

        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        PermitContext[] memory permitContexts = new PermitContext[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
            permitContexts[i] = PermitContext({permitProcessor: address(0), permitNonce: 0});
        }

        AdvancedOrder[] memory advancedListing =
             _getAdvancedOrders(
                saleDetailsArray,
                signature,
                cosignature,
                feesOnTop,
                permitContexts,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkBuyListingsAdvancedFnCalldata(advancedListing, bulkOrderProofs, feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListingsAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuyEmptyCosignedListingsAdvanced(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedListingProofsAndSignature(
            6,
            fuzzedOrderInputsArray[0].sellerKey,
            0,
            caller,
            saleDetailsArray
        );

        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        PermitContext[] memory permitContexts = new PermitContext[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
            permitContexts[i] = PermitContext({permitProcessor: address(0), permitNonce: 0});
        }

        AdvancedOrder[] memory advancedListing =
             _getAdvancedOrders(
                saleDetailsArray,
                signature,
                cosignature,
                feesOnTop,
                permitContexts,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkBuyListingsAdvancedFnCalldata(advancedListing, bulkOrderProofs, feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListingsAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkBuyEmptyCosignedListingsWithFeesOnTopAdvanced(address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }
        }

        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedListingProofsAndSignature(
            6,
            fuzzedOrderInputsArray[0].sellerKey,
            0,
            caller,
            saleDetailsArray
        );

        PermitContext[] memory permitContexts = new PermitContext[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            permitContexts[i] = PermitContext({permitProcessor: address(0), permitNonce: 0});
        }

        AdvancedOrder[] memory advancedListing =
             _getAdvancedOrders(
                saleDetailsArray,
                signature,
                cosignature,
                feesOnTop,
                permitContexts,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkBuyListingsAdvancedFnCalldata(advancedListing, bulkOrderProofs, feesOnTop);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkBuyListingsAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _bulkBuyEmptyCosignedListingsWithFeesOnTopAdvanced(address channel, address caller, uint256 nativePaymentValue, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        for (uint256 i = 0; i < saleDetailsArray.length; ++i) {
            if (saleDetailsArray[i].paymentMethod == address(0)) {
                nativePaymentValue = nativePaymentValue + feesOnTop[i].amount;
            }
        }

        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedListingProofsAndSignature(
            6,
            fuzzedOrderInputsArray[0].sellerKey,
            0,
            caller,
            saleDetailsArray
        );

        PermitContext[] memory permitContexts = new PermitContext[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            permitContexts[i] = PermitContext({permitProcessor: address(0), permitNonce: 0});
        }

        AdvancedOrder[] memory advancedListing =
             _getAdvancedOrders(
                saleDetailsArray,
                signature,
                cosignature,
                feesOnTop,
                permitContexts,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkBuyListingsAdvancedFnCalldata(advancedListing, bulkOrderProofs, feesOnTop);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.bulkBuyListingsAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    // Item Offers

    function _acceptSignedItemOfferAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForItemOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_ITEM_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptSignedItemOfferAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForItemOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_ITEM_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptSignedItemOfferWithFeeOnTopAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForItemOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_ITEM_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptSignedItemOfferWithFeeOnTopAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForItemOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_ITEM_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptEmptyCosignedItemOfferAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForItemOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            0,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_ITEM_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptEmptyCosignedItemOfferAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForItemOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            0,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_ITEM_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptCosignedItemOfferAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForItemOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_ITEM_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptCosignedItemOfferAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForItemOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_ITEM_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptEmptyCosignedItemOfferWithFeeOnTopAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForItemOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            0,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_ITEM_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptEmptyCosignedItemOfferWithFeeOnTopAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForItemOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            0,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_ITEM_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptCosignedItemOfferWithFeeOnTopAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForItemOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_ITEM_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptCosignedItemOfferWithFeeOnTopAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForItemOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_ITEM_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    // Bulk Accept Item Offers

    function _bulkAcceptSignedItemOffersAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForItemOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_ITEM_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptSignedItemOffersAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForItemOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_ITEM_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptSignedItemOffersWithFeesOnTopAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForItemOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_ITEM_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptSignedItemOffersWithFeesOnTopAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForItemOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_ITEM_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptEmptyCosignedItemOffersAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForItemOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_ITEM_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedItemOffersAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForItemOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_ITEM_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptCosignedItemOffersAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForItemOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_ITEM_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptCosignedItemOffersAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForItemOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_ITEM_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptEmptyCosignedItemOffersWithFeesOnTopAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForItemOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_ITEM_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedItemOffersWithFeesOnTopAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForItemOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_ITEM_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptCosignedItemOffersWithFeesOnTopAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForItemOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_ITEM_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptCosignedItemOffersWithFeesOnTopAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForItemOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_ITEM_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    // Collection Offers

    function _acceptSignedCollectionOfferAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptSignedCollectionOfferAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptSignedCollectionOfferWithFeeOnTopAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptSignedCollectionOfferWithFeeOnTopAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptEmptyCosignedCollectionOfferAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            0,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptEmptyCosignedCollectionOfferAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            0,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptCosignedCollectionOfferAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptCosignedCollectionOfferAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptEmptyCosignedCollectionOfferWithFeeOnTopAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            0,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptEmptyCosignedCollectionOfferWithFeeOnTopAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            0,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptCosignedCollectionOfferWithFeeOnTopAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptCosignedCollectionOfferWithFeeOnTopAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetails,
                signature,
                cosignature,
                TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}),
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)}));

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    // Bulk Accept Collection Offers

    function _bulkAcceptSignedCollectionOffersAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptSignedCollectionOffersAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptSignedCollectionOffersWithFeesOnTopAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptSignedCollectionOffersWithFeesOnTopAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptEmptyCosignedCollectionOffersAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedCollectionOffersAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptCosignedCollectionOffersAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptCosignedCollectionOffersAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptEmptyCosignedCollectionOffersWithFeesOnTopAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedCollectionOffersWithFeesOnTopAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptCosignedCollectionOffersWithFeesOnTopAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptCosignedCollectionOffersWithFeesOnTopAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForCollectionOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray
        );

        TestTokenSetProof[] memory tokenSetProofs = new TestTokenSetProof[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            tokenSetProofs[i] = TestTokenSetProof({rootHash: bytes32(0), proof: new bytes32[](0)});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_COLLECTION_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    // Token Set Offers

    function _acceptSignedTokenSetOfferAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails,
            tokenSetProof
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails,
                signature,
                cosignature,
                tokenSetProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), tokenSetProof);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptSignedTokenSetOfferAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails,
            tokenSetProof
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails,
                signature,
                cosignature,
                tokenSetProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), tokenSetProof);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptSignedTokenSetOfferWithFeeOnTopAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails,
            tokenSetProof
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails,
                signature,
                cosignature,
                tokenSetProof,
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, tokenSetProof);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptSignedTokenSetOfferWithFeeOnTopAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails,
            tokenSetProof
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails,
                signature,
                cosignature,
                tokenSetProof,
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, tokenSetProof);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptEmptyCosignedTokenSetOfferAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            0,
            caller,
            saleDetails,
            tokenSetProof
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails,
                signature,
                cosignature,
                tokenSetProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), tokenSetProof);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptEmptyCosignedTokenSetOfferAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            0,
            caller,
            saleDetails,
            tokenSetProof
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails,
                signature,
                cosignature,
                tokenSetProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), tokenSetProof);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptCosignedTokenSetOfferAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails,
            tokenSetProof
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails,
                signature,
                cosignature,
                tokenSetProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), tokenSetProof);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptCosignedTokenSetOfferAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails,
            tokenSetProof
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails,
                signature,
                cosignature,
                tokenSetProof,
                FeeOnTop({recipient: address(0), amount: 0}),
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, FeeOnTop({recipient: address(0), amount: 0}), tokenSetProof);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptEmptyCosignedTokenSetOfferWithFeeOnTopAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            0,
            caller,
            saleDetails,
            tokenSetProof
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails,
                signature,
                cosignature,
                tokenSetProof,
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, tokenSetProof);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptEmptyCosignedTokenSetOfferWithFeeOnTopAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            0,
            caller,
            saleDetails,
            tokenSetProof
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails,
                signature,
                cosignature,
                tokenSetProof,
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, tokenSetProof);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _acceptCosignedTokenSetOfferWithFeeOnTopAdvanced(address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails,
            tokenSetProof
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails,
                signature,
                cosignature,
                tokenSetProof,
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, tokenSetProof);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.acceptOfferAdvanced(fnCalldata);
    }

    function _acceptCosignedTokenSetOfferWithFeeOnTopAdvanced(address channel, address caller, FuzzedOrder721 memory fuzzedOrderInputs, Order memory saleDetails, TestTokenSetProof memory tokenSetProof, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof memory bulkOrderProof, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getAdvancedBidProofAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputs.buyerKey,
            fuzzedOrderInputs.cosignerKey,
            caller,
            saleDetails,
            tokenSetProof
        );

        AdvancedBidOrder memory advancedBid =
             _getAdvancedBid(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetails,
                signature,
                cosignature,
                tokenSetProof,
                feeOnTop,
                bulkOrderProof
            );

        bytes memory fnCalldata = _getAcceptOfferAdvancedFnCalldata(advancedBid, bulkOrderProof, feeOnTop, tokenSetProof);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.acceptOfferAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    // Bulk Accept Token Set Offers

    function _bulkAcceptSignedTokenSetOffersAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofs, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray,
            tokenSetProofs
        );

        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptSignedTokenSetOffersAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofs, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray,
            tokenSetProofs
        );

        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptSignedTokenSetOffersWithFeesOnTopAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofs, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray,
            tokenSetProofs
        );

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptSignedTokenSetOffersWithFeesOnTopAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofs, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray,
            tokenSetProofs
        );

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptEmptyCosignedTokenSetOffersAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofs, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray,
            tokenSetProofs
        );

        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedTokenSetOffersAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofs, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray,
            tokenSetProofs
        );

        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptCosignedTokenSetOffersAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofs, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray,
            tokenSetProofs
        );

        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptCosignedTokenSetOffersAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofs, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray,
            tokenSetProofs
        );

        FeeOnTop[] memory feesOnTop = new FeeOnTop[](saleDetailsArray.length);
        for (uint256 i = 0; i < saleDetailsArray.length; i++) {
            feesOnTop[i] = FeeOnTop({recipient: address(0), amount: 0});
        }

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptEmptyCosignedTokenSetOffersWithFeesOnTopAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofs, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray,
            tokenSetProofs
        );

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptEmptyCosignedTokenSetOffersWithFeesOnTopAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofs, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            0,
            caller,
            saleDetailsArray,
            tokenSetProofs
        );

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    function _bulkAcceptCosignedTokenSetOffersWithFeesOnTopAdvanced(address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofs, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray,
            tokenSetProofs
        );

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.bulkAcceptOffersAdvanced(fnCalldata);
    }

    function _bulkAcceptCosignedTokenSetOffersWithFeesOnTopAdvanced(address channel, address caller, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, TestTokenSetProof[] memory tokenSetProofs, FeeOnTop[] memory feesOnTop, bytes4 expectedRevertSelector) internal {
        (
            BulkOrderProof[] memory bulkOrderProofs, 
            SignatureECDSA memory signature,
            Cosignature memory cosignature
        ) = _getBatchOfAdvancedBidProofsAndSignatureForTokenSetOffer(
            6,
            fuzzedOrderInputsArray[0].buyerKey,
            fuzzedOrderInputsArray[0].cosignerKey,
            caller,
            saleDetailsArray,
            tokenSetProofs
        );

        AdvancedBidOrder[] memory advancedBids =
             _getAdvancedBids(
                OFFER_TYPE_TOKEN_SET_OFFER,
                saleDetailsArray,
                signature,
                cosignature,
                tokenSetProofs,
                feesOnTop,
                bulkOrderProofs
            );

        bytes memory fnCalldata = _getBulkAcceptOffersAdvancedFnCalldata(advancedBids, bulkOrderProofs, feesOnTop, tokenSetProofs);

        _forwardCall(channel, caller, address(_paymentProcessor), 0, _paymentProcessor.bulkAcceptOffersAdvanced.selector, fnCalldata, expectedRevertSelector);

    }

    // Sweep Collection Advanced

    function _sweepSignedListingsAdvanced(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory advancedSweepItems = 
            _getAdvancedSweepItems(
                6,
                fuzzedOrderInputsArray[0].sellerKey,
                0,
                caller,
                saleDetailsArray
            );

        AdvancedSweep memory advancedSweep =
             _getAdvancedSweep(
                FeeOnTop({recipient: address(0), amount: 0}),
                sweepOrder,
                advancedSweepItems
            );

        bytes memory fnCalldata = _getSweepCollectionAdvancedFnCalldata(advancedSweep);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.sweepCollectionAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepSignedListingsAdvanced(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory advancedSweepItems = 
            _getAdvancedSweepItems(
                6,
                fuzzedOrderInputsArray[0].sellerKey,
                0,
                caller,
                saleDetailsArray
            );

        AdvancedSweep memory advancedSweep =
             _getAdvancedSweep(
                FeeOnTop({recipient: address(0), amount: 0}),
                sweepOrder,
                advancedSweepItems
            );

        bytes memory fnCalldata = _getSweepCollectionAdvancedFnCalldata(advancedSweep);
        
        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollectionAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepSignedListingsWithFeeOnTopAdvanced(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        if (sweepOrder.paymentMethod == address(0)) {
            nativePaymentValue += feeOnTop.amount;
        }

        AdvancedSweepItem[] memory advancedSweepItems = 
            _getAdvancedSweepItems(
                6,
                fuzzedOrderInputsArray[0].sellerKey,
                0,
                caller,
                saleDetailsArray
            );

        AdvancedSweep memory advancedSweep =
             _getAdvancedSweep(
                feeOnTop,
                sweepOrder,
                advancedSweepItems
            );

        bytes memory fnCalldata = _getSweepCollectionAdvancedFnCalldata(advancedSweep);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.sweepCollectionAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepSignedListingsWithFeeOnTopAdvanced(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        if (sweepOrder.paymentMethod == address(0)) {
            nativePaymentValue += feeOnTop.amount;
        }

        AdvancedSweepItem[] memory advancedSweepItems = 
            _getAdvancedSweepItems(
                6,
                fuzzedOrderInputsArray[0].sellerKey,
                0,
                caller,
                saleDetailsArray
            );

        AdvancedSweep memory advancedSweep =
             _getAdvancedSweep(
                feeOnTop,
                sweepOrder,
                advancedSweepItems
            );

        bytes memory fnCalldata = _getSweepCollectionAdvancedFnCalldata(advancedSweep);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollectionAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepEmptyCosignedListingsAdvanced(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory advancedSweepItems = 
            _getAdvancedSweepItems(
                6,
                fuzzedOrderInputsArray[0].sellerKey,
                0,
                caller,
                saleDetailsArray
            );

        AdvancedSweep memory advancedSweep =
             _getAdvancedSweep(
                FeeOnTop({recipient: address(0), amount: 0}),
                sweepOrder,
                advancedSweepItems
            );

        bytes memory fnCalldata = _getSweepCollectionAdvancedFnCalldata(advancedSweep);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.sweepCollectionAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepEmptyCosignedListingsAdvanced(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory advancedSweepItems = 
            _getAdvancedSweepItems(
                6,
                fuzzedOrderInputsArray[0].sellerKey,
                0,
                caller,
                saleDetailsArray
            );

        AdvancedSweep memory advancedSweep =
             _getAdvancedSweep(
                FeeOnTop({recipient: address(0), amount: 0}),
                sweepOrder,
                advancedSweepItems
            );

        bytes memory fnCalldata = _getSweepCollectionAdvancedFnCalldata(advancedSweep);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollectionAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepCosignedListingsAdvanced(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory advancedSweepItems = 
            _getAdvancedSweepItems(
                6,
                fuzzedOrderInputsArray[0].sellerKey,
                fuzzedOrderInputsArray[0].cosignerKey,
                caller,
                saleDetailsArray
            );

        AdvancedSweep memory advancedSweep =
             _getAdvancedSweep(
                FeeOnTop({recipient: address(0), amount: 0}),
                sweepOrder,
                advancedSweepItems
            );

        bytes memory fnCalldata = _getSweepCollectionAdvancedFnCalldata(advancedSweep);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.sweepCollectionAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepCosignedListingsAdvanced(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, bytes4 expectedRevertSelector) internal {
        AdvancedSweepItem[] memory advancedSweepItems = 
            _getAdvancedSweepItems(
                6,
                fuzzedOrderInputsArray[0].sellerKey,
                fuzzedOrderInputsArray[0].cosignerKey,
                caller,
                saleDetailsArray
            );

        AdvancedSweep memory advancedSweep =
             _getAdvancedSweep(
                FeeOnTop({recipient: address(0), amount: 0}),
                sweepOrder,
                advancedSweepItems
            );

        bytes memory fnCalldata = _getSweepCollectionAdvancedFnCalldata(advancedSweep);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollectionAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepEmptyCosignedListingsWithFeeOnTopAdvanced(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        if (sweepOrder.paymentMethod == address(0)) {
            nativePaymentValue += feeOnTop.amount;
        }

        AdvancedSweepItem[] memory advancedSweepItems = 
            _getAdvancedSweepItems(
                6,
                fuzzedOrderInputsArray[0].sellerKey,
                0,
                caller,
                saleDetailsArray
            );

        AdvancedSweep memory advancedSweep =
             _getAdvancedSweep(
                feeOnTop,
                sweepOrder,
                advancedSweepItems
            );

        bytes memory fnCalldata = _getSweepCollectionAdvancedFnCalldata(advancedSweep);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.sweepCollectionAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepEmptyCosignedListingsWithFeeOnTopAdvanced(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        if (sweepOrder.paymentMethod == address(0)) {
            nativePaymentValue += feeOnTop.amount;
        }

        AdvancedSweepItem[] memory advancedSweepItems = 
            _getAdvancedSweepItems(
                6,
                fuzzedOrderInputsArray[0].sellerKey,
                0,
                caller,
                saleDetailsArray
            );

        AdvancedSweep memory advancedSweep =
             _getAdvancedSweep(
                feeOnTop,
                sweepOrder,
                advancedSweepItems
            );

        bytes memory fnCalldata = _getSweepCollectionAdvancedFnCalldata(advancedSweep);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollectionAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _sweepCosignedListingsWithFeeOnTopAdvanced(address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        if (sweepOrder.paymentMethod == address(0)) {
            nativePaymentValue += feeOnTop.amount;
        }

        AdvancedSweepItem[] memory advancedSweepItems = 
            _getAdvancedSweepItems(
                6,
                fuzzedOrderInputsArray[0].sellerKey,
                fuzzedOrderInputsArray[0].cosignerKey,
                caller,
                saleDetailsArray
            );

        AdvancedSweep memory advancedSweep =
             _getAdvancedSweep(
                feeOnTop,
                sweepOrder,
                advancedSweepItems
            );

        bytes memory fnCalldata = _getSweepCollectionAdvancedFnCalldata(advancedSweep);

        if(expectedRevertSelector != bytes4(0x00000000)) {
            vm.expectRevert(expectedRevertSelector);
        }
    
        vm.prank(caller, caller);
        _paymentProcessor.sweepCollectionAdvanced{value: nativePaymentValue}(fnCalldata);
    }

    function _sweepCosignedListingsWithFeeOnTopAdvanced(address channel, address caller, uint256 nativePaymentValue, SweepOrder memory sweepOrder, FuzzedOrder721[] memory fuzzedOrderInputsArray, Order[] memory saleDetailsArray, FeeOnTop memory feeOnTop, bytes4 expectedRevertSelector) internal {
        if (sweepOrder.paymentMethod == address(0)) {
            nativePaymentValue += feeOnTop.amount;
        }

        AdvancedSweepItem[] memory advancedSweepItems = 
            _getAdvancedSweepItems(
                6,
                fuzzedOrderInputsArray[0].sellerKey,
                fuzzedOrderInputsArray[0].cosignerKey,
                caller,
                saleDetailsArray
            );

        AdvancedSweep memory advancedSweep =
             _getAdvancedSweep(
                feeOnTop,
                sweepOrder,
                advancedSweepItems
            );

        bytes memory fnCalldata = _getSweepCollectionAdvancedFnCalldata(advancedSweep);

        _forwardCall(channel, caller, address(_paymentProcessor), nativePaymentValue, _paymentProcessor.sweepCollectionAdvanced.selector, fnCalldata, expectedRevertSelector);
    }

    function _getBulkSaleApprovalTypehash(uint256 height) public pure returns(bytes32 hash) {
        if(height > 10 || height == 0) {
            revert PaymentProcessor__InvalidBulkOrderHeight();
        }
        bytes memory memTypehashes = BULK_SALE_APPROVAL_TYPEHASHES_LOOKUP;
        assembly {
            hash := mload(add(memTypehashes, shl(5, height)))
        }
    }

    function _getBulkCollectionOfferApprovalTypehash(uint256 height) public pure returns(bytes32 hash) {
        if(height > 10 || height == 0) {
            revert PaymentProcessor__InvalidBulkOrderHeight();
        }
        bytes memory memTypehashes = BULK_COLLECTION_OFFER_APPROVAL_TYPEHASHES_LOOKUP;
        assembly {
            hash := mload(add(memTypehashes, shl(5, height)))
        }
    }

    function _getBulkItemOfferApprovalTypehash(uint256 height) public pure returns(bytes32 hash) {
        if(height > 10 || height == 0) {
            revert PaymentProcessor__InvalidBulkOrderHeight();
        }
        bytes memory memTypehashes = BULK_ITEM_OFFER_APPROVAL_TYPEHASHES_LOOKUP;
        assembly {
            hash := mload(add(memTypehashes, shl(5, height)))
        }
    }

    function _getBulkTokenSetOfferApprovalTypehash(uint256 height) public pure returns(bytes32 hash) {
        if(height > 10 || height == 0) {
            revert PaymentProcessor__InvalidBulkOrderHeight();
        }
        bytes memory memTypehashes = BULK_TOKEN_SET_OFFER_APPROVAL_TYPEHASHES_LOOKUP;
        assembly {
            hash := mload(add(memTypehashes, shl(5, height)))
        }
    }
}