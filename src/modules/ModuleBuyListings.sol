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
 
* @title ModuleBuyListings
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 

contract ModuleBuyListings is PaymentProcessorModuleAdvanced {

    constructor(address configurationContract) PaymentProcessorModuleAdvanced(configurationContract){}

    /**
     * @notice Executes a buy listing transaction for a single order item.
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
     * @dev    Throws when the taker does not have or did not send sufficient funds to complete the purchase.
     * @dev    Throws when the token transfer fails for any reason such as lack of approvals or token no longer owned by maker.
     * @dev    Throws when the maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Any unused native token payment will be returned to the taker as wrapped native token.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Maker's nonce is marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Maker's partially fillable order state is updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. An `BuyListingERC721` event has been emitted for a ERC721 purchase.
     * @dev    6. An `BuyListingERC1155` event has been emitted for a ERC1155 purchase.
     * @dev    7. A `NonceInvalidated` event has been emitted for a ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for a ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  saleDetails     The order execution details.
     * @param  sellerSignature The maker's signature authorizing the order execution.
     * @param  cosignature     The additional cosignature for a cosigned order, if applicable.
     * @param  feeOnTop        The additional fee to add on top of the order, paid by taker.
     */
    function buyListing(
        Order memory saleDetails, 
        SignatureECDSA memory sellerSignature,
        Cosignature memory cosignature,
        FeeOnTop calldata feeOnTop
    ) public payable {
        uint256 appendedDataLength;
        unchecked {
            appendedDataLength = msg.data.length - BASE_MSG_LENGTH_BUY_LISTING;
        }

        TradeContext memory context = TradeContext({
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
        });

        uint256 remainingNativeProceeds = 
            _executeOrderBuySide(
                context,
                msg.value,
                saleDetails, 
                sellerSignature,
                cosignature,
                feeOnTop
            );

        _refundUnspentNativeFunds(remainingNativeProceeds, context.taker);
    }

    /**
     * @notice Executes an advanced buy listing transaction for a single order item.
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
     * @dev    Throws when the taker does not have or did not send sufficient funds to complete the purchase.
     * @dev    Throws when the token transfer fails for any reason such as lack of approvals or token no longer owned by maker.
     * @dev    Throws when the maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Any unused native token payment will be returned to the taker as wrapped native token.
     * @dev    Throws when the provided bulk order merkle proof and order index are invalid.
     * @dev    Throws when the provided permit processor does not have approval to move the token or receives an invalid signature.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Maker's nonce is marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Maker's partially fillable order state is updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. An `BuyListingERC721` event has been emitted for a ERC721 purchase.
     * @dev    6. An `BuyListingERC1155` event has been emitted for a ERC1155 purchase.
     * @dev    7. A `NonceInvalidated` event has been emitted for a ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for a ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  advancedListing  The cosigner, maker, and taker signatures, order details and permit details.
     * @param  bulkOrderProof   The merkle proofs and order index for an offer that was created via signing a merkle tree.
     * @param  feeOnTop         The additional fee to add on top of the order, paid by taker.
     */
    function buyListingAdvanced(
        AdvancedOrder memory advancedListing,
        BulkOrderProof calldata bulkOrderProof,
        FeeOnTop calldata feeOnTop
    ) public payable {
        uint256 appendedDataLength;
        unchecked {
            appendedDataLength = 
                msg.data.length - 
                BASE_MSG_LENGTH_BUY_LISTING_ADVANCED -
                (PROOF_ELEMENT_SIZE * bulkOrderProof.proof.length);
        }

        TradeContext memory context = TradeContext({
            channel: msg.sender,
            taker: _getTaker(appendedDataLength),
            disablePartialFill: true,
            orderDigest: bytes32(0),
            backfillNumerator: uint16(0),
            backfillReceiver: address(0),
            bountyNumerator: uint16(0),
            exclusiveMarketplace: address(0),
            useRoyaltyBackfillAsRoyaltySource: false,
            protocolFeeVersion: advancedListing.saleDetails.protocolFeeVersion,
            protocolFees: appStorage().protocolFeeVersions[advancedListing.saleDetails.protocolFeeVersion]
        });

        uint256 remainingNativeProceeds = 
            _executeOrderBuySideAdvanced(
                context,
                msg.value,
                advancedListing,
                bulkOrderProof,
                feeOnTop
            );

        _refundUnspentNativeFunds(remainingNativeProceeds, context.taker);
    }

    /**
     * @notice Executes a buy listing transaction for multiple order items.
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
     * @dev    Throws when the taker does not have or did not send sufficient funds to complete the purchase.
     * @dev    Throws when a maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Will NOT throw when a token fails to transfer but also will not disperse payments for failed items.
     * @dev    Any unused native token payment will be returned to the taker as wrapped native token.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Makers nonces are marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Makers partially fillable order states are updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. `BuyListingERC721` events have been emitted for each ERC721 purchase.
     * @dev    6. `BuyListingERC1155` events have been emitted for each ERC1155 purchase.
     * @dev    7. A `NonceInvalidated` event has been emitted for each ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for each ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  saleDetailsArray An array of order execution details.
     * @param  sellerSignatures An array of maker signatures authorizing the order execution.
     * @param  cosignatures     An array of additional cosignatures for cosigned orders, if applicable.
     * @param  feesOnTop        An array of additional fees to add on top of the orders, paid by taker.
     */
    function bulkBuyListings(
        Order[] calldata saleDetailsArray,
        SignatureECDSA[] calldata sellerSignatures,
        Cosignature[] calldata cosignatures,
        FeeOnTop[] calldata feesOnTop
    ) public payable {
        if (saleDetailsArray.length != sellerSignatures.length) {
            revert PaymentProcessor__InputArrayLengthMismatch();
        }

        if (saleDetailsArray.length != cosignatures.length) {
            revert PaymentProcessor__InputArrayLengthMismatch();
        }

        if (saleDetailsArray.length != feesOnTop.length) {
            revert PaymentProcessor__InputArrayLengthMismatch();
        }

        if (saleDetailsArray.length == 0) {
            revert PaymentProcessor__InputArrayLengthCannotBeZero();
        }

        uint256 appendedDataLength;
        unchecked {
            appendedDataLength = 
                msg.data.length - 
                BASE_MSG_LENGTH_BULK_BUY_LISTINGS - 
                (BASE_MSG_LENGTH_BULK_BUY_LISTINGS_PER_ITEM * saleDetailsArray.length);
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
            protocolFeeVersion: saleDetailsArray[0].protocolFeeVersion,
            protocolFees: appStorage().protocolFeeVersions[saleDetailsArray[0].protocolFeeVersion]
        });

        uint256 remainingNativeProceeds = msg.value;

        Order memory saleDetails;
        SignatureECDSA memory sellerSignature;
        Cosignature memory cosignature;
        FeeOnTop calldata feeOnTop;

        for (uint256 i = 0; i < saleDetailsArray.length;) {
            saleDetails = saleDetailsArray[i];
            sellerSignature = sellerSignatures[i];
            cosignature = cosignatures[i];
            feeOnTop = feesOnTop[i];

            if (context.protocolFeeVersion != saleDetails.protocolFeeVersion) {
                context.protocolFeeVersion = saleDetails.protocolFeeVersion;
                context.protocolFees = appStorage().protocolFeeVersions[saleDetails.protocolFeeVersion];
            }

            remainingNativeProceeds = 
                _executeOrderBuySide(
                    context, 
                    remainingNativeProceeds, 
                    saleDetails, 
                    sellerSignature, 
                    cosignature, 
                    feeOnTop);

            unchecked {
                ++i;
            }
        }

        _refundUnspentNativeFunds(remainingNativeProceeds, context.taker);
    }

    /**
     * @notice Executes an advanced buy listing transaction for multiple order items.
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
     * @dev    Throws when the taker does not have or did not send sufficient funds to complete the purchase.
     * @dev    Throws when a maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Throws when any provided bulk order merkle proof and order index are invalid.
     * @dev    Throws when any provided permit processor does not have approval to move the token or receives an invalid signature.
     * @dev    Will NOT throw when a token fails to transfer but also will not disperse payments for failed items.
     * @dev    Any unused native token payment will be returned to the taker as wrapped native token.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Makers nonces are marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Makers partially fillable order states are updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. `BuyListingERC721` events have been emitted for each ERC721 purchase.
     * @dev    6. `BuyListingERC1155` events have been emitted for each ERC1155 purchase.
     * @dev    7. A `NonceInvalidated` event has been emitted for each ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for each ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  advancedListingsArray  An array of cosigner, maker, and taker signatures, order details and permit details.
     * @param  bulkOrderProofs        The merkle proofs and order index for an offer that was created via signing a merkle tree.
     * @param  feesOnTop              An array of additional fees to add on top of the orders, paid by taker.
     */
    function bulkBuyListingsAdvanced( 
        AdvancedOrder[] calldata advancedListingsArray,
        BulkOrderProof[] calldata bulkOrderProofs,
        FeeOnTop[] calldata feesOnTop
    ) public payable {
        if (advancedListingsArray.length == 0) {
            revert PaymentProcessor__InputArrayLengthCannotBeZero();
        }

        if (advancedListingsArray.length != feesOnTop.length) {
            revert PaymentProcessor__InputArrayLengthMismatch();
        }

        if (advancedListingsArray.length != bulkOrderProofs.length) {
            revert PaymentProcessor__InputArrayLengthMismatch();
        }

        uint256 remainingNativeProceeds = msg.value;

        uint256 appendedDataLength;
        unchecked {
            appendedDataLength = 
                msg.data.length - 
                BASE_MSG_LENGTH_BULK_BUY_LISTINGS_ADVANCED - 
                (BASE_MSG_LENGTH_BULK_BUY_LISTINGS_ADVANCED_PER_ITEM * advancedListingsArray.length);

            for (uint256 i = 0; i < advancedListingsArray.length; ++i) {
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
            protocolFeeVersion: advancedListingsArray[0].saleDetails.protocolFeeVersion,
            protocolFees: appStorage().protocolFeeVersions[advancedListingsArray[0].saleDetails.protocolFeeVersion]
        });

        AdvancedOrder memory advancedListing;

        for (uint256 i = 0; i < advancedListingsArray.length;) {
            advancedListing = advancedListingsArray[i];
            if (context.protocolFeeVersion != advancedListing.saleDetails.protocolFeeVersion) {
                context.protocolFeeVersion = advancedListing.saleDetails.protocolFeeVersion;
                context.protocolFees = appStorage().protocolFeeVersions[advancedListing.saleDetails.protocolFeeVersion];
            }

            remainingNativeProceeds = 
                _executeOrderBuySideAdvanced(
                    context, 
                    remainingNativeProceeds, 
                    advancedListing,
                    bulkOrderProofs[i],
                    feesOnTop[i]);

            unchecked {
                ++i;
            }
        }

        _refundUnspentNativeFunds(remainingNativeProceeds, context.taker);
    }
}
