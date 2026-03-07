//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;


/**
 * @dev This struct defines the payment settings for a collection.
 * 
 * @dev **initialized**: True if the payment settings have been initialized, false otherwise.
 * @dev **paymentSettingsType**: The type of payment settings for the collection.
 * @dev **paymentMethodWhitelistId**: The ID of the payment method whitelist to use for the collection.
 * @dev **royaltyBackfillReceiver**: The address to use as the royalty backfill receiver.
 * @dev **royaltyBackfillNumerator**: The numerator to use for the royalty backfill.
 * @dev **royaltyBountyNumerator**: The numerator to use for the royalty bounty.
 * @dev **extraData**: Extra data for the payment settings.
 */
struct CollectionRegistryPaymentSettings {
    bool initialized;
    uint8 paymentSettingsType;
    uint32 paymentMethodWhitelistId;
    address royaltyBackfillReceiver;
    uint16 royaltyBackfillNumerator;
    uint16 royaltyBountyNumerator;
    uint16 extraData;
}

/**
 * @dev This struct defines the parameters for collection payment settings.
 *
 * @dev **paymentSettings**: The payment settings for the collection.
 * @dev **paymentMethodWhitelistId**: The ID of the payment method whitelist to use for the collection.
 * @dev **constrainedPricingPaymentMethod**: The payment method to use for constrained pricing.
 * @dev **royaltyBackfillNumerator**: The numerator to use for the royalty backfill.
 * @dev **royaltyBackfillReceiver**: The address to use as the royalty backfill receiver.
 * @dev **royaltyBountyNumerator**: The numerator to use for the royalty bounty.
 * @dev **exclusiveBountyReceiver**: The address to use as the exclusive bounty receiver.
 * @dev **extraData**: Extra data for the payment settings.
 * @dev **collectionMinimumFloorPrice**: The minimum floor price for the collection.
 * @dev **collectionMaximumCeilingPrice**: The maximum ceiling price for the collection.
 * @dev **flags**: The flags for the payment settings.
 */
struct CollectionPaymentSettingsParams {
    uint8 paymentSettings;
    uint32 paymentMethodWhitelistId;
    address constrainedPricingPaymentMethod;
    uint16 royaltyBackfillNumerator;
    address royaltyBackfillReceiver;
    uint16 royaltyBountyNumerator;
    address exclusiveBountyReceiver;
    uint16 extraData;
    uint120 collectionMinimumFloorPrice;
    uint120 collectionMaximumCeilingPrice;
}

/**
 * @dev This struct defines the pricing bounds for a registry.
 *
 * @dev **isSet**: True if the pricing bounds are set, false otherwise.
 * @dev **floorPrice**: The floor price for the registry.
 * @dev **ceilingPrice**: The ceiling price for the registry.
 */
struct RegistryPricingBounds {
    bool isSet;
    uint120 floorPrice;
    uint120 ceilingPrice;
}