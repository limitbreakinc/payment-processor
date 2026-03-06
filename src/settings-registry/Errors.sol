//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

/// @dev Thrown when ownership of a payment method whitelist is transferred to the zero address.
error CollectionSettingsRegistry__PaymentMethodWhitelistOwnershipCannotBeTransferredToZeroAddress();

/// @dev Thrown when a payment method whitelist is referenced that does not exist.
error CollectionSettingsRegistry__PaymentMethodWhitelistDoesNotExist();

/// @dev Thrown when a royalty bounty numerator exceeds the fee denominator.
error CollectionSettingsRegistry__RoyaltyBountyNumeratorCannotExceedFeeDenominator();

/// @dev Thrown when a royalty backfill numerator exceeds the fee denominator.
error CollectionSettingsRegistry__RoyaltyBackfillNumeratorCannotExceedFeeDenominator();

/// @dev Thrown when a function requires the caller to have owner or admin privileges.
error CollectionSettingsRegistry__CallerMustHaveElevatedPermissionsForSpecifiedNFT();

/// @dev Thrown when a function requires the caller owns a payment method whitelist.
error CollectionSettingsRegistry__CallerDoesNotOwnPaymentMethodWhitelist();

/// @dev Thrown when the ceiling price is trying to be set lower than the floor price.
error CollectionSettingsRegistry__CeilingPriceMustBeGreaterThanFloorPrice();

/// @dev Thrown when a provided array is empty.
error CollectionSettingsRegistry__InputArrayLengthCannotBeZero();

/// @dev Thrown when the lengths of two arrays do not match.
error CollectionSettingsRegistry__InputArrayLengthMismatch();

/// @dev Thrown when a sync is attempted to remove a whitelisted payment method that is still approved.
error CollectionSettingsRegistry__CannotSyncRemovalOfWhitelistedPaymentMethod();

/// @dev Thrown when a function requires the caller to own a trusted permit processor list.
error CollectionSettingsRegistry__CallerDoesNotOwnTrustedPermitProcessorList();

/// @dev Thrown when a payment method whitelist is in an invalid state.
error CollectionSettingsRegistry__PaymentMethodWhitelistInvalidState();