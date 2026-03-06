//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "../DataTypes.sol";

/** 
* @title IPaymentProcessorEvents
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 
interface IPaymentProcessorEvents {

    /// @notice Emitted when an ERC721 listing is purchased.
    event BuyListingERC721(
        address indexed buyer,
        address indexed seller,
        address indexed tokenAddress,
        address beneficiary,
        address paymentCoin,
        uint256 tokenId,
        uint256 salePrice);

    /// @notice Emitted when an ERC1155 listing is purchased.
    event BuyListingERC1155(
        address indexed buyer,
        address indexed seller,
        address indexed tokenAddress,
        address beneficiary,
        address paymentCoin,
        uint256 tokenId,
        uint256 amount,
        uint256 salePrice);

    /// @notice Emitted when an ERC721 offer is accepted.
    event AcceptOfferERC721(
        address indexed seller,
        address indexed buyer,
        address indexed tokenAddress,
        address beneficiary,
        address paymentCoin,
        uint256 tokenId,
        uint256 salePrice);

    /// @notice Emitted when an ERC1155 offer is accepted.
    event AcceptOfferERC1155(
        address indexed seller,
        address indexed buyer,
        address indexed tokenAddress,
        address beneficiary,
        address paymentCoin,
        uint256 tokenId,
        uint256 amount,
        uint256 salePrice);

    /// @notice Emitted when a cosigner destroys itself.
    event DestroyedCosigner(address indexed cosigner);

    /// @notice Emitted when a user revokes all of their existing listings or offers that share the master nonce.
    event MasterNonceInvalidated(address indexed account, uint256 nonce);

    /// @notice Emitted when a user revokes a single listing or offer nonce for a specific marketplace.
    event NonceInvalidated(
        uint256 indexed nonce, 
        address indexed account, 
        bool wasCancellation);

    /// @notice Emitted when a user fills a single listing or offer nonce but item fails to fill.
    event NonceRestored(
        uint256 indexed nonce, 
        address indexed account);

    /// @notice Emitted when a user revokes a single permitted listing nonce.
    event PermittedOrderNonceInvalidated(
        uint256 indexed permitNonce, 
        uint256 indexed orderNonce, 
        address indexed account, 
        bool wasCancellation);

    /// @notice Emitted when protocol fees are updated.
    event ProtocolFeesUpdated(
        address indexed newProtocolFeeRecipient,
        uint16 minimumProtocolFeeBps,
        uint16 marketplaceFeeProtocolTaxBps,
        uint16 feeOnTopProtocolTaxBps,
        uint48 gracePeriodExpiration);

    /// @notice Emitted the first time a partially fillable 1155 order has items filled on-chain.
    event OrderDigestOpened(
        bytes32 indexed orderDigest, 
        address indexed account, 
        uint256 orderStartAmount);

    /// @notice Emitted when a user fills items on a partially fillable 1155 listing.
    event OrderDigestItemsFilled(
        bytes32 indexed orderDigest, 
        address indexed account, 
        uint256 amountFilled);

    /// @notice Emitted when a user revokes a single partially fillable 1155 listing or offer for a specific marketplace.
    event OrderDigestInvalidated(
        bytes32 indexed orderDigest, 
        address indexed account, 
        bool wasCancellation);

    /// @notice Emitted when a user fills a partially fillable 1155 listing or offer but item fails to fill.
    event OrderDigestItemsRestored(
        bytes32 indexed orderDigest, 
        address indexed account, 
        uint256 amountRestoredToOrder);

    /// @notice Emitted when a coin is added to the approved coins mapping for a whitelist.
    event PaymentMethodAddedToWhitelist(
        uint32 indexed paymentMethodWhitelistId, 
        address indexed paymentMethod);

    /// @notice Emitted when a coin is removed from the approved coins mapping for a whitelist.
    event PaymentMethodRemovedFromWhitelist(
        uint32 indexed paymentMethodWhitelistId, 
        address indexed paymentMethod);

    /// @notice Emitted when a trusted channel is added for a collection
    event TrustedChannelAddedForCollection(
        address indexed tokenAddress, 
        address indexed channel);

    /// @notice Emitted when a trusted channel is removed for a collection.
    event TrustedChannelRemovedForCollection(
        address indexed tokenAddress, 
        address indexed channel);

    /// @notice Emitted when a permit processor is added to the trusted permit processor list.
    event TrustedPermitProcessorAdded(address indexed permitProcessor);

    /// @notice Emitted when a permit processor is removed from the trusted permit processor list.
    event TrustedPermitProcessorRemoved(address indexed permitProcessor);

    /// @notice Emitted whenever pricing bounds change at a collection level for price-constrained collections.
    event UpdatedCollectionLevelPricingBoundaries(
        address indexed tokenAddress, 
        uint256 floorPrice, 
        uint256 ceilingPrice);

    /// @notice Emitted when payment settings are updated for a collection.
    event UpdatedCollectionPaymentSettings(
        address indexed tokenAddress, 
        PaymentSettings paymentSettings, 
        uint32 indexed paymentMethodWhitelistId, 
        address indexed constrainedPricingPaymentMethod,
        uint16 royaltyBackfillNumerator,
        address royaltyBackfillReceiver,
        uint16 royaltyBountyNumerator,
        address exclusiveBountyReceiver,
        bool blockTradesFromUntrustedChannels,
        bool useRoyaltyBackfillAsRoyaltySource);

    /// @notice Emitted whenever pricing bounds change at a token level for price-constrained collections.
    event UpdatedTokenLevelPricingBoundaries(
        address indexed tokenAddress, 
        uint256 indexed tokenId, 
        uint256 floorPrice, 
        uint256 ceilingPrice);
}