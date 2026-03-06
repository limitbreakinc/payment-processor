//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "./PaymentProcessorModulePermits.sol";

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
 
* @title PaymentProcessorModuleAdvanced
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 

abstract contract PaymentProcessorModuleAdvanced is PaymentProcessorModulePermits {
    using EnumerableSet for EnumerableSet.AddressSet;

    constructor(address configurationContract) PaymentProcessorModulePermits(configurationContract) {}

    /*************************************************************************/
    /*                            Order Execution                            */
    /*************************************************************************/

    /**
     * @notice Executes an advanced buy side order. An advanced order includes an optional permit context and optional bulk order proof.
     *
     * @dev    Throws when the permit processor is not trusted.
     * @dev    Throws when the permit processor is provided and the maker created the order by signing a merkle tree root.
     *
     * @param tradeContext         The execution context of the trade.
     * @param startingNativeFunds  The starting native funds.
     * @param advancedListing      Order details including the permit context, signatures and sale details.
     * @param bulkOrderProof       Optional bulk order proof.
     * @param feeOnTop             The additional fee to add on top of the orders, paid by taker.
     */
    function _executeOrderBuySideAdvanced(
        TradeContext memory tradeContext,
        uint256 startingNativeFunds,
        AdvancedOrder memory advancedListing,
        BulkOrderProof calldata bulkOrderProof,
        FeeOnTop calldata feeOnTop
    ) internal returns (uint256 endingNativeFunds) {
        if (advancedListing.permitContext.permitProcessor == address(0)) {
            if (bulkOrderProof.proof.length == 0) {
                endingNativeFunds = _executeOrderBuySide(
                    tradeContext,
                    startingNativeFunds,
                    advancedListing.saleDetails,
                    advancedListing.signature,
                    advancedListing.cosignature,
                    feeOnTop);
            } else {
                endingNativeFunds = _executeOrderBuySideBulk(
                    tradeContext,
                    startingNativeFunds,
                    advancedListing,
                    bulkOrderProof,
                    feeOnTop);
            }
        } else {
            if (bulkOrderProof.proof.length == 0) {
                if (!_isTrustedPermitProcessor(advancedListing.permitContext.permitProcessor)) {
                    revert PaymentProcessor__PermitProcessorNotTrusted();
                }
                advancedListing.saleDetails.itemPrice = uint240(advancedListing.saleDetails.itemPrice);
    
                endingNativeFunds = _validateAndFulfillSinglePermittedOrder(
                    startingNativeFunds,
                    Sides.Buy,
                    advancedListing,
                    tradeContext,
                    feeOnTop);
            } else {
                revert PaymentProcessor__PermitsAreNotCompatibleWithBulkOrders();
            }
        }
    }

    /**
     * @notice Verifies the proof and signature of an order that was generated by a signed merkle tree root
     * @notice and executes the order.
     *
     * @dev    Throws when the order type is ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL and the remaining fillable 
     * @dev    amount is less than the minimum fillable amount requested.
     * @dev    Throws when the order status is not open.
     * @dev    Throws when the nonce has already been invalidated.
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the maker's signature is invalid.
     *
     * @param tradeContext         The execution context of the trade.
     * @param startingNativeFunds  The starting native funds.
     * @param advancedListing      Order details including the permit context, signatures and sale details.
     * @param bulkOrderProof       The bulk order proof and order index.
     * @param feeOnTop             The additional fee to add on top of the orders, paid by taker. 
     */
    function _executeOrderBuySideBulk(
        TradeContext memory tradeContext,
        uint256 startingNativeFunds,
        AdvancedOrder memory advancedListing,
        BulkOrderProof calldata bulkOrderProof,
        FeeOnTop calldata feeOnTop
    ) internal returns (uint256 endingNativeFunds) {
        Order memory saleDetails = advancedListing.saleDetails;
        saleDetails.itemPrice = uint240(saleDetails.itemPrice);

        uint256 quantityToFill = _verifyBulkSaleApprovalProofAndSignedTree(
                tradeContext,
                saleDetails,
                advancedListing.signature,
                advancedListing.cosignature,
                bulkOrderProof);

        endingNativeFunds = 
            _validateAndFulfillOrder(
                Sides.Buy, 
                tradeContext, 
                startingNativeFunds, 
                quantityToFill, 
                saleDetails, 
                feeOnTop);
    }

    /**
     * @notice Executes an advanced sell side order. An advanced order includes an optional permit context and optional bulk order proof.
     *
     * @dev    Throws when the permit processor is provided and is not trusted.
     * @dev    Throws when the permit processor is provided and the maker created the order by signing a merkle tree root.
     * @dev    Throws when the permit processor is set and the order is paid with the native token.
     * 
     * @param tradeContext         The execution context of the trade.
     * @param advancedBid          Order details including the permit context, signatures and sale details.
     * @param bulkOrderProof       Optional bulk order proof.
     * @param feeOnTop             The additional fee to add on top of the orders, paid by taker.
     */
    function _executeOrderSellSideAdvanced(
        TradeContext memory tradeContext,
        AdvancedBidOrder memory advancedBid,
        BulkOrderProof calldata bulkOrderProof,
        FeeOnTop calldata feeOnTop,
        TokenSetProof calldata tokenSetProof
    ) internal {
        if (advancedBid.advancedOrder.permitContext.permitProcessor == address(0)) {
            if (bulkOrderProof.proof.length == 0) { 
                _executeOrderSellSide(
                    tradeContext,
                    advancedBid.offerType,
                    advancedBid.advancedOrder.saleDetails,
                    advancedBid.advancedOrder.signature,
                    tokenSetProof,
                    advancedBid.advancedOrder.cosignature,
                    feeOnTop);
            } else {
                _executeOrderSellSideBulk(
                    tradeContext,
                    advancedBid,
                    bulkOrderProof,
                    feeOnTop,
                    tokenSetProof);
            }
        } else {
            if (bulkOrderProof.proof.length == 0) { 
                if (!_isTrustedPermitProcessor(advancedBid.advancedOrder.permitContext.permitProcessor)) {
                    revert PaymentProcessor__PermitProcessorNotTrusted();
                }
        
                if (advancedBid.advancedOrder.saleDetails.paymentMethod == address(0)) {
                    revert PaymentProcessor__BadPaymentMethod();
                }
                advancedBid.advancedOrder.saleDetails.itemPrice = uint240(advancedBid.advancedOrder.saleDetails.itemPrice);

                uint256 quantityToFill = 
                    _verifyBidOrderSignatures(
                        advancedBid.offerType, 
                        tradeContext, 
                        advancedBid.advancedOrder.saleDetails, 
                        advancedBid.advancedOrder.signature, 
                        advancedBid.advancedOrder.cosignature, 
                        tokenSetProof);

                _adjustForUnitPricing(quantityToFill, advancedBid.advancedOrder.saleDetails);
        
                advancedBid.advancedOrder.signature = advancedBid.sellerPermitSignature;
        
                _validateAndFulfillSinglePermittedOrder(0, Sides.Sell, advancedBid.advancedOrder, tradeContext, feeOnTop);
            } else {
                revert PaymentProcessor__PermitsAreNotCompatibleWithBulkOrders();
            }
        }
    }

    /**
     * @notice Verifies the proof and signature of an order that was generated by a signed merkle tree root
     * @notice and executes the order.
     *
     * @dev    Throws when the payment method is the native token.
     * @dev    Throws when the token set proof is provided and is invalid.
     * @dev    Throws when the nonce has already been invalidated.
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the maker's signature is invalid.
     * @dev    Throws when the order status is not open.
     * @dev    Throws when the order type is ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL and the remaining fillable
     * @dev    amount is less than the minimum fillable amount requested.
     * 
     * @param tradeContext         The execution context of the trade.
     * @param advancedBid          Order details including the permit context, signatures and sale details.
     * @param bulkOrderProof       The bulk order proof and order index.
     * @param feeOnTop             The additional fee to add on top of the orders, paid by taker.
     * @param tokenSetProof        The token set proof that contains the root hash for the merkle
     *                             tree of allowed tokens for accepting the maker's offer.
     */
    function _executeOrderSellSideBulk(
        TradeContext memory tradeContext,
        AdvancedBidOrder memory advancedBid,
        BulkOrderProof calldata bulkOrderProof,
        FeeOnTop calldata feeOnTop,
        TokenSetProof calldata tokenSetProof
    ) internal {
        Order memory saleDetails = advancedBid.advancedOrder.saleDetails;
        saleDetails.itemPrice = uint240(saleDetails.itemPrice);

        if (saleDetails.paymentMethod == address(0)) {
            revert PaymentProcessor__BadPaymentMethod();
        }

        uint256 quantityToFill;

        uint256 offerType = advancedBid.offerType;
        if (offerType == OFFER_TYPE_COLLECTION_OFFER) {
            quantityToFill = _verifyBulkCollectionOfferApprovalProofAndSignedTree(
                tradeContext, 
                saleDetails, 
                advancedBid.advancedOrder.signature, 
                advancedBid.advancedOrder.cosignature,
                bulkOrderProof);
        } else if (offerType == OFFER_TYPE_ITEM_OFFER) {
            quantityToFill = _verifyBulkItemOfferApprovalProofAndSignedTree(
                tradeContext,
                saleDetails, 
                advancedBid.advancedOrder.signature, 
                advancedBid.advancedOrder.cosignature,
                bulkOrderProof);
        } else if (offerType == OFFER_TYPE_TOKEN_SET_OFFER) {
            quantityToFill = _verifyBulkTokenSetOfferApprovalProofAndSignedTree(
                tradeContext, 
                saleDetails, 
                advancedBid.advancedOrder.signature, 
                tokenSetProof, 
                advancedBid.advancedOrder.cosignature,
                bulkOrderProof);
        } else {
            revert PaymentProcessor__InvalidOfferType();
        }

        _validateAndFulfillOrder(
            Sides.Sell, 
            tradeContext, 
            0, 
            quantityToFill, 
            saleDetails, 
            feeOnTop);
    }

    /**
     * @notice Executes a sweep order. A sweep order is a collection of items that are purchased in a single transaction.
     * 
     * @dev    Throws when the sweep order protocol is ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL.
     * @dev    Throws when the sweep order items array is empty.
     * @dev    Throws when a collection is set to block untrusted channels and the transaction originates
     * @dev    from an untrusted channel.
     * @dev    Throws when the payment method is not an allowed payment method.
     * @dev    Throws when trading is paused for the collection.
     * @dev    Throws when any protocol is ORDER_PROTOCOLS_ERC721_FILL_OR_KILL and the amount is not 1.
     * @dev    Throws when any protocol is ORDER_PROTOCOLS_ERC1155_FILL_OR_KILL and the amount is 0.
     * @dev    Throws when any protocol is not ORDER_PROTOCOLS_ERC721_FILL_OR_KILL or ORDER_PROTOCOLS_ERC1155_FILL_OR_KILL.
     * @dev    Throws when the sum of the marketplace fee and the max royalty fee exceeds the fee denominator.
     * @dev    Throws when the sale price is not within the allowed price range.
     * @dev    Throws when the order has expired.
     * @dev    Throws when the fee on top is greater than the sum of the listing prices.
     * @dev    Throws when the payment method is not an allowed payment method.
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the maker signature is invalid.
     * @dev    Throws when the maker's order nonce has already been used or was cancelled.
     * @dev    Throws when a partially fillable order has already been filled, cancelled or 
     * @dev    cannot be filled with the minimum fillable amount.
     *
     * @param tradeContext         The execution context of the trade.
     * @param startingNativeFunds  The starting native funds.
     * @param advancedSweep        Order details including the permit context, signatures and sweep details.
     */
    function _executeSweepOrderAdvanced(
        TradeContext memory tradeContext,
        uint256 startingNativeFunds,
        AdvancedSweep calldata advancedSweep
    ) internal returns (uint256 endingNativeFunds) {
        if (advancedSweep.sweepOrder.protocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
            revert PaymentProcessor__OrderProtocolERC1155FillPartialUnsupportedInSweeps();
        }

        if (advancedSweep.items.length == 0) {
            revert PaymentProcessor__InputArrayLengthCannotBeZero();
        }

        SweepExecutionParams memory params = _validateSweepOrderHeader(tradeContext, advancedSweep.sweepOrder);

        endingNativeFunds = _validateAndFulfillSweepOrderAdvanced(
            startingNativeFunds,
            advancedSweep,
            tradeContext,
            params
        );
    }

    /**
     * @notice Validates and fulfills a sweep order.
     *
     * @dev    Throws when any protocol is ORDER_PROTOCOLS_ERC721_FILL_OR_KILL and the amount is not 1.
     * @dev    Throws when any protocol is ORDER_PROTOCOLS_ERC1155_FILL_OR_KILL and the amount is 0.
     * @dev    Throws when any protocol is not ORDER_PROTOCOLS_ERC721_FILL_OR_KILL or ORDER_PROTOCOLS_ERC1155_FILL_OR_KILL.
     * @dev    Throws when the sum of the marketplace fee and the max royalty fee exceeds the fee denominator.
     * @dev    Throws when the sale price is not within the allowed price range.
     * @dev    Throws when the order has expired.
     * @dev    Throws when the fee on top is greater than the sum of the listing prices.
     * @dev    Throws when the payment method is not an allowed payment method.
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the maker signature is invalid.
     * @dev    Throws when the maker's order nonce has already been used or was cancelled.
     * @dev    Throws when a partially fillable order has already been filled, cancelled or 
     * @dev    cannot be filled with the minimum fillable amount.
     * 
     * @param startingNativeFunds  The starting native funds.
     * @param advancedSweep        Order details including the permit context, signatures and sweep details.
     * @param context              The current exectuion context.
     * @param params               The sweep execution parameters.
     */
    function _validateAndFulfillSweepOrderAdvanced(
        uint256 startingNativeFunds,
        AdvancedSweep calldata advancedSweep,
        TradeContext memory context,
        SweepExecutionParams memory params
    ) internal returns (uint256 endingNativeFunds) {
        endingNativeFunds = startingNativeFunds;

        uint256 sumListingPrices;
        uint256 dispensedPaymentValue; 

        SweepOrder calldata sweepOrder = advancedSweep.sweepOrder;
        AdvancedSweepItem[] calldata items = advancedSweep.items;

        for(uint256 itemIndex;itemIndex < items.length;) {
            AdvancedSweepItem calldata advancedSweepItem = items[itemIndex];
            SweepItem calldata sweepItem = advancedSweepItem.sweepItem;
            AdvancedOrder memory advancedOrder;

            advancedOrder.permitContext = advancedSweepItem.permitContext;
            advancedOrder.signature = advancedSweepItem.signature;
            advancedOrder.cosignature = advancedSweepItem.cosignature;
            advancedOrder.saleDetails = Order({
                protocol: sweepOrder.protocol,
                maker: sweepItem.maker,
                beneficiary: sweepOrder.beneficiary,
                marketplace: sweepItem.marketplace,
                fallbackRoyaltyRecipient: sweepItem.fallbackRoyaltyRecipient,
                paymentMethod: sweepOrder.paymentMethod,
                tokenAddress: sweepOrder.tokenAddress,
                tokenId: sweepItem.tokenId,
                amount: sweepItem.amount,
                itemPrice: uint240(sweepItem.itemPrice),
                nonce: sweepItem.nonce,
                expiration: sweepItem.expiration,
                marketplaceFeeNumerator: sweepItem.marketplaceFeeNumerator,
                maxRoyaltyFeeNumerator: sweepItem.maxRoyaltyFeeNumerator,
                requestedFillAmount: sweepItem.amount,
                minimumFillAmount: sweepItem.amount,
                protocolFeeVersion: sweepItem.protocolFeeVersion
            });

            Order memory saleDetails = advancedOrder.saleDetails;

            if (context.protocolFeeVersion != saleDetails.protocolFeeVersion) {
                context.protocolFeeVersion = saleDetails.protocolFeeVersion;
                context.protocolFees = appStorage().protocolFeeVersions[saleDetails.protocolFeeVersion];
            }

            sumListingPrices += saleDetails.itemPrice;

            if (saleDetails.protocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
                if (saleDetails.amount != ONE) {
                    revert PaymentProcessor__AmountForERC721SalesMustEqualOne();
                }
            } else if (saleDetails.protocol == ORDER_PROTOCOLS_ERC1155_FILL_OR_KILL) {
                if (saleDetails.amount == 0) {
                    revert PaymentProcessor__AmountForERC1155SalesGreaterThanZero();
                }
            } else {
                revert PaymentProcessor__InvalidOrderProtocol();
            }

            if (saleDetails.marketplaceFeeNumerator + saleDetails.maxRoyaltyFeeNumerator > FEE_DENOMINATOR) {
                revert PaymentProcessor__MarketplaceAndRoyaltyFeesWillExceedSalePrice();
            }

            if (params.paymentSettings == PaymentSettings.PricingConstraints || params.paymentSettings == PaymentSettings.PricingConstraintsCollectionOnly) {
                _validateSalePriceInRange(
                    params.paymentSettings,
                    saleDetails.tokenAddress, 
                    saleDetails.tokenId, 
                    saleDetails.amount, 
                    saleDetails.itemPrice);
            }

            if (block.timestamp > saleDetails.expiration) {
                    revert PaymentProcessor__OrderHasExpired();
            }

            if (block.timestamp > context.protocolFees.versionExpiration) {
                revert PaymentProcessor__ProtocolFeeVersionExpired();
            }

            if (context.protocolFees.minimumProtocolFeeBps > FEE_DENOMINATOR) {
                revert PaymentProcessor__ProtocolFeeOrTaxExceedsCap();
            }

            if (advancedOrder.permitContext.permitProcessor == address(0)) {
                if (advancedSweepItem.bulkOrderProof.proof.length == 0) {
                    _verifySaleApproval(
                        context,
                        saleDetails,
                        advancedOrder.signature,
                        advancedOrder.cosignature
                    );
                } else {
                    _verifyBulkSaleApprovalProofAndSignedTree(
                        context,
                        saleDetails,
                        advancedOrder.signature,
                        advancedOrder.cosignature,
                        advancedSweepItem.bulkOrderProof
                    );
                }
            }

            (endingNativeFunds, dispensedPaymentValue) = _dispenseAndPayoutSweepItemAdvanced(
                advancedOrder, 
                context,
                params,
                endingNativeFunds,
                dispensedPaymentValue
            );

            unchecked {
                ++itemIndex;
            }
        }

        if (advancedSweep.feeOnTop.amount > sumListingPrices) {
            revert PaymentProcessor__FeeOnTopCannotBeGreaterThanItemPrice();
        }

        endingNativeFunds = _finalizePaymentAccumulatorDisbursement(
            context,
            params,
            advancedSweep.feeOnTop,
            dispensedPaymentValue,
            sumListingPrices,
            endingNativeFunds
        );
    }

    /**
     * @notice Disburses the accumulated proceeds to the respective recipients.
     *
     * @dev    Throws when the provided permit processor is not trusted.
     * @dev    Throws when the order has run out of native funds.
     */
    function _dispenseAndPayoutSweepItemAdvanced(
        AdvancedOrder memory advancedOrder,
        TradeContext memory context,
        SweepExecutionParams memory params,
        uint256 startingNativeFunds,
        uint256 startingDispensedPaymentValue
    ) internal returns(
        uint256 endingNativeFunds,
        uint256 endingDispensedPaymentValue
    ) {
        endingNativeFunds = startingNativeFunds;
        endingDispensedPaymentValue = startingDispensedPaymentValue;

        Order memory saleDetails = advancedOrder.saleDetails;
        bool failedToDispense;

        if (advancedOrder.permitContext.permitProcessor == address(0)) {
            failedToDispense = !params.fnPointers.funcDispenseToken(
                saleDetails.maker, 
                saleDetails.beneficiary, 
                saleDetails.tokenAddress, 
                saleDetails.tokenId, 
                saleDetails.amount);

            if(failedToDispense) {
                if (saleDetails.protocol != ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
                    _restoreNonce(saleDetails.maker, saleDetails.nonce);
                }
            }
        } else {
            if (!_isTrustedPermitProcessor(advancedOrder.permitContext.permitProcessor)) {
                revert PaymentProcessor__PermitProcessorNotTrusted();
            }

            uint256 quantityToFill;
            (quantityToFill, failedToDispense) = 
                _verifyPermittedSaleApprovalAndDispense(true, saleDetails.maker, advancedOrder, context);

            _adjustForUnitPricing(quantityToFill, saleDetails);
        }

        if (!failedToDispense) {
            SplitProceeds memory proceeds =
                _computePaymentSplits(
                    context,
                    saleDetails.itemPrice,
                    saleDetails.tokenAddress,
                    saleDetails.tokenId,
                    saleDetails.marketplace,
                    saleDetails.marketplaceFeeNumerator,
                    saleDetails.maxRoyaltyFeeNumerator,
                    saleDetails.fallbackRoyaltyRecipient
                );

            unchecked {
                endingDispensedPaymentValue += saleDetails.itemPrice;
            }

            if (saleDetails.paymentMethod == address(0)) {
                if (endingNativeFunds < saleDetails.itemPrice) {
                    revert PaymentProcessor__RanOutOfNativeFunds();
                }

                unchecked {
                    endingNativeFunds -= saleDetails.itemPrice;
                }
            }

            if (proceeds.royaltyRecipient != params.accumulator.lastRoyaltyRecipient) {
                if(params.accumulator.accumulatedRoyaltyProceeds > 0) {
                    params.fnPointers.funcPayout(params.accumulator.lastRoyaltyRecipient, context.taker, params.paymentCoin, params.accumulator.accumulatedRoyaltyProceeds);
                }

                params.accumulator.lastRoyaltyRecipient = proceeds.royaltyRecipient;
                params.accumulator.accumulatedRoyaltyProceeds = 0;
            }

            if (saleDetails.marketplace != params.accumulator.lastMarketplace) {
                if(params.accumulator.accumulatedMarketplaceProceeds > 0) {
                    params.fnPointers.funcPayout(params.accumulator.lastMarketplace, context.taker, params.paymentCoin, params.accumulator.accumulatedMarketplaceProceeds);
                }

                params.accumulator.lastMarketplace = saleDetails.marketplace;
                params.accumulator.accumulatedMarketplaceProceeds = 0;
            }

            if (saleDetails.maker != params.accumulator.lastSeller) {
                if(params.accumulator.accumulatedSellerProceeds > 0) {
                    params.fnPointers.funcPayout(params.accumulator.lastSeller, context.taker, params.paymentCoin, params.accumulator.accumulatedSellerProceeds);
                }

                params.accumulator.lastSeller = saleDetails.maker;
                params.accumulator.accumulatedSellerProceeds = 0;
            }

            if (context.protocolFees.protocolFeeReceiver != params.accumulator.lastProtocolFeeRecipient) {
                if (params.accumulator.accumulatedInfrastructureProceeds > 0) {
                    params.fnPointers.funcPayout(params.accumulator.lastProtocolFeeRecipient, context.taker, params.paymentCoin, params.accumulator.accumulatedInfrastructureProceeds);
                }

                params.accumulator.lastProtocolFeeRecipient = context.protocolFees.protocolFeeReceiver;
                params.accumulator.accumulatedInfrastructureProceeds = 0;
            }

            unchecked {
                params.accumulator.accumulatedRoyaltyProceeds += proceeds.royaltyProceeds;
                params.accumulator.accumulatedMarketplaceProceeds += proceeds.marketplaceProceeds;
                params.accumulator.accumulatedSellerProceeds += proceeds.sellerProceeds;
                params.accumulator.accumulatedInfrastructureProceeds += proceeds.infrastructureProceeds;
            }

            params.fnPointers.funcEmitOrderExecutionEvent(context, saleDetails);
        }

    }

    /**
     * @notice Verifies the proof and signature of an order that was generated by a signed merkle tree root.
     *
     * @dev    Throws when the maker's signature is invalid.
     * @dev    Throws when the order status is not open.
     * @dev    Throws when the nonce has already been invalidated.
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the order type is ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL and the remaining fillable
     * @dev    amount is less than the minimum fillable amount requested.
     *
     * @param  context                            The execution context of the trade.
     * @param  saleDetails                        The details of the sale.
     * @param  signature                          The maker's signature authorizing the order execution.
     * @param  cosignature                        The additional cosignature for a cosigned order, if applicable.
     * @param  bulkOrderProof                     The bulk order proof and order index.
     * @param  orderHash                          The digest generated from the order details.
     * @param  _getBulkOrderTypehashByTreeHeight  The function to get the bulk order typehash by tree height.
     */
    function _verifyBulkOrderSignatures(
        TradeContext memory context,
        Order memory saleDetails,
        SignatureECDSA memory signature,
        Cosignature memory cosignature,
        BulkOrderProof calldata bulkOrderProof,
        bytes32 orderHash,
        function(uint256) internal pure returns(bytes32) _getBulkOrderTypehashByTreeHeight
    ) internal returns (uint256 quantityToFill) {
        uint256 orderIndex = bulkOrderProof.orderIndex;
        bytes32 bulkOrderRootHash = orderHash;
        bytes32[] calldata proof = bulkOrderProof.proof;
        for (uint256 i; i < proof.length;) {
            if (orderIndex & 1 == 0) {
                bulkOrderRootHash = EfficientHash.efficientHash(bulkOrderRootHash, proof[i]);
            } else {
                bulkOrderRootHash = EfficientHash.efficientHash(proof[i], bulkOrderRootHash);
            }
            orderIndex >>= 1;
            unchecked {
                ++i;
            }
        }

        if (cosignature.signer != address(0)) {
            _verifyCosignature(context, signature, cosignature);
        }

        _verifyMakerSignature(
            saleDetails.maker, 
            signature, 
            _hashTypedDataV4(
                _cachedDomainSeparator, 
                EfficientHash.efficientHash(
                    _getBulkOrderTypehashByTreeHeight(bulkOrderProof.proof.length),
                    bulkOrderRootHash
                )
            )
        );

        if (saleDetails.protocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
            quantityToFill = _checkAndUpdateRemainingFillableItems(
                saleDetails.maker, 
                orderHash, 
                saleDetails.amount, 
                saleDetails.requestedFillAmount,
                saleDetails.minimumFillAmount);
            context.orderDigest = orderHash;
        } else {
            quantityToFill = saleDetails.amount;
        }
    }

    /**
     * @notice Generate the order digest and verify the bulk order proof and signatures for an item.
     *
     * @dev    Throws when the maker's signature is invalid.
     * @dev    Throws when the order status is not open.
     * @dev    Throws when the nonce has already been invalidated.
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the order type is ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL and the remaining fillable
     * @dev    amount is less than the minimum fillable amount requested.
     *
     * @param  tradeContext     The execution context of the trade.
     * @param  saleDetails      The details of the sale.
     * @param  signature        The maker's signature authorizing the order execution.
     * @param  cosignature      The additional cosignature for a cosigned order, if applicable.
     * @param  bulkOrderProof   The bulk order proof and order index.
     */
    function _verifyBulkItemOfferApprovalProofAndSignedTree(
        TradeContext memory tradeContext,
        Order memory saleDetails,
        SignatureECDSA memory signature,
        Cosignature memory cosignature,
        BulkOrderProof calldata bulkOrderProof
    ) internal returns (uint256 quantityToFill) {
        bytes32 orderHash = 
            _generateItemOfferOrderHash(
                saleDetails, 
                saleDetails.maker, 
                cosignature.signer, 
                _checkAndInvalidateNonceForFillOrKillOrders(saleDetails)
            );

        quantityToFill = _verifyBulkOrderSignatures(
            tradeContext, 
            saleDetails, 
            signature, 
            cosignature, 
            bulkOrderProof, 
            orderHash,
            _getBulkItemOfferApprovalTypehash
        );
    }

    /**
     * @notice Generate the order digest and verify the bulk order proof and signatures for a collection.
     *
     * @dev    Throws when the maker's signature is invalid.
     * @dev    Throws when the order status is not open.
     * @dev    Throws when the nonce has already been invalidated.
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the order type is ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL and the remaining fillable
     * @dev    amount is less than the minimum fillable amount requested.
     *
     * @param  tradeContext     The execution context of the trade.
     * @param  saleDetails      The details of the sale.
     * @param  signature        The maker's signature authorizing the order execution.
     * @param  cosignature      The additional cosignature for a cosigned order, if applicable.
     * @param  bulkOrderProof   The bulk order proof and order index.
     */
    function _verifyBulkCollectionOfferApprovalProofAndSignedTree(
        TradeContext memory tradeContext,
        Order memory saleDetails,
        SignatureECDSA memory signature,
        Cosignature memory cosignature,
        BulkOrderProof calldata bulkOrderProof
    ) internal returns (uint256 quantityToFill) {
        bytes32 orderHash = 
            _generateCollectionOfferOrderHash(
                saleDetails, 
                saleDetails.maker, 
                cosignature.signer, 
                _checkAndInvalidateNonceForFillOrKillOrders(saleDetails)
            );

        quantityToFill = _verifyBulkOrderSignatures(
            tradeContext, 
            saleDetails, 
            signature, 
            cosignature, 
            bulkOrderProof, 
            orderHash,
            _getBulkCollectionOfferApprovalTypehash
        );
    }

    /**
     * @notice Generate the order digest and verify the bulk order proof and signatures for a token set order.
     *
     * @dev    Throws when the maker's signature is invalid.
     * @dev    Throws when the order status is not open.
     * @dev    Throws when the nonce has already been invalidated.
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the order type is ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL and the remaining fillable
     * @dev    amount is less than the minimum fillable amount requested.
     *
     * @param  tradeContext     The execution context of the trade.
     * @param  saleDetails      The details of the sale.
     * @param  signature        The maker's signature authorizing the order execution.
     * @param  tokenSetProof    The merkle proofs for an offer that is a subset of tokens in a collection.
     * @param  cosignature      The additional cosignature for a cosigned order, if applicable.
     * @param  bulkOrderProof   The bulk order proof and order index.
     */
    function _verifyBulkTokenSetOfferApprovalProofAndSignedTree(
        TradeContext memory tradeContext,
        Order memory saleDetails,
        SignatureECDSA memory signature,
        TokenSetProof calldata tokenSetProof,
        Cosignature memory cosignature,
        BulkOrderProof calldata bulkOrderProof
    ) internal returns (uint256 quantityToFill) {
        bytes32 orderHash = 
            _generateTokenSetOfferOrderHash(
                tokenSetProof,
                saleDetails, 
                saleDetails.maker, 
                cosignature.signer, 
                _checkAndInvalidateNonceForFillOrKillOrders(saleDetails)
            );

        quantityToFill = _verifyBulkOrderSignatures(
            tradeContext, 
            saleDetails, 
            signature, 
            cosignature, 
            bulkOrderProof, 
            orderHash,
            _getBulkTokenSetOfferApprovalTypehash
        );
    }

    /**
     * @notice Generate the order digest and verify the bulk order proof and signatures for a sale approval.
     *
     * @dev    Throws when the maker's signature is invalid.
     * @dev    Throws when the order status is not open.
     * @dev    Throws when the nonce has already been invalidated.
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the order type is ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL and the remaining fillable
     * @dev    amount is less than the minimum fillable amount requested.
     *
     * @param  tradeContext     The execution context of the trade.
     * @param  saleDetails      The details of the sale.
     * @param  signature        The maker's signature authorizing the order execution.
     * @param  cosignature      The additional cosignature for a cosigned order, if applicable.
     * @param  bulkOrderProof   The bulk order proof and order index.
     */
    function _verifyBulkSaleApprovalProofAndSignedTree(
        TradeContext memory tradeContext,
        Order memory saleDetails,
        SignatureECDSA memory signature,
        Cosignature memory cosignature,
        BulkOrderProof calldata bulkOrderProof
    ) internal returns (uint256 quantityToFill) {
        bytes32 orderHash = 
            _generateListingOrderHash(
                saleDetails, 
                saleDetails.maker, 
                cosignature.signer, 
                _checkAndInvalidateNonceForFillOrKillOrders(saleDetails)
            );

        quantityToFill = _verifyBulkOrderSignatures(
            tradeContext, 
            saleDetails, 
            signature, 
            cosignature, 
            bulkOrderProof, 
            orderHash,
            _getBulkSaleApprovalTypehash
        );
    }

    /**
     * @notice Helper function which returns the bulk sale approval typehash for a provided height.
     *
     * @param height  The height of the typehash.
     */
    function _getBulkSaleApprovalTypehash(uint256 height) internal pure returns(bytes32 hash) {
        if(height > 10 || height == 0) {
            revert PaymentProcessor__InvalidBulkOrderHeight();
        }
        bytes memory memTypehashes = BULK_SALE_APPROVAL_TYPEHASHES_LOOKUP;
        assembly {
            hash := mload(add(memTypehashes, shl(5, height)))
        }
    }

    /**
     * @notice Helper function which returns the bulk collection offer approval typehash for a provided height.
     *
     * @param height  The height of the typehash.
     */
    function _getBulkCollectionOfferApprovalTypehash(uint256 height) internal pure returns(bytes32 hash) {
        if(height > 10 || height == 0) {
            revert PaymentProcessor__InvalidBulkOrderHeight();
        }
        bytes memory memTypehashes = BULK_COLLECTION_OFFER_APPROVAL_TYPEHASHES_LOOKUP;
        assembly {
            hash := mload(add(memTypehashes, shl(5, height)))
        }
    }

    /**
     * @notice Helper function which returns the bulk item offer approval typehash for a provided height.
     *
     * @param height  The height of the typehash.
     */
    function _getBulkItemOfferApprovalTypehash(uint256 height) internal pure returns(bytes32 hash) {
        if(height > 10 || height == 0) {
            revert PaymentProcessor__InvalidBulkOrderHeight();
        }
        bytes memory memTypehashes = BULK_ITEM_OFFER_APPROVAL_TYPEHASHES_LOOKUP;
        assembly {
            hash := mload(add(memTypehashes, shl(5, height)))
        }
    }

    /**
     * @notice Helper function which returns the bulk token set offer approval typehash for a provided height.
     *
     * @param height  The height of the typehash.
     */
    function _getBulkTokenSetOfferApprovalTypehash(uint256 height) internal pure returns(bytes32 hash) {
        if(height > 10 || height == 0) {
            revert PaymentProcessor__InvalidBulkOrderHeight();
        }
        bytes memory memTypehashes = BULK_TOKEN_SET_OFFER_APPROVAL_TYPEHASHES_LOOKUP;
        assembly {
            hash := mload(add(memTypehashes, shl(5, height)))
        }
    }
}