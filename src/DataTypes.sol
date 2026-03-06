//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "@limitbreak/tm-core-lib/src/utils/structs/EnumerableSet.sol";

import { 
    OrderFillAmounts
} from "@limitbreak/permit-c/DataTypes.sol";

/**
 * @dev Used internally to indicate which side of the order the taker is on.
 */
enum Sides { 
    // 0: Taker is on buy side of order.
    Buy, 

    // 1: Taker is on sell side of order.
    Sell 
}

/**
 * @dev Defines the rules applied to a collection for payments.
 */
enum PaymentSettings { 
    // 0: Utilize Payment Processor default whitelist.
    DefaultPaymentMethodWhitelist,

    // 1: Allow any payment method.
    AllowAnyPaymentMethod,

    // 2: Use a custom payment method whitelist.
    CustomPaymentMethodWhitelist,

    // 3: Single payment method with floor and ceiling limits on collections only.
    PricingConstraintsCollectionOnly,

    // 4: Single payment method with floor and ceiling limits, allows both token and collection level constraints.
    PricingConstraints,

    // 5: Pauses trading for the collection.
    Paused
}

/**
 * @dev This struct is used internally for the deployment of the Payment Processor contract and 
 * @dev module deployments to define the default payment method whitelist.
 */
struct DefaultPaymentMethods {
    address defaultPaymentMethod1;
    address defaultPaymentMethod2;
    address defaultPaymentMethod3;
    address defaultPaymentMethod4;
}

/**
 * @dev This struct is used internally for the deployment of the Payment Processor contract and 
 * @dev module deployments to define the default trusted permit processors.
 */
struct TrustedPermitProcessors {
    address permitProcessor1;
    address permitProcessor2;
}

/**
 * @dev This struct is used internally for the deployment of the Payment Processor contract to define the
 * @dev module addresses to be used for the contract.
 */
struct PaymentProcessorModules {
    address moduleOnChainCancellation;
    address moduleBuyListings;
    address moduleAcceptOffers;
    address moduleSweeps;
}

/**
 * @dev This struct defines the payment settings parameters for a collection.
 *
 * @dev **paymentSettings**: The general rule definition for payment methods allowed.
 * @dev **paymentMethodWhitelistId**: The list id to be used when paymentSettings is set to CustomPaymentMethodWhitelist.
 * @dev **royaltyBackfillReceiver**: The backfilled royalty receiver for a collection.
 * @dev **royaltyBackfillNumerator**: The royalty fee to apply to the collection when ERC2981 is not supported.
 * @dev **royaltyBountyNumerator**: The percentage of royalties the creator will grant to a marketplace for order fulfillment.
 * @dev **isRoyaltyBountyExclusive**: If true, royalty bounties will only be paid if the order marketplace is the set exclusive marketplace.
 * @dev **blockTradesFromUntrustedChannels**: If true, trades that originate from untrusted channels will not be executed.
 */
struct CollectionPaymentSettings {
    bool initialized;
    PaymentSettings paymentSettings;
    uint32 paymentMethodWhitelistId;
    address royaltyBackfillReceiver;
    uint16 royaltyBackfillNumerator;
    uint16 royaltyBountyNumerator;
    uint8 flags;
}

/**
 * @dev The `v`, `r`, and `s` components of an ECDSA signature.  For more information
 *      [refer to this article](https://medium.com/mycrypto/the-magic-of-digital-signatures-on-ethereum-98fe184dc9c7).
 */
struct SignatureECDSA {
    uint256 v;
    bytes32 r;
    bytes32 s;
}

/**
 * @dev This struct defines order execution parameters.
 * 
 * @dev **protocol**: The order protocol to apply to the order.
 * @dev **maker**: The user that created and signed the order to be executed by a taker.
 * @dev **beneficiary**: The account that will receive the tokens.
 * @dev **marketplace**: The fee receiver of the marketplace that the order was created on.
 * @dev **fallbackRoyaltyRecipient**: The address that will receive royalties if ERC2981 
 * @dev is not supported by the collection and the creator has not defined backfilled royalties with Payment Processor.
 * @dev **paymentMethod**: The payment method for the order.
 * @dev **tokenAddress**: The address of the token collection the order is for.
 * @dev **tokenId**: The token id that the order is for.
 * @dev **amount**: The quantity of token the order is for.
 * @dev **itemPrice**: The price for the order in base units for the payment method.
 * @dev **nonce**: The maker's nonce for the order.
 * @dev **expiration**: The time, in seconds since the Unix epoch, that the order will expire.
 * @dev **marketplaceFeeNumerator**: The percentage fee that will be sent to the marketplace.
 * @dev **maxRoyaltyFeeNumerator**: The maximum royalty the maker is willing to accept. This will be used
 * @dev as the royalty amount when ERC2981 is not supported by the collection.
 * @dev **requestedFillAmount**: The amount of tokens for an ERC1155 partial fill order that the taker wants to fill.
 * @dev **minimumFillAmount**: The minimum amount of tokens for an ERC1155 partial fill order that the taker will accept.
 * @dev **protocolFeeVersion**: The protocol fee version to use when applying protocol fees.
 */
