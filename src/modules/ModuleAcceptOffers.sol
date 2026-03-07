//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "./PaymentProcessorModuleAdvanced.sol";
import "@limitbreak/tm-core-lib/src/licenses/LicenseRef-PolyForm-Strict-1.0.0.sol";

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
 
* @title ModuleAcceptOffers
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 

contract ModuleAcceptOffers is PaymentProcessorModuleAdvanced {

    constructor(address configurationContract) PaymentProcessorModuleAdvanced(configurationContract){}

    /**
     * @notice Executes an offer accept transaction for a single order item.
     *
     * @dev    Throws when the maker's nonce has already been used or has been cancelled.
     * @dev    Throws when the order has expired.
     * @dev    Throws when the combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when the taker fee on top exceeds 100% of the item sale price.
     * @dev    Throws when the maker's master nonce does not match the order details.
     * @dev    Throws when the order does not comply with the collection payment settings.
     * @dev    Throws when the maker's signature is invalid.
     * @dev    Throws when the order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when the maker does not have sufficient funds to complete the purchase.
     * @dev    Throws when the token transfer fails for any reason such as lack of approvals or token not owned by the taker.
     * @dev    Throws when the token the offer is being accepted for does not match the conditions set by the maker.
     * @dev    Throws when the maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Maker's nonce is marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Maker's partially fillable order state is updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. An `AcceptOfferERC721` event has been emitted for a ERC721 sale.
     * @dev    6. An `AcceptOfferERC1155` event has been emitted for a ERC1155 sale.
     * @dev    7. A `NonceInvalidated` event has been emitted for a ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for a ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  offerType       The type of offer being executed.
     * @param  saleDetails     The order execution details.
     * @param  buyerSignature  The maker's signature authorizing the order execution.
     * @param  tokenSetProof   The merkle proofs for an offer that is a subset of tokens in a collection.
     * @param  cosignature     The additional cosignature for a cosigned order, if applicable.
     * @param  feeOnTop        The additional fee to add on top of the order, paid by taker.
     */
    function acceptOffer(
        uint256 offerType, 
        Order memory saleDetails, 
        SignatureECDSA memory buyerSignature,
        TokenSetProof calldata tokenSetProof,
        Cosignature memory cosignature,
        FeeOnTop calldata feeOnTop
    ) public {
        uint256 appendedDataLength;
        unchecked {
            appendedDataLength = 
                msg.data.length - 
                BASE_MSG_LENGTH_ACCEPT_OFFER - 
                (PROOF_ELEMENT_SIZE * tokenSetProof.proof.length);
        }

        _executeOrderSellSide(
            TradeContext({
                channel: msg.sender,
                taker: _getTaker(appendedDataLength),
                disablePartialFill: true,
                orderDigest: bytes32(0),
                backfillNumerator: uint16(0),
                backfillReceiver: address(0),
                bountyNumerator: uint16(0),
                exclusiveMarketplace: address(0),
                useRoyaltyBackfillAsRoyaltySource: false,
                protocolFeeVersion: saleDetails.protocolFeeVersion,
                protocolFees: appStorage().protocolFeeVersions[saleDetails.protocolFeeVersion]
            }),
            offerType, 
            saleDetails, 
            buyerSignature,
            tokenSetProof,
            cosignature,
            feeOnTop);
    }

    /**
     * @notice Executes an advanced offer accept transaction for a single order item.
     *
     * @dev    Throws when the maker's nonce has already been used or has been cancelled.
     * @dev    Throws when the order has expired.
     * @dev    Throws when the combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when the taker fee on top exceeds 100% of the item sale price.
     * @dev    Throws when the maker's master nonce does not match the order details.
     * @dev    Throws when the order does not comply with the collection payment settings.
     * @dev    Throws when the maker's signature is invalid.
     * @dev    Throws when the order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when the maker does not have sufficient funds to complete the purchase.
     * @dev    Throws when the token transfer fails for any reason such as lack of approvals or token not owned by the taker.
     * @dev    Throws when the token the offer is being accepted for does not match the conditions set by the maker.
     * @dev    Throws when the maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Throws when the provided bulk order merkle proof and order index are invalid.
     * @dev    Throws when the provided permit processor does not have approval to move the token or receives an invalid signature.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Maker's nonce is marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Maker's partially fillable order state is updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. An `AcceptOfferERC721` event has been emitted for a ERC721 sale.
     * @dev    6. An `AcceptOfferERC1155` event has been emitted for a ERC1155 sale.
     * @dev    7. A `NonceInvalidated` event has been emitted for a ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for a ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  advancedBid      The cosigner, maker, and taker signatures, order details and permit details.
     * @param  bulkOrderProof   The merkle proofs and order index for an offer that was created via signing a merkle tree.
     * @param  feeOnTop         The additional fee to add on top of the order, paid by taker.
     * @param  tokenSetProof    The merkle proofs for an offer that is a subset of tokens in a collection.
     */
    function acceptOfferAdvanced(
        AdvancedBidOrder memory advancedBid,
        BulkOrderProof calldata bulkOrderProof,
        FeeOnTop calldata feeOnTop,
        TokenSetProof calldata tokenSetProof
    ) public {
        uint256 appendedDataLength;
        unchecked {
            appendedDataLength = 
                msg.data.length - 
                BASE_MSG_LENGTH_ACCEPT_OFFER_ADVANCED - 
                (PROOF_ELEMENT_SIZE * tokenSetProof.proof.length) -
                (PROOF_ELEMENT_SIZE * bulkOrderProof.proof.length);
        }

        _executeOrderSellSideAdvanced(
            TradeContext({
                channel: msg.sender,
                taker: _getTaker(appendedDataLength),
                disablePartialFill: true,
                orderDigest: bytes32(0),
                backfillNumerator: uint16(0),
                backfillReceiver: address(0),
                bountyNumerator: uint16(0),
                exclusiveMarketplace: address(0),
                useRoyaltyBackfillAsRoyaltySource: false,
                protocolFeeVersion: advancedBid.advancedOrder.saleDetails.protocolFeeVersion,
                protocolFees: appStorage().protocolFeeVersions[advancedBid.advancedOrder.saleDetails.protocolFeeVersion]
            }),
            advancedBid,
            bulkOrderProof,
            feeOnTop,
            tokenSetProof);
    }

    /**
     * @notice Executes an accept offer transaction for multiple order items.
     *
     * @dev    Throws when a maker's nonce has already been used or has been cancelled.
     * @dev    Throws when any order has expired.
     * @dev    Throws when any combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when any taker fee on top exceeds 100% of the item sale price.
     * @dev    Throws when a maker's master nonce does not match the order details.
     * @dev    Throws when an order does not comply with the collection payment settings.
     * @dev    Throws when a maker's signature is invalid.
     * @dev    Throws when an order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when a maker does not have sufficient funds to complete the purchase.
     * @dev    Throws when the token an offer is being accepted for does not match the conditions set by the maker.
     * @dev    Throws when a maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Will NOT throw when a token fails to transfer but also will not disperse payments for failed items.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Makers nonces are marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Makers partially fillable order states are updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. `AcceptOfferERC721` events have been emitted for each ERC721 sale.
     * @dev    6. `AcceptOfferERC1155` events have been emitted for each ERC1155 sale.
     * @dev    7. A `NonceInvalidated` event has been emitted for each ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for each ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  params          The parameters for the bulk offers being accepted.
     * @param  feesOnTop       The additional fees to add on top of the orders, paid by taker.
     * @param  tokenSetProofs  The merkle proofs for offers that are subsets of tokens in a collection.
     */
    function bulkAcceptOffers(
        BulkAcceptOffersParams[] memory params,
        FeeOnTop[] calldata feesOnTop,
        TokenSetProof[] calldata tokenSetProofs
    ) public {
        if (params.length != feesOnTop.length) {
            revert PaymentProcessor__InputArrayLengthMismatch();
        }

        if (feesOnTop.length != tokenSetProofs.length) {
            revert PaymentProcessor__InputArrayLengthMismatch();
        }

        if (params.length == 0) {
            revert PaymentProcessor__InputArrayLengthCannotBeZero();
        }

        uint256 appendedDataLength;
        unchecked {
            appendedDataLength = 
                msg.data.length - 
                BASE_MSG_LENGTH_BULK_ACCEPT_OFFERS - 
                (BASE_MSG_LENGTH_BULK_ACCEPT_OFFERS_PER_ITEM * params.length);

            for (uint256 i = 0; i < tokenSetProofs.length;) {
                appendedDataLength -= PROOF_ELEMENT_SIZE * tokenSetProofs[i].proof.length;
                ++i;
            }
        }

        TradeContext memory context = TradeContext({
            channel: msg.sender,
            taker: _getTaker(appendedDataLength),
            disablePartialFill: false,
            orderDigest: bytes32(0),
            backfillNumerator: uint16(0),
            backfillReceiver: address(0),
            bountyNumerator: uint16(0),
            exclusiveMarketplace: address(0),
            useRoyaltyBackfillAsRoyaltySource: false,
            protocolFeeVersion: params[0].saleDetails.protocolFeeVersion,
            protocolFees: appStorage().protocolFeeVersions[params[0].saleDetails.protocolFeeVersion]
        });

        BulkAcceptOffersParams memory offerParams;
        for (uint256 i = 0; i < params.length;) {
            offerParams = params[i];

            if (context.protocolFeeVersion != offerParams.saleDetails.protocolFeeVersion) {
                context.protocolFeeVersion = offerParams.saleDetails.protocolFeeVersion;
                context.protocolFees = appStorage().protocolFeeVersions[offerParams.saleDetails.protocolFeeVersion];
            }

            _executeOrderSellSide(
                context,
                offerParams.offerType, 
                offerParams.saleDetails, 
                offerParams.signature,
                tokenSetProofs[i],
                offerParams.cosignature,
                feesOnTop[i]);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Executes an advanced offer accept transaction for multiple order items.
     *
     * @dev    Throws when a maker's nonce has already been used or has been cancelled.
     * @dev    Throws when any order has expired.
     * @dev    Throws when any combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when any taker fee on top exceeds 100% of the item sale price.
     * @dev    Throws when a maker's master nonce does not match the order details.
     * @dev    Throws when an order does not comply with the collection payment settings.
     * @dev    Throws when a maker's signature is invalid.
     * @dev    Throws when an order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when a maker does not have sufficient funds to complete the purchase.
     * @dev    Throws when any token transfer fails for any reason such as lack of approvals or token not owned by the taker.
     * @dev    Throws when the token an offer is being accepted for does not match the conditions set by the maker.
     * @dev    Throws when a maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Throws when the provided bulk order merkle proof and order index are invalid.
     * @dev    Throws when the provided permit processor does not have approval to move the token or receives an invalid signature.
     * @dev    Will NOT throw when a token fails to transfer but also will not disperse payments for failed items.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Maker's nonce is marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Maker's partially fillable order state is updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. An `AcceptOfferERC721` event has been emitted for a ERC721 sale.
     * @dev    6. An `AcceptOfferERC1155` event has been emitted for a ERC1155 sale.
     * @dev    7. A `NonceInvalidated` event has been emitted for a ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for a ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  advancedBidsArray  The cosigner, maker, and taker signatures, order details and permit details.
     * @param  bulkOrderProofs    The merkle proofs and order index for an offer that was created via signing a merkle tree.
     * @param  feesOnTop          The additional fee to add on top of the order, paid by taker.
     * @param  tokenSetProofs     The merkle proofs for an offer that is a subset of tokens in a collection.
     */
    function bulkAcceptOffersAdvanced(
        AdvancedBidOrder[] calldata advancedBidsArray,
        BulkOrderProof[] calldata bulkOrderProofs,
        FeeOnTop[] calldata feesOnTop,
        TokenSetProof[] calldata tokenSetProofs
    ) public {

        if (advancedBidsArray.length == 0) {
            revert PaymentProcessor__InputArrayLengthCannotBeZero();
        }

        if (advancedBidsArray.length != feesOnTop.length) {
            revert PaymentProcessor__InputArrayLengthMismatch();
        }

        if (tokenSetProofs.length != feesOnTop.length) {
            revert PaymentProcessor__InputArrayLengthMismatch();
        }

        if (bulkOrderProofs.length != feesOnTop.length) {
            revert PaymentProcessor__InputArrayLengthMismatch();
        }

        uint256 appendedDataLength;
        unchecked {
            appendedDataLength = 
                msg.data.length - 
                BASE_MSG_LENGTH_BULK_ACCEPT_OFFERS_ADVANCED - 
                (BASE_MSG_LENGTH_BULK_ACCEPT_OFFERS_ADVANCED_PER_ITEM * advancedBidsArray.length);

            for (uint256 i = 0; i < advancedBidsArray.length; ++i) {
                appendedDataLength -= PROOF_ELEMENT_SIZE * tokenSetProofs[i].proof.length;
                appendedDataLength -= PROOF_ELEMENT_SIZE * bulkOrderProofs[i].proof.length;
            }
        }

        TradeContext memory context = TradeContext({
            channel: msg.sender,
            taker: _getTaker(appendedDataLength),
            disablePartialFill: false,
            orderDigest: bytes32(0),
            backfillNumerator: uint16(0),
            backfillReceiver: address(0),
            bountyNumerator: uint16(0),
            exclusiveMarketplace: address(0),
            useRoyaltyBackfillAsRoyaltySource: false,
            protocolFeeVersion: advancedBidsArray[0].advancedOrder.saleDetails.protocolFeeVersion,
            protocolFees: appStorage().protocolFeeVersions[advancedBidsArray[0].advancedOrder.saleDetails.protocolFeeVersion]
        });

        for (uint256 i = 0; i < advancedBidsArray.length;) {
            if (context.protocolFeeVersion != advancedBidsArray[i].advancedOrder.saleDetails.protocolFeeVersion) {
                context.protocolFeeVersion = advancedBidsArray[i].advancedOrder.saleDetails.protocolFeeVersion;
                context.protocolFees = 
                    appStorage().protocolFeeVersions[advancedBidsArray[i].advancedOrder.saleDetails.protocolFeeVersion];
            }

            _executeOrderSellSideAdvanced(
                context,
                advancedBidsArray[i],
                bulkOrderProofs[i],
                feesOnTop[i],
                tokenSetProofs[i]);

            unchecked {
                ++i;
            }
        }
    }
}
