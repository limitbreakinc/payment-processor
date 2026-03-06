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
 
* @title ModuleSweeps
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 

contract ModuleSweeps is PaymentProcessorModuleAdvanced {

    constructor(address configurationContract) PaymentProcessorModuleAdvanced(configurationContract){}

    /**
     * @notice Executes a sweep transaction for buying multiple items from the same collection.
     *
     * @dev    Throws when the sweep order protocol is ERC1155_PARTIAL_FILL (unsupported).
     * @dev    Throws when a maker's nonce has already been used or has been cancelled.
     * @dev    Throws when any order has expired.
     * @dev    Throws when any combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when the taker fee on top exceeds 100% of the combined item sale prices.
     * @dev    Throws when a maker's master nonce does not match the order details.
     * @dev    Throws when an order does not comply with the collection payment settings.
     * @dev    Throws when a maker's signature is invalid.
     * @dev    Throws when an order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when the taker does not have or did not send sufficient funds to complete the purchase.
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
     *
     * @param  feeOnTop         The additional fee to add on top of the orders, paid by taker.
     * @param  sweepOrder       The order information that is common to all items in the sweep.
     * @param  items            An array of items that contains the order information unique to each item.
     * @param  signedSellOrders An array of maker signatures authorizing the order execution.
     * @param  cosignatures     An array of additional cosignatures for cosigned orders, if applicable.
     */
    function sweepCollection(
        FeeOnTop calldata feeOnTop,
        SweepOrder calldata sweepOrder,
        SweepItem[] calldata items,
        SignatureECDSA[] calldata signedSellOrders,
        Cosignature[] calldata cosignatures
    ) public payable {
        uint256 appendedDataLength;
        unchecked {
            appendedDataLength = 
                msg.data.length - 
                BASE_MSG_LENGTH_SWEEP_COLLECTION - 
                (BASE_MSG_LENGTH_SWEEP_COLLECTION_PER_ITEM * items.length);
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
            protocolFeeVersion: type(uint256).max,
            protocolFees: ProtocolFees({
                protocolFeeReceiver: address(0),
                minimumProtocolFeeBps: 0,
                marketplaceFeeProtocolTaxBps: 0,
                feeOnTopProtocolTaxBps: 0,
                versionExpiration: 0
            })
        });

        uint256 remainingNativeProceeds =_executeSweepOrder(
            context,
            msg.value,
            feeOnTop,
            sweepOrder,
            items,
            signedSellOrders,
            cosignatures
        );

        _refundUnspentNativeFunds(remainingNativeProceeds, context.taker);
    }

    /**
     * @notice Executes an advanced sweep transaction for buying multiple items from the same collection.
     *
     * @dev    Throws when the sweep order protocol is ERC1155_PARTIAL_FILL (unsupported).
     * @dev    Throws when a maker's nonce has already been used or has been cancelled.
     * @dev    Throws when any order has expired.
     * @dev    Throws when any combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when the taker fee on top exceeds 100% of the combined item sale prices.
     * @dev    Throws when a maker's master nonce does not match the order details.
     * @dev    Throws when an order does not comply with the collection payment settings.
     * @dev    Throws when a maker's signature is invalid.
     * @dev    Throws when an order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when the taker does not have or did not send sufficient funds to complete the purchase.
     * @dev    Throws when the provided bulk order merkle proof and order index are invalid.
     * @dev    Throws when the provided permit processor does not have approval to move the token or receives an invalid signature.
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
     *
     * @param  advancedSweep  The cosigner, maker, and taker signatures, order details and permit details.
     */
    function sweepCollectionAdvanced(
        AdvancedSweep calldata advancedSweep
    ) public payable {
        uint256 appendedDataLength;
        unchecked {
            appendedDataLength = 
                msg.data.length - 
                BASE_MSG_LENGTH_SWEEP_COLLECTION_ADVANCED - 
                (BASE_MSG_LENGTH_SWEEP_COLLECTION_ADVANCED_PER_ITEM * advancedSweep.items.length);

            for (uint256 i = 0; i < advancedSweep.items.length; ++i) {
                appendedDataLength -= PROOF_ELEMENT_SIZE * advancedSweep.items[i].bulkOrderProof.proof.length;
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
            protocolFeeVersion: type(uint256).max,
            protocolFees: ProtocolFees({
                protocolFeeReceiver: address(0),
                minimumProtocolFeeBps: 0,
                marketplaceFeeProtocolTaxBps: 0,
                feeOnTopProtocolTaxBps: 0,
                versionExpiration: 0
            })
        });

        uint256 remainingNativeProceeds =_executeSweepOrderAdvanced(
            context,
            msg.value,
            advancedSweep
        );

        _refundUnspentNativeFunds(remainingNativeProceeds, context.taker);
    }
}