struct Order {
    uint256 protocol;
    address maker;
    address beneficiary;
    address marketplace;
    address fallbackRoyaltyRecipient;
    address paymentMethod;
    address tokenAddress;
    uint256 tokenId;
    uint256 amount;
    uint256 itemPrice;
    uint256 nonce;
    uint256 expiration;
    uint256 marketplaceFeeNumerator;
    uint256 maxRoyaltyFeeNumerator;
    uint256 requestedFillAmount;
    uint256 minimumFillAmount;
    uint256 protocolFeeVersion;
}

/**
 * @dev This struct defines the items required to execute an advanced order.
 *
 * @dev **saleDetails**: The order execution parameters.
 * @dev **signature**: The signature of the maker authorizing the order execution.
 * @dev **cosignature**: The cosignature of the maker authorizing the order execution.
 * @dev **permitContext**: Contains the address of the permit processor and the permit nonce to be used.
 */
struct AdvancedOrder {
    Order saleDetails;
    SignatureECDSA signature;
    Cosignature cosignature;
    PermitContext permitContext;
}

/**
 * @dev This struct defines the items required to execute an advanced bid order.
 * 
 * @dev **offerType**: The type of offer to execute.
 * @dev **advancedOrder**: The order execution parameters.
 * @dev **sellerPermitSignature**: The signature of the seller to be used for the permit.
 */
struct AdvancedBidOrder {
    uint256 offerType;
    AdvancedOrder advancedOrder;
    SignatureECDSA sellerPermitSignature;
}

/**
 * @dev This struct defines the items required to execute an advanced sweep order.
 *
 * @dev **feeOnTop**: The additional fee to be paid by the taker.
 * @dev **sweepOrder**: The order execution parameters.
 * @dev **items**: An array of items to be executed as part of the sweep order.
 */
struct AdvancedSweep {
    FeeOnTop feeOnTop;
    SweepOrder sweepOrder;
    AdvancedSweepItem[] items;
}

/**
 * @dev This struct is a wrapper for a sweep order item that includes the permit context, bulk order information, signature and cosignature.
 *
 * @dev **sweepItem**: The sweep order item to be executed.
 * @dev **signature**: The signature of the maker authorizing the order execution.
 * @dev **cosignature**: The cosignature of the maker authorizing the order execution.
 * @dev **permitContext**: Contains the address of the permit processor and the permit nonce to be used.
 * @dev **bulkOrderProof**: The proof data for the bulk order.
 */
struct AdvancedSweepItem {
    SweepItem sweepItem;
    SignatureECDSA signature;
    Cosignature cosignature;
    PermitContext permitContext;
    BulkOrderProof bulkOrderProof;
}

/**
 * @dev This struct defines the cosignature for verifying an order that is a cosigned order.
 *
 * @dev **signer**: The address that signed the cosigned order. This must match the cosigner that is part of the order signature.
 * @dev **taker**: The address of the order taker.
 * @dev **expiration**: The time, in seconds since the Unix epoch, that the cosignature will expire.
 * @dev The `v`, `r`, and `s` components of an ECDSA signature.  For more information
 *      [refer to this article](https://medium.com/mycrypto/the-magic-of-digital-signatures-on-ethereum-98fe184dc9c7).
 */
struct Cosignature {
    address signer;
    address taker;
    uint256 expiration;
    uint256 v;
    bytes32 r;
    bytes32 s;
}

/**
 * @dev This struct defines an additional fee on top of an order, paid by taker.
 *
 * @dev **recipient**: The recipient of the additional fee.
 * @dev **amount**: The amount of the additional fee, in base units of the payment token.
 */
struct FeeOnTop {
    address recipient;
    uint256 amount;
}

