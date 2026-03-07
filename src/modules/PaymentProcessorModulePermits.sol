//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "./PaymentProcessorModule.sol";

import {
    IPermitC 
} from "@limitbreak/permit-c/interfaces/IPermitC.sol";

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
 
* @title PaymentProcessorModulePermits
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 

abstract contract PaymentProcessorModulePermits is PaymentProcessorModule {
    using EnumerableSet for EnumerableSet.AddressSet;

    address private immutable permitProcessor1;
    address private immutable permitProcessor2;

    constructor(address configurationContract) PaymentProcessorModule(configurationContract) {
        (,,,TrustedPermitProcessors memory trustedPermitProcessors,,
        ) = IPaymentProcessorConfiguration(configurationContract).getPaymentProcessorModuleDeploymentParams();
        
        permitProcessor1 = trustedPermitProcessors.permitProcessor1;
        permitProcessor2 = trustedPermitProcessors.permitProcessor2;
    }

    /*************************************************************************/
    /*                        Default Permit Processors                      */
    /*************************************************************************/

    /**
     * @notice Returns true if `permitProcessor` is a trusted permit processor.
     * 
     * @dev    This function will also return true if the permit processor was added after contract deployment.
     */
    function _isTrustedPermitProcessor(address permitProcessor) internal returns (bool) {
        if (permitProcessor == permitProcessor1 || 
            permitProcessor == permitProcessor2) {
            return true;
        }
        if (appStorage().trustedPermitProcessors.contains(permitProcessor)) {
            return true;
        }
        return IPaymentProcessorSettings(address(this)).checkTrustedPermitProcessors(permitProcessor);
    }

    /**
     * @notice Returns an array of the default payment methods defined at contract deployment.
     * 
     * @dev    This array will **NOT** include default payment methods added after contract deployment.
     */
    function _getTrustedPermitProcessors() internal view returns (address[] memory trustedPermitProcessors) {
        trustedPermitProcessors = new address[](2);
        trustedPermitProcessors[0] = permitProcessor1;
        trustedPermitProcessors[1] = permitProcessor2;
    }

    /*************************************************************************/
    /*                           Order Fulfillment                           */
    /*************************************************************************/

    /**
     * @notice Validates and fulfills a single permitted order.
     * 
     * @dev    Throws if the order is buy side, requires a cosignature, and the cosignature is invalid.
     * @dev    Throws if the permit nonce is invalid.
     * @dev    Throws if the permit signature is invalid.
     *
     * @param startingNativeFunds The starting native funds.
     * @param side                The side of the order.
     * @param matchedOrder        The order to fulfill.
     * @param tradeContext        The execution context of the trade.
     * @param feeOnTop            The additional fee to add on top of the order, paid by taker.
     */
    function _validateAndFulfillSinglePermittedOrder(
        uint256 startingNativeFunds,
        Sides side,
        AdvancedOrder memory matchedOrder,
        TradeContext memory tradeContext,
        FeeOnTop calldata feeOnTop
    ) internal returns (uint256 endingNativeFunds) {
        endingNativeFunds = startingNativeFunds;

        Order memory saleDetails = matchedOrder.saleDetails;

        address purchaser = tradeContext.taker;
        address seller = matchedOrder.saleDetails.maker;
        bool isBuySide = side == Sides.Buy;

        if (!isBuySide) {
            purchaser = matchedOrder.saleDetails.maker;
            seller = tradeContext.taker;
        }

        (uint256 quantityToFill, bool failedToDispense) = 
            _verifyPermittedSaleApprovalAndDispense(isBuySide, seller, matchedOrder, tradeContext);
        
        _adjustForUnitPricing(quantityToFill, saleDetails);

        _validateBasicOrderDetails(tradeContext, saleDetails);

        if (failedToDispense) {
            if (tradeContext.disablePartialFill) {
                revert PaymentProcessor__DispensingTokenWasUnsuccessful();
            }
        } else {
            SplitProceeds memory proceeds =
                _computePaymentSplits(
                    tradeContext,
                    saleDetails.itemPrice,
                    saleDetails.tokenAddress,
                    saleDetails.tokenId,
                    saleDetails.marketplace,
                    saleDetails.marketplaceFeeNumerator,
                    saleDetails.maxRoyaltyFeeNumerator,
                    saleDetails.fallbackRoyaltyRecipient
                );

            uint256 feeOnTopAmount;
            if (feeOnTop.recipient != address(0)) {
                feeOnTopAmount = feeOnTop.amount;

                if (feeOnTopAmount > saleDetails.itemPrice) {
                    revert PaymentProcessor__FeeOnTopCannotBeGreaterThanItemPrice();
                }
            }

            if (saleDetails.paymentMethod == address(0)) {
                unchecked {
                    uint256 nativeProceedsToSpend = saleDetails.itemPrice + feeOnTopAmount;
                    if (endingNativeFunds < nativeProceedsToSpend) {
                        revert PaymentProcessor__RanOutOfNativeFunds();
                    }

                    endingNativeFunds -= nativeProceedsToSpend;
                }
            }

            FulfillOrderFunctionPointers memory fnPointers = 
                _getOrderFulfillmentFunctionPointers(side, saleDetails.paymentMethod, saleDetails.protocol);

            if (feeOnTopAmount > 0) {
                unchecked {
                    uint256 feeOnTopAmountInfrastructure = feeOnTopAmount * tradeContext.protocolFees.feeOnTopProtocolTaxBps / FEE_DENOMINATOR;
                    fnPointers.funcPayout(feeOnTop.recipient, tradeContext.taker, saleDetails.paymentMethod, feeOnTopAmount - feeOnTopAmountInfrastructure);

                    if (purchaser == tradeContext.taker) {
                        proceeds.infrastructureProceeds += feeOnTopAmountInfrastructure;
                    } else {
                        if (feeOnTopAmountInfrastructure > 0) {
                            fnPointers.funcPayout(tradeContext.protocolFees.protocolFeeReceiver, tradeContext.taker, saleDetails.paymentMethod, feeOnTopAmountInfrastructure);
                        }
                    }
                }
            }

            if (proceeds.infrastructureProceeds > 0) {
                fnPointers.funcPayout(tradeContext.protocolFees.protocolFeeReceiver, purchaser, saleDetails.paymentMethod, proceeds.infrastructureProceeds);
            }

            if (proceeds.royaltyProceeds > 0) {
                fnPointers.funcPayout(proceeds.royaltyRecipient, purchaser, saleDetails.paymentMethod, proceeds.royaltyProceeds);
            }

            if (proceeds.marketplaceProceeds > 0) {
                fnPointers.funcPayout(saleDetails.marketplace, purchaser, saleDetails.paymentMethod, proceeds.marketplaceProceeds);
            }

            if (proceeds.sellerProceeds > 0) {
                fnPointers.funcPayout(seller, purchaser, saleDetails.paymentMethod, proceeds.sellerProceeds);
            }

            fnPointers.funcEmitOrderExecutionEvent(tradeContext, saleDetails);
        }
    }

    /*************************************************************************/
    /*                        Signature Verification                         */
    /*************************************************************************/

    /**
     * @notice Performs initial verification of a permit signature and processes it via the permit processor.
     *
     * @dev    Throws if the order is buy side, requires a cosignature, and the cosignature is invalid.
     * @dev    Throws if the permit nonce is invalid.
     * @dev    Throws if the permit signature is invalid.
     *
     * @param isBuySide       True if the order is buy side, false otherwise.
     * @param seller          The seller of the order.
     * @param matchedOrder    The order to verify.
     * @param tradeContext    The trade context.
     */
    function _verifyPermittedSaleApprovalAndDispense(
        bool isBuySide,
        address seller,
        AdvancedOrder memory matchedOrder,
        TradeContext memory tradeContext
    ) internal returns (uint256 quantityToFill, bool isError) {
        Order memory saleDetails = matchedOrder.saleDetails;

        bytes32 orderDigest = _generateListingOrderHash(
            matchedOrder.saleDetails,
            seller,
            isBuySide ? matchedOrder.cosignature.signer : address(0),
            appStorage().masterNonces[seller]
        );

        if (isBuySide) {
            if (matchedOrder.cosignature.signer != address(0)) {
                _verifyCosignature(
                    tradeContext, 
                    matchedOrder.signature, 
                    matchedOrder.cosignature);
            }
        }

        if (saleDetails.protocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
            if (isBuySide) {
                (quantityToFill, isError) = _fillPermittedOrderERC1155(seller, orderDigest, matchedOrder);
            } else {
                isError = _permitTransferFromWithAdditionalDataERC1155(seller, orderDigest, matchedOrder);
                quantityToFill = saleDetails.amount;
            }
        } else {
            quantityToFill = saleDetails.amount;

            if (saleDetails.protocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
                isError = _permitTransferFromWithAdditionalDataERC721(seller, orderDigest, matchedOrder);
            } else {
                isError = _permitTransferFromWithAdditionalDataERC1155(seller, orderDigest, matchedOrder);
            }
        }
    }

    /**
     * @notice Processes a permit signature for an ERC1155 order.
     *
     * @dev    Throws if the permit nonce is invalid.
     * @dev    Throws if the permit signature is invalid.
     * @dev    Throws if the amount remaining is less than the minimum fill amount.
     * @dev    Throws if the quantity to fill exceeds uint248 max.
     *
     * @param seller          The seller of the order.
     * @param orderDigest     The order digest.
     * @param matchedOrder    The order to verify.
     */
    function _fillPermittedOrderERC1155(
        address seller,
        bytes32 orderDigest,
        AdvancedOrder memory matchedOrder
    ) internal returns (uint256 quantityToFill, bool isError) {
        Order memory saleDetails = matchedOrder.saleDetails;

        (
            quantityToFill, 
            isError
        ) = IPermitC(matchedOrder.permitContext.permitProcessor).fillPermittedOrderERC1155(
            _repackSignature(matchedOrder.signature),
            OrderFillAmounts({
                orderStartAmount: saleDetails.amount,
                requestedFillAmount: saleDetails.requestedFillAmount,
                minimumFillAmount: saleDetails.minimumFillAmount
            }),
            saleDetails.tokenAddress,
            saleDetails.tokenId,
            seller,
            saleDetails.beneficiary,
            matchedOrder.permitContext.permitNonce,
            uint48(saleDetails.expiration),
            orderDigest,
            PERMITTED_ORDER_SALE_APPROVAL
        );

        if(quantityToFill > type(uint248).max) {
            revert PaymentProcessor__AmountExceedsMaximum();
        }
    }

    /**
     * @notice Processes a permit signature with additional data for an ERC1155 order.
     * 
     * @dev    Throws if the permit nonce is invalid.
     * @dev    Throws if the permit signature is invalid.
     *
     * @param seller          The seller of the order.
     * @param orderDigest     The order digest.
     * @param matchedOrder    The order to verify.
     */
    function _permitTransferFromWithAdditionalDataERC1155(
        address seller,
        bytes32 orderDigest,
        AdvancedOrder memory matchedOrder
    ) internal returns (bool isError) {
        Order memory saleDetails = matchedOrder.saleDetails;

        isError = IPermitC(matchedOrder.permitContext.permitProcessor).permitTransferFromWithAdditionalDataERC1155(
            saleDetails.tokenAddress,
            saleDetails.tokenId,
            matchedOrder.permitContext.permitNonce,
            saleDetails.amount,
            saleDetails.expiration,
            seller,
            saleDetails.beneficiary,
            saleDetails.amount,
            orderDigest,
            PERMITTED_TRANSFER_SALE_APPROVAL,
            _repackSignature(matchedOrder.signature)
        );

        if (!isError) {
            emit PermittedOrderNonceInvalidated(
                matchedOrder.permitContext.permitNonce,
                saleDetails.nonce,
                seller,
                false
            );
        }
    }

    /**
     * @notice Processes a permit signature with additional data for an ERC721 order.
     * 
     * @dev    Throws if the permit nonce is invalid.
     * @dev    Throws if the permit signature is invalid.
     * 
     * @param seller          The seller of the order.
     * @param orderDigest     The order digest.
     * @param matchedOrder    The order to verify.
     */
    function _permitTransferFromWithAdditionalDataERC721(
        address seller,
        bytes32 orderDigest,
        AdvancedOrder memory matchedOrder
    ) internal returns (bool isError) {
        Order memory saleDetails = matchedOrder.saleDetails;

        isError = IPermitC(matchedOrder.permitContext.permitProcessor).permitTransferFromWithAdditionalDataERC721(
            saleDetails.tokenAddress,
            saleDetails.tokenId,
            matchedOrder.permitContext.permitNonce,
            saleDetails.expiration,
            seller,
            saleDetails.beneficiary,
            orderDigest,
            PERMITTED_TRANSFER_SALE_APPROVAL,
            _repackSignature(matchedOrder.signature)
        );

        if (!isError) {
            emit PermittedOrderNonceInvalidated(
                matchedOrder.permitContext.permitNonce,
                saleDetails.nonce,
                seller,
                false
            );
        }
    }

    /**
     * @notice Concatenates the r, s, and v values of a signature into a single bytes array.
     *
     * @param signature The signature to repack.
     */
    function _repackSignature(SignatureECDSA memory signature) internal pure returns (bytes memory) {
        if(signature.v > type(uint8).max) {
            revert PaymentProcessor__InvalidSignatureV();
        }
        return abi.encodePacked(signature.r, signature.s, uint8(signature.v));
    }
}