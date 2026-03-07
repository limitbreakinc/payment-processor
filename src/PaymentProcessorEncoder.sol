//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "@limitbreak/tm-core-lib/src/licenses/LicenseRef-PolyForm-Strict-1.0.0.sol";
import "./DataTypes.sol";

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
 
* @title Payment Processor
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 

import "./modules/ModuleAcceptOffers.sol";
import "./modules/ModuleBuyListings.sol";
import "./modules/ModuleSweeps.sol";
import "./modules/ModuleOnChainCancellation.sol";

contract PaymentProcessorEncoder {

    /**************************************************************/
    /*              ON-CHAIN CANCELLATION OPERATIONS              */
    /**************************************************************/

    /**
     * @notice Helper function to encode transaction calldata in the format required for a `destroyCosigner` call.
     *
     * @dev    Encoding parameters into a bytes array is performed for gas optimization in Payment Processor.
     * @dev    Payment Processor is separated into multiple module contracts due to contract size limitations.
     * @dev    Calls to the Payment Processor contract are passed along to the corresponding module through a delegate call.
     * @dev    *Note:* This encoding function should **not** be called on-chain as part of a transaction. It is meant to
     * @dev    be called off-chain to prepare the transaction data for a call to Payment Processor.
     *
     * @param  cosigner   The address of the cosigner to destroy.
     * @param  signature  The signature of the cosigner to destroy.
     */
    function encodeDestroyCosignerCalldata(
        address /*paymentProcessorAddress*/, 
        address cosigner,
        SignatureECDSA memory signature
    ) external view returns (bytes memory) {
        return _removeFirst4Bytes(
            abi.encodeWithSelector(
                ModuleOnChainCancellation.destroyCosigner.selector,
                cosigner,
                signature));
    }

    /**
     * @notice Helper function to encode transaction calldata in the format required for a `revokeSingleNonce` call.
     *
     * @dev    Encoding parameters into a bytes array is performed for gas optimization in Payment Processor.
     * @dev    Payment Processor is separated into multiple module contracts due to contract size limitations.
     * @dev    Calls to the Payment Processor contract are passed along to the corresponding module through a delegate call.
     * @dev    *Note:* This encoding function should **not** be called on-chain as part of a transaction. It is meant to
     * @dev    be called off-chain to prepare the transaction data for a call to Payment Processor.
     *
     * @param  nonce The nonce that was signed in the revoked listing or offer.
     */
    function encodeRevokeSingleNonceCalldata(address /*paymentProcessorAddress*/, uint256 nonce) external view returns (bytes memory) {
        return _removeFirst4Bytes(
            abi.encodeWithSelector(
                ModuleOnChainCancellation.revokeSingleNonce.selector,
                nonce));
    }

    /**
     * @notice Helper function to encode transaction calldata in the format required for a `revokeOrderDigest` call.
     *
     * @dev    Encoding parameters into a bytes array is performed for gas optimization in Payment Processor.
     * @dev    Payment Processor is separated into multiple module contracts due to contract size limitations.
     * @dev    Calls to the Payment Processor contract are passed along to the corresponding module through a delegate call.
     * @dev    *Note:* This encoding function should **not** be called on-chain as part of a transaction. It is meant to
     * @dev    be called off-chain to prepare the transaction data for a call to Payment Processor.
     *
     * @param  digest The order digest that was signed in the revoked listing or offer.
     */
    function encodeRevokeOrderDigestCalldata(address /*paymentProcessorAddress*/, bytes32 digest) external view returns (bytes memory) {
        return _removeFirst4Bytes(
            abi.encodeWithSelector(
                ModuleOnChainCancellation.revokeOrderDigest.selector,
                digest));
    }

    /**************************************************************/
    /*                     TRADING OPERATIONS                     */
    /**************************************************************/

    /**
     * @notice Helper function to encode transaction calldata in the format required for a `buyListing` call.
     *
     * @dev    Encoding parameters into a bytes array is performed for gas optimization in Payment Processor.
     * @dev    Payment Processor is separated into multiple module contracts due to contract size limitations.
     * @dev    Calls to the Payment Processor contract are passed along to the corresponding module through a delegate call.
     * @dev    *Note:* This encoding function should **not** be called on-chain as part of a transaction. It is meant to
     * @dev    be called off-chain to prepare the transaction data for a call to Payment Processor.
     *
     * @param  saleDetails              The order execution details.
     * @param  signature                The maker's signature authorizing the order execution.
     * @param  cosignature              The additional cosignature for a cosigned order, if applicable.
     * @param  feeOnTop                 The additional fee to add on top of the order, paid by taker.
     */
    function encodeBuyListingCalldata(
        address /*paymentProcessorAddress*/, 
        Order memory saleDetails, 
        SignatureECDSA memory signature,
        Cosignature memory cosignature,
        FeeOnTop memory feeOnTop
    ) external view returns (bytes memory) {
        return _removeFirst4Bytes(
            abi.encodeWithSelector(
                ModuleBuyListings.buyListing.selector,
                saleDetails,
                signature,
                cosignature,
                feeOnTop));
    }

    /**
     * @notice Helper function to encode transaction calldata in the format required for a `acceptOffer` call.
     *
     * @dev    Encoding parameters into a bytes array is performed for gas optimization in Payment Processor.
     * @dev    Payment Processor is separated into multiple module contracts due to contract size limitations.
     * @dev    Calls to the Payment Processor contract are passed along to the corresponding module through a delegate call.
     * @dev    *Note:* This encoding function should **not** be called on-chain as part of a transaction. It is meant to
     * @dev    be called off-chain to prepare the transaction data for a call to Payment Processor.
     *
     * @param  offerType      The type of offer to execute.
     * @param  saleDetails    The order execution details.
     * @param  signature      The maker's signature authorizing the order execution.
     * @param  tokenSetProof  The root hash and merkle proofs for an offer that is a subset of tokens in a collection.
     * @param  cosignature    The additional cosignature for a cosigned order, if applicable.
     * @param  feeOnTop       The additional fee to add on top of the order, paid by taker.
     */
    function encodeAcceptOfferCalldata(
        address /*paymentProcessorAddress*/, 
        uint256 offerType,
        Order memory saleDetails, 
        SignatureECDSA memory signature,
        TokenSetProof memory tokenSetProof,
        Cosignature memory cosignature,
        FeeOnTop memory feeOnTop
    ) external view returns (bytes memory) {
        return _removeFirst4Bytes(
            abi.encodeWithSelector(
                ModuleAcceptOffers.acceptOffer.selector,
                offerType,
                saleDetails,
                signature,
                tokenSetProof,
                cosignature,
                feeOnTop));
    }

    /**
     * @notice Helper function to encode transaction calldata in the format required for a `bulkBuyListings` call.
     *
     * @dev    Encoding parameters into a bytes array is performed for gas optimization in Payment Processor.
     * @dev    Payment Processor is separated into multiple module contracts due to contract size limitations.
     * @dev    Calls to the Payment Processor contract are passed along to the corresponding module through a delegate call.
     * @dev    *Note:* This encoding function should **not** be called on-chain as part of a transaction. It is meant to
     * @dev    be called off-chain to prepare the transaction data for a call to Payment Processor.
     *
     * @param  saleDetailsArray         An array of order execution details.
     * @param  signatures               An array of maker signatures authorizing the order execution.
     * @param  cosignatures             An array of additional cosignatures for cosigned orders, if applicable.
     * @param  feesOnTop                An array of additional fees to add on top of the orders, paid by taker.
     */
    function encodeBulkBuyListingsCalldata(
        address /*paymentProcessorAddress*/, 
        Order[] calldata saleDetailsArray, 
        SignatureECDSA[] calldata signatures,
        Cosignature[] calldata cosignatures,
        FeeOnTop[] calldata feesOnTop
    ) external view returns (bytes memory) {
        return _removeFirst4Bytes(
            abi.encodeWithSelector(
                ModuleBuyListings.bulkBuyListings.selector,
                saleDetailsArray,
                signatures,
                cosignatures,
                feesOnTop));
    }

    /**
     * @notice Helper function to encode transaction calldata in the format required for a `bulkAcceptOffers` call.
     *
     * @dev    Encoding parameters into a bytes array is performed for gas optimization in Payment Processor.
     * @dev    Payment Processor is separated into multiple module contracts due to contract size limitations.
     * @dev    Calls to the Payment Processor contract are passed along to the corresponding module through a delegate call.
     * @dev    *Note:* This encoding function should **not** be called on-chain as part of a transaction. It is meant to
     * @dev    be called off-chain to prepare the transaction data for a call to Payment Processor.
     *
     * @param  offerTypeArray       An array of offer types to execute.
     * @param  saleDetailsArray     An array of order execution details.
     * @param  signatures           An array of maker signatures authorizing the order executions.
     * @param  tokenSetProofsArray  An array of root hashes and merkle proofs for offers that are a subset of tokens in a collection.
     * @param  cosignaturesArray    An array of additional cosignatures for cosigned orders, as applicable.
     * @param  feesOnTopArray       An array of additional fees to add on top of the orders, paid by taker.
     */
    function encodeBulkAcceptOffersCalldata(
        address /*paymentProcessorAddress*/, 
        uint256[] memory offerTypeArray,
        Order[] memory saleDetailsArray,
        SignatureECDSA[] memory signatures,
        TokenSetProof[] memory tokenSetProofsArray,
        Cosignature[] memory cosignaturesArray,
        FeeOnTop[] memory feesOnTopArray
    ) external view returns (bytes memory) {
        BulkAcceptOffersParams[] memory params = new BulkAcceptOffersParams[](offerTypeArray.length);
        
        for (uint256 i; i < offerTypeArray.length; ++i) {
            params[i].offerType = offerTypeArray[i];
            params[i].saleDetails = saleDetailsArray[i];
            params[i].signature = signatures[i];
            params[i].cosignature = cosignaturesArray[i];
        }

        return _removeFirst4Bytes(
            abi.encodeWithSelector(
                ModuleAcceptOffers.bulkAcceptOffers.selector,
                params,
                feesOnTopArray,
                tokenSetProofsArray));
    }

    /**
     * @notice Helper function to encode transaction calldata in the format required for a `sweepCollection` call.
     *
     * @dev    Encoding parameters into a bytes array is performed for gas optimization in Payment Processor.
     * @dev    Payment Processor is separated into multiple module contracts due to contract size limitations.
     * @dev    Calls to the Payment Processor contract are passed along to the corresponding module through a delegate call.
     * @dev    *Note:* This encoding function should **not** be called on-chain as part of a transaction. It is meant to
     * @dev    be called off-chain to prepare the transaction data for a call to Payment Processor.
     *
     * @param  feeOnTop                 An array of additional fees to add on top of the orders, paid by taker.
     * @param  sweepOrder               The order information that is common to all items in the sweep.
     * @param  items                    An array of items that contains the order information unique to each item.
     * @param  signatures               An array of maker signatures authorizing the order execution.
     * @param  cosignatures             An array of additional cosignatures for cosigned orders, if applicable.
     */
    function encodeSweepCollectionCalldata(
        address /*paymentProcessorAddress*/, 
        FeeOnTop memory feeOnTop,
        SweepOrder memory sweepOrder,
        SweepItem[] calldata items,
        SignatureECDSA[] calldata signatures,
        Cosignature[] calldata cosignatures
    ) external view returns (bytes memory) {
        return _removeFirst4Bytes(
            abi.encodeWithSelector(
                ModuleSweeps.sweepCollection.selector,
                feeOnTop,
                sweepOrder,
                items,
                signatures,
                cosignatures));
    }

    /**
     * @notice Helper function to encode transaction calldata in the format required for a `buyListingAdvanced` call.
     *
     * @dev    Encoding parameters into a bytes array is performed for gas optimization in Payment Processor.
     * @dev    Payment Processor is separated into multiple module contracts due to contract size limitations.
     * @dev    Calls to the Payment Processor contract are passed along to the corresponding module through a delegate call.
     * @dev    *Note:* This encoding function should **not** be called on-chain as part of a transaction. It is meant to
     * @dev    be called off-chain to prepare the transaction data for a call to Payment Processor.
     *
     * @param  advancedListing  The advanced listing order details.
     * @param  bulkOrderProof   The merkle proofs and order index for the bulk order.
     * @param  feeOnTop         The additional fee to add on top of the order, paid by taker.
     */
    function encodeBuyListingAdvancedCalldata(
        address /*paymentProcessorAddress*/, 
        AdvancedOrder memory advancedListing,
        BulkOrderProof memory bulkOrderProof,
        FeeOnTop memory feeOnTop
    ) external view returns (bytes memory) {
        return _removeFirst4Bytes(
            abi.encodeWithSelector(
                ModuleBuyListings.buyListingAdvanced.selector,
                advancedListing,
                bulkOrderProof,
                feeOnTop));
    }

    /**
     * @notice Helper function to encode transaction calldata in the format required for a `acceptOfferAdvanced` call.
     *
     * @dev    Encoding parameters into a bytes array is performed for gas optimization in Payment Processor.
     * @dev    Payment Processor is separated into multiple module contracts due to contract size limitations.
     * @dev    Calls to the Payment Processor contract are passed along to the corresponding module through a delegate call.
     * @dev    *Note:* This encoding function should **not** be called on-chain as part of a transaction. It is meant to
     * @dev    be called off-chain to prepare the transaction data for a call to Payment Processor.
     *
     * @param  advancedBid     The advanced bid order details.
     * @param  bulkOrderProof  The merkle proofs and order index for the bulk order.
     * @param  feeOnTop        The additional fee to add on top of the order, paid by taker.
     * @param  tokenSetProof   The root hash and merkle proofs for an offer that is a subset of tokens in a collection.
     */
    function encodeAcceptOfferAdvancedCalldata(
        address /*paymentProcessorAddress*/, 
        AdvancedBidOrder memory advancedBid,
        BulkOrderProof memory bulkOrderProof,
        FeeOnTop memory feeOnTop,
        TokenSetProof memory tokenSetProof
    ) external view returns (bytes memory) {
        return _removeFirst4Bytes(
            abi.encodeWithSelector(
                ModuleAcceptOffers.acceptOfferAdvanced.selector,
                advancedBid,
                bulkOrderProof,
                feeOnTop,
                tokenSetProof));
    }
    /**
     * @notice Helper function to encode transaction calldata in the format required for a `bulkBuyListingsAdvanced` call.
     *
     * @dev    Encoding parameters into a bytes array is performed for gas optimization in Payment Processor.
     * @dev    Payment Processor is separated into multiple module contracts due to contract size limitations.
     * @dev    Calls to the Payment Processor contract are passed along to the corresponding module through a delegate call.
     * @dev    *Note:* This encoding function should **not** be called on-chain as part of a transaction. It is meant to
     * @dev    be called off-chain to prepare the transaction data for a call to Payment Processor.
     *
     * @param  advancedListingsArray  An array of advanced listing order details.
     * @param  bulkOrderProofs        An array of merkle proofs and order indexes for the bulk orders.
     * @param  feesOnTop              An array of additional fees to add on top of the orders, paid by taker.
     */
    function encodeBulkBuyListingsAdvancedCalldata(
        address /*paymentProcessorAddress*/, 
        AdvancedOrder[] memory advancedListingsArray,
        BulkOrderProof[] memory bulkOrderProofs,
        FeeOnTop[] memory feesOnTop
    ) external view returns (bytes memory) {
        return _removeFirst4Bytes(
            abi.encodeWithSelector(
                ModuleBuyListings.bulkBuyListingsAdvanced.selector,
                advancedListingsArray,
                bulkOrderProofs,
                feesOnTop));
    }

    /**
     * @notice Helper function to encode transaction calldata in the format required for a `bulkAcceptOffersAdvanced` call.
     *
     * @dev    Encoding parameters into a bytes array is performed for gas optimization in Payment Processor.
     * @dev    Payment Processor is separated into multiple module contracts due to contract size limitations.
     * @dev    Calls to the Payment Processor contract are passed along to the corresponding module through a delegate call.
     * @dev    *Note:* This encoding function should **not** be called on-chain as part of a transaction. It is meant to
     * @dev    be called off-chain to prepare the transaction data for a call to Payment Processor.
     *
     * @param  advancedBidsArray  An array of advanced bid order details.
     * @param  bulkOrderProofs    An array of merkle proofs and order indexes for the bulk orders.
     * @param  feesOnTop          An array of additional fees to add on top of the orders, paid by taker.
     * @param  tokenSetProofs     An array of root hashes and merkle proofs for offers that are a subset of tokens in a collection.
     */
    function encodeBulkAcceptOffersAdvancedCalldata(
        address /*paymentProcessorAddress*/, 
        AdvancedBidOrder[] memory advancedBidsArray,
        BulkOrderProof[] memory bulkOrderProofs,
        FeeOnTop[] memory feesOnTop,
        TokenSetProof[] memory tokenSetProofs
    ) external view returns (bytes memory) {
        return _removeFirst4Bytes(
            abi.encodeWithSelector(
                ModuleAcceptOffers.bulkAcceptOffersAdvanced.selector,
                advancedBidsArray,
                bulkOrderProofs,
                feesOnTop,
                tokenSetProofs));
    }

    /**
     * @notice Helper function to encode transaction calldata in the format required for a `sweepCollectionAdvanced` call.
     *
     * @dev    Encoding parameters into a bytes array is performed for gas optimization in Payment Processor.
     * @dev    Payment Processor is separated into multiple module contracts due to contract size limitations.
     * @dev    Calls to the Payment Processor contract are passed along to the corresponding module through a delegate call.
     * @dev    *Note:* This encoding function should **not** be called on-chain as part of a transaction. It is meant to
     * @dev    be called off-chain to prepare the transaction data for a call to Payment Processor.
     *
     * @param  advancedSweep The advanced sweep order details.
     */
    function encodeSweepCollectionAdvancedCalldata(
        address /*paymentProcessorAddress*/, 
        AdvancedSweep memory advancedSweep
    ) external view returns (bytes memory) {
        return _removeFirst4Bytes(
            abi.encodeWithSelector(
                ModuleSweeps.sweepCollectionAdvanced.selector,
                advancedSweep));
    }

    /**************************************************************/
    /*                      HELPER FUNCTIONS                      */
    /**************************************************************/

    /**
    * @notice Helper function to remove the first 4 bytes of a bytes array.
    *
    * @dev    This function is used to remove the function selector from the provided calldata.
    * @dev    Removing the function selector is necessary to prepare the calldata for a delegate call to Payment Processor.
    */
    function _removeFirst4Bytes(bytes memory data) private view returns (bytes memory result) {
        assembly {
            if lt(mload(data), 0x04) {
                revert(0,0)
            }
            mstore(result, sub(mload(data), 0x04))
            if iszero(staticcall(gas(), 0x04, add(data, 0x24), mload(result), add(result, 0x20), mload(result))){
              revert(0,0)
            }
        }
    }
}