/**
 * @dev This struct defines the proof data for accepting an offer that is for a subset
 * @dev of items in a collection. The computed root hash from the proof must match the root
 * @dev hash that was signed by the order maker to recover the maker address.
 * 
 * @dev **proof**: The merkle proofs for the item being supplied to fulfill the offer order.
 */
struct TokenSetProof {
    bytes32[] proof;
}

/**
 * @dev This struct defines the proof data for a bulk order.
 * 
 * @dev **orderIndex**: The index of the order in the bulk order.
 * @dev **proof**: The merkle proofs for the order being supplied to fulfill the bulk order.
 */
struct BulkOrderProof {
    uint256 orderIndex;
    bytes32[] proof;
}

/**
 * @dev Current state of a partially fillable order.
 */
enum PartiallyFillableOrderState { 
    // 0: Order is open and may continue to be filled.
    Open, 

    // 1: Order has been completely filled.
    Filled, 

    // 2: Order has been cancelled.
    Cancelled
}

/**
 * @dev This struct defines the current status of a partially fillable order.
 * 
 * @dev **state**: The current state of the order as defined by the PartiallyFillableOrderState enum.
 * @dev **remainingFillableQuantity**: The remaining quantity that may be filled for the order.
 */
struct PartiallyFillableOrderStatus {
    PartiallyFillableOrderState state;
    uint248 remainingFillableQuantity;
}

/**
 * @dev This struct defines order information that is common to all items in a sweep order.
 * 
 * @dev **protocol**: The order protocol to apply to the order.
 * @dev **tokenAddress**: The address of the token collection the order is for.
 * @dev **paymentMethod**: The payment method for the order.
 * @dev **beneficiary**: The account that will receive the tokens.
 */
struct SweepOrder {
    uint256 protocol;
    address tokenAddress;
    address paymentMethod;
    address beneficiary;
}

/**
 * @dev This struct defines order information that is unique to each item of a sweep order.
 * @dev Combined with the SweepOrder header information to make an Order to execute.
 * 
 * @dev **maker**: The user that created and signed the order to be executed by a taker.
 * @dev **marketplace**: The marketplace that the order was created on.
 * @dev **fallbackRoyaltyRecipient**: The address that will receive royalties if ERC2981 
 * @dev is not supported by the collection and the creator has not defined royalties with Payment Processor.
 * @dev **tokenId**: The token id that the order is for.
 * @dev **amount**: The quantity of token the order is for.
 * @dev **itemPrice**: The price for the order in base units for the payment method.
 * @dev **nonce**: The maker's nonce for the order.
 * @dev **expiration**: The time, in seconds since the Unix epoch, that the order will expire.
 * @dev **marketplaceFeeNumerator**: The percentage fee that will be sent to the marketplace.
 * @dev **maxRoyaltyFeeNumerator**: The maximum royalty the maker is willing to accept. This will be used
 * @dev as the royalty amount when ERC2981 is not supported by the collection.
 * @dev **protocolFeeVersion**: The protocol fee version to use when applying protocol fees.
 */
struct SweepItem {
    address maker;
    address marketplace;
    address fallbackRoyaltyRecipient;
    uint256 tokenId;
    uint256 amount;
    uint256 itemPrice;
    uint256 nonce;
    uint256 expiration;
    uint256 marketplaceFeeNumerator;
    uint256 maxRoyaltyFeeNumerator;
    uint256 protocolFeeVersion;
}

/**
 * @dev This struct is used to define pricing constraints for a collection or individual token.
 *
 * @dev **isSet**: When true, this indicates that pricing constraints are set for the collection or token.
 * @dev **floorPrice**: The minimum price for a token or collection.  This is only enforced when 
 * @dev `enforcePricingConstraints` is `true`.
 * @dev **ceilingPrice**: The maximum price for a token or collection.  This is only enforced when
 * @dev `enforcePricingConstraints` is `true`.
 */
struct PricingBounds {
    bool initialized;
    bool isSet;
    uint120 floorPrice;
    uint120 ceilingPrice;
}

/**
 * @dev This struct defines the parameters for a bulk offer acceptance transaction.
 * 
 * 
 * @dev **offerType**: Offer type to execute.
 * @dev **saleDetails**: Order execution details.
 * @dev **signature**: Maker signature authorizing the order executions.
 * @dev **cosignature**: Additional cosignature for cosigned orders, as applicable.
 */
struct BulkAcceptOffersParams {
    uint256 offerType;
    Order saleDetails;
    SignatureECDSA signature;
    Cosignature cosignature;
}

