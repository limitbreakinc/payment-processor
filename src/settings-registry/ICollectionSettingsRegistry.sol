//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "./IPaymentProcessorSettings.sol";
import "./SettingsDataTypes.sol";

/** 
* @title ICollectionSettingsRegistry
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 
interface ICollectionSettingsRegistry {

    /// @notice Emitted when a new payment method whitelist is created.
    event CreatedPaymentMethodWhitelist(
        uint32 indexed paymentMethodWhitelistId, 
        address indexed whitelistOwner,
        string whitelistName);

    /// @notice Emitted when a coin is added to the approved coins mapping for a whitelist.
    event PaymentMethodAddedToWhitelist(
        uint32 indexed paymentMethodWhitelistId, 
        address indexed paymentMethod);

    /// @notice Emitted when a coin is removed from the approved coins mapping for a whitelist.
    event PaymentMethodRemovedFromWhitelist(
        uint32 indexed paymentMethodWhitelistId, 
        address indexed paymentMethod);

    /// @notice Emitted when a permit processor is added to the trusted permit processor list.
    event TrustedPermitProcessorAdded(address indexed permitProcessor);

    /// @notice Emitted when a permit processor is removed from the trusted permit processor list.
    event TrustedPermitProcessorRemoved(address indexed permitProcessor);

    /// @notice Emitted when payment settings are updated for a collection.
    event UpdatedCollectionPaymentSettings(
        address indexed tokenAddress,
        CollectionPaymentSettingsParams params
    );

    /// @notice Emitted whenever pricing bounds change at a token level for price-constrained collections.
    event UpdatedTokenLevelPricingBoundaries(
        address indexed tokenAddress, 
        uint256 indexed tokenId, 
        uint256 floorPrice, 
        uint256 ceilingPrice);

    /// @notice Emitted when a trusted channel is removed for a collection.
    event TrustedChannelRemovedForCollection(
        address indexed tokenAddress, 
        address indexed channel);

    /// @notice Emitted when a trusted channel is added for a collection.
    event TrustedChannelAddedForCollection(
        address indexed tokenAddress, 
        address indexed channel);

    /// @notice Emitted when a payment method whitelist is reassigned to a new owner.
    event ReassignedPaymentMethodWhitelistOwnership(uint32 indexed id, address indexed newOwner);

    function isCollectionSettingsInitialized(address tokenAddress) external view returns (bool);

    function getCollectionSettings(
        address tokenAddress,
        bytes32[] calldata dataExtensions,
        bytes32[] calldata wordExtensions
    ) external view returns (
        CollectionRegistryPaymentSettings memory collectionCoreSettings,
        RegistryPricingBounds memory collectionPricingBounds,
        address constrainedPricingPaymentMethod,
        address exclusiveBountyReceiver,
        bytes[] memory data, 
        bytes32[] memory words
    );

    function getCollectionSettingsExtendedData(
        address tokenAddress, 
        bytes32[] calldata extensions
    ) external view returns (bytes[] memory data);

    function getCollectionSettingsExtendedWords(
        address tokenAddress, 
        bytes32[] calldata extensions
    ) external view returns (bytes32[] memory words);

    function isWhitelistedPaymentMethod(
        uint32 whitelistId,
        address paymentMethod
    ) external view returns (bool paymentMethodWhitelisted);

    function isTrustedChannelForCollection(
        address tokenAddress,
        address channel
    ) external view returns (bool channelIsTrusted);

    function isTrustedPermitProcessor(
        address permitProcessor
    ) external view returns (bool isTrusted);

    function getTokenBoundPricing(
        address tokenAddress,
        uint256 tokenId
    ) external view returns (RegistryPricingBounds memory);
}