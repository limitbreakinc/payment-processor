//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "../interfaces/IPaymentProcessorConfiguration.sol";
import "../interfaces/IPaymentProcessorEvents.sol";
import "../storage/PaymentProcessorStorageAccess.sol";
import "../settings-registry/IPaymentProcessorSettings.sol";
import "../Constants.sol";
import "../Errors.sol";

import "../settings-registry/ICollectionSettingsRegistry.sol";

import "@limitbreak/tm-core-lib/src/token/erc20/utils/SafeERC20.sol";
import "@limitbreak/tm-core-lib/src/utils/cryptography/EfficientHash.sol";
import "@limitbreak/tm-core-lib/src/token/erc721/IERC721.sol";
import "@limitbreak/tm-core-lib/src/token/erc1155/IERC1155.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import {TrustedForwarderERC2771Context} from "@limitbreak/trusted-forwarder/TrustedForwarderERC2771Context.sol";

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
 
* @title PaymentProcessorModule
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 

abstract contract PaymentProcessorModule is 
    TrustedForwarderERC2771Context, 
    PaymentProcessorStorageAccess, 
    IPaymentProcessorEvents {

    using EnumerableSet for EnumerableSet.AddressSet;

    // Recommendations For Default Immutable Payment Methods Per Chain
    // Default Payment Method 1: Wrapped Native Coin
    // Default Payment Method 2: Wrapped ETH
    // Default Payment Method 3: USDC (Native)
    // Default Payment Method 4: USDC (Bridged)

    /// @dev The address of the ERC20 contract used for wrapped native token.
    address internal immutable _wrappedNativeCoinAddress;

    /// @dev The first default payment method defined at contract deployment. Immutable to save SLOAD cost.
    address internal immutable defaultPaymentMethod1;

    /// @dev The second default payment method defined at contract deployment. Immutable to save SLOAD cost.
    address internal immutable defaultPaymentMethod2;

    /// @dev The third default payment method defined at contract deployment. Immutable to save SLOAD cost.
    address internal immutable defaultPaymentMethod3;

    /// @dev The fourth default payment method defined at contract deployment. Immutable to save SLOAD cost.
    address internal immutable defaultPaymentMethod4;

    /// @dev The address of the collection settings registry contract.
    address internal immutable collectionSettingsRegistry;

    /// @dev The domain separator for EIP-712 signatures.
    bytes32 internal immutable _cachedDomainSeparator;

    address internal immutable _defaultInfrastructureFeeReceiver;

    constructor(address configurationContract)
    TrustedForwarderERC2771Context(
        IPaymentProcessorConfiguration(configurationContract).getPaymentProcessorModuleERC2771ContextParams()
    ) {
        (
            address paymentProcessorAddress_,
            address wrappedNativeCoinAddress_,
            DefaultPaymentMethods memory defaultPaymentMethods,,
            address collectionSettingsRegistry_,
            address infrastructureFeeReceiver_
        ) = IPaymentProcessorConfiguration(configurationContract).getPaymentProcessorModuleDeploymentParams();
        
        if (wrappedNativeCoinAddress_ == address(0) ||
            collectionSettingsRegistry_ == address(0)) {
            revert PaymentProcessor__InvalidConstructorArguments();
        }

        _wrappedNativeCoinAddress = wrappedNativeCoinAddress_;
        defaultPaymentMethod1 = defaultPaymentMethods.defaultPaymentMethod1;
        defaultPaymentMethod2 = defaultPaymentMethods.defaultPaymentMethod2;
        defaultPaymentMethod3 = defaultPaymentMethods.defaultPaymentMethod3;
        defaultPaymentMethod4 = defaultPaymentMethods.defaultPaymentMethod4;
        collectionSettingsRegistry = collectionSettingsRegistry_;

        _cachedDomainSeparator =
            keccak256(
                abi.encode(
                    keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"), 
                    keccak256(bytes("PaymentProcessor")), 
                    keccak256(bytes("3.0.0")), 
                    block.chainid, 
                    paymentProcessorAddress_
                )
            );

        _defaultInfrastructureFeeReceiver = infrastructureFeeReceiver_;
    }

    /*************************************************************************/
    /*                        Default Payment Methods                        */
    /*************************************************************************/

    /**
     * @notice Returns true if `paymentMethod` is a default payment method.
     * 
     * @dev    This function will return true if the default payment method was added after contract deployment.
     *
     * @param paymentMethod The address of the payment method to check.
     */
    function _isDefaultPaymentMethod(address paymentMethod) internal returns (bool) {
        if (paymentMethod == address(0)) {
            return true;
        } else if (paymentMethod == _wrappedNativeCoinAddress) {
            return true;
        } else if (paymentMethod == defaultPaymentMethod1) {
            return true;
        } else if (paymentMethod == defaultPaymentMethod2) {
            return true;
        } else if (paymentMethod == defaultPaymentMethod3) {
            return true;
        } else if (paymentMethod == defaultPaymentMethod4) {
            return true;
        } else {
            // If it isn't one of the gas efficient immutable default payment methods,
            // it may have bee added to the fallback default payment method whitelist,
            // but there are SLOAD costs.

            return _isWhitelistedPaymentMethod(DEFAULT_PAYMENT_METHOD_WHITELIST_ID, paymentMethod);
        }
    }

    /**
     * @notice Returns true if `paymentMethod` is whitelisted for the provided `whitelistId`.
     *
     * @dev    This function will cache the payment method to the Payment Processor from the Collection Settings Registry
     * @dev    if it is not already cached.
     *
     * @param  whitelistId   The id of the whitelist to check.
     * @param  paymentMethod The address of the payment method to check.
     */
    function _isWhitelistedPaymentMethod(uint32 whitelistId, address paymentMethod) internal returns(bool) {
        if (appStorage().collectionPaymentMethodWhitelists[whitelistId].contains(paymentMethod)) {
            return true;
        }
        return IPaymentProcessorSettings(address(this)).checkWhitelistedPaymentMethod(whitelistId, paymentMethod);
    }

    /**
     * @notice Adds `paymentMethod` to the provided `whitelistId`.
     *
     * @param  ptrPaymentMethods The storage pointer to the payment method whitelist.
     * @param  whitelistId       The id of the whitelist to add the payment method to.
     * @param  paymentMethod     The address of the payment method to add.
     */
    function _addWhitelistedPaymentMethod(EnumerableSet.AddressSet storage ptrPaymentMethods, uint32 whitelistId, address paymentMethod) internal {
        if (ptrPaymentMethods.add(paymentMethod)) {
            emit PaymentMethodAddedToWhitelist(whitelistId, paymentMethod);
        }
    }

    /**
     * @notice Removes `paymentMethod` from the provided `whitelistId`.
     *
     * @param  ptrPaymentMethods The storage pointer to the payment method whitelist.
     * @param  whitelistId       The id of the whitelist to remove the payment method from.
     * @param  paymentMethod     The address of the payment method to remove.
     */
    function _removeWhitelistedPaymentMethod(EnumerableSet.AddressSet storage ptrPaymentMethods, uint32 whitelistId, address paymentMethod) internal {
        if (ptrPaymentMethods.remove(paymentMethod)) {
            emit PaymentMethodRemovedFromWhitelist(whitelistId, paymentMethod);
        }
    }

    /**
     * @notice Returns true if the provided `channel` is a trusted channel for the provided `tokenAddress`, false otherwise.
     *
     * @dev    This function will cache the channel to the Payment Processor from the Collection Settings Registry
     * @dev    if it is not already cached.
     *
     * @param  tokenAddress The address of the token collection.
     * @param  channel      The address of the channel to check.
     */
    function _isCollectionTrustedChannel(address tokenAddress, address channel) internal returns(bool) {
        if (appStorage().collectionTrustedChannels[tokenAddress].contains(channel)) {
            return true;
        }
        return IPaymentProcessorSettings(address(this)).checkCollectionTrustedChannels(tokenAddress, channel);
    }

    /**
     * @notice Adds `channel` to the trusted channels for the provided `tokenAddress`.
     *
     * @param  ptrTrustedChannels The storage pointer to the trusted channels set.
     * @param  tokenAddress       The address of the token collection.
     * @param  channel            The address of the channel to add.
     */
    function _addCollectionTrustedChannel(EnumerableSet.AddressSet storage ptrTrustedChannels, address tokenAddress, address channel) internal {
        if (ptrTrustedChannels.add(channel)) {
            emit TrustedChannelAddedForCollection(tokenAddress, channel);
        }
    }

    /**
     * @notice Removes `channel` from the trusted channels for the provided `tokenAddress`.
     *
     * @param  ptrTrustedChannels The storage pointer to the trusted channels set.
     * @param  tokenAddress       The address of the token collection.
     * @param  channel            The address of the channel to remove.
     */
    function _removeCollectionTrustedChannel(EnumerableSet.AddressSet storage ptrTrustedChannels, address tokenAddress, address channel) internal {
        if (ptrTrustedChannels.remove(channel)) {
            emit TrustedChannelRemovedForCollection(tokenAddress, channel);
        }
    }

    /**
     * @notice Adds `permitProcessor` to the trusted permit processors set.
     *
     * @param  permitProcessor The address of the permit processor to add.
     */
    function _addTrustedPermitProcessor(address permitProcessor) internal {
        if (appStorage().trustedPermitProcessors.add(permitProcessor)) {
            emit TrustedPermitProcessorAdded(permitProcessor);
        }
    }

    /**
     * @notice Removes `permitProcessor` from the trusted permit processors set.
     *
     * @param  permitProcessor The address of the permit processor to remove.
     */
    function _removeTrustedPermitProcessor(address permitProcessor) internal {
        if (appStorage().trustedPermitProcessors.remove(permitProcessor)) {
            emit TrustedPermitProcessorRemoved(permitProcessor);
        }
    }

    /**
     * @notice Returns an array of the default payment methods defined at contract deployment.
     * 
     * @dev    This array will **NOT** include default payment methods added after contract deployment.
     */
    function _getDefaultPaymentMethods() internal view returns (address[] memory) {
        address[] memory defaultPaymentMethods = new address[](6);
        defaultPaymentMethods[0] = address(0);
        defaultPaymentMethods[1] = _wrappedNativeCoinAddress;
        defaultPaymentMethods[2] = defaultPaymentMethod1;
        defaultPaymentMethods[3] = defaultPaymentMethod2;
        defaultPaymentMethods[4] = defaultPaymentMethod3;
        defaultPaymentMethods[5] = defaultPaymentMethod4;
        return defaultPaymentMethods;
    }

    /*************************************************************************/
    /*                            Order Execution                            */
    /*************************************************************************/

    /**
     * @notice Adjusts the item price and amount for per unit pricing.
     *
     * @dev    This function may be called multiple times during a bulk execution.
     * @dev    Throws when a partial fill order is not equally divisible by the number of items in the order.
     * 
     * @param quantityToFill The quantity of the item to fill.
     * @param saleDetails    The order execution details.
     */
    function _adjustForUnitPricing(uint256 quantityToFill, Order memory saleDetails) internal pure {
        if (quantityToFill != saleDetails.amount) {
            if (saleDetails.itemPrice % saleDetails.amount != 0) {
                revert PaymentProcessor__PartialFillsNotSupportedForNonDivisibleItems();
            }

            saleDetails.itemPrice = saleDetails.itemPrice / saleDetails.amount * quantityToFill;
            saleDetails.amount = quantityToFill;
        }
    }

    /**
     * @notice Validates the collection payment settings and fulfills an order.
     *
     * @dev    This function may be called multiple times during a bulk execution.
     * @dev    Throws when a partial fill order is not equally divisible by the number of items in the order.
     * @dev    Throws when a collection is set to block untrusted channels and the transaction originates 
     * @dev    from an untrusted channel.
     * @dev    Throws when the payment method is not an allowed payment method.
     * @dev    Throws when the sweep order is for ERC721 tokens and the amount is set to a value other than one.
     * @dev    Throws when the sweep order is for ERC1155 tokens and the amount is set to zero.
     * @dev    Throws when the marketplace fee and maximum royalty fee will exceed the sales price of an item.
     * @dev    Throws when the current block time is greater than the order expiration.
     * 
     *
     * @param  side                 The side of the order to fulfill.
     * @param  context              The current execution context to determine the taker.
     * @param  startingNativeFunds  The amount of native funds available at the beginning of the order execution.
     * @param  quantityToFill       The quantity of the item to fill.
     * @param  saleDetails          The order execution details.
     * @param  feeOnTop             The additional fee to add on top of the order, paid by taker.
     */
    function _validateAndFulfillOrder(
        Sides side,
        TradeContext memory context,
        uint256 startingNativeFunds,
        uint256 quantityToFill,
        Order memory saleDetails,
        FeeOnTop calldata feeOnTop
    ) internal returns (uint256 endingNativeFunds) {
        _adjustForUnitPricing(quantityToFill, saleDetails);

        _validateBasicOrderDetails(context, saleDetails);

        endingNativeFunds = _fulfillSingleOrderWithFeeOnTop(
            startingNativeFunds,
            context,
            side == Sides.Buy ? context.taker : saleDetails.maker,
            side == Sides.Buy ? saleDetails.maker : context.taker,
            saleDetails.paymentMethod,
            _getOrderFulfillmentFunctionPointers(side, saleDetails.paymentMethod, saleDetails.protocol),
            saleDetails,
            feeOnTop);
    }

    /**
     * @notice Checks order validation and fulfills a buy listing order.
     * 
     * @dev    This function may be called multiple times during a bulk execution.
     * @dev    Throws when a partial fill order is not equally divisible by the number of items in the order.
     * 
     * @param context             The current execution context to determine the taker.
     * @param startingNativeFunds The amount of native funds available at the beginning of the order execution.
     * @param saleDetails         The order execution details.
     * @param signedSellOrder     The maker's signature authorizing the order execution.
     * @param cosignature         The additional cosignature for a cosigned order, if applicable.
     * @param feeOnTop            The additional fee to add on top of the order, paid by taker.
     * 
     * @return endingNativeFunds  The amount of native funds available at the end of the order execution.
     */
    function _executeOrderBuySide(
        TradeContext memory context,
        uint256 startingNativeFunds,
        Order memory saleDetails,
        SignatureECDSA memory signedSellOrder,
        Cosignature memory cosignature,
        FeeOnTop calldata feeOnTop
    ) internal returns (uint256 endingNativeFunds) {
        saleDetails.itemPrice = uint240(saleDetails.itemPrice);

        uint256 quantityToFill = _verifySaleApproval(
            context, 
            saleDetails, 
            signedSellOrder, 
            cosignature);

        endingNativeFunds = 
            _validateAndFulfillOrder(
                Sides.Buy, 
                context, 
                startingNativeFunds, 
                quantityToFill, 
                saleDetails, 
                feeOnTop);
    }

    /**
     * @notice Checks order validation and fulfills an offer acceptance.
     * 
     * @dev    This function may be called multiple times during a bulk execution.
     * @dev    Throws when the payment method is the chain native token.
     * @dev    Throws when the supplied token for a token set offer cannot be validated with the root hash and proof.
     * @dev    Throws when a partial fill order is not equally divisible by the number of items in the order.
     * 
     * @param  context                The current execution context to determine the taker.
     * @param  offerType              The offer type to execute.
     * @param  saleDetails            The order execution details.
     * @param  signature              The maker's signature authorizing the order execution.
     * @param  tokenSetProof          The root hash and merkle proofs for an offer that is a subset of tokens in a collection.
     * @param  cosignature            The additional cosignature for a cosigned order, if applicable.
     * @param  feeOnTop               The additional fee to add on top of the order, paid by taker.
     */
    function _executeOrderSellSide(
        TradeContext memory context,
        uint256 offerType, 
        Order memory saleDetails,
        SignatureECDSA memory signature,
        TokenSetProof calldata tokenSetProof,
        Cosignature memory cosignature,
        FeeOnTop calldata feeOnTop
    ) internal {
        if (saleDetails.paymentMethod == address(0)) {
            revert PaymentProcessor__BadPaymentMethod();
        }
        saleDetails.itemPrice = uint240(saleDetails.itemPrice);

        uint256 quantityToFill = 
            _verifyBidOrderSignatures(
                offerType, 
                context, 
                saleDetails, 
                signature, 
                cosignature, 
                tokenSetProof
            );

        _validateAndFulfillOrder(
            Sides.Sell, 
            context, 
            0, 
            quantityToFill, 
            saleDetails, 
            feeOnTop);
    }

    /**
     * @notice Checks order validation and fulfills a sweep order.
     * 
     * @dev    Throws when the order protocol is for ERC1155 partial fills.
     * @dev    Throws when the `items`, `signedSellOrders` and `cosignatures` arrays have different lengths.
     * @dev    Throws when the `items` array length is zero.
     * 
     * @param context             The current execution context to determine the taker.
     * @param startingNativeFunds The amount of native funds available at the beginning of the order execution.
     * @param feeOnTop            The additional fee to add on top of the orders, paid by taker.
     * @param sweepOrder          The order information that is common to all items in the sweep.
     * @param items               An array of items that contains the order information unique to each item.
     * @param signedSellOrders    An array of maker signatures authorizing the order execution.
     * @param cosignatures        An array of additional cosignatures for cosigned orders, if applicable.
     * 
     * @return endingNativeFunds  The amount of native funds available at the end of the order execution.
     */
    function _executeSweepOrder(
        TradeContext memory context,
        uint256 startingNativeFunds,
        FeeOnTop calldata feeOnTop,
        SweepOrder calldata sweepOrder,
        SweepItem[] calldata items,
        SignatureECDSA[] calldata signedSellOrders,
        Cosignature[] calldata cosignatures
    ) internal returns (uint256 endingNativeFunds) {

        if (sweepOrder.protocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
            revert PaymentProcessor__OrderProtocolERC1155FillPartialUnsupportedInSweeps();
        }

        if (items.length != signedSellOrders.length) {
            revert PaymentProcessor__InputArrayLengthMismatch();
        }

        if (items.length != cosignatures.length) {
            revert PaymentProcessor__InputArrayLengthMismatch();
        }

        if (items.length == 0) {
            revert PaymentProcessor__InputArrayLengthCannotBeZero();
        }

        SweepExecutionParams memory params = _validateSweepOrderHeader(context, sweepOrder);

        endingNativeFunds = _validateAndFulfillSweepOrder(
            context,
            startingNativeFunds,
            feeOnTop,
            sweepOrder,
            items,
            signedSellOrders,
            cosignatures,
            params
        );
    }

    /*************************************************************************/
    /*                           Order Hashes                                */
    /*************************************************************************/

    /**
     * @notice Generates the order hash for a listing order.
     *
     * @param saleDetails      The order execution details.
     * @param signer           The address of the signer authorizing the order.
     * @param cosigner         The address of the cosigner authorizing the order.
     * @param makerMasterNonce The master nonce for the maker.
     */
    function _generateListingOrderHash(
        Order memory saleDetails,
        address signer,
        address cosigner,
        uint256 makerMasterNonce
    ) internal pure returns (bytes32 orderHash) {
        orderHash =
            EfficientHash.efficientHashExtensionEnd(
                EfficientHash.efficientHashExtensionContinue(
                    EfficientHash.efficientHashExtensionStart(
                        17,
                        SALE_APPROVAL_HASH,
                        bytes32(uint256(uint8(saleDetails.protocol))),
                        bytes32(uint256(uint160(cosigner))),
                        bytes32(uint256(uint160(signer))),
                        bytes32(uint256(uint160(saleDetails.marketplace))),
                        bytes32(uint256(uint160(saleDetails.fallbackRoyaltyRecipient))),
                        bytes32(uint256(uint160(saleDetails.paymentMethod))),
                        bytes32(uint256(uint160(saleDetails.tokenAddress)))
                    ),
                    bytes32(saleDetails.tokenId),
                    bytes32(saleDetails.amount),
                    bytes32(saleDetails.itemPrice),
                    bytes32(saleDetails.expiration),
                    bytes32(saleDetails.marketplaceFeeNumerator),
                    bytes32(saleDetails.maxRoyaltyFeeNumerator),
                    bytes32(saleDetails.nonce),
                    bytes32(makerMasterNonce)
                ),
                bytes32(saleDetails.protocolFeeVersion)
            );
    }

    /**
     * @notice Generates the order hash for a single item offer order.
     *
     * @param saleDetails      The order execution details.
     * @param signer           The address of the signer authorizing the order.
     * @param cosigner         The address of the cosigner authorizing the order.
     * @param makerMasterNonce The master nonce for the maker.
     */
    function _generateItemOfferOrderHash(
        Order memory saleDetails,
        address signer,
        address cosigner,
        uint256 makerMasterNonce
    ) internal pure returns (bytes32 orderHash) {
        orderHash = 
            EfficientHash.efficientHashSixteenStep2(
                EfficientHash.efficientHashSixteenStep1(
                    ITEM_OFFER_APPROVAL_HASH,
                    bytes32(uint256(uint8(saleDetails.protocol))),
                    bytes32(uint256(uint160(cosigner))),
                    bytes32(uint256(uint160(signer))),
                    bytes32(uint256(uint160(saleDetails.beneficiary))),
                    bytes32(uint256(uint160(saleDetails.marketplace))),
                    bytes32(uint256(uint160(saleDetails.fallbackRoyaltyRecipient))),
                    bytes32(uint256(uint160(saleDetails.paymentMethod)))
                ),
                bytes32(uint256(uint160(saleDetails.tokenAddress))),
                bytes32(saleDetails.tokenId),
                bytes32(saleDetails.amount),
                bytes32(saleDetails.itemPrice),
                bytes32(saleDetails.expiration),
                bytes32(saleDetails.marketplaceFeeNumerator),
                bytes32(saleDetails.nonce),
                bytes32(makerMasterNonce)
            );
    }

    /**
     * @notice Generates the order hash for a collection offer order.
     *
     * @param saleDetails      The order execution details.
     * @param signer           The address of the signer authorizing the order.
     * @param cosigner         The address of the cosigner authorizing the order.
     * @param makerMasterNonce The master nonce for the maker.
     */
    function _generateCollectionOfferOrderHash(
        Order memory saleDetails,
        address signer,
        address cosigner,
        uint256 makerMasterNonce
    ) internal pure returns (bytes32 orderHash) {
        orderHash = 
            EfficientHash.efficientHashFifteenStep2(
                EfficientHash.efficientHashFifteenStep1(
                    COLLECTION_OFFER_APPROVAL_HASH,
                    bytes32(uint256(uint8(saleDetails.protocol))),
                    bytes32(uint256(uint160(cosigner))),
                    bytes32(uint256(uint160(signer))),
                    bytes32(uint256(uint160(saleDetails.beneficiary))),
                    bytes32(uint256(uint160(saleDetails.marketplace))),
                    bytes32(uint256(uint160(saleDetails.fallbackRoyaltyRecipient))),
                    bytes32(uint256(uint160(saleDetails.paymentMethod)))
                ),
                bytes32(uint256(uint160(saleDetails.tokenAddress))),
                bytes32(saleDetails.amount),
                bytes32(saleDetails.itemPrice),
                bytes32(saleDetails.expiration),
                bytes32(saleDetails.marketplaceFeeNumerator),
                bytes32(saleDetails.nonce),
                bytes32(makerMasterNonce)
            );
    }

    /**
     * @notice Generates the order hash for a token set offer order.
     *
     * @param saleDetails      The order execution details.
     * @param signer           The address of the signer authorizing the order.
     * @param cosigner         The address of the cosigner authorizing the order.
     * @param makerMasterNonce The master nonce for the maker.
     * @param tokenSetProof    The token set proof for the order.
     */
    function _generateTokenSetOfferOrderHash(
        TokenSetProof calldata tokenSetProof,
        Order memory saleDetails,
        address signer,
        address cosigner,
        uint256 makerMasterNonce
    ) internal pure returns (bytes32 orderHash) {
        bytes32 tokenSetRootHash = _generateTokenSetRootHash(saleDetails.tokenAddress, saleDetails.tokenId, tokenSetProof.proof);

        orderHash = 
            EfficientHash.efficientHashSixteenStep2(
                EfficientHash.efficientHashSixteenStep1(
                    TOKEN_SET_OFFER_APPROVAL_HASH,
                    bytes32(uint256(uint8(saleDetails.protocol))),
                    bytes32(uint256(uint160(cosigner))),
                    bytes32(uint256(uint160(signer))),
                    bytes32(uint256(uint160(saleDetails.beneficiary))),
                    bytes32(uint256(uint160(saleDetails.marketplace))),
                    bytes32(uint256(uint160(saleDetails.fallbackRoyaltyRecipient))),
                    bytes32(uint256(uint160(saleDetails.paymentMethod)))
                ),
                bytes32(uint256(uint160(saleDetails.tokenAddress))),
                bytes32(saleDetails.amount),
                bytes32(saleDetails.itemPrice),
                bytes32(saleDetails.expiration),
                bytes32(saleDetails.marketplaceFeeNumerator),
                bytes32(saleDetails.nonce),
                bytes32(makerMasterNonce),
                tokenSetRootHash
            );
    }

    function _generateTokenSetRootHash(
        address tokenAddress,
        uint256 tokenId,
        bytes32[] calldata proof
    ) internal pure returns (bytes32 tokenSetRootHash) {
        tokenSetRootHash = EfficientHash.efficientHash(bytes32(uint256(uint160(tokenAddress))), bytes32(tokenId));
        bytes32 currentProof;
        for (uint256 i; i < proof.length; ++i) {
            currentProof = proof[i];
            if (currentProof < tokenSetRootHash) {
                tokenSetRootHash = EfficientHash.efficientHash(currentProof, tokenSetRootHash);
            } else {
                tokenSetRootHash = EfficientHash.efficientHash(tokenSetRootHash, currentProof);
            }
        }
    }

    /*************************************************************************/
    /*                           Order Validation                            */
    /*************************************************************************/

    /**
     * @notice Loads collection payment settings to validate a single item order.
     * 
     * @dev    This function may be called multiple times during a bulk execution.
     * @dev    Throws when a collection is set to block untrusted channels and the transaction originates 
     * @dev    from an untrusted channel.
     * @dev    Throws when the payment method is not an allowed payment method.
     * @dev    Throws when the sweep order is for ERC721 tokens and the amount is set to a value other than one.
     * @dev    Throws when the sweep order is for ERC1155 tokens and the amount is set to zero.
     * @dev    Throws when the marketplace fee and maximum royalty fee will exceed the sales price of an item.
     * @dev    Throws when the current block time is greater than the order expiration.
     * 
     * @param context     The current execution context to determine the taker.
     * @param saleDetails The order execution details.
     */
    function _validateBasicOrderDetails(
        TradeContext memory context,
        Order memory saleDetails
    ) internal {
        if (saleDetails.protocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL) {
            if (saleDetails.amount != ONE) {
                revert PaymentProcessor__AmountForERC721SalesMustEqualOne();
            }
        } else if (saleDetails.protocol < ORDER_PROTOCOLS_INVALID) {
            if (saleDetails.amount == 0) {
                revert PaymentProcessor__AmountForERC1155SalesGreaterThanZero();
            }
        } else {
            revert PaymentProcessor__InvalidOrderProtocol();
        }

        if (block.timestamp > saleDetails.expiration) {
            revert PaymentProcessor__OrderHasExpired();
        }

        if (saleDetails.marketplaceFeeNumerator + saleDetails.maxRoyaltyFeeNumerator > FEE_DENOMINATOR) {
            revert PaymentProcessor__MarketplaceAndRoyaltyFeesWillExceedSalePrice();
        }

        CollectionPaymentSettings storage paymentSettingsForCollection = 
            appStorage().collectionPaymentSettings[saleDetails.tokenAddress];

        if (!paymentSettingsForCollection.initialized) {
            IPaymentProcessorSettings(address(this)).checkSyncCollectionSettings(saleDetails.tokenAddress);
        }

        PaymentSettings paymentSettings = paymentSettingsForCollection.paymentSettings;
        context.backfillReceiver = paymentSettingsForCollection.royaltyBackfillReceiver;
        context.backfillNumerator = paymentSettingsForCollection.royaltyBackfillNumerator;
        context.bountyNumerator = paymentSettingsForCollection.royaltyBountyNumerator;

        uint8 flags = paymentSettingsForCollection.flags;

        if (_isFlagSet(flags, FLAG_BLOCK_TRADES_FROM_UNTRUSTED_CHANNELS)) {
            if (!_isCollectionTrustedChannel(saleDetails.tokenAddress, context.channel)) {
                revert PaymentProcessor__TradeOriginatedFromUntrustedChannel();
            }
        }

        context.useRoyaltyBackfillAsRoyaltySource = _isFlagSet(flags, FLAG_USE_BACKFILL_AS_ROYALTY_SOURCE);

        context.exclusiveMarketplace = 
            _isFlagSet(flags, FLAG_IS_ROYALTY_BOUNTY_EXCLUSIVE) ?
                appStorage().collectionExclusiveBountyReceivers[saleDetails.tokenAddress] : address(0);
        
        if (paymentSettings == PaymentSettings.DefaultPaymentMethodWhitelist) {
            if (!_isDefaultPaymentMethod(saleDetails.paymentMethod)) {
                revert PaymentProcessor__PaymentCoinIsNotAnApprovedPaymentMethod();
            }
        } else if (paymentSettings == PaymentSettings.CustomPaymentMethodWhitelist) {
            if (!_isWhitelistedPaymentMethod(paymentSettingsForCollection.paymentMethodWhitelistId, saleDetails.paymentMethod)) {
                revert PaymentProcessor__PaymentCoinIsNotAnApprovedPaymentMethod();
            }
        } else if (paymentSettings == PaymentSettings.PricingConstraints || paymentSettings == PaymentSettings.PricingConstraintsCollectionOnly) {
            if (appStorage().collectionConstrainedPricingPaymentMethods[saleDetails.tokenAddress] != saleDetails.paymentMethod) {
                revert PaymentProcessor__PaymentCoinIsNotAnApprovedPaymentMethod();
            }

            _validateSalePriceInRange(
                paymentSettings,
                saleDetails.tokenAddress, 
                saleDetails.tokenId, 
                saleDetails.amount, 
                saleDetails.itemPrice);
        } else if (paymentSettings == PaymentSettings.Paused) {
            revert PaymentProcessor__TradingIsPausedForCollection();
        }

        if (block.timestamp > context.protocolFees.versionExpiration) {
            revert PaymentProcessor__ProtocolFeeVersionExpired();
        }

        if (context.protocolFees.minimumProtocolFeeBps > FEE_DENOMINATOR) {
            revert PaymentProcessor__ProtocolFeeOrTaxExceedsCap();
        }
    }

    /**
     * @notice Validates the sweep order header and returns the sweep execution parameters.
     *
     * @dev    This function may be called multiple times during a bulk execution.
     * @dev    Throws when a collection is set to block untrusted channels and the transaction originates
     * @dev    from an untrusted channel.
     * @dev    Throws when the payment method is not an allowed payment method.
     * @dev    Throws when trading is paused for the collection.
     * 
     * @param context    The current execution context to determine the taker.
     * @param sweepOrder The order information that is common to all items in the sweep.
     */
    function _validateSweepOrderHeader(
        TradeContext memory context,
        SweepOrder memory sweepOrder
    ) internal returns (
        SweepExecutionParams memory params
    ) {
        CollectionPaymentSettings storage paymentSettingsForCollection = 
            appStorage().collectionPaymentSettings[sweepOrder.tokenAddress];

        if (!paymentSettingsForCollection.initialized) {
            IPaymentProcessorSettings(address(this)).checkSyncCollectionSettings(sweepOrder.tokenAddress);
        }

        PaymentSettings paymentSettings = paymentSettingsForCollection.paymentSettings;
        context.backfillReceiver = paymentSettingsForCollection.royaltyBackfillReceiver;
        context.backfillNumerator = paymentSettingsForCollection.royaltyBackfillNumerator;
        context.bountyNumerator = paymentSettingsForCollection.royaltyBountyNumerator;

        uint8 flags = paymentSettingsForCollection.flags;

        if (_isFlagSet(flags, FLAG_BLOCK_TRADES_FROM_UNTRUSTED_CHANNELS)) {
            if (!_isCollectionTrustedChannel(sweepOrder.tokenAddress, context.channel)) {
                revert PaymentProcessor__TradeOriginatedFromUntrustedChannel();
            }
        }
        
        context.useRoyaltyBackfillAsRoyaltySource = _isFlagSet(flags, FLAG_USE_BACKFILL_AS_ROYALTY_SOURCE);

        context.exclusiveMarketplace = 
            _isFlagSet(flags, FLAG_IS_ROYALTY_BOUNTY_EXCLUSIVE) ?
                appStorage().collectionExclusiveBountyReceivers[sweepOrder.tokenAddress] : address(0);

        if (paymentSettings == PaymentSettings.DefaultPaymentMethodWhitelist) {
            if (!_isDefaultPaymentMethod(sweepOrder.paymentMethod)) {
                revert PaymentProcessor__PaymentCoinIsNotAnApprovedPaymentMethod();
            }
        } else if (paymentSettings == PaymentSettings.CustomPaymentMethodWhitelist) {
            if (!_isWhitelistedPaymentMethod(paymentSettingsForCollection.paymentMethodWhitelistId, sweepOrder.paymentMethod)) {
                revert PaymentProcessor__PaymentCoinIsNotAnApprovedPaymentMethod();
            }
        } else if (paymentSettings == PaymentSettings.PricingConstraints || paymentSettings == PaymentSettings.PricingConstraintsCollectionOnly) {
            if (appStorage().collectionConstrainedPricingPaymentMethods[sweepOrder.tokenAddress] != sweepOrder.paymentMethod) {
                revert PaymentProcessor__PaymentCoinIsNotAnApprovedPaymentMethod();
            }
            params.paymentSettings = paymentSettings;
        } else if (paymentSettings == PaymentSettings.Paused) {
            revert PaymentProcessor__TradingIsPausedForCollection();
        }

        params.fnPointers = _getOrderFulfillmentFunctionPointers(Sides.Buy, sweepOrder.paymentMethod, sweepOrder.protocol);
        params.paymentCoin = sweepOrder.paymentMethod;
    }

    /**
     * @notice Validates the sales price for a token is within the bounds set.
     * 
     * @dev    Throws when the unit price is above the ceiling bound.
     * @dev    Throws when the unit price is below the floor bound.
     * 
     * @param tokenAddress The contract address for the token.
     * @param tokenId      The token id.
     * @param amount       The quantity of the token being transacted.
     * @param salePrice    The total price for the token quantity.
     */
    function _validateSalePriceInRange(
        PaymentSettings paymentSettings,
        address tokenAddress, 
        uint256 tokenId, 
        uint256 amount, 
        uint256 salePrice
    ) internal {
        (uint256 floorPrice, uint256 ceilingPrice) = _getFloorAndCeilingPrices(paymentSettings, tokenAddress, tokenId);

        unchecked {
            uint256 unitPrice = salePrice / amount;

            if (unitPrice > ceilingPrice) {
                revert PaymentProcessor__SalePriceAboveMaximumCeiling();
            }

            if (unitPrice < floorPrice) {
                revert PaymentProcessor__SalePriceBelowMinimumFloor();
            }
        }
    }

    /**
     * @notice Returns the floor and ceiling price for a token for collections set to use pricing constraints.
     * 
     * @dev    Returns token pricing bounds if token bounds are set. 
     * @dev    If token bounds are not set then returns collection pricing bounds if they are set.
     * @dev    If collection bounds are not set, returns zero floor bound and uint256 max ceiling bound.
     * 
     * @param tokenAddress The contract address for the token.
     * @param tokenId      The token id.
     */
    function _getFloorAndCeilingPrices(
        PaymentSettings paymentSettings,
        address tokenAddress, 
        uint256 tokenId
    ) internal returns (uint256, uint256) {
        if (paymentSettings == PaymentSettings.PricingConstraints) {
            PricingBounds storage tokenLevelPricingBounds = appStorage().tokenPricingBounds[tokenAddress][tokenId];
            if (!tokenLevelPricingBounds.initialized) {
                return IPaymentProcessorSettings(address(this)).checkSyncTokenPricingBounds(tokenAddress, tokenId);
            }
            if (tokenLevelPricingBounds.isSet) {
                return (tokenLevelPricingBounds.floorPrice, tokenLevelPricingBounds.ceilingPrice);
            }
        }
        
        PricingBounds memory collectionLevelPricingBounds = appStorage().collectionPricingBounds[tokenAddress];
        if (collectionLevelPricingBounds.isSet) {
            return (collectionLevelPricingBounds.floorPrice, collectionLevelPricingBounds.ceilingPrice);
        }

        return (0, type(uint256).max);
    }

    /*************************************************************************/
    /*                           Order Fulfillment                           */
    /*************************************************************************/

    /**
     * @notice Dispenses tokens and proceeds for a single order.
     * 
     * @dev    This function may be called multiple times during a bulk execution.
     * @dev    Throws when a token false to dispense AND partial fills are disabled.
     * @dev    Throws when the taker did not supply enough native funds.
     * @dev    Throws when the fee on top amount is greater than the item price.
     * 
     * @param startingNativeFunds      The amount of native funds remaining at the beginning of the function call.
     * @param context                  The current execution context to determine the taker.
     * @param purchaser                The user that is buying the token.
     * @param seller                   The user that is selling the token.
     * @param paymentCoin              The ERC20 token used for payment, will be zero values for chain native token.
     * @param fnPointers               Struct containing the function pointers for dispensing tokens, sending payments
     *                                 and emitting events.
     * @param saleDetails              The order execution details.
     * @param feeOnTop                 The additional fee on top of the item sales price to be paid by the taker.
     *
     * @return endingNativeFunds       The amount of native funds remaining at the end of the function call.
     */
    function _fulfillSingleOrderWithFeeOnTop(
        uint256 startingNativeFunds,
        TradeContext memory context,
        address purchaser,
        address seller,
        address paymentCoin,
        FulfillOrderFunctionPointers memory fnPointers,
        Order memory saleDetails,
        FeeOnTop calldata feeOnTop
    ) internal returns (uint256 endingNativeFunds) {
        endingNativeFunds = startingNativeFunds;

        if (!fnPointers.funcDispenseToken(
                seller, 
                saleDetails.beneficiary, 
                saleDetails.tokenAddress, 
                saleDetails.tokenId, 
                saleDetails.amount)) {
            if (context.disablePartialFill) {
                revert PaymentProcessor__DispensingTokenWasUnsuccessful();
            } 
            else {
                // Nonce or some amount of fillable quantity was burned during order validation, but the item failed to 
                // fill.  Since partial fills are allowed, restore the nonce because we can't make assumptions about the
                // reason the fill failed. Order books should re-simulate there order for removal from order book if it 
                // failed because a fill is impossible.
                if (saleDetails.protocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
                    _restoreFillableItems(saleDetails.maker, context.orderDigest, saleDetails.amount);
                } else {
                    _restoreNonce(saleDetails.maker, saleDetails.nonce);
                }
            }
        } else {
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

            if (feeOnTopAmount > 0) {
                unchecked {
                    uint256 feeOnTopAmountInfrastructure = feeOnTopAmount * context.protocolFees.feeOnTopProtocolTaxBps / FEE_DENOMINATOR;
                    fnPointers.funcPayout(feeOnTop.recipient, context.taker, paymentCoin, feeOnTopAmount - feeOnTopAmountInfrastructure);
                    
                    if (purchaser == context.taker) {
                        proceeds.infrastructureProceeds += feeOnTopAmountInfrastructure;
                    } else {
                        if (feeOnTopAmountInfrastructure > 0) {
                            fnPointers.funcPayout(context.protocolFees.protocolFeeReceiver, context.taker, paymentCoin, feeOnTopAmountInfrastructure);
                        }
                    }
                }
            }

            if (proceeds.infrastructureProceeds > 0) {
                fnPointers.funcPayout(context.protocolFees.protocolFeeReceiver, purchaser, paymentCoin, proceeds.infrastructureProceeds);
            }

            if (proceeds.royaltyProceeds > 0) {
                fnPointers.funcPayout(proceeds.royaltyRecipient, purchaser, paymentCoin, proceeds.royaltyProceeds);
            }

            if (proceeds.marketplaceProceeds > 0) {
                fnPointers.funcPayout(saleDetails.marketplace, purchaser, paymentCoin, proceeds.marketplaceProceeds);
            }

            if (proceeds.sellerProceeds > 0) {
                fnPointers.funcPayout(seller, purchaser, paymentCoin, proceeds.sellerProceeds);
            }

            fnPointers.funcEmitOrderExecutionEvent(context, saleDetails);
        }
    }

    /**
     * @notice Validates a sweep order and fulfills the order.
     *
     * @dev    Throws when the order protocol is for ERC721 and the amount is not set to one.
     * @dev    Throws when the order protocol is for ERC1155 and the amount is set to zero.
     * @dev    Throws when an invalid order protocol is detected.
     * @dev    Throws when the marketplace fee and maximum royalty fee will exceed the sales price of an item.
     * @dev    Throws when the sale price is outside the pricing constraints.
     * @dev    Throws when the current block time is greater than the order expiration.
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the maker signature is invalid.
     * @dev    Throws when the maker's order nonce has already been used or was cancelled.
     * @dev    Throws when a partially fillable order has already been filled, cancelled or 
     * @dev    cannot be filled with the minimum fillable amount.
     * @dev    Throws when the taker did not supply enough native funds.
     *
     * @param context             The current execution context to determine the taker.
     * @param startingNativeFunds The amount of native funds available at the beginning of the order execution.
     * @param feeOnTop            The additional fee to add on top of the orders, paid by taker.
     * @param sweepOrder          The order information that is common to all items in the sweep.
     * @param items               An array of items that contains the order information unique to each item.
     * @param signedSellOrders    An array of maker signatures authorizing the order execution.
     * @param cosignatures        An array of additional cosignatures for cosigned orders, if applicable.
     * @param params              The sweep execution parameters.
     */
    function _validateAndFulfillSweepOrder(
        TradeContext memory context,
        uint256 startingNativeFunds,
        FeeOnTop calldata feeOnTop,
        SweepOrder calldata sweepOrder,
        SweepItem[] calldata items,
        SignatureECDSA[] memory signedSellOrders,
        Cosignature[] memory cosignatures,
        SweepExecutionParams memory params
    ) internal returns (uint256 endingNativeFunds) {
        endingNativeFunds = startingNativeFunds;

        uint256 sumListingPrices;
        uint256 dispensedPaymentValue;

        for(uint256 itemIndex;itemIndex < items.length;) {
            SweepItem calldata sweepItem = items[itemIndex];
            Order memory saleDetails = Order({
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

            _verifySaleApproval(
                context,
                saleDetails,
                signedSellOrders[itemIndex],
                cosignatures[itemIndex]
            );

            (endingNativeFunds, dispensedPaymentValue) = _dispenseAndPayoutSweepItem(
                context,
                saleDetails, 
                params,
                endingNativeFunds,
                dispensedPaymentValue
            );

            unchecked {
                ++itemIndex;
            }
        }

        if (feeOnTop.amount > sumListingPrices) {
            revert PaymentProcessor__FeeOnTopCannotBeGreaterThanItemPrice();
        }

        endingNativeFunds = _finalizePaymentAccumulatorDisbursement(
            context,
            params,
            feeOnTop,
            dispensedPaymentValue,
            sumListingPrices,
            endingNativeFunds
        );
    }

    /**
     * @notice Finalizes the payment accumulator disbursement for a sweep order.
     * 
     * @dev    Throws if the taker did not supply enough native funds.
     *
     * @param context                The current execution context to determine the taker.
     * @param params                 The sweep execution parameters.
     * @param feeOnTop               The additional fee to add on top of the orders, paid by taker.
     * @param dispensedPaymentValue  The total value of dispensed payments.
     * @param sumListingPrices       The total value of all listings.
     * @param startingNativeFunds    The amount of native funds available at the beginning of the order execution.
     */
    function _finalizePaymentAccumulatorDisbursement(
        TradeContext memory context,
        SweepExecutionParams memory params,
        FeeOnTop calldata feeOnTop,
        uint256 dispensedPaymentValue,
        uint256 sumListingPrices,
        uint256 startingNativeFunds
    ) internal returns (uint256 endingNativeFunds) {
        endingNativeFunds = startingNativeFunds;

        if (feeOnTop.recipient != address(0)) {
            if (feeOnTop.amount > 0) {
                uint256 feeOnTopAmountApp;
                uint256 feeOnTopAmount = feeOnTop.amount * dispensedPaymentValue / sumListingPrices;
                uint256 feeOnTopAmountInfrastructure = feeOnTopAmount * context.protocolFees.feeOnTopProtocolTaxBps / FEE_DENOMINATOR;
                unchecked {
                    feeOnTopAmountApp = feeOnTopAmount - feeOnTopAmountInfrastructure;
                }
                
                if (address(params.paymentCoin) == address(0)) {
                    if (endingNativeFunds < feeOnTopAmount) {
                        revert PaymentProcessor__RanOutOfNativeFunds();
                    }
    
                    unchecked {
                        endingNativeFunds -= feeOnTopAmount;
                    }
                }

                params.fnPointers.funcPayout(
                    feeOnTop.recipient, 
                    context.taker, 
                    params.paymentCoin, 
                    feeOnTopAmountApp
                );

                unchecked {
                    params.accumulator.accumulatedInfrastructureProceeds += feeOnTopAmountInfrastructure;
                }
            }
        }

        if(params.accumulator.accumulatedInfrastructureProceeds > 0) {
            params.fnPointers.funcPayout(
                context.protocolFees.protocolFeeReceiver,
                context.taker, 
                params.paymentCoin, 
                params.accumulator.accumulatedInfrastructureProceeds
            );
        }

        if(params.accumulator.accumulatedRoyaltyProceeds > 0) {
            params.fnPointers.funcPayout(
                params.accumulator.lastRoyaltyRecipient, 
                context.taker, 
                params.paymentCoin, 
                params.accumulator.accumulatedRoyaltyProceeds
            );
        }

        if(params.accumulator.accumulatedMarketplaceProceeds > 0) {
            params.fnPointers.funcPayout(
                params.accumulator.lastMarketplace, 
                context.taker, 
                params.paymentCoin, 
                params.accumulator.accumulatedMarketplaceProceeds
            );
        }

        if(params.accumulator.accumulatedSellerProceeds > 0) {
            params.fnPointers.funcPayout(
                params.accumulator.lastSeller, 
                context.taker, 
                params.paymentCoin, 
                params.accumulator.accumulatedSellerProceeds
            );
        }
    }

    /**
     * @notice Dispenses tokens and proceeds for a single sweep item.
     *
     * @dev    Throws when the taker did not supply enough native funds.
     * @dev    If the token transfer fails, the nonce is restored.
     *
     * @param context              The current execution context to determine the taker.
     * @param saleDetails          The order execution details.
     * @param params               The sweep execution parameters.
     * @param startingNativeFunds  The amount of native funds available at the beginning of the order execution.
     */
    function _dispenseAndPayoutSweepItem(
        TradeContext memory context,
        Order memory saleDetails,
        SweepExecutionParams memory params,
        uint256 startingNativeFunds,
        uint256 startingDispensedPaymentValue
    ) internal returns(
        uint256 endingNativeFunds,
        uint256 endingDispensedPaymentValue
    ) {
        endingNativeFunds = startingNativeFunds;
        endingDispensedPaymentValue = startingDispensedPaymentValue;

        if (params.fnPointers.funcDispenseToken(
                saleDetails.maker, 
                saleDetails.beneficiary, 
                saleDetails.tokenAddress, 
                saleDetails.tokenId, 
                saleDetails.amount)) {
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
        } else {
            if (saleDetails.protocol != ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL) {
                _restoreNonce(saleDetails.maker, saleDetails.nonce);
            }
        }
    }

    /**
     * @notice Calculates the payment splits between seller, creator and marketplace based
     * @notice on on-chain royalty information or backfilled royalty information if on-chain
     * @notice data is unavailable.
     * 
     * @dev    Throws when ERC2981 on-chain royalties are set to an amount greater than the 
     * @dev    maker signed maximum.
     * 
     * @param salePrice                The sale price for the token being sold.
     * @param tokenAddress             The contract address for the token being sold.
     * @param tokenId                  The token id for the token being sold.
     * @param marketplaceFeeRecipient  The address that will receive the marketplace fee. 
     *                                 If zero, no marketplace fee will be applied.
     * @param marketplaceFeeNumerator  The fee numerator for calculating marketplace fees.
     * @param maxRoyaltyFeeNumerator  The maximum royalty fee authorized by the order maker.
     * @param fallbackRoyaltyRecipient The address that will receive royalties if not defined onchain.
     * @param context                  The royalty backfill and bounty information set onchain by the creator.
     *
     * @return proceeds A struct containing the split of payment and receiving addresses for the
     *                  seller, creator and marketplace.
     */
    function _computePaymentSplits(
        TradeContext memory context,
        uint256 salePrice,
        address tokenAddress,
        uint256 tokenId,
        address marketplaceFeeRecipient,
        uint256 marketplaceFeeNumerator,
        uint256 maxRoyaltyFeeNumerator,
        address fallbackRoyaltyRecipient
    ) internal view returns (SplitProceeds memory proceeds) {

        proceeds.sellerProceeds = salePrice;

        bool useBackfill = context.useRoyaltyBackfillAsRoyaltySource;

        address royaltyReceiver;
        uint256 royaltyAmount;
        if(!useBackfill) {
            (
                royaltyReceiver, 
                royaltyAmount, 
                useBackfill
            ) = _safeRoyaltyInfo(tokenAddress, tokenId, salePrice);

            if (royaltyAmount == 0) {
                useBackfill = true;
            }
        }
        unchecked {
            if (useBackfill) {
                // If the token doesn't implement the royaltyInfo function or creator has set
                // the use backfill royalty flag, then check if there are backfilled royalties.
                if (context.backfillReceiver != address(0)) {
                    if (context.backfillNumerator > maxRoyaltyFeeNumerator) {
                        revert PaymentProcessor__OnchainRoyaltiesExceedMaximumApprovedRoyaltyFee();
                    }
        
                    proceeds.royaltyRecipient = context.backfillReceiver;
                    proceeds.royaltyProceeds = 
                        (salePrice * context.backfillNumerator) / FEE_DENOMINATOR;
        
                    proceeds.sellerProceeds -= proceeds.royaltyProceeds;
                } else if (fallbackRoyaltyRecipient != address(0)) {
                    proceeds.royaltyRecipient = fallbackRoyaltyRecipient;
                    proceeds.royaltyProceeds = (salePrice * maxRoyaltyFeeNumerator) / FEE_DENOMINATOR;
        
                    proceeds.sellerProceeds -= proceeds.royaltyProceeds;
                }
            } else {
                if (royaltyReceiver == address(0)) {
                    royaltyAmount = 0;
                }
        
                if (royaltyAmount > 0) {
                    if (royaltyAmount > (salePrice * maxRoyaltyFeeNumerator) / FEE_DENOMINATOR) {
                        revert PaymentProcessor__OnchainRoyaltiesExceedMaximumApprovedRoyaltyFee();
                    }
        
                    proceeds.royaltyRecipient = royaltyReceiver;
                    proceeds.royaltyProceeds = royaltyAmount;
        
                    proceeds.sellerProceeds -= royaltyAmount;
                }
            }

            if (marketplaceFeeRecipient != address(0)) {
                proceeds.marketplaceProceeds = (salePrice * marketplaceFeeNumerator) / FEE_DENOMINATOR;
                proceeds.sellerProceeds -= proceeds.marketplaceProceeds;

                if (context.bountyNumerator > 0) {
                    if (context.exclusiveMarketplace == address(0) || 
                        context.exclusiveMarketplace == marketplaceFeeRecipient) {
                        uint256 royaltyBountyProceeds = 
                            proceeds.royaltyProceeds * context.bountyNumerator / FEE_DENOMINATOR;
                    
                        if (royaltyBountyProceeds > 0) {
                            proceeds.royaltyProceeds -= royaltyBountyProceeds;
                            proceeds.marketplaceProceeds += royaltyBountyProceeds;
                        }
                    }
                }

                proceeds.infrastructureProceeds = 
                    proceeds.marketplaceProceeds * context.protocolFees.marketplaceFeeProtocolTaxBps / FEE_DENOMINATOR;
                proceeds.marketplaceProceeds -= proceeds.infrastructureProceeds;
            }

            uint256 minInfrastructureFee = (salePrice * context.protocolFees.minimumProtocolFeeBps) / FEE_DENOMINATOR;
            if (proceeds.infrastructureProceeds < minInfrastructureFee) {
                uint256 shortfall = minInfrastructureFee - proceeds.infrastructureProceeds;
                if (shortfall > proceeds.sellerProceeds) {
                    proceeds.infrastructureProceeds += proceeds.sellerProceeds;
                    proceeds.sellerProceeds = 0;
                } else {
                    proceeds.sellerProceeds -= shortfall;
                    proceeds.infrastructureProceeds = minInfrastructureFee;
                }
            }
        }
    }

    /**
     * @notice Transfers chain native token to `to`.
     * 
     * @dev    Throws when the native token transfer call reverts.
     *
     * @param to                   The address that will receive chain native tokens.
     * @param proceeds             The amount of chain native token value to transfer.
     */
    function _pushProceeds(address to, uint256 proceeds) internal {
        bool success;

        assembly {
            // Transfer the ETH and store if it succeeded or not.
            success := call(gas(), to, proceeds, 0, 0, 0, 0)
        }

        if (!success) {
            revert PaymentProcessor__FailedToTransferProceeds();
        }
    }

    /**
     * @notice Refunds the taker any unspent native funds.
     * 
     * @param remainingNativeFunds The amount of native funds that were not spent.
     * @param taker                The address that will receive the unspent native funds.
     */
    function _refundUnspentNativeFunds(uint256 remainingNativeFunds, address taker) internal {
        if (remainingNativeFunds > 0) {
            _pushProceeds(taker, remainingNativeFunds);
        }
    }

    /**
     * @notice Transfers chain native token to `payee`.
     * 
     * @dev    Throws when the native token transfer call reverts.
     *
     * @param payee     The address that will receive chain native tokens.
     * @param proceeds  The amount of chain native token value to transfer.
     */
    function _payoutNativeCurrency(
        address payee, 
        address /*payer*/, 
        address /*paymentCoin*/, 
        uint256 proceeds) internal {
        _pushProceeds(payee, proceeds);
    }

    /**
     * @notice Transfers ERC20 tokens to from `payer` to `payee`.
     * 
     * @dev    Throws when the ERC20 transfer call reverts.
     *
     * @param payee The address that will receive ERC20 tokens.
     * @param payer The address the ERC20 tokens will be sent from.
     * @param paymentCoin The ERC20 token being transferred.
     * @param proceeds The amount of token value to transfer.
     */
    function _payoutCoinCurrency(
        address payee, 
        address payer, 
        address paymentCoin, 
        uint256 proceeds) internal {
        if (SafeERC20.safeTransferFrom(paymentCoin, payer, payee, proceeds)) {
            revert PaymentProcessor__FailedToTransferProceeds();
        }
    }

    /**
     * @notice Calls the token contract to transfer an ERC721 token from the seller to the buyer.
     * 
     * @dev    This will **NOT** throw if the transfer fails. It will instead return false
     * @dev    so that the calling function can handle the failed transfer.
     * @dev    Returns true if the transfer does not revert.
     * 
     * @param from         The seller of the token.
     * @param to           The beneficiary of the order execution.
     * @param tokenAddress The contract address for the token being transferred.
     * @param tokenId      The token id for the order.
     */
    function _dispenseERC721Token(
        address from, 
        address to, 
        address tokenAddress, 
        uint256 tokenId, 
        uint256 /*amount*/) internal returns (bool) {
        try IERC721(tokenAddress).transferFrom(from, to, tokenId) {
            return true;
        } catch {
            return false;
        }
    }

    /**
     * @notice Calls the token contract to transfer an ERC1155 token from the seller to the buyer.
     * 
     * @dev    This will **NOT** throw if the transfer fails. It will instead return false
     * @dev    so that the calling function can handle the failed transfer.
     * @dev    Returns true if the transfer does not revert.
     * 
     * @param from         The seller of the token.
     * @param to           The beneficiary of the order execution.
     * @param tokenAddress The contract address for the token being transferred.
     * @param tokenId      The token id for the order.
     * @param amount       The quantity of the token to transfer.
     */
    function _dispenseERC1155Token(
        address from, 
        address to, 
        address tokenAddress, 
        uint256 tokenId, 
        uint256 amount) internal returns (bool) {
        try IERC1155(tokenAddress).safeTransferFrom(from, to, tokenId, amount, "") {
            return true;
        } catch {
            return false;
        }
    }

    /**
     * @notice Emits a a BuyListingERC721 event.
     * 
     * @param context The current execution context to determine the taker.
     * @param saleDetails The order execution details.
     */
    function _emitBuyListingERC721Event(TradeContext memory context, Order memory saleDetails) internal {
        emit BuyListingERC721(
                context.taker,
                saleDetails.maker,
                saleDetails.tokenAddress,
                saleDetails.beneficiary,
                saleDetails.paymentMethod,
                saleDetails.tokenId,
                saleDetails.itemPrice);
    }

    /**
     * @notice Emits a BuyListingERC1155 event.
     * 
     * @param context The current execution context to determine the taker.
     * @param saleDetails The order execution details.
     */
    function _emitBuyListingERC1155Event(TradeContext memory context, Order memory saleDetails) internal {
        emit BuyListingERC1155(
                context.taker,
                saleDetails.maker,
                saleDetails.tokenAddress,
                saleDetails.beneficiary,
                saleDetails.paymentMethod,
                saleDetails.tokenId,
                saleDetails.amount,
                saleDetails.itemPrice);
    }

    /**
     * @notice Emits an AcceptOfferERC721 event.
     * 
     * @param context The current execution context to determine the taker.
     * @param saleDetails The order execution details.
     */
    function _emitAcceptOfferERC721Event(TradeContext memory context, Order memory saleDetails) internal {
        emit AcceptOfferERC721(
                context.taker,
                saleDetails.maker,
                saleDetails.tokenAddress,
                saleDetails.beneficiary,
                saleDetails.paymentMethod,
                saleDetails.tokenId,
                saleDetails.itemPrice);
    }

    /**
     * @notice Emits an AcceptOfferERC1155 event.
     * 
     * @param context The current execution context to determine the taker.
     * @param saleDetails The order execution details.
     */
    function _emitAcceptOfferERC1155Event(TradeContext memory context, Order memory saleDetails) internal {
        emit AcceptOfferERC1155(
                context.taker,
                saleDetails.maker,
                saleDetails.tokenAddress,
                saleDetails.beneficiary,
                saleDetails.paymentMethod,
                saleDetails.tokenId,
                saleDetails.amount,
                saleDetails.itemPrice);
    }

    /**
     * @notice Returns the appropriate function pointers for payouts, dispensing tokens and event emissions.
     *
     * @param side The taker's side of the order.
     * @param paymentMethod The payment method for the order. If address zero, the chain native token.
     * @param orderProtocol The type of token and fill method for the order.
     */
    function _getOrderFulfillmentFunctionPointers(
        Sides side,
        address paymentMethod,
        uint256 orderProtocol
    ) internal pure returns (FulfillOrderFunctionPointers memory orderFulfillmentFunctionPointers) {
        orderFulfillmentFunctionPointers = FulfillOrderFunctionPointers({
            funcPayout: paymentMethod == address(0) ? _payoutNativeCurrency : _payoutCoinCurrency,
            funcDispenseToken: orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? _dispenseERC721Token : _dispenseERC1155Token,
            funcEmitOrderExecutionEvent: orderProtocol == ORDER_PROTOCOLS_ERC721_FILL_OR_KILL ? 
                (side == Sides.Buy ? _emitBuyListingERC721Event : _emitAcceptOfferERC721Event) : 
                (side == Sides.Buy ?_emitBuyListingERC1155Event : _emitAcceptOfferERC1155Event)
        });
    }

    /*************************************************************************/
    /*                        Signature Verification                         */
    /*************************************************************************/

    /**
     * @notice Updates the remaining fillable amount and order status for partially fillable orders.
     * @notice Performs checks for minimum fillable amount and order status.
     *
     * @dev    Throws when the remaining fillable amount is less than the minimum fillable amount requested.
     * @dev    Throws when the order status is not open.
     *
     * @param account             The maker account for the order.
     * @param orderDigest         The hash digest of the order execution details.
     * @param orderStartAmount    The original amount for the partially fillable order.
     * @param requestedFillAmount The amount the taker is requesting to fill.
     * @param minimumFillAmount   The minimum amount the taker is willing to fill.
     *
     * @return quantityToFill     Lesser of remainingFillableAmount and requestedFillAmount.
     */
    function _checkAndUpdateRemainingFillableItems(
        address account,
        bytes32 orderDigest, 
        uint256 orderStartAmount,
        uint256 requestedFillAmount,
        uint256 minimumFillAmount
    ) internal returns (uint256 quantityToFill) {
        if(orderStartAmount > type(uint248).max) {
            revert PaymentProcessor__AmountExceedsMaximum();
        }

        quantityToFill = requestedFillAmount;
        PartiallyFillableOrderStatus storage partialFillStatus = 
            appStorage().partiallyFillableOrderStatuses[account][orderDigest];
    
        if (partialFillStatus.state == PartiallyFillableOrderState.Open) {
            if (partialFillStatus.remainingFillableQuantity == 0) {
                partialFillStatus.remainingFillableQuantity = uint248(orderStartAmount);
                emit OrderDigestOpened(orderDigest, account, orderStartAmount);
            }

            if (quantityToFill > partialFillStatus.remainingFillableQuantity) {
                quantityToFill = partialFillStatus.remainingFillableQuantity;
            }

            if (quantityToFill < minimumFillAmount) {
                revert PaymentProcessor__UnableToFillMinimumRequestedQuantity();
            }

            unchecked {
                partialFillStatus.remainingFillableQuantity -= uint248(quantityToFill);
                emit OrderDigestItemsFilled(orderDigest, account, quantityToFill);
            }

            if (partialFillStatus.remainingFillableQuantity == 0) {
                partialFillStatus.state = PartiallyFillableOrderState.Filled;
                emit OrderDigestInvalidated(orderDigest, account, false);
            }
        } else {
            revert PaymentProcessor__OrderIsEitherCancelledOrFilled();
        }
    }

    /**
     * @notice Restored items to a partially fillable order when the items failed to dispense in a bulk order fill.
     *
     * @param account             The maker account for the order.
     * @param orderDigest         The hash digest of the order execution details.
     * @param unfilledAmount      The amount that was subtracted from the order that needs to be added back.
     *
     */
    function _restoreFillableItems(address account, bytes32 orderDigest, uint256 unfilledAmount) internal {
        if (unfilledAmount > 0) {
            PartiallyFillableOrderStatus storage partialFillStatus = 
                appStorage().partiallyFillableOrderStatuses[account][orderDigest];

            unchecked {
                partialFillStatus.remainingFillableQuantity += uint248(unfilledAmount);
            }

            partialFillStatus.state = PartiallyFillableOrderState.Open;

            emit OrderDigestItemsRestored(orderDigest, account, unfilledAmount);
        }
    }

    /**
     * @notice Invalidates a maker's nonce and emits a NonceInvalidated event.
     * 
     * @dev    Throws when the nonce has already been invalidated.
     * 
     * @param account         The maker account to invalidate `nonce` of.
     * @param nonce           The nonce to invalidate.
     * @param wasCancellation If true, the invalidation is the maker cancelling the nonce. 
     *                        If false, from the nonce being used to execute an order.
     */
    function _checkAndInvalidateNonce(
        address account, 
        uint256 nonce, 
        bool wasCancellation) internal returns (uint256) {

        // The following code is equivalent to, but saves 115 gas units:
        // 
        // mapping(uint256 => uint256) storage ptrInvalidatedSignatureBitmap = 
        //     appStorage().invalidatedSignatures[account];

        // unchecked {
        //     uint256 slot = nonce / 256;
        //     uint256 offset = nonce % 256;
        //     uint256 slotValue = ptrInvalidatedSignatureBitmap[slot];
        // 
        //     if (((slotValue >> offset) & ONE) == ONE) {
        //         revert PaymentProcessor__SignatureAlreadyUsedOrRevoked();
        //     }
        // 
        //     ptrInvalidatedSignatureBitmap[slot] = (slotValue | ONE << offset);
        // }

        unchecked {
            if (uint256(appStorage().invalidatedSignatures[account][uint248(nonce >> 8)] ^= (ONE << uint8(nonce))) & 
                (ONE << uint8(nonce)) == ZERO) {
                revert PaymentProcessor__SignatureAlreadyUsedOrRevoked();
            }
        }

        emit NonceInvalidated(nonce, account, wasCancellation);

        return appStorage().masterNonces[account];
    }

    /**
     * @notice After a maker's nonce is invalidated, should the order item fail to transfer
     *         we need to restore the nonce so order cannot be griefed.  Emits a NonceRestored event.
     * 
     * @dev    Throws when the nonce has already been invalidated.
     * 
     * @param account         The maker account to restore `nonce` of.
     * @param nonce           The nonce to restore.
     */
    function _restoreNonce(address account, uint256 nonce) internal {
        unchecked {
            if (uint256(appStorage().invalidatedSignatures[account][uint248(nonce >> 8)] ^= (ONE << uint8(nonce))) & 
                (ONE << uint8(nonce)) != ZERO) {
                revert PaymentProcessor__SignatureNotUsedOrRevoked();
            }
        }

        emit NonceRestored(nonce, account);
    }

    /**
     * @notice Updates the state of a maker's order to cancelled and remaining fillable quantity to zero.
     *
     * @dev    Throws when the current order state is not open.
     *
     * @param account     The maker account to invalid the order for.
     * @param orderDigest The hash digest of the order to invalidate.
     */
    function _revokeOrderDigest(address account, bytes32 orderDigest) internal {
        PartiallyFillableOrderStatus storage partialFillStatus = 
            appStorage().partiallyFillableOrderStatuses[account][orderDigest];
    
        if (partialFillStatus.state == PartiallyFillableOrderState.Open) {
            partialFillStatus.state = PartiallyFillableOrderState.Cancelled;
            partialFillStatus.remainingFillableQuantity = 0;
            emit OrderDigestInvalidated(orderDigest, account, true);
        } else {
            revert PaymentProcessor__OrderIsEitherCancelledOrFilled();
        }
    }

    /**
     * @notice Invalidates a maker's nonce and emits a NonceInvalidated event.
     *
     * @dev    Skips nonce invalidation for partial fillable orders.
     * @dev    Throws when the nonce has already been invalidated.
     *
     * @param saleDetails The order execution details.
     */
    function _checkAndInvalidateNonceForFillOrKillOrders(
        Order memory saleDetails
    ) internal returns (uint256 masterNonce) {
        masterNonce = 
            saleDetails.protocol == ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL ? 
                appStorage().masterNonces[saleDetails.maker] :
                _checkAndInvalidateNonce(saleDetails.maker, saleDetails.nonce, false);
    }

    /**
     * Verifies offer is approved by the maker.
     *
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the maker signature is invalid.
     * @dev    Throws when the maker's order nonce has already been used or was cancelled.
     * @dev    Throws when a partially fillable order has already been filled, cancelled or 
     * @dev    cannot be filled with the minimum fillable amount.
     * 
     * @param offerType               The type of offer to execute.
     * @param context                 The current execution context to determine the taker.
     * @param saleDetails             The order execution details.
     * @param signature               The order maker's signature.
     * @param cosignature             The cosignature from the order cosigner, if applicable.
     * @param tokenSetProof           The token set proof that contains the root hash for the merkle
     *                                tree of allowed tokens for accepting the maker's offer.
     */
    function _verifyBidOrderSignatures(
        uint256 offerType,
        TradeContext memory context,
        Order memory saleDetails,
        SignatureECDSA memory signature,
        Cosignature memory cosignature,
        TokenSetProof calldata tokenSetProof
    ) internal returns (uint256 quantityToFill) {
        if (offerType == OFFER_TYPE_COLLECTION_OFFER) {
            quantityToFill = _verifyCollectionOffer(
                context, 
                saleDetails, 
                signature, 
                cosignature);
        } else if (offerType == OFFER_TYPE_ITEM_OFFER) {
            quantityToFill = _verifyItemOffer(
                context,
                saleDetails, 
                signature, 
                cosignature);
        } else if (offerType == OFFER_TYPE_TOKEN_SET_OFFER) {
            quantityToFill = _verifyTokenSetOffer(
                context, 
                saleDetails, 
                signature, 
                cosignature,
                tokenSetProof);
        } else {
            revert PaymentProcessor__InvalidOfferType();
        }
    }

    /**
     * @notice Verifies a token offer is approved by the maker.
     *
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the maker signature is invalid.
     * @dev    Throws when the maker's order nonce has already been used or was cancelled.
     * @dev    Throws when a partially fillable order has already been filled, cancelled or 
     * @dev    cannot be filled with the minimum fillable amount.
     *
     * @param context       The current execution context to determine the taker.
     * @param saleDetails   The order execution details.
     * @param signature     The order maker's signature.
     * @param cosignature   The cosignature from the order cosigner, if applicable.
     * 
     * @return quantityToFill The amount of the token that will be filled for this order.
     */
    function _verifyItemOffer(
        TradeContext memory context, 
        Order memory saleDetails,
        SignatureECDSA memory signature,
        Cosignature memory cosignature
    ) internal returns (uint256 quantityToFill) {
        quantityToFill = _verifyOrderSignatures(
            context, 
            saleDetails, 
            signature, 
            cosignature, 
            _generateItemOfferOrderHash(
                saleDetails,
                saleDetails.maker,
                cosignature.signer,
                _checkAndInvalidateNonceForFillOrKillOrders(saleDetails)
            )
        );
    }

    /**
     * @notice Verifies a collection offer is approved by the maker.
     *
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the maker signature is invalid.
     * @dev    Throws when the maker's order nonce has already been used or was cancelled.
     * @dev    Throws when a partially fillable order has already been filled, cancelled or 
     * @dev    cannot be filled with the minimum fillable amount.
     *
     * @param context       The current execution context to determine the taker.
     * @param saleDetails   The order execution details.
     * @param signature     The order maker's signature.
     * @param cosignature   The cosignature from the order cosigner, if applicable.
     * 
     * @return quantityToFill The amount of the token that will be filled for this order.
     */
    function _verifyCollectionOffer(
        TradeContext memory context, 
        Order memory saleDetails,
        SignatureECDSA memory signature,
        Cosignature memory cosignature
    ) internal returns (uint256 quantityToFill) {
        quantityToFill = _verifyOrderSignatures(
            context, 
            saleDetails, 
            signature, 
            cosignature, 
            _generateCollectionOfferOrderHash(
                saleDetails,
                saleDetails.maker,
                cosignature.signer,
                _checkAndInvalidateNonceForFillOrKillOrders(saleDetails)
            )
        );
    }

    /**
     * @notice Verifies a token set offer is approved by the maker.
     *
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the maker signature is invalid.
     * @dev    Throws when the maker's order nonce has already been used or was cancelled.
     * @dev    Throws when a partially fillable order has already been filled, cancelled or 
     * @dev    cannot be filled with the minimum fillable amount.
     *
     * @param context       The current execution context to determine the taker.
     * @param saleDetails   The order execution details.
     * @param signature     The order maker's signature.
     * @param tokenSetProof The token set proof that contains the root hash for the merkle  
     *                      tree of allowed tokens for accepting the maker's offer.
     * @param cosignature   The cosignature from the order cosigner, if applicable.
     * 
     * @return quantityToFill The amount of the token that will be filled for this order.
     */
    function _verifyTokenSetOffer(
        TradeContext memory context, 
        Order memory saleDetails,
        SignatureECDSA memory signature,
        Cosignature memory cosignature,
        TokenSetProof calldata tokenSetProof
    ) internal returns (uint256 quantityToFill) {
        bytes32 orderHash = 
            _generateTokenSetOfferOrderHash(
                tokenSetProof,
                saleDetails,
                saleDetails.maker,
                cosignature.signer,
                _checkAndInvalidateNonceForFillOrKillOrders(saleDetails)
            );

        quantityToFill = _verifyOrderSignatures(
            context, 
            saleDetails, 
            signature, 
            cosignature, 
            orderHash
        );
    }

    /**
     * @notice Verifies a listing is approved by the maker.
     *
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the maker signature is invalid.
     * @dev    Throws when the maker's order nonce has already been used or was cancelled.
     * @dev    Throws when a partially fillable order has already been filled, cancelled or 
     * @dev    cannot be filled with the minimum fillable amount.
     *
     * @param context     The current execution context to determine the taker.
     * @param saleDetails The order execution details.
     * @param signature   The order maker's signature.
     * @param cosignature The cosignature from the order cosigner, if applicable.
     * 
     * @return quantityToFill The amount of the token that will be filled for this order.
     */
    function _verifySaleApproval(
        TradeContext memory context, 
        Order memory saleDetails,
        SignatureECDSA memory signature,
        Cosignature memory cosignature
    ) internal returns (uint256 quantityToFill) {
        quantityToFill = _verifyOrderSignatures(
            context, 
            saleDetails, 
            signature, 
            cosignature, 
            _generateListingOrderHash(
                saleDetails,
                saleDetails.maker,
                cosignature.signer,
                _checkAndInvalidateNonceForFillOrKillOrders(saleDetails)
            )
        );
    }

    /**
     * @notice Verifies a listing is approved by the maker.
     *
     * @dev    Throws when a cosignature is required and the cosignature is invalid.
     * @dev    Throws when the maker signature is invalid.
     * @dev    Throws when the maker's order nonce has already been used or was cancelled.
     * @dev    Throws when a partially fillable order has already been filled, cancelled or
     * @dev    cannot be filled with the minimum fillable amount.
     *
     * @param context     The current execution context to determine the taker.
     * @param saleDetails The order execution details.
     * @param signature   The order maker's signature.
     * @param cosignature The cosignature from the order cosigner, if applicable.
     * @param orderHash   The hash digest of the order execution details.
     */
    function _verifyOrderSignatures(
        TradeContext memory context,
        Order memory saleDetails,
        SignatureECDSA memory signature,
        Cosignature memory cosignature,
        bytes32 orderHash
    ) internal returns (uint256 quantityToFill) {
        if (cosignature.signer != address(0)) {
            _verifyCosignature(context, signature, cosignature);
        }

         bytes32 orderDigest = _hashTypedDataV4(_cachedDomainSeparator, orderHash);

        _verifyMakerSignature(saleDetails.maker, signature, orderDigest);

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
     * @notice Reverts a transaction when the recovered signer is not the order maker.
     *
     * @dev Throws when the recovered signer for the `signature` and `digest` does not match the order maker AND
     * @dev - The maker address does not have deployed code, OR 
     * @dev - The maker contract does not return the correct ERC1271 value to validate the signature.
     *
     * @param maker The adress for the order maker.
     * @param signature The order maker's signature.
     * @param digest The hash digest of the order.
     */
    function _verifyMakerSignature(address maker, SignatureECDSA memory signature, bytes32 digest ) internal view {
        (bool isError, address signer) = _tryEcdsaRecover(digest, signature.v, signature.r, signature.s);
        if (maker != signer || isError) {
            if (maker.code.length > 0) {
                _verifyEIP1271Signature(maker, digest, signature);
            } else {
                revert PaymentProcessor__UnauthorizedOrder();
            }
        }
    }

    /**
     * @notice Reverts the transaction when a supplied cosignature is not valid.
     *
     * @dev    Throws when the current block timestamp is greater than the cosignature expiration.
     * @dev    Throws when the order taker does not match the cosignature taker.
     * @dev    Throws when the cosigner has self-destructed their account.
     * @dev    Throws when the recovered address for the cosignature does not match the cosigner address.
     * 
     * @param context     The current execution context to determine the order taker.
     * @param signature   The order maker's signature.
     * @param cosignature The cosignature from the order cosigner.
     */
    function _verifyCosignature(
        TradeContext memory context, 
        SignatureECDSA memory signature, 
        Cosignature memory cosignature
    ) internal view {
        if (block.timestamp > cosignature.expiration) {
            revert PaymentProcessor__CosignatureHasExpired();
        }

        if (context.taker != cosignature.taker) {
            revert PaymentProcessor__UnauthorizedTaker();
        }

        if (appStorage().destroyedCosigners[cosignature.signer]) {
            revert PaymentProcessor__CosignerHasSelfDestructed();
        }

        if (cosignature.signer != _ecdsaRecover(
            _hashTypedDataV4(
                _cachedDomainSeparator, 
                EfficientHash.efficientHash(
                    COSIGNATURE_HASH,
                    bytes32(signature.v),
                    signature.r,
                    signature.s,
                    bytes32(cosignature.expiration),
                    bytes32(uint256(uint160(cosignature.taker)))
                )
            ), 
            cosignature.v, 
            cosignature.r, 
            cosignature.s)) {
            revert PaymentProcessor__NotAuthorizedByCosigner();
        }
    }

    /**
     * @notice Reverts the transaction if the contract at `signer` does not return the ERC1271
     * @notice isValidSignature selector when called with `hash`.
     * 
     * @dev    Throws when attempting to verify a signature from an address that has deployed
     * @dev    contract code using ERC1271 and the contract does not return the isValidSignature
     * @dev    function selector as its return value.
     *
     * @param signer The signer address for a maker order that has deployed contract code.
     * @param hash The ERC712 hash value of the order.
     * @param signature The signature for the order hash.
     */
    function _verifyEIP1271Signature(
        address signer, 
        bytes32 hash, 
        SignatureECDSA memory signature
    ) internal view {
        if (!_safeIsValidSignature(signer, hash, signature.v, signature.r, signature.s)) {
            revert PaymentProcessor__EIP1271SignatureInvalid();
        }
    }

    /**
     * @notice A gas efficient, and fallback-safe way to call the isValidSignature function for EIP-1271.
     *
     * @param signer     The EIP-1271 signer to call to check for a valid signature.
     * @param hash       The hash digest to verify with the EIP-1271 signer.
     * @param v         The `v` value of the signature
     * @param r         The `r` value of the signature
     * @param s         The `s` value of the signature
     * 
     * @return isValid   True if the EIP-1271 signer returns the EIP-1271 magic value.
     */
    function _safeIsValidSignature(
        address signer,
        bytes32 hash,
        uint256 v,
        bytes32 r,
        bytes32 s
    ) private view returns(bool isValid) {
        if (v > type(uint8).max) {
            revert PaymentProcessor__InvalidSignatureV();
        }

        assembly {
            function _callIsValidSignature(_signer, _hash, _r, _s, _v) -> _isValid {
                let ptr := mload(0x40)
                // store isValidSignature(bytes32,bytes) selector
                mstore(ptr, hex"1626ba7e")
                // store bytes32 hash value in abi encoded location
                mstore(add(ptr, 0x04), _hash)
                // store abi encoded location of the bytes signature data
                mstore(add(ptr, 0x24), 0x40)
                // store bytes signature length
                mstore(add(ptr, 0x44), 0x41)
                // store the signature `_r`, `_v` and `_s` in memory
                // `_v` is stored before `_s` to avoid shifting
                mstore(add(ptr, 0x64), _r)
                mstore(add(ptr, 0x85), _v)
                mstore(add(ptr, 0x84), _s)
                // update free memory pointer, 0xC4 is the length of calldata
                mstore(0x40, add(ptr, 0xC4))

                // static call _signer with abi encoded data
                // skip return data check if call failed or return data size is not at least 32 bytes
                if and(iszero(lt(returndatasize(), 0x20)), staticcall(gas(), _signer, ptr, 0xC4, 0x00, 0x20)) {
                    // check if return data is equal to isValidSignature magic value
                    _isValid := eq(mload(0x00), hex"1626ba7e")
                    leave
                }
            }
            isValid := _callIsValidSignature(signer, hash, r, s, v)
        }
    }

    /**
     * @notice Recovers the signer address from a hash and signature.
     * 
     * @dev Throws when `v` is greater than `type(uint8).max`.
     * @dev Throws when the recovered address is zero.
     *
     * @param digest The hash digest that was signed.
     * @param v The v-value of the signature.
     * @param r The r-value of the signature.
     * @param s The s-value of the signature.
     *
     * @return signer The recovered signer address from the signature.
     */
    function _ecdsaRecover(
        bytes32 digest, 
        uint256 v, 
        bytes32 r, 
        bytes32 s
    ) internal pure returns (address signer) {
        bool isError;
        (isError, signer) = _tryEcdsaRecover(digest, v, r, s);
        if(isError) {
            revert PaymentProcessor__UnauthorizedOrder();
        }
    }

    /**
     * @notice Recovers the signer address from a hash and signature.
     * 
     * @dev     Does **NOT** revert if invalid input values are provided or `signer` is recovered as address(0)
     * @dev     Returns an `isError` value in those conditions that is handled upstream
     *
     * @param digest The hash digest that was signed.
     * @param v The v-value of the signature.
     * @param r The r-value of the signature.
     * @param s The s-value of the signature.
     *
     * @return isError  True if the ECDSA function is provided invalid inputs
     * @return signer   The recovered signer address from the signature.
     */
    function _tryEcdsaRecover(
        bytes32 digest, 
        uint256 v, 
        bytes32 r, 
        bytes32 s
    ) internal pure returns (bool isError, address signer) {
        if (v > type(uint8).max) {
            return (true, address(0));
        }

        signer = ecrecover(digest, uint8(v), r, s);
        isError = (signer == address(0));
    }

    /**
     * @notice Returns the EIP-712 hash digest for `domainSeparator` and `structHash`.
     * 
     * @param domainSeparator The domain separator for the EIP-712 hash.
     * @param structHash The hash of the EIP-712 struct.
     */
    function _hashTypedDataV4(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
        return ECDSA.toTypedDataHash(domainSeparator, structHash);
    }

    /*************************************************************************/
    /*                             Miscellaneous                             */
    /*************************************************************************/

    /**
     * @notice Pulls settings from the CollectionSettingsRegistry contract and updates the
     * @notice applicable cached collection settings in the PaymentProcessor contract.
     * 
     * @param tokenAddress The contract address for the token to update settings for.
     */
    function _syncCollectionSettings(address tokenAddress) internal {
        bytes32[] memory noExtensions;

        (
            CollectionRegistryPaymentSettings memory collectionCoreSettings,
            RegistryPricingBounds memory collectionPricingBounds,
            address constrainedPricingPaymentMethod,
            address exclusiveBountyReceiver,,
        ) = ICollectionSettingsRegistry(collectionSettingsRegistry).getCollectionSettings(tokenAddress, noExtensions, noExtensions);

        uint8 flags = uint8(collectionCoreSettings.extraData);

        appStorage().collectionPaymentSettings[tokenAddress] = CollectionPaymentSettings({
            initialized: true,
            paymentSettings: PaymentSettings(collectionCoreSettings.paymentSettingsType),
            paymentMethodWhitelistId: collectionCoreSettings.paymentMethodWhitelistId,
            royaltyBackfillReceiver: collectionCoreSettings.royaltyBackfillReceiver,
            royaltyBackfillNumerator: collectionCoreSettings.royaltyBackfillNumerator,
            royaltyBountyNumerator: collectionCoreSettings.royaltyBountyNumerator,
            flags: flags
        });

        if (PaymentSettings(collectionCoreSettings.paymentSettingsType) == PaymentSettings.PricingConstraints ||
            PaymentSettings(collectionCoreSettings.paymentSettingsType) == PaymentSettings.PricingConstraintsCollectionOnly) {
            appStorage().collectionConstrainedPricingPaymentMethods[tokenAddress] = constrainedPricingPaymentMethod;
            PricingBounds memory currentPricingBounds = appStorage().collectionPricingBounds[tokenAddress];
            
            if(!(currentPricingBounds.isSet == collectionPricingBounds.isSet &&
                currentPricingBounds.floorPrice == collectionPricingBounds.floorPrice &&
                currentPricingBounds.ceilingPrice == collectionPricingBounds.ceilingPrice)
            ) {
                appStorage().collectionPricingBounds[tokenAddress] = PricingBounds({
                    initialized: true,
                    isSet: collectionPricingBounds.isSet,
                    floorPrice: collectionPricingBounds.floorPrice,
                    ceilingPrice: collectionPricingBounds.ceilingPrice
                });

                emit UpdatedCollectionLevelPricingBoundaries(
                    tokenAddress, 
                    collectionPricingBounds.floorPrice, 
                    collectionPricingBounds.ceilingPrice);
            }
        }

        if (_isFlagSet(flags, FLAG_IS_ROYALTY_BOUNTY_EXCLUSIVE)) {
            appStorage().collectionExclusiveBountyReceivers[tokenAddress] = exclusiveBountyReceiver;
        }

        emit UpdatedCollectionPaymentSettings(
            tokenAddress, 
            PaymentSettings(collectionCoreSettings.paymentSettingsType), 
            collectionCoreSettings.paymentMethodWhitelistId,
            constrainedPricingPaymentMethod,
            collectionCoreSettings.royaltyBackfillNumerator,
            collectionCoreSettings.royaltyBackfillReceiver,
            collectionCoreSettings.royaltyBountyNumerator,
            exclusiveBountyReceiver,
            _isFlagSet(flags, FLAG_BLOCK_TRADES_FROM_UNTRUSTED_CHANNELS),
            _isFlagSet(flags, FLAG_USE_BACKFILL_AS_ROYALTY_SOURCE));
    }

    /**
     * @notice Reverts the transaction if the caller is not the CollectionSettingsRegistry or the contract itself.
     */
    function _requireCallerIsCollectionSettingsRegistryOrSelf() internal view {
        if(!(msg.sender == collectionSettingsRegistry || msg.sender == address(this))) {
            revert PaymentProcessor__CallerIsNotSettingsRegistryOrSelf();
        }
    }

    /**
     * @notice Returns true if the `flagValue` has the `flag` set, false otherwise.
     *
     * @dev    This function uses the bitwise AND operator to check if the `flag` is set in `flagValue`.
     *
     * @param flagValue  The value to check for the presence of the `flag`.
     * @param flag       The flag to check for in the `flagValue`.
     */
    function _isFlagSet(uint8 flagValue, uint8 flag) internal pure returns (bool flagSet) {
        flagSet = (flagValue & flag) != 0;
    }

    /**
     * @notice Sets the `flag` in `flagValue` to `flagSet` and returns the updated value.
     * 
     * @dev    This function uses the bitwise OR and AND operators to set or unset the `flag` in `flagValue`.
     *
     * @param flagValue The value to set the `flag` in.
     * @param flag      The flag to set in the `flagValue`.
     * @param flagSet   True to set the `flag`, false to unset the `flag`.
     */
    function _setFlag(uint8 flagValue, uint8 flag, bool flagSet) internal pure returns (uint8) {
        if(flagSet) {
            return (flagValue | flag);
        } else {
            unchecked {
                return (flagValue & (255 - flag));
            }
        }
    }

    /**
     * @notice A gas efficient, and fallback-safe way to call the royaltyInfo function on a token contract.
     *
     * @dev    This will get the royaltyInfo if it exists - and when the function is unimplemented, the
     * @dev    presence of a fallback function will not result in halted execution.
     * 
     * @param  tokenAddress The contract address of the token to check for royalties.
     * @param  tokenId      The token ID to check for royalties.
     * @param  salePrice    The sale price of the token.
     */
    function _safeRoyaltyInfo(
        address tokenAddress, 
        uint256 tokenId, 
        uint256 salePrice
    ) internal view returns(address receiver, uint256 royaltyAmount, bool isError) {
        assembly {
            function _callRoyaltyInfo(_tokenAddress, _tokenId, _salePrice) -> _receiver, _royaltyAmount, _isError {
                let ptr := mload(0x40)
                mstore(0x40, add(ptr, 0x60))
                mstore(ptr, 0x2a55205a)
                mstore(add(0x20, ptr), _tokenId)
                mstore(add(0x40, ptr), _salePrice)
                if and(iszero(lt(returndatasize(), 0x40)), staticcall(gas(), _tokenAddress, add(ptr, 0x1C), 0x44, 0x00, 0x40)) {
                    _receiver := mload(0x00)
                    _royaltyAmount := mload(0x20)
                    leave
                }
                _isError := true
            }
            receiver, royaltyAmount, isError := _callRoyaltyInfo(tokenAddress, tokenId, salePrice)
        }
    }

    /**
     * @notice A gas efficient, and fallback-safe way to call the owner function on a token contract.
     *
     * @dev    This will get the owner if it exists - and when the function is unimplemented, the
     * @dev    presence of a fallback function will not result in halted execution.
     *
     * @param tokenAddress The contract address of the token to check for the owner.
     */
    function _safeOwner(
        address tokenAddress
    ) internal view returns(address owner, bool isError) {
        assembly {
            function _callOwner(_tokenAddress) -> _owner, _isError {
                mstore(0x00, 0x8da5cb5b)
                if and(iszero(lt(returndatasize(), 0x20)), staticcall(gas(), _tokenAddress, 0x1C, 0x04, 0x00, 0x20)) {
                    _owner := mload(0x00)
                    leave
                }
                _isError := true
            }
            owner, isError := _callOwner(tokenAddress)
        }
    }
    
    /**
     * @notice A gas efficient, and fallback-safe way to call the hasRole function on a token contract.
     *
     * @dev    This will check if the account `hasRole` if `hasRole` exists - and when the function is unimplemented, the
     * @dev    presence of a fallback function will not result in halted execution.
     *
     * @param tokenAddress The contract address of the token to check for the role.
     * @param role         The role to check for.
     * @param account      The account to check for the role.
     */
    function _safeHasRole(
        address tokenAddress,
        bytes32 role,
        address account
    ) internal view returns(bool hasRole, bool isError) {
        assembly {
            function _callHasRole(_tokenAddress, _role, _account) -> _hasRole, _isError {
                let ptr := mload(0x40)
                mstore(0x40, add(ptr, 0x60))
                mstore(ptr, 0x91d14854)
                mstore(add(0x20, ptr), _role)
                mstore(add(0x40, ptr), _account)
                if and(iszero(lt(returndatasize(), 0x20)), staticcall(gas(), _tokenAddress, add(ptr, 0x1C), 0x44, 0x00, 0x20)) {
                    _hasRole := mload(0x00)
                    leave
                }
                _isError := true
            }
            hasRole, isError := _callHasRole(tokenAddress, role, account)
        }
    }

    
    /**
     * @notice Returns the taker for a transaction with trusted forwarder context if appended data length is 20 bytes.
     *
     * @dev    Throws when appended data length is not zero or 20 bytes.
     * 
     * @param appendedDataLength  The length of extra calldata sent with a transaction.
     * 
     * @return taker  The address of the taker for the transaction.
     */
    function _getTaker(
        uint256 appendedDataLength
    ) internal view returns(address taker) {
        taker = msg.sender;
        if (appendedDataLength > 0) {
            if (appendedDataLength != 20) revert PaymentProcessor__BadCalldataLength();
            taker = _msgSender();
        }
    }
}