/**
 * @dev This struct defines the parameters for a sweep execution transaction.
 *
 * @dev **fnPointers**: The function pointers to use for the sweep execution.
 * @dev **accumulator**: The accumulator to use for the sweep execution.
 * @dev **paymentCoin**: The payment token to use for the sweep execution.
 * @dev **paymentSettings**: The payment settings to use for the sweep execution.
 */
struct SweepExecutionParams {
    FulfillOrderFunctionPointers fnPointers;
    PayoutsAccumulator accumulator;
    address paymentCoin;
    PaymentSettings paymentSettings;
}

/** 
 * @dev This struct defines the parameters for the proceeds to be split between the seller, marketplace, and royalty recipient.
 *
 * @dev **royaltyRecipient**: The address of the royalty recipient.
 * @dev **royaltyProceeds**: The amount of proceeds to be sent to the royalty recipient.
 * @dev **marketplaceProceeds**: The amount of proceeds to be sent to the marketplace.
 * @dev **sellerProceeds**: The amount of proceeds to be sent to the seller.
 * @dev **infrastructureProceeds**: The amount of proceeds to be sent to the infrastructure recipient.
 */
struct SplitProceeds {
    address royaltyRecipient;
    uint256 royaltyProceeds;
    uint256 marketplaceProceeds;
    uint256 sellerProceeds;
    uint256 infrastructureProceeds;
}

/** 
 * @dev This struct defines the parameters to be used to accumulate payouts for an order.
 *
 * @dev **lastSeller**: The address of the last seller to receive proceeds.
 * @dev **lastMarketplace**: The address of the last marketplace to receive proceeds.
 * @dev **lastRoyaltyRecipient**: The address of the last royalty recipient to receive proceeds.
 * @dev **lastProtocolFeeRecipient**: The address of the last protocol fee recipient to receive proceeds.
 * @dev **accumulatedSellerProceeds**: The total amount of proceeds accumulated for the seller.
 * @dev **accumulatedMarketplaceProceeds**: The total amount of proceeds accumulated for the marketplace.
 * @dev **accumulatedRoyaltyProceeds**: The total amount of proceeds accumulated for the royalty recipient.
 * @dev **accumulatedInfrastructureProceeds**: The total amount of proceeds accumulated for the infrastructure recipient.
 */
struct PayoutsAccumulator {
    address lastSeller;
    address lastMarketplace;
    address lastRoyaltyRecipient;
    address lastProtocolFeeRecipient;
    uint256 accumulatedSellerProceeds;
    uint256 accumulatedMarketplaceProceeds;
    uint256 accumulatedRoyaltyProceeds;
    uint256 accumulatedInfrastructureProceeds;
}

/** 
 * @dev This struct defines the function pointers to be used for the fulfillment of an order.
 *
 * @dev **funcPayout**: The function pointer to use for the payout.
 * @dev **funcDispenseToken**: The function pointer to use for the token dispensation.
 * @dev **funcEmitOrderExecutionEvent**: The function pointer to use for emitting the order execution event.
 */
 struct FulfillOrderFunctionPointers {
    function(address,address,address,uint256) funcPayout;
    function(address,address,address,uint256,uint256) returns (bool) funcDispenseToken;
    function(TradeContext memory, Order memory) funcEmitOrderExecutionEvent;
 }

 /** 
 * @dev This struct defines the context to be used for a trade execution.
 *
 * @dev **channel**: The address of the channel to use for the trade.
 * @dev **taker**: The address of the taker for the trade.
 * @dev **disablePartialFill**: A flag to indicate if partial fills are disabled.
 * @dev **orderDigest**: The digest of the order to be executed.
 * @dev **backfillNumerator**: The numerator to use for the backfill.
 * @dev **backfillReceiver**: The address of the backfill receiver.
 * @dev **bountyNumerator**: The numerator to use for the bounty.
 * @dev **exclusiveMarketplace**: The address of the exclusive marketplace.
 * @dev **useRoyaltyBackfillAsRoyaltySource**: A flag to indicate if the royalty backfill should be used as the royalty source.
 * @dev **protocolFeeVersion**: The protocol fee version to use when applying protocol fees.
 * @dev **protocolFees**: Struct containing the loaded protocol fees for the current context.
 */
 struct TradeContext {
    address channel;
    address taker;
    bool disablePartialFill;
    bytes32 orderDigest;
    uint16 backfillNumerator;
    address backfillReceiver;
    uint16 bountyNumerator;
    address exclusiveMarketplace;
    bool useRoyaltyBackfillAsRoyaltySource;
    uint256 protocolFeeVersion;
    ProtocolFees protocolFees;
 }

/** 
 * @dev This struct defines the items required to handle a permitted order.
 *
 * @dev **permitProcessor**: The address of the permit processor to use for the order.
 * @dev **permitNonce**: The nonce to use for the permit.
 */
 struct PermitContext {
    address permitProcessor;
    uint256 permitNonce;
 }

/** 
 * @dev This struct defines the protocol fees to be applied to a trade based on the protocol fee version.
 *
 * @dev **protocolFeeReceiver**: The address to receive protocol fees.
 * @dev **minimumProtocolFeeBps**: The minimum fee in BPS that is applied to a trade.
 * @dev **marketplaceFeeProtocolTaxBps**: The fee in BPS that is applied to marketplace fees.
 * @dev **feeOnTopProtocolTaxBps**: The fee in BPS that is applied to a fee on top.
 * @dev **versionExpiration**: The timestamp when the protocol fee version expires.
 */
 struct ProtocolFees {
    address protocolFeeReceiver;
    uint16 minimumProtocolFeeBps;
    uint16 marketplaceFeeProtocolTaxBps;
    uint16 feeOnTopProtocolTaxBps;
    uint48 versionExpiration;
 }

/**
 * @dev This struct defines contract-level storage to be used across all Payment Processor modules.
 * @dev Follows the Diamond storage pattern.
 */
struct PaymentProcessorStorage {
    /**
     * @notice User-specific master nonce that allows buyers and sellers to efficiently cancel all listings or offers
     *         they made previously. The master nonce for a user only changes when they explicitly request to revoke all
     *         existing listings and offers.
     *
     * @dev    When prompting sellers to sign a listing or offer, marketplaces must query the current master nonce of
     *         the user and include it in the listing/offer signature data.
     */
    mapping(address => uint256) masterNonces;

    /**
     * @dev The mapping key is the user address.
     *
     * @dev The mapping value is another nested mapping of "slot" (key) to a bitmap (value) containing boolean flags
     *      indicating whether or not a nonce has been used or invalidated.
     *
     * @dev Marketplaces MUST track their own nonce by user, incrementing it for every signed listing or offer the user
     *      creates.  Listings and purchases may be executed out of order, and they may never be executed if orders
     *      are not matched prior to expriation.
     *
     * @dev The slot and the bit offset within the mapped value are computed as:
     *
     * @dev ```slot = nonce / 256;```
     * @dev ```offset = nonce % 256;```
     */
    mapping(address => mapping(uint256 => uint256)) invalidatedSignatures;
    
    /// @dev Mapping of token contract addresses to the collection payment settings.
    mapping (address => CollectionPaymentSettings) collectionPaymentSettings;

    /// @dev Mapping of payment method whitelist id to a defined list of allowed payment methods.
    mapping (uint32 => EnumerableSet.AddressSet) collectionPaymentMethodWhitelists;

    /// @dev Mapping of token contract addresses to the collection-level pricing boundaries (floor and ceiling price).
    mapping (address => PricingBounds) collectionPricingBounds;

    /// @dev Mapping of token contract addresses to the token-level pricing boundaries (floor and ceiling price).
    mapping (address => mapping (uint256 => PricingBounds)) tokenPricingBounds;

    /// @dev Mapping of token contract addresses to the defined pricing constaint payment method.
    mapping (address => address) collectionConstrainedPricingPaymentMethods;

    /// @dev Mapping of token contract addresses to the defined exclusive bounty receivers.
    mapping (address => address) collectionExclusiveBountyReceivers;

    /// @dev Mapping of maker addresses to a mapping of order digests to the status of the partially fillable order for that digest.
    mapping (address => mapping(bytes32 => PartiallyFillableOrderStatus)) partiallyFillableOrderStatuses;

    /// @dev Mapping of token contract addresses to the defined list of trusted channels for the token contract.
    mapping (address => EnumerableSet.AddressSet) collectionTrustedChannels;

    /// @dev A mapping of all co-signers that have self-destructed and can never be used as cosigners again.
    mapping (address => bool) destroyedCosigners;

    /// @dev An enumerable set of trusted permit processors that may be used.
    EnumerableSet.AddressSet trustedPermitProcessors;

    /// @dev Protocol Fee Current Version.
    uint256 currentProtocolFeeVersion;

    /// @dev Protocol Fee Version History.
    mapping (uint256 => ProtocolFees) protocolFeeVersions;
}
