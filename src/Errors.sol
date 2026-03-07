//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

/// @dev Thrown when an order is an ERC721 order and the amount is not one.
error PaymentProcessor__AmountForERC721SalesMustEqualOne();

/// @dev Thrown when an order is an ERC1155 order and the amount is zero.
error PaymentProcessor__AmountForERC1155SalesGreaterThanZero();

/// @dev Thrown when processing a permitted order and the order amount exceeds type(uint248).max
error PaymentProcessor__AmountExceedsMaximum();

/// @dev Thrown when appended data length is not zero or twenty bytes.
error PaymentProcessor__BadCalldataLength();

/// @dev Thrown when an offer is being accepted and the payment method is the chain native token.
error PaymentProcessor__BadPaymentMethod();

/**
 * @dev Thrown when a call is made to a function that must be called by the Collection Settings Registry 
 * @dev or by a self call from Payment Processor and the caller is not either of those addresses.
 */
error PaymentProcessor__CallerIsNotSettingsRegistryOrSelf();

/**
 * @dev Thrown when modifying collection payment settings, pricing bounds, or trusted channels on a collection
 * @dev that the caller is not the owner of or a member of the default admin role for.
 */
error PaymentProcessor__CallerMustHaveElevatedPermissionsForSpecifiedNFT();

/// @dev Thrown when the current block time is greater than the expiration time for the cosignature.
error PaymentProcessor__CosignatureHasExpired();

/// @dev Thrown when the cosigner has self destructed.
error PaymentProcessor__CosignerHasSelfDestructed();

/// @dev Thrown when a token failed to transfer to the beneficiary and partial fills are disabled.
error PaymentProcessor__DispensingTokenWasUnsuccessful();

/// @dev Thrown when a maker is a contract and the contract does not return the correct EIP1271 response to validate the signature.
error PaymentProcessor__EIP1271SignatureInvalid();

/// @dev Thrown when a native token transfer call fails to transfer the tokens.
error PaymentProcessor__FailedToTransferProceeds();

/// @dev Thrown when the additional fee on top exceeds the item price.
error PaymentProcessor__FeeOnTopCannotBeGreaterThanItemPrice();

/// @dev Thrown when the supplied root hash, token and proof do not match.
error PaymentProcessor__IncorrectTokenSetMerkleProof();

/// @dev Thrown when an input array has zero items in a location where it must have items.
error PaymentProcessor__InputArrayLengthCannotBeZero();

/// @dev Thrown when multiple input arrays have different lengths but are required to be the same length.
error PaymentProcessor__InputArrayLengthMismatch();

/// @dev Thrown when the height of the bulk order tree is either 0 or greater than 12.
error PaymentProcessor__InvalidBulkOrderHeight();

/// @dev Thrown when Payment Processor or a module is being deployed with invalid constructor arguments.
error PaymentProcessor__InvalidConstructorArguments();

/// @dev Thrown when an offer type parameter is not a valid offer type.
error PaymentProcessor__InvalidOfferType();

/// @dev Thrown when an order protocol parameter is not a valid order protocol type.
error PaymentProcessor__InvalidOrderProtocol();

/// @dev Thrown when a signature `v` value is greater than 255.
error PaymentProcessor__InvalidSignatureV();

/// @dev Thrown when the combined marketplace and royalty fees will exceed the item price.
error PaymentProcessor__MarketplaceAndRoyaltyFeesWillExceedSalePrice();

/// @dev Thrown when the version expiration grace period is exceeded.
error PaymentProcessor__MaxGracePeriodExceeded();

/// @dev Thrown when the recovered address from a cosignature does not match the order cosigner.
error PaymentProcessor__NotAuthorizedByCosigner();

/// @dev Thrown when the ERC2981 or backfilled royalties exceed the maximum fee specified by the order maker.
error PaymentProcessor__OnchainRoyaltiesExceedMaximumApprovedRoyaltyFee();

/// @dev Thrown when the current block timestamp is greater than the order expiration time.
error PaymentProcessor__OrderHasExpired();

/// @dev Thrown when attempting to fill a partially fillable order that has already been filled or cancelled.
error PaymentProcessor__OrderIsEitherCancelledOrFilled();

/// @dev Thrown when attempting to execute a sweep order for partially fillable orders.
error PaymentProcessor__OrderProtocolERC1155FillPartialUnsupportedInSweeps();

/// @dev Thrown when attempting to partially fill an order where the item price is not equally divisible by the amount of tokens.
error PaymentProcessor__PartialFillsNotSupportedForNonDivisibleItems();

/// @dev Thrown when attempting to execute an order with a payment method that is not allowed by the collection payment settings.
error PaymentProcessor__PaymentCoinIsNotAnApprovedPaymentMethod();

/// @dev Thrown when both a permit and a bulk order proof are submitted for an order, as these features are incompatible.
error PaymentProcessor__PermitsAreNotCompatibleWithBulkOrders();

/// @dev Thrown when attempting to use an untrusted permit processing system.
error PaymentProcessor__PermitProcessorNotTrusted();

/// @dev Thrown when the protocol fee is set to a value exceeding the maximum fee cap.
error PaymentProcessor__ProtocolFeeOrTaxExceedsCap();

/// @dev Thrown when the protocol fee version is expired.
error PaymentProcessor__ProtocolFeeVersionExpired();

/// @dev Thrown when distributing payments and fees in native token and the amount remaining is less than the amount to distribute.
error PaymentProcessor__RanOutOfNativeFunds();

/// @dev Thrown when a collection is set to pricing constraints and the item price exceeds the defined maximum price.
error PaymentProcessor__SalePriceAboveMaximumCeiling();

/// @dev Thrown when a collection is set to pricing constraints and the item price is below the defined minimum price.
error PaymentProcessor__SalePriceBelowMinimumFloor();

/// @dev Thrown when a maker's nonce has already been used for an executed order or cancelled by the maker.
error PaymentProcessor__SignatureAlreadyUsedOrRevoked();

/// @dev Thrown when a maker's nonce has not already been used for an executed order but an item with that nonce fails to fill.
error PaymentProcessor__SignatureNotUsedOrRevoked();

/**
 * @dev Thrown when a collection is set to block untrusted channels and the order execution originates from a channel 
 * @dev that is not in the collection's trusted channel list.
 */ 
error PaymentProcessor__TradeOriginatedFromUntrustedChannel();

/// @dev Thrown when a trading of a specific collection has been paused by the collection owner or admin.
error PaymentProcessor__TradingIsPausedForCollection();

/**
 * @dev Thrown when attempting to fill a partially fillable order and the amount available to fill 
 * @dev is less than the specified minimum to fill.
 */
error PaymentProcessor__UnableToFillMinimumRequestedQuantity();

/// @dev Thrown when the recovered signer for an order does not match the order maker.
error PaymentProcessor__UnauthorizedOrder();

/// @dev Thrown when the taker on a cosigned order does not match the taker on the cosignature.
error PaymentProcessor__UnauthorizedTaker();

/// @dev Thrown when the Payment Processor or a module is being deployed with uninitialized configuration values.
error PaymentProcessor__UninitializedConfiguration();