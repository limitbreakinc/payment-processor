# Payment Processor Exchange Integration Guide

## Glossary

- **Payment Processor**: An NFT exchange protocol built by creators, for creators.  Built for trading of ERC721-C and ERC1155-C tokens, but backwards compatible to support trading of any ERC721 or ERC1155 token as well. Analagous to Blur Marketplace and Seaport exchange protocols, but built entirely around honoring fully on-chain programmable royalties. Also known as `PaymentProcessor`.
- **PaymentProcessor**: Shorthand for `Payment Processor`.
- **PaymentProcessor Encoder**: A helper contract deployed alongside PaymentProcessor that integrated marketplaces use to format PaymentProcessor function calldata.
- **Maker(s)**: Create buying or selling orders that are not carried out immediately.  For example, "sell NFT `A` at a price of $100" or "buy NFT `B` for $100".  This creates liquidity, meaning that it is easier for others to instantly buy or sell NFTs when the conditions are met.  When Bob lists an NFT he owns for sale, Bob is considered maker of the order.  Similarly, when Bob offers to buy an NFT, Bob is considered the maker of the order.
- **Taker(s)**: The entities that buy or sell instantly are called takers. In other words, the takers fill the orders created by the makers.  When Alice executes and order to buy Bob's listing, Alice is considered the taker of the order.  Similarly, when Alice accepts an offer from Bob to buy an NFT she owns, Alice is considered the taker of the order.
- **Listing**: An order to sell an NFT once filled by a taker.  Listings are gaslessly signed off-chain by the owner of the NFT.
- **Item Offer**: An order to buy a single, specific NFT once filled by a taker.  Item offers apply to exactly one specific token id in a collection.  Offers are gaslessly signed off-chain by one or more parties interested in purchasing the NFT.
- **Collection Offer**: An order to buy any NFT belonging to the same collection once filled by a taker.  Collection offers apply to any token id for a specific collection.  Offers are gaslessly signed off-chain by one or more parties interested in purchasing an NFT.
- **Token Set Offer**: An order to buy a single NFT from a subset of token ids in the same collection once filled by a taker.  Token set offers apply to a subset of token ids for a specific collection.  Offers are gaslessly signed off-chain by one or more parties interested in purchasing an NFT.
- **Standard Order**: Any listing or offer that may be filled directly by a taker.  Standard orders, when cancelled, must be cancelled on-chain by the order maker at their own gas expense.  Standard orders are not susceptible to censorship.
- **Cosigned Order**: Any listing or offer that must be cosigned by another party in order to be filled by a taker.  Cosigned orders, when cancelled, can be gaslessly cancelled off-chain.  Order-book providers that support cosigned orders must properly secure and automate the co-signing process.  The order-book provider must guarantee that no cosignature can be generated for a previously cancelled order.  Similarly, the order-book provider must guarantee availability of cosignatures to takers such that orders can always be filled uninterrupted. The use of cosigned orders are at the order maker's discretion.  Pros include cheaper, faster cancellation/replacement of orders without incurring transaction gas costs.  Cons include censorship/denial of service risks.
- **Advanced Order**: An order which includes advanced functionality. This can include utilizing a permit processor for approvals and/or processing bulk orders.
- **Beneficiary**: The address of the account that receives the NFT/item when an order is filled.  The buyer and beneficiary can be, but don't have to be the same account.
- **Fee On Top**: A `fee on top` is typically reserved for a marketplace or specialized wallet that finds orders filled by the taker.  This taker marketplace fee is an optional fee paid by the taker in excess of the items' prices in one or more orders.

## Taker Operations / Functions

| Function                                                     | Parameter Encoding Function                                                      | Valid Maker Order Signature Input Type(s)                                                                                                                    |
|--------------------------------------------------------------|----------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [buyListing](#buy-listing)                                   | [encodeBuyListingCalldata](#encodebuylistingcalldata)                            | [SaleApproval](#sale-approval)                                                                                                                               |
| [buyListingAdvanced](#buy-listing-advanced)                  | [encodeBuyListingAdvancedCalldata](#encodebuylistingadvancedcalldata)            | [SaleApproval](#sale-approval)                                                                                                                               |
| [acceptOffer](#accept-offer)                                 | [encodeAcceptOfferCalldata](#encodeacceptoffercalldata)                          | [ItemOfferApproval](#item-offer-approval), [CollectionOfferApproval](#collection-offer-approval), [TokenSetOfferApproval](#token-set-offer-approval)         |
| [acceptOfferAdvanced](#accept-offer-advanced)                | [encodeAcceptOfferAdvancedCalldata](#encodeacceptofferadvancedcalldata)          | [ItemOfferApproval](#item-offer-approval), [CollectionOfferApproval](#collection-offer-approval), [TokenSetOfferApproval](#token-set-offer-approval)         |
| [bulkBuyListings](#bulk-buy-listings)                        | [encodeBulkBuyListingsCalldata](#encodebulkbuylistingscalldata)                  | [SaleApproval](#sale-approval)                                                                                                                               |
| [bulkBuyListingsAdvanced](#bulk-buy-listings-advanced)       | [encodeBulkBuyListingsAdvancedCalldata](#encodebulkbuylistingsadvancedcalldata)  | [SaleApproval](#sale-approval)                                                                                                                               |
| [bulkAcceptOffers](#bulk-accept-offers)                      | [encodeBulkAcceptOffersCalldata](#encodebulkacceptofferscalldata)                | [ItemOfferApproval](#item-offer-approval), [CollectionOfferApproval](#collection-offer-approval), [TokenSetOfferApproval](#token-set-offer-approval)         |
| [bulkAcceptOffersAdvanced](#bulk-accept-offers-advanced)     | [encodeBulkAcceptOffersAdvancedCalldata](#encodebulkacceptoffersadvancedcalldata)| [ItemOfferApproval](#item-offer-approval), [CollectionOfferApproval](#collection-offer-approval), [TokenSetOfferApproval](#token-set-offer-approval)         |
| [sweepCollection](#sweep-collection)                         | [encodeSweepCollectionCalldata](#encodesweepcollectioncalldata)                  | [SaleApproval](#sale-approval)                                                                                                                               |
| [sweepCollectionAdvanced](#sweep-collection-advanced)        | [encodeSweepCollectionAdvancedCalldata](#encodesweepcollectionadvancedcalldata)  | [SaleApproval](#sale-approval)                                                                                                                               |

### Buy Listing

Exchanges should call `buyListing` when a taker wants to purchase a single listing using a UX analogous to "Buy Now".  There are two variations of `buyListing`.

`buyListing` - To be used when the taker fills a standard sell order and the maker and taker marketplace is the same, or when the taker marketplace does not include a fee on top.

`buyListingAdvanced` - To be used when the taker fills a sell order that was signed using a merkle tree and / or when the maker is using a permit processor to handle approvals.

*Note: The taker/buyer (`msg.sender`) pays for the item and any fee on top when applicable.  Because the `buyListing` function is payable, both native or ERC-20 payment methods are accepted.*

### Accept Offer

Exchanges should call `acceptOffer` when a taker wants to sell a single item that matches an offer made by a prospective buyer.  The kinds of offers are currently supported by PaymentProcessor:

1. Item Offer - An offer made on a specific collection where only one specific token id can be used to fill the order.
2. Collection Offer - An offer made on a specific collection where any token id can be used to fill the order.
3. Token Set Offer - An offer made on a specific collection where any token id contained in a specified subset of token ids can be used to fill the order.

There are two variations of `acceptOffer`.

`acceptOffer` - To be used when the taker fills a standard buy order (offer) and the maker and taker marketplace is the same, or when the taker marketplace does not include a fee on top.

`acceptOfferAdvanced` - To be used when the taker fills a buy order (offer) that was signed using a merkle tree and / or when the maker is using a permit processor to handle approvals.

*Note: The taker/seller (`msg.sender`) pays for the fee on top when applicable.  The maker/buyer pays the cost of the filled item.  Because the `acceptOffer` function is not payable, only ERC-20 payment methods are accepted.*

### Bulk Buy Listings

Exchanges should call `bulkBuyListings` when a taker wants to purchase more than one listing using a UX analagous to a "Shopping Cart".  This allows a taker to select many NFTs across different collections or with varying payment methods and fill all of the listings at once.  There are two variations of `bulkBuyListings`.

`bulkBuyListings` - To be used when the taker fills a set of orders that includes only standard sell orders, none of which includes fees on top.

`bulkBuyListingsAdvanced` - To be used when the taker fills a set of orders that were signed using a merkle tree and / or when the maker is using a permit processor to handle approvals.

- *Note that when executing an array of orders, an array of cosignatures must be provided of equal length such that saleDetailsArray[index] corresponds with cosignatures[index].  When saleDetailsArray[index] was signed as a standard order, cosignatures[index] must be an empty (zero) cosignature.*

### Bulk Accept Offers

Exchanges should call `bulkAcceptOffers` when a taker wants to accept/fill more than one offer at once.  This allows a taker to sell multiple items they own across one or more collections in a single transaction.  The kinds of offers are currently supported by PaymentProcessor:

1. Item Offer - An offer made on a specific collection where only one specific token id can be used to fill the order.
2. Collection Offer - An offer made on a specific collection where any token id can be used to fill the order.
3. Token Set Offer - An offer made on a specific collection where any token id contained in a specified subset of token ids can be used to fill the order.

There are two variations of `bulkAcceptOffers`. 

`bulkAcceptOffers` - To be used when the taker fills a set of orders that includes only standard buy orders (offers), none of which includes fees on top.

`bulkAcceptOffersAdvanced` - To be used when the taker fills a set of orders that were signed using a merkle tree and / or when the maker is using a permit processor to handle approvals.

- *Note that when executing an array of orders, an array of fees on top must be provided of equal length such that saleDetailsArray[index] corresponds with feesOnTop[index].  When saleDetailsArray[index] has no fee on top, feesOnTop[index] must be an empty (zero) fee on top.*
- *Note that when executing an array of orders, an array of cosignatures must be provided of equal length such that saleDetailsArray[index] corresponds with cosignatures[index].  When saleDetailsArray[index] was signed as a standard order, cosignatures[index] must be an empty (zero) cosignature.*

### Sweep Collection

Exchanges should call `sweepCollection` (a more gas efficient form of `bulkBuyListings`) when a taker wants to purchase more than one similar listings.  A common UX is the "Collection Sweep" UX where the taker specifies a number of items from a collection they want to buy, with some pricing limits.  

For a sweep to be filled, all items in the sweep order must share the following commonalities:

1. All sell orders fillable in the sweep must be from the same collection.
3. All sell orders fillable in the sweep must use the same method of payment.
5. All sell orders fillable in the sweep must specify the same beneficiary of the NFT.

When filling sweep orders, the following fields can be different for each filled item:

1. Maker
2. Marketplace
3. Fallback Royalty Recipient
4. Token Id
5. Amount
6. Item Price
7. Nonce (for standard orders)
8. Expiration
9. Marketplace Fee Numerator
10. Max Royalty Fee Numerator
11. Protocol Fee Version

There are two variations of `sweepCollection`.

`sweepCollection` - To be used when the taker fills a set of orders that includes only standard sell orders with no fee on top.

`sweepCollectionAdvanced` - To be used when the taker fills a set of orders that include orders signed using a merkle tree and / or when the maker is using a permit processor to handle approvals.

- *Note that each sweep order defines a single fee on top.*
- *Note that when executing an array of orders, an array of cosignatures must be provided of equal length such that saleDetailsArray[index] corresponds with cosignatures[index].  When saleDetailsArray[index] was signed as a standard order, cosignatures[index] must be an empty (zero) cosignature.*

*Note: The taker/buyer (`msg.sender`) pays for the items and any fee on top when applicable.  Because the `sweepCollection` function is payable, both native or ERC-20 payment methods are accepted.*

*Note: For the most gas-efficient collection sweeps, marketplaces should make a best effort to group orders in the array by marketplace address, seller, and royalty recipient.*

## Encoding Function Call Parameters

In order to not overflow smart contract bytecode size limits, PaymentProcessor is split into smaller library modules.  When making calls to PaymentProcessor, these calls are forwarded to the corresponding module and implementation function using `DELEGATECALL`.  For gas efficiency purposes, the function calldata must be passed in as a raw calldata byte array.  PaymentProcessor is deployed with a helper contract called the PaymentProcessorEncoder.  It accepts the expected function implementation parameters and encodes them as a single calldata byte array that should be passed into PaymentProcessor when making calls to fill orders.  The subsections below detail each PaymentProcessorEncoder function.

### encodeBuyListingCalldata

Used to encode calldata for PaymentProcessor `buyListing` function.

```solidity
function encodeBuyListingCalldata(
        address paymentProcessorAddress, 
        Order memory saleDetails, 
        SignatureECDSA memory signature,
        Cosignature memory cosignature,
        FeeOnTop memory feeOnTop) external view returns (bytes memory);
```

### encodeBuyListingAdvancedCalldata

Used to encode calldata for PaymentProcessor `buyListingAdvanced` function.

```solidity
function encodeBuyListingAdvancedCalldata(
        address paymentProcessorAddress, 
        AdvancedOrder memory advancedListing,
        BulkOrderProof memory bulkOrderProof,
        FeeOnTop memory feeOnTop) external view returns (bytes memory);
```

### encodeAcceptOfferCalldata

Used to encode calldata for PaymentProcessor `acceptOffer` function.

```solidity
function encodeAcceptOfferCalldata(
        address paymentProcessorAddress, 
        uint256 offerType,
        Order memory saleDetails, 
        SignatureECDSA memory signature,
        TokenSetProof memory tokenSetProof,
        Cosignature memory cosignature,
        FeeOnTop memory feeOnTop) external view returns (bytes memory);
```

*Note: When filling an item offer, `offerType` MUST be set to `OFFER_TYPE_ITEM_OFFER (1)`, and `tokenSetProof` MUST be set to the empty `TokenSetProof({proof: bytes32[](0)})`.

*Note: When filling a collection offer, `offerType` MUST be set to `OFFER_TYPE_COLLECTION_OFFER (0)`, and `tokenSetProof` MUST be set to the empty `TokenSetProof({proof: bytes32[](0)})`.

*Note: When filling a token set offer, `offerType` MUST be set to `OFFER_TYPE_TOKEN_SET_OFFER (2)`, and `tokenSetProof` MUST contain the valid merkle proof for the collection and token id being filled, and the root computed from the proof must be signed by the order maker.

### encodeAcceptOfferAdvancedCalldata

Used to encode calldata for the PaymentProcessor `acceptOfferAdvanced` function.

```solidity
function encodeAcceptOfferAdvancedCalldata(
        address paymentProcessorAddress, 
        AdvancedBidOrder memory advancedBid,    
        BulkOrderProof memory bulkOrderProof,
        FeeOnTop memory feeOnTop,
        TokenSetProof memory tokenSetProof) external view returns (bytes memory)
```

*Note: If the maker did not use a permit processor, `advancedBid.permitContext` MUST be set to the empty `PermitContext({permitProcessor: address(0), permitNonce: 0})`.*

*Note: If the order being filled is not associated with a merkle root, `bulkOrderProof` MUST be set to the empty  `BulkOrderProof({orderIndex: 0, proof: []})`.*

*Note: If the order being filled does not have fees on top, `feeOnTop` MUST be set to the empty `FeeOnTop({recipient: address(0), amount: 0})`.*

### encodeBulkBuyListingsCalldata

Used to encode calldata for PaymentProcessor `bulkBuyListings` function.

```solidity
function encodeBulkBuyListingsCalldata(
        address paymentProcessorAddress, 
        Order[] calldata saleDetailsArray, 
        SignatureECDSA[] calldata signatures,
        Cosignature[] calldata cosignatures,
        FeeOnTop[] calldata feesOnTop) external view returns (bytes memory);
```

*Note: The length of the `saleDetailsArray`, `signatures`, `cosignatures`, and `feesOnTop` MUST match and MUST be non-zero. `saleDetailsArray[index]` MUST correspond to `signatures[index]`, `cosignatures[index]`, and `feesOnTop[index]`.*

### encodeBulkBuyListingsAdvancedCalldata

Used to encode calldata for PaymentProcessor `bulkBuyListingsAdvanced` function.

```solidity
function encodeBulkBuyListingsAdvancedCalldata(
        address paymentProcessorAddress, 
        AdvancedOrder[] memory advancedListingsArray,
        BulkOrderProof[] memory bulkOrderProofs,
        FeeOnTop[] memory feesOnTop) external view returns (bytes memory)
```

*Note: The length of the `advancedListingsArray`, `bulkOrderProofs` and `feesOnTop` MUST match and MUST be non-zero. `advancedListingsArray[index]` MUST correspond to `bulkOrderProofs[index]` and `feesOnTop[index]`.*

*Note: If the maker did not use a permit processor, `advancedListingsArray[index].permitContext` MUST be set to the empty `PermitContext({permitProcessor: address(0), permitNonce: 0})`.*

*Note: If the order being filled is not be associated with a merkle root, `bulkOrderProofs[index]` MUST be set to  `BulkOrderProof({orderIndex: 0, proof: []})`.*

*Note: If the order being filled does not have fees on top, `feesOnTop[index]` MUST be set to the empty `FeeOnTop({recipient: address(0), amount: 0})`.*

### encodeBulkAcceptOffersCalldata

Used to encode calldata for PaymentProcessor `bulkAcceptOffers` function.

```solidity
function encodeBulkAcceptOffersCalldata(
        address paymentProcessorAddress, 
        uint256[] memory offerTypeArray,
        Order[] memory saleDetailsArray,
        SignatureECDSA[] memory signatures,
        TokenSetProof[] memory tokenSetProofsArray,
        Cosignature[] memory cosignaturesArray,
        FeeOnTop[] memory feesOnTopArray) external view returns (bytes memory);
```

*Note: The length of the `saleDetailsArray`, `signatures`, `tokenSetProofsArray`, `cosignaturesArray`, `feesOnTopArray`, and `offerTypeArray` MUST match and MUST be non-zero. `saleDetailsArray[index]` MUST correspond to `signatures[index]`, `tokenSetProofsArray[index]`, `cosignaturesArray[index]`, `feesOnTopArray[index]`, and `offerTypeArray[index]`.*

*Note: When filling an item offer, `offerTypeArray[index]` MUST be set to `OFFER_TYPE_ITEM_OFFER (1)`, and `tokenSetProofsArray[index]` MUST be set to the empty `TokenSetProof({proof: bytes32[](0)})`.*

*Note: When filling a collection offer, `offerTypeArray[index]` MUST be set to `OFFER_TYPE_COLLECTION_OFFER (0)`, and `tokenSetProofsArray[index]` MUST be set to the empty `TokenSetProof({proof: bytes32[](0)})`.*

*Note: When filling a token set offer, `offerTypeArray[index]` MUST be set to `OFFER_TYPE_TOKEN_SET_OFFER (2)`, and `tokenSetProofsArray[index]` MUST contain the valid merkle proof for the collection and token id being filled, and the computed merkle root must be signed by the order maker.*

### encodeBulkAcceptOffersAdvancedCalldata

Used to encode calldata for PaymentProcessor `bulkAcceptOffersAdvanced` function.

```solidity
function encodeBulkAcceptOffersAdvancedCalldata(
        address paymentProcessorAddress, 
        AdvancedBidOrder[] memory advancedBidsArray,
        BulkOrderProof[] memory bulkOrderProofs,
        FeeOnTop[] memory feesOnTop,
        TokenSetProof[] memory tokenSetProofs) external view returns (bytes memory)
```

*Note: The length of the `advancedBidsArray`, `bulkOrderProofs`, `feesOnTop`, and `tokenSetProofs` MUST match and MUST be non-zero. `advancedBidsArray[index]` MUST correspond to `bulkOrderProofs[index]`, `feesOnTop[index]`, and `tokenSetProofs[index]`.*

*Note: If the maker did not use a permit processor, `advancedBidsArray[index].permitContext` MUST be set to the empty `PermitContext({permitProcessor: address(0), permitNonce: 0})`.*

*Note: If the order being filled is not be associated with a merkle root, `bulkOrderProofs[index]` MUST be set to the empty `BulkOrderProof({orderIndex: 0, proof: []})`.*

*Note: As fees on top may not apply to all orders being filled, `feesOnTop[index]` MUST be set to the empty `FeeOnTop({recipient: address(0), amount: 0})` for any order that is not subject to a fee on top.*

*Note: When filling a token set offer, `tokenSetProofs[index]` MUST be set to the empty `TokenSetProof({proof: bytes32[](0)})`.*

### encodeSweepCollectionCalldata

Used to encode calldata for PaymentProcessor `sweepCollection` function.

```solidity
function encodeSweepCollectionCalldata(
        address paymentProcessorAddress, 
        FeeOnTop memory feeOnTop,
        SweepOrder memory sweepOrder,
        SweepItem[] calldata items,
        SignatureECDSA[] calldata signatures,
        Cosignature[] calldata cosignatures) external view returns (bytes memory);
```

*Note: The length of the `items`, `signatures`, and `cosignatures` arrays MUST match and MUST be non-zero. `items[index]` MUST correspond to `signatures[index]` and `cosignatures[index]`.*

### encodeSweepCollectionAdvancedCalldata

Used to encode calldata for PaymentProcessor `sweepCollectionAdvanced` fucntion.

```solidity
function encodeSweepCollectionAdvancedCalldata(
        address paymentProcessorAddress, 
        AdvancedSweep memory advancedSweep) external view returns (bytes memory)
```

*Note: If the maker did not use a permit processor, `advancedSweep.items[index].permitContext` MUST be set to the empty `PermitContext({permitProcessor: address(0), permitNonce: 0})`.*

*Note: If the order being filled is not be associated with a merkle root, `advancedSweep.items[index].bulkOrderProof` MUST be set to the empty `BulkOrderProof({orderIndex: 0, proof: []})`.*

*Note: If the order being filled does not have fees on top, `advancedSweep.feeOnTop` MUST be set to the empty `FeeOnTop({recipient: address(0), amount: 0})`.*

### encodeRevokeSingleNonceCalldata

Used to encode calldata for PaymentProcessor `revokeSingleNonce` function (on-chain order cancellation).

```solidity
function encodeRevokeSingleNonceCalldata(address paymentProcessorAddress, uint256 nonce) external view returns (bytes memory);
```

## Maker Signature Formats

Makers sign orders in a human readable EIP-712 typed data format.  Exchanges that integrate PaymentProcessor are responsible for correctly prompting makers to sign the appropriate messages at order creation time.  The typed data formats of each order vary depending on the order type.  The following subsections details the various typed data formats compatible with PaymentProcessor.

All PaymentProcessor typed data signatures share the same EIP-712 domain:

```js
EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)
```

***Note: One of the fields that must always be signed and acknowledged by the order maker is the maximum royalty fee that will be deducted from the proceeds. Upon each signature request, this max royalty fee amount should be queried from the NFT contract using the EIP-2981 `royaltyInfo` function. In case a collection does not implement `royaltyInfo`, the query logic should fallback to check the PaymentProcessor contract to determine if a royalty backfill has been supplied by the collection creator/owner using the `collectionRoyaltyBackfillSettings` function. If the on-chain royalty increases after the listing has been signed, sales will not execute. However, if the on-chain royalty is reduced, the reduced royalty fee is paid during the sale.***

### Sale Approval

When listing an individual NFT for sale, with no co-signature required, the seller/maker must be prompted to sign an EIP-712 sale approval in the following format.

```js
SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)
```

### Item Offer Approval

When making an offer on a specific NFT, with no co-signature required, the buyer/maker must be prompted to sign an EIP-712 sale approval in the following format.

```js
ItemOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)
```

### Collection Offer Approval

When making an offer on any NFT in a specific collection, with no co-signature required, the buyer/maker must be prompted to sign an EIP-712 sale approval in the following format.

```js
CollectionOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)
```

### Token Set Offer Approval

When making an offer on a subset of NFTs in a specific collection, with no co-signature required, the buyer/maker must be prompted to sign an EIP-712 sale approval in the following format.

```js
TokenSetOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce,bytes32 tokenSetMerkleRoot)
```

### Cosignature Format

All cosigned listings and offers require a secondary signature to be provided at fill-time/execution time.  The same cosignature format applies to all cosigned maker signatures, and takes a cosigner expiration and the maker's signature v, r, s components as typed data inputs.  Note: for security purposes, co-signatures must always be signed by EOA co-signers.  Furthermore, cosignature expiration times should be relatively short.  A cosignature expiration time between 5 and 10 minutes is suggested.  If the expiration time is too short, transactions may fail because the expiration time elapses before a transaction has been confirmed.  However, if the expiration time is too long a leak of the co-signature could be executed well into the future. 

```js
Cosignature(uint8 v,bytes32 r,bytes32 s,uint256 expiration,address taker)
```

## Data Structures

The following subsections detail the data structures needed for the creation of and filling of orders in PaymentProcessor.  Note that [maker signature formats vary by order-type](#maker-signature-formats).

### SignatureECDSA

| V     | R       | S       |
|-------|---------|---------|
| uint8 | bytes32 | bytes32 |

- V: The `v` component of an ECDSA signature.
- R: The `r` component of an ECDSA signature.
- S: The `s` component of an ECDSA signature.

*[Note: For a detailed explanation of ECDSA signatures read this article](https://medium.com/mycrypto/the-magic-of-digital-signatures-on-ethereum-98fe184dc9c7).*

### Cosignature

| Signer  | Taker   | Expiration | V     | R       | S       |
|---------|---------|------------|-------|---------|---------|
| address | address | uint256    | uint8 | bytes32 | bytes32 |

- Signer: The co-signer designated and acknowledged in the order maker's signature approving the order.  MUST be an EOA, or `address(0)` when the co-signature is empty.  It is expected that marketplaces implementing co-signing MUST expose an API enabling the taker to retrieve a co-signature approving the fill of co-signed orders.
- Taker: The address of the account filling the co-signed order.  May be an EOA or Smart Contract account, or `address(0)` when the co-signature is empty.  A marketplace's co-signing API service MUST acknowledge the taker address in the co-signature.
- Expiration: The unix timestamp (in seconds) when the co-signature expires, or `0` when the co-signature is empty.  A marketplace's co-signing API should use the current unix timestamp and add a validity time that is acknowledged in the co-signature.  If the validity time is too short, there might not be sufficient time for the fill transaction to be confirmed on-chain, possibly resulting in failed fill transactions.  However, the validity time should also not be too long, as a taker could sit on a fill transaction for quite a while.  It is left up to the marketplace to determine an appropriate validity time.
- V: The `v` component of the co-signer's signature.  
- R: The `r` component of the co-signer's signature.
- S: The `s` component of the co-signer's signature.

*Note: The co-signature is generated when the co-signer creates an ECDSA signature of the [Cosignature](#cosignature-format) typed data message.*

### FeeOnTop

A `fee on top` is typically reserved for a marketplace or specialized wallet that found the order filled by the taker.  This taker marketplace fee is an optional fee paid by the taker in excess of the items' prices in one or more orders.  When the maker and taker marketplace is the same, it is strongly encouraged not to apply this fee, as the fee can already be assessed in the maker fee.  Note that the `fee on top` is paid in the same currency as the order's payment method.

| Recipient | Amount  |
|-----------|---------|
| address   | uint256 |

- Recipient: The address to which the fee is paid, or `address(0)` when the fee is empty.
- Amount: The absolute amount of the fee, in wei, or `0` when the fee is empty. Note that the fee amount is not permitted to exceed the item sale price of any given order.

### BulkOrderProof

Bulk Order Proofs allow for users to sign for multiple listings or offers in one signature.  To make it more transparent, the marketplace should present the signature digest in a human readable format, allowing for users to review the data they sign before completing.  Due to how `EIP-712` struct hashing works, a nested array of `[2] * treeHeight` will produce the same hash as the root hash, provided it contains the same data and is padded with empty structs.  Trees of depths 1 (`2^1 = 2`) to 10 (`2^10 = 1024`) are supported.

### Bulk Order Typehashes

The Bulk Order Typehash Lookup tables are generated by concatenating the hashes from each height into one bytes array. This is decoded by taking the bytes32 output of the offset of `height - 1 * 32`.

```js
// keccack256("BulkSaleApproval(SaleApproval[2] tree)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)")
bytes32 constant BULK_SALE_APPROVAL_HEIGHT_1_HASH = 0x8659f55d4c88f84030fe09241169834754ebf2e61099b616e530c6b65712c644;

// keccack256("BulkSaleApproval(SaleApproval[2][2] tree)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)")
bytes32 constant BULK_SALE_APPROVAL_HEIGHT_2_HASH = 0x5106f4043cda72e04ca2c760016628ea8d5667309323ba590682ea5254b4e82e;

// keccack256("BulkSaleApproval(SaleApproval[2][2][2] tree)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)")
bytes32 constant BULK_SALE_APPROVAL_HEIGHT_3_HASH = 0x71267a8f42e7ccde4ac75848a93b741df7a2f7a58e40274055f2fa51dbaa69ce;

// keccack256("BulkSaleApproval(SaleApproval[2][2][2][2] tree)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)")
bytes32 constant BULK_SALE_APPROVAL_HEIGHT_4_HASH = 0x6e90557aed2a349f8b6efb2b652c4025c56cfa82424c5cd0c6801cc234ebf519;

// keccack256("BulkSaleApproval(SaleApproval[2][2][2][2][2] tree)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)")
bytes32 constant BULK_SALE_APPROVAL_HEIGHT_5_HASH = 0xcaf42fc49ad57705ea6be2ca9e1835c9ccddf7bc6fdea8f851917329b1d53a7f;

// keccack256("BulkSaleApproval(SaleApproval[2][2][2][2][2][2] tree)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)")
bytes32 constant BULK_SALE_APPROVAL_HEIGHT_6_HASH = 0x09b32b6b5ffee898d5fe18398652042cc8c46449329c5a1a79e425f4ede9bc2b;

// keccack256("BulkSaleApproval(SaleApproval[2][2][2][2][2][2][2] tree)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)")
bytes32 constant BULK_SALE_APPROVAL_HEIGHT_7_HASH = 0xc2362dea3338b88607906397acfdcc5651f19b40a038ee7c89dc4ab54c736cac;

// keccack256("BulkSaleApproval(SaleApproval[2][2][2][2][2][2][2][2] tree)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)")
bytes32 constant BULK_SALE_APPROVAL_HEIGHT_8_HASH = 0xf2bbc4f6d7ccfa2b8aab6505f0c8f2868c5a190c6c4cfce8c0de447804904df9;

// keccack256("BulkSaleApproval(SaleApproval[2][2][2][2][2][2][2][2][2] tree)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)")
bytes32 constant BULK_SALE_APPROVAL_HEIGHT_9_HASH = 0x81f99e15003039550d3597e34e6426b1e230992a5a3727cb5e230754f18f3566;

// keccack256("BulkSaleApproval(SaleApproval[2][2][2][2][2][2][2][2][2][2] tree)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)")
bytes32 constant BULK_SALE_APPROVAL_HEIGHT_10_HASH = 0x012178d0a6b8f8748e48411572bdc391435539737aafc91fcba6f2c24ae156cf;

// keccack256("BulkCollectionOfferApproval(CollectionOfferApproval[2] tree)CollectionOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_COLLECTION_OFFER_APPROVAL_HEIGHT_1_HASH = 0xfb1dd652f3a5dcde3cb90b0cbb7ff0d33df15a48f216e6ac0e2306ff3538e336;

// keccack256("BulkCollectionOfferApproval(CollectionOfferApproval[2][2] tree)CollectionOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_COLLECTION_OFFER_APPROVAL_HEIGHT_2_HASH = 0x32fc12675167bd2e9c23f1a9b90ce9c0a14daa7e8b3fa5a01105804ad64aa49d;

// keccack256("BulkCollectionOfferApproval(CollectionOfferApproval[2][2][2] tree)CollectionOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_COLLECTION_OFFER_APPROVAL_HEIGHT_3_HASH = 0x22beb101a4a232e5b05a7b5f4727888724dd418194d6c5b1f1ba5ead4cbeed42;

// keccack256("BulkCollectionOfferApproval(CollectionOfferApproval[2][2][2][2] tree)CollectionOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_COLLECTION_OFFER_APPROVAL_HEIGHT_4_HASH = 0x9ba46e6a390d8f8edfb6f752177c215b1cf8b6dcf1f5da395ead6c3e19755698;

// keccack256("BulkCollectionOfferApproval(CollectionOfferApproval[2][2][2][2][2] tree)CollectionOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_COLLECTION_OFFER_APPROVAL_HEIGHT_5_HASH = 0xae93fe4a03206f6bb45035fab04a39964c83e7d265e93fc31521c86dd25a3be4;

// keccack256("BulkCollectionOfferApproval(CollectionOfferApproval[2][2][2][2][2][2] tree)CollectionOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_COLLECTION_OFFER_APPROVAL_HEIGHT_6_HASH = 0xee3cb9e25b214af21b0d321776864470916324653397b355b267b2894a009a98;

// keccack256("BulkCollectionOfferApproval(CollectionOfferApproval[2][2][2][2][2][2][2] tree)CollectionOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_COLLECTION_OFFER_APPROVAL_HEIGHT_7_HASH = 0x516d5d5306f95a17cb6d0b84e71f78919a98ac5e3c723fc4b9b1a720193d590d;

// keccack256("BulkCollectionOfferApproval(CollectionOfferApproval[2][2][2][2][2][2][2][2] tree)CollectionOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_COLLECTION_OFFER_APPROVAL_HEIGHT_8_HASH = 0xf5b1dcad1bd5c8161d6b904513bc658d4c9b8c288b2271e0f27d5938654e4186;

// keccack256("BulkCollectionOfferApproval(CollectionOfferApproval[2][2][2][2][2][2][2][2][2] tree)CollectionOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_COLLECTION_OFFER_APPROVAL_HEIGHT_9_HASH = 0x63c21e3ce7e506548c01ef4e6a27a5805f9328e0da83e9a7c765dc28266a5aa1;

// keccack256("BulkCollectionOfferApproval(CollectionOfferApproval[2][2][2][2][2][2][2][2][2][2] tree)CollectionOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_COLLECTION_OFFER_APPROVAL_HEIGHT_10_HASH = 0x9802b2e35d72255f2ae69bed829f0104723aa156059e02dfccfe781ffc955356;

// keccack256("BulkItemOfferApproval(ItemOfferApproval[2] tree)ItemOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_ITEM_OFFER_APPROVAL_HEIGHT_1_HASH = 0x243dc86e63d73b10b2764253a38ab8763ded4ac63a632adef4019e482161964a;

// keccack256("BulkItemOfferApproval(ItemOfferApproval[2][2] tree)ItemOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_ITEM_OFFER_APPROVAL_HEIGHT_2_HASH = 0x2ed4880b2bfec74882da06ca9f461158c42fa73fa5974b5abec9fcde7cdd43ee;

// keccack256("BulkItemOfferApproval(ItemOfferApproval[2][2][2] tree)ItemOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_ITEM_OFFER_APPROVAL_HEIGHT_3_HASH = 0x8308607f65c90c023abf48563d2c8bd8c783d1db48ffd02ec324105d9f682f96;

// keccack256("BulkItemOfferApproval(ItemOfferApproval[2][2][2][2] tree)ItemOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_ITEM_OFFER_APPROVAL_HEIGHT_4_HASH = 0x1f7a30dcec9205ff30a5290b3b756e1fd1a1585539bccbc817ab4e59d69a055e;

// keccack256("BulkItemOfferApproval(ItemOfferApproval[2][2][2][2][2] tree)ItemOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_ITEM_OFFER_APPROVAL_HEIGHT_5_HASH = 0xcfa8c0abdff5fb2704d1818f38dc974f5bdde6dfe1a4ddc3e22a1f3e593e98f3;

// keccack256("BulkItemOfferApproval(ItemOfferApproval[2][2][2][2][2][2] tree)ItemOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_ITEM_OFFER_APPROVAL_HEIGHT_6_HASH = 0x24e3124a40922800d1eb1890240fc7d07f257a303bb383e8c0820e9910be1f97;

// keccack256("BulkItemOfferApproval(ItemOfferApproval[2][2][2][2][2][2][2] tree)ItemOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_ITEM_OFFER_APPROVAL_HEIGHT_7_HASH = 0xc72769ff919066b8d1f586bb8b7e720ad93f735ffa9570f9e9ef0e865d13251d;

// keccack256("BulkItemOfferApproval(ItemOfferApproval[2][2][2][2][2][2][2][2] tree)ItemOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_ITEM_OFFER_APPROVAL_HEIGHT_8_HASH = 0x89338818bfd140179260dbdc6d6bf38461d49661c166f2b76d3b56727acab7ad;

// keccack256("BulkItemOfferApproval(ItemOfferApproval[2][2][2][2][2][2][2][2][2] tree)ItemOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_ITEM_OFFER_APPROVAL_HEIGHT_9_HASH = 0xf3e381ed4335a28fa612f4068c58de673cad05c8a7fbfb5c1fd557c2c5a2de9f;

// keccack256("BulkItemOfferApproval(ItemOfferApproval[2][2][2][2][2][2][2][2][2][2] tree)ItemOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)")
bytes32 constant BULK_ITEM_OFFER_APPROVAL_HEIGHT_10_HASH = 0x84c94a0cfd84379f92ed5827593e2218a1dc1b975626bbe5c6948b9d2232f7d7;

// keccack256("BulkTokenSetOfferApproval(TokenSetOfferApproval[2] tree)TokenSetOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce,bytes32 tokenSetMerkleRoot)")
bytes32 constant BULK_TOKEN_SET_OFFER_APPROVAL_HEIGHT_1_HASH = 0x0d0b16c0b281480a518e0ae1543bf94c612edc289e45edc04e8510dac617afa4;

// keccack256("BulkTokenSetOfferApproval(TokenSetOfferApproval[2][2] tree)TokenSetOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce,bytes32 tokenSetMerkleRoot)")
bytes32 constant BULK_TOKEN_SET_OFFER_APPROVAL_HEIGHT_2_HASH = 0x337b9c051f65323200a3580d4917087d4d82e350fcc68b3397c654c9fc7872c3;

// keccack256("BulkTokenSetOfferApproval(TokenSetOfferApproval[2][2][2] tree)TokenSetOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce,bytes32 tokenSetMerkleRoot)")
bytes32 constant BULK_TOKEN_SET_OFFER_APPROVAL_HEIGHT_3_HASH = 0x8f8f306a409d08a43b82756f57beb839c3bf5bdd388ba0850d9d21f5c1d0c4dc;

// keccack256("BulkTokenSetOfferApproval(TokenSetOfferApproval[2][2][2][2] tree)TokenSetOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce,bytes32 tokenSetMerkleRoot)")
bytes32 constant BULK_TOKEN_SET_OFFER_APPROVAL_HEIGHT_4_HASH = 0x9f510b8ccf7bbda5c9bd4333d7dcfc8e280aac9eaa9427dcd2f2ffca1fa7a833;

// keccack256("BulkTokenSetOfferApproval(TokenSetOfferApproval[2][2][2][2][2] tree)TokenSetOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce,bytes32 tokenSetMerkleRoot)")
bytes32 constant BULK_TOKEN_SET_OFFER_APPROVAL_HEIGHT_5_HASH = 0x8599a8fc89aae892d7419812435866d931c9da91198b2f48d1d5318acb524461;

// keccack256("BulkTokenSetOfferApproval(TokenSetOfferApproval[2][2][2][2][2][2] tree)TokenSetOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce,bytes32 tokenSetMerkleRoot)")
bytes32 constant BULK_TOKEN_SET_OFFER_APPROVAL_HEIGHT_6_HASH = 0xa0f24864e615845dfa14bee5d4fa28950fcdcf9d31893c68c26f4cfa13402a97;

// keccack256("BulkTokenSetOfferApproval(TokenSetOfferApproval[2][2][2][2][2][2][2] tree)TokenSetOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce,bytes32 tokenSetMerkleRoot)")
bytes32 constant BULK_TOKEN_SET_OFFER_APPROVAL_HEIGHT_7_HASH = 0x621dd1d4cc7477f0587a16f5cd40ea8750209653e7275ccaea3b68623860181b;

// keccack256("BulkTokenSetOfferApproval(TokenSetOfferApproval[2][2][2][2][2][2][2][2] tree)TokenSetOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce,bytes32 tokenSetMerkleRoot)")
bytes32 constant BULK_TOKEN_SET_OFFER_APPROVAL_HEIGHT_8_HASH = 0x51e570aee92287102d49a7493d337e8aa332c1bc639273de546b428973379fa9;

// keccack256("BulkTokenSetOfferApproval(TokenSetOfferApproval[2][2][2][2][2][2][2][2][2] tree)TokenSetOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce,bytes32 tokenSetMerkleRoot)")
bytes32 constant BULK_TOKEN_SET_OFFER_APPROVAL_HEIGHT_9_HASH = 0xa9415346b8de2006517a8de68b2b4147a1d6fd91ce600f4040941627c1c8c3df;

// keccack256("BulkTokenSetOfferApproval(TokenSetOfferApproval[2][2][2][2][2][2][2][2][2][2] tree)TokenSetOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce,bytes32 tokenSetMerkleRoot)")
bytes32 constant BULK_TOKEN_SET_OFFER_APPROVAL_HEIGHT_10_HASH = 0xb75be8e10d720cf92518936f56974bdfa8e4a723902dd12e415ffba6eb6dde12;
```

### Bulk Approval Signature Creation

Creating a Bulk Order Signature requires you to create a merkle tree where the root is the bulk order, and the leaves are the approval types (e.g. `SaleApproval` or `ItemOfferApproval`).  The tree must be **exactly** 2^N items, where N is the height of the tree calculated by taking the maximum of `log2(orderCount)`.  If the amount of approvals is not exactly equal to the computed amount of required items, you would pad with empty approvals which would be unfillable.

An example for an order with 7 items would be:

Visual Order
```
log2(7) = 2.8 = 3

  |---------------------------------------------------|
1 |  [[[sa1,sa2], [sa3,sa4]], [[sa5,sa6], [sa7,pad]]] |
  |---------------------------------------------------|
2 |  [[sa1,sa2], [sa3,sa4]] |  [[sa5,sa6], [sa7,pad]] |
  |---------------------------------------------------|
3 | [sa1, sa2] | [sa3, sa4] | [sa5, sa6] | [sa7, pad] |
```

Example in JavaScript
```javascript
// Bulk Order Type
export const EIP_712_BULK_ORDER_TYPE = {
    BulkSaleApproval: [{ name: "tree", type: "SaleApproval[2][2][2]" }],
    SaleApproval: [
        { name: "protocol", type: "uint8" },
        { name: "cosigner", type: "address" },
        { name: "seller", type: "address" },
        { name: "marketplace", type: "address" },
        { name: "fallbackRoyaltyRecipient", type: "address" },
        { name: "paymentMethod", type: "address" },
        { name: "tokenAddress", type: "address" },
        { name: "tokenId", type: "uint256" },
        { name: "amount", type: "uint256" },
        { name: "itemPrice", type: "uint256" },
        { name: "expiration", type: "uint256" },
        { name: "marketplaceFeeNumerator", type: "uint256" },
        { name: "maxRoyaltyFeeNumerator", type: "uint256" },
        { name: "nonce", type: "uint256" },
        { name: "masterNonce", type: "uint256" },
        { name: "protocolFeeVersion", type: "uint256" }
    ]
};

const bulkArray: SaleApproval[][][] = [];

const exampleSaleApproval = {
        protocol: 0,
        cosigner: zeroAddress,
        seller: '0xabc...',
        marketplace: '0xbeef...',
        fallbackRoyaltyRecipient: zeroAddress,
        paymentMethod: zeroAddress,
        tokenAddress: '0x123...',
        tokenId: 1,
        amount: 1,
        itemPrice: 1e18,
        expiration: 9999999999999,
        marketplaceFeeNumerator: 0,
        maxRoyaltyFeeNumerator: 0,
        nonce: 0,
        masterNonce: 0,
        protocolFeeVersion: 0
};

const blankApproval = {
        protocol: 0,
        cosigner: zeroAddress,
        seller: zeroAddress,
        marketplace: zeroAddress,
        fallbackRoyaltyRecipient: zeroAddress,
        paymentMethod: zeroAddress,
        tokenAddress: zeroAddress,
        tokenId: 0,
        amount: 0,
        itemPrice: 0,
        expiration: 0,
        marketplaceFeeNumerator: 0,
        maxRoyaltyFeeNumerator: 0,
        nonce: 0,
        masterNonce: 0,
        protocolFeeVersion: 0
}

bulkArray[0][0][0] = exampleSaleApproval;
bulkArray[0][0][1] = exampleSaleApproval;
bulkArray[0][1][0] = exampleSaleApproval;
bulkArray[0][1][1] = exampleSaleApproval;
bulkArray[1][0][0] = exampleSaleApproval;
bulkArray[1][0][1] = exampleSaleApproval;
bulkArray[1][1][0] = exampleSaleApproval;
bulkArray[1][1][1] = blankApproval;

const dataToSign = {
        BulkSaleApproval: {
                tree: bulkArray;
        }
}

const typedData = JSON.stringify({
        primaryType: 'BulkSaleApproval',
        domain: domain,
        message: { tree: dataToSign },
        types: {
        EIP712Domain: [
                { name: 'name', type: 'string' },
                { name: 'version', type: 'string' },
                { name: 'chainId', type: 'uint256' },
                { name: 'verifyingContract', type: 'address' }
        ],
        ... types,
        }
});

const params = [signerAddress, typedData];
const method = 'eth_signTypedData_v4';

const sig = await window.ethereum.request({ method, params });

// Generate tree
const hashedData = dataToSign.flat(Infinity).map((saleApproval) => {

        const encodedData = encodeAbiParameters(
        parseAbiParameters(
                "bytes32 hash, uint8 protocol, address cosigner, address seller, address marketplace, address fallbackRoyaltyRecipient, address paymentMethod, address tokenAddress, uint256 tokenId, uint256 amount, uint256 itemPrice, uint256 expiration, uint256 marketplaceFeeNumerator, uint256 maxRoyaltyFeeNumerator, uint256 nonce, uint256 masterNonce, uint256 protocolFeeVersion"),
        [
                SALE_APPROVAL_TYPE_HASH,
                saleApproval.protocol, 
                saleApproval.cosigner, 
                saleApproval.seller, 
                saleApproval.marketplace, 
                saleApproval.fallbackRoyaltyRecipient, 
                saleApproval.paymentMethod, 
                saleApproval.tokenAddress, 
                saleApproval.tokenId, 
                saleApproval.amount, 
                saleApproval.itemPrice, 
                saleApproval.expiration, 
                saleApproval.marketplaceFeeNumerator, 
                saleApproval.maxRoyaltyFeeNumerator, 
                saleApproval.nonce, 
                saleApproval.masterNonce,
                saleApproval.protocolFeeVersion
        ]
        );

        return keccak256(encodedData);
});

const tree: MerkleTree = new MerkleTree(hashedData, keccak256, {
        complete: true,
        sort: false,
        hashLeaves: false,
        fillDefaultHash: keccak256(encodedNullSaleApproval)
});

```

### Processing Bulk Orders

When submitting an order that is part of a bulk approval, the index of the approval must be provided with the proof.  This is used to determine the placing of the approval in order to recreate the tree and generate the correct hash.  Using the previous example, orders are indexed as below:

```
bulkArray[0][0][0] == 0;
bulkArray[0][0][1] == 1;
bulkArray[0][1][0] == 2;
bulkArray[0][1][1] == 3;
bulkArray[1][0][0] == 4;
bulkArray[1][0][1] == 5;
bulkArray[1][1][0] == 6;
bulkArray[1][1][1] == 7;
```

So to submit an order for `bulkArray[0][1][0]` you would submit as below:

```javascript
const index = 2;
const hexProof = tree.getHexProot(hashedData[index]);

const order: AdvancedOrder = {
        saleDetails: order,
        signature: sig,
        cosignature: nullSig,
        permitContext: {
                permitProcessor: zeroAddress,
                permitNonce: BigInt(0),
        }
}

const proof: Proof = {
        proof: hexProof,
        orderIndex: index
};

const feeOnTop: FeeOnTop = {
        recipient: zeroAddress,
        amount: BigInt(0),
}

const calldata = await publicClient.readContract({
        address: PAYMENT_PROCESSOR_ENCODER_ADDRESS,
        abi: paymentProcessorEncoderAbi.abi,
        functionName: 'encodebuyListingAdvancedCalldata',
        args: [PAYMENT_PROCESSOR_ADDRESS, order, proof, feeOnTop]
});

const { request } = await publicClient.simulateContract({
        account: address,
        address: PAYMENT_PROCESSOR_ADDRESS,
        abi: paymentProcessorAbi.abi,
        functionName: 'buyListingAdvanced',
        args: [calldata]
});
await walletClient.writeContract(request);
```

### TokenSetProof

Token set proofs are required to fill token set offers on a collection.  A token set offer is a merkle tree where the leaf data is the keccak256 hash of the collection address and token id.

```
leafHash = keccak256(abi.encode(collectionAddress, tokenId));
```

| Proof     |
|-----------|
| bytes32[] |

- Proof: The merkle proof for the specific collection/token id leaf node being filled, , or `bytes32[](0)` when the order being filled is not a token set offer.

### Permit Processor

 Payment Processor has support to use a permit processor like PermitC to handle approvals in a more advanced and secure way. To handle this, the taker must first give standard approval on their token to the permit processor contract before executing the order. A signature for the permit processor would utilize the `PermitTransferFromWithAdditionalData` on PermitC. 

An example of handling this would look like this:
```javascript
const PERMIT_C_TYPE = {
        PermitTransferFromWithAdditionalData: [
        { name: "token", type: "address" },
        { name: "id", type: "uint256" },
        { name: "amount", type: "uint256" },
        { name: "nonce", type: "uint256" },
        { name: "operator", type: "address" },
        { name: "expiration", type: "uint256" },
        { name: "masterNonce", type: "uint256" },
        { name: "approval", type: "SaleApproval" },
        ],
        SaleApproval: [
        { name: "protocol", type: "uint8" },
        { name: "cosigner", type: "address" },
        { name: "seller", type: "address" },
        { name: "marketplace", type: "address" },
        { name: "fallbackRoyaltyRecipient", type: "address" },
        { name: "paymentMethod", type: "address" },
        { name: "tokenAddress", type: "address" },
        { name: "tokenId", type: "uint256" },
        { name: "amount", type: "uint256" },
        { name: "itemPrice", type: "uint256" },
        { name: "expiration", type: "uint256" },
        { name: "marketplaceFeeNumerator", type: "uint256" },
        { name: "maxRoyaltyFeeNumerator", type: "uint256" },
        { name: "nonce", type: "uint256" },
        { name: "masterNonce", type: "uint256" },
        { name: "protocolFeeVersion", type: "uint256" }
        ]
}

const typedData = JSON.stringify({
        primaryType: 'PermitTransferFromWithAdditionalData',
        domain: PERMIT_C_DOMAIN,
        message: {
        token: sa1.tokenAddress,
        id: sa1.tokenId,
        amount: sa1.amount,
        nonce: sa1.nonce,
        operator: PAYMENT_PROCESSOR_ADDRESS,
        expiration: sa1.expiration,
        masterNonce: sa1.masterNonce,
        approval: sa1
        },
        types: {
        EIP712Domain: [
                { name: 'name', type: 'string' },
                { name: 'version', type: 'string' },
                { name: 'chainId', type: 'uint256' },
                { name: 'verifyingContract', type: 'address' }
        ],
        ... PERMIT_C_TYPE,
        }
});

const params = [address, typedData];
const method = 'eth_signTypedData_v4';

const sig = await window.ethereum.request({ method, params });
setSignature(sig);

const order: AdvancedOrder = {
        saleDetails: order1,
        signature: sig,
        cosignature: nullSig,
        permitContext: {
                permitProcessor: PERMIT_C_ADDRESS,
                permitNonce: BigInt(0),
        }
}
const nullFeeOnTop: FeeOnTop = {
        recipient: zeroAddress,
        amount: BigInt(0),
};
const nullBulkOrder: Proof = {
        orderIndex: BigInt(0),
        proof: [],
};

const calldata = await publicClient?.readContract({
        address: PAYMENT_PROCESSOR_ENCODER_ADDRESS,
        abi: paymentProcessorEncoderAbi.abi,
        functionName: 'encodeBuyListingAdvancedCalldata',
        args: [PAYMENT_PROCESSOR_ADDRESS, order, nullBulkOrder, nullFeeOnTop]
});  

const {request} = await publicClient.simulateContract({
        account: address,
        address: PAYMENT_PROCESSOR_ADDRESS,
        abi: paymentProcessorAbi.abi,
        functionName: 'buyListingAdvanced',
        args: [calldata]
});
await walletClient.writeContract(request);
```

### Order

This data structure is used to fill all single and bulk orders that are not sweep orders.

| Protocol | Maker   | Beneficiary | Marketplace | Fallback Royalty Recipient | Payment Method | Token Address | Token Id | Amount  | Item Price | Nonce   | Expiration | Marketplace Fee Numerator | Max Royalty Fee Numerator | Requested Fill Amount | Minimum Fill Amount | Protocol Fee Version |
|----------|---------|-------------|-------------|----------------------------|----------------|---------------|----------|---------|------------|---------|------------|---------------------------|---------------------------|-----------------------|---------------------|----------------------|
|uint8     | address | address     | address     | address                    | address        | address       | uint256  | uint256 | uint256    | uint256 | uint256    | uint256                   | uint256                   | uint256 | uint256 | uint256 |

- Protocol: `0` for ERC721 or `1` for ERC1155 collections.
- Maker: The address of the account the created the order.  May be an EOA or Smart Contract account. When the order was a listing, the maker is the seller of the item.  When the order was an offer, the maker is the buyer of the item.
- Beneficiary: The address of the account that receives the item when the order is filled.  When the order was a listing, the taker (`msg.sender`) can either buy with themselves as the beneficiary, or another account.  When the order was an offer, the maker would be the buyer, and the beneficiary address can either be the maker's account or another account. For example, the buyer could be a user's hot wallet, and the beneficiary could be the user's cold storage wallet.
- Marketplace: The address to which the primary (maker) marketplace fee should be paid, or `address(0)` if the maker marketplace charges no platform fees.  Note that for collections that offer non-exclusive royalty bounties, the maker marketplace also receives a royalty bounty paid out of creator royalties.  For collections that offer exclusive royalty bounties, the maker marketplace receives a royalty bounty only if it matches the exclusive royalty bounty recipient designated by the collection creator.
- Payment Method: The address of the ERC-20 coin used to fill the trade, or `address(0)` for the native currency of the chain the trade executed on.  For example, `address(0)` denotes ETH on ETH Mainnet, and Matic on Polygon Mainnet.
- Token Address: The address of the collection.
- Token Id: The id of the token (if collection is ERC721), or the token type id of the token (if collection is ERC1155).
- Amount: The number of tokens. MUST be `1` if collection is ERC721, and MUST be greater than or equal to `1` if collection is ERC1155.
- Item Price: The price of the token(s) in the order.
- Nonce: An id unique to the order that helps prevent replay attacks.  Nonce applies only to standard signed orders, and may not be re-used.  For co-signed order, nonce should be set to `0`. Note: It is easier to generate a random nonce than attempt to keep track of nonces that have been used.  However, be aware that a gas optimization is in place such that filled or cancelled nonces are tracked in a bitmap. 0-255, 256-511, 512-767, etc all fall within the same slot, so if possible it is ideal to track used nonces through fill events and attempt to use sequential nonces starting at zero.  Because each maker address has its own set of nonces generated for gasless listings, it is possible that marketplaces will have no knowledge of nonces used in outstanding order signatures.  Ideally, a shared service could be created and utilized by all marketplaces that issues nonces for orders.
- Expiration: The unix timestamp (in seconds) when the maker's order signature expires.  A marketplace's order making API should use the current unix timestamp and add a user-defined validity time that is acknowledged in the maker's signature.  
- Marketplace Fee Numerator: Marketplace fee percentage in bips. Should be in range 0-10,000, as denominator is 10,000. 0.5% fee numerator is 50, 1% fee numerator is 100, 10% fee numerator is 1,000 and so on.
- Max Royalty Fee Numerator: Maximum approved royalty fee percentage in bips.  Should be in range 0-10,000, as denominator is 10,000. 0.5% fee numerator is 50, 1% fee numerator is 100, 10% fee numerator is 1,000 and so on.  When requesting the order signature from the order maker, the marketplace MUST first attempt to read the royalties for the individual token using the EIP-2981 `royaltyInfo` function call on the collection.  If `royaltyInfo` raises an exception (likely because it is unimplemented), the marketplace MUST attempt to determine if royalties have been backfilled  by calling the `collectionRoyaltyBackfillSettings` function on PaymentProcessor.  If no on-chain royalties are present, this may be set to `0`.
- Requested Fill Amount: The amount of tokens for an ERC1155 partial fill order that the taker wants to fill.
- Minimum Fill Amount: The minimum amount of tokens for an ERC1155 partial fill order that the taker will accept.
- Protocol Fee Version: The versioned protocol fee number, used to access the correct protocol fee that was authorized in an order.

### Sweep Order

This data structure is used to fill sweep orders, and represents the shared values that apply to all order in the sweep.

| Protocol | Token Address | Payment Method | Beneficiary |
|----------| --------------|----------------|-------------|
| uint8    | address       | address        | address     |

- Protocol: `0` for ERC721 or `1` for ERC1155 collections.
- Token Address: The address of the collection.
- Payment Method: The address of the ERC-20 coin used to fill the trade, or `address(0)` for the native currency of the chain the trade executed on.  For example, `address(0)` denotes ETH on ETH Mainnet, and Matic on Polygon Mainnet.
- Beneficiary: The address of the account that receives the item when the order is filled.

### Sweep Item

This data structure is used to fill sweep orders, and represents the values that apply to individual orders in the sweep.

| Maker   | Marketplace | Fallback Royalty Recipient | Token Id | Amount     | Item Price | Nonce   | Expiration | Marketplace Fee Numerator | Max Royalty Fee Numerator | Protocol Fee Version |
|---------|-------------|----------------------------|----------|------------|------------|---------|------------|---------------------------|---------------------------|----------------------|
| address | address     | address                    | uint256  | uint256    | uint256    | uint256 | uint256    | uint256                   | uint256                   | uint256              |

- Maker: The address of the account the created the order.  May be an EOA or Smart Contract account. When the order was a listing, the maker is the seller of the item.  When the order was an offer, the maker is the buyer of the item.
- Marketplace: The address to which the primary (maker) marketplace fee should be paid, or `address(0)` if the maker marketplace charges no platform fees.  Note that for collections that offer non-exclusive royalty bounties, the maker marketplace also receives a royalty bounty paid out of creator royalties.  For collections that offer exclusive royalty bounties, the maker marketplace receives a royalty bounty only if it matches the exclusive royalty bounty recipient designated by the collection creator.
- Token Id: The id of the token (if collection is ERC721), or the token type id of the token (if collection is ERC1155).
- Amount: The number of tokens. MUST be `1` if collection is ERC721, and MUST be greater than or equal to `1` if collection is ERC1155.
- Item Price: The price of the token(s) in the order.
- Nonce: An id unique to the order that helps prevent replay attacks.  Nonce applies only to standard signed orders, and may not be re-used.  For co-signed order, nonce should be set to `0`. Note: It is easier to generate a random nonce than attempt to keep track of nonces that have been used.  However, be aware that a gas optimization is in place such that filled or cancelled nonces are tracked in a bitmap. 0-255, 256-511, 512-767, etc all fall within the same slot, so if possible it is ideal to track used nonces through fill events and attempt to use sequential nonces starting at zero.  Because each maker address has its own set of nonces generated for gasless listings, it is possible that marketplaces will have no knowledge of nonces used in outstanding order signatures.  Ideally, a shared service could be created and utilized by all marketplaces that issues nonces for orders.
- Expiration: The unix timestamp (in seconds) when the maker's order signature expires.  A marketplace's order making API should use the current unix timestamp and add a user-defined validity time that is acknowledged in the maker's signature.  
- Marketplace Fee Numerator: Marketplace fee percentage in bips. Should be in range 0-10,000, as denominator is 10,000. 0.5% fee numerator is 50, 1% fee numerator is 100, 10% fee numerator is 1,000 and so on.
- Max Royalty Fee Numerator: Maximum approved royalty fee percentage in bips.  Should be in range 0-10,000, as denominator is 10,000. 0.5% fee numerator is 50, 1% fee numerator is 100, 10% fee numerator is 1,000 and so on.  When requesting the order signature from the order maker, the marketplace MUST first attempt to read the royalties for the individual token using the EIP-2981 `royaltyInfo` function call on the collection.  If `royaltyInfo` raises an exception (likely because it is unimplemented), the marketplace MUST attempt to determine if royalties have been backfilled by calling the `collectionRoyaltyBackfillSettings` function on PaymentProcessor.  If no on-chain royalties are present, this may be set to `0`.
- Protocol Fee Version: The versioned protocol fee number, used to access the correct protocol fee that was authorized in an order.

## Recommended Marketplace Workflows

This section details the suggested workflows for implementing user facing trading features compatible with PaymentProcessor.

### Making Orders

#### Making a Listing

1. Maker browses their items and selects an item to list for sale.
2. Maker inputs: Listing Currency/Payment Method, Price, Validity Time.
3. Maker prompted to acknowledge/accept maker marketplace fee percentage and on-chain royalty fee (display sale price, fees, and net seller proceeds)
4. Maker prompted to decide on standard order (on-chain cancellations) or co-signed order (gasless cancellation). For standard orders, a nonce is generated.  For co-signed orders, nonce not required.
5. Signature Prompt [SaleApproval](#sale-approval)
6. Order and signature added to order book.

#### Making An Item Offer

1. Maker browses a collection and selects a single item to make an offer on.
2. Maker inputs: Offer Currency/Payment Method, Price, Validity Time, Beneficiary.
3. Maker prompted to acknowledge/accept maker marketplace fee percentage (display sale price, fees, and net seller proceeds)
4. Maker prompted to decide on standard order (on-chain cancellations) or co-signed order (gasless cancellation). For standard orders, a nonce is generated.  For co-signed orders, nonce not required.
5. Signature Prompt for [ItemOfferApproval](#item-offer-approval)
6. Order and signature added to order book.

#### Making A Collection Offer

1. Maker browses a collection and chooses to make a collection offer for any item in the collection.
2. Maker inputs: Offer Currency/Payment Method, Price, Validity Time, Beneficiary.
3. Maker prompted to acknowledge/accept maker marketplace fee percentage (display sale price, fees, and net seller proceeds).
4. Maker prompted to decide on standard order (on-chain cancellations) or co-signed order (gasless cancellation). For standard orders, a nonce is generated.  For co-signed orders, nonce not required.
5. Signature Prompt for [CollectionOfferApproval](#collection-offer-approval)
6. Order and signature added to order book.

#### Making A Token Set Collection Offer

This can take a few forms depending on how the marketplace chooses to implement this.  This can take the form of offers on traits, offers on tokens that have not been stolen, etc.

1. Maker browses a collection and chooses some criteria for token ids to make an offer on.  The marketplace generates a merkle tree of tokens based on the criteria.
2. Maker inputs: Offer Currency/Payment Method, Price, Validity Time, Beneficiary.
3. Maker prompted to acknowledge/accept maker marketplace fee percentage (display sale price, fees, and net seller proceeds).
4. Maker prompted to acknowledge the set of tokens/merkle root.
5. Maker prompted to decide on standard order (on-chain cancellations) or co-signed order (gasless cancellation). For standard orders, a nonce is generated.  For co-signed orders, nonce not required.
6. Signature Prompt for [TokenSetOfferApproval](#token-set-offer-approval)
7. Order and signature added to order book.

### Cancelling Orders

#### Cancelling A Single Listing

1. Display maker's listings.
2. Maker selects a listing to cancel.
3. If standard order, maker confirms `revokeSingleNonce` transaction.  If co-signed order flag order as cancelled in DB and do not allow co-signing service to co-sign the order if requested.  Order should be hidden from future listing queries.

#### Cancelling A Single Offer

1. Display maker's offers.
2. Maker selects an offer to cancel.
3. If standard order, maker confirms `revokeSingleNonce` transaction.  If co-signed order flag order as cancelled in DB and do not allow co-signing service to co-sign the order if requested.  Order should be hidden from future offer queries.

#### Cancelling All Outstanding Standard Orders

1. If the maker chooses to cancel ALL outstanding standard listings and offers they have made, the maker simply needs to confirm a `revokeMasterNonce` transaction.  This should cancel/invalidate all prior orders that were not co-signed orders.

#### Cancelling All Outstanding Co-Signed Orders

1. The marketplace should flag all outstandingn orders for the user as cancelled in the DB.  The co-signing service should not return co-signatures for any of the cancelled orders, and the orders should be hidden from all future queries.

### Filling Orders

#### Filling A Single Listing (Buy Now)

1. Taker browses listings and chooses a listed item.
2. Taker selects "Buy Now".
3. Taker selects beneficiary (whether self or other account).
4. Taker prompted to review the details, including review and acknowledgement of fee on top when applicable.
5. If listing order was co-signed, client requests a co-signature for the listing.
6. The most applicable `buyListing` function should be called.  [Applicability Details](#buy-listing)
7. Marketplace calls the appropriate PaymentProcessorEncoder function to generate the calldata to fill the order.
8. Wallet pops up a transaction confirmation of the applicable `buyListing` call.
9. Taker confirms or rejects the transaction through their wallet interface.

#### Filling A Batch Of Listings (Shopping Cart)

1. Taker browses listings and chooses several listed items (they may be from one or more collections).
2. Taker selects "Add To Shopping Cart" for each item.
3. Taker reviews cart and "Checks Out".
4. Taker selects beneficiary (whether self or other account).
5. Taker prompted to review the details, including review and acknowledgement of all fees on top when applicable.
6. For any co-signed listing orders, client requests co-signatures.
7. The most applicable `bulkBuyListings` function should be called.  [Applicability Details](#bulk-buy-listings)
8. Marketplace calls the appropriate PaymentProcessorEncoder function to generate the calldata to bulk fill the orders.
9. Wallet pops up a transaction confirmation of the applicable `bulkBuyListings` call.
10. Taker confirms or rejects the transaction through their wallet interface.

#### Filling A Collection Sweep

1. Taker chooses "Sweep Collection" for the desired collection.
2. Taker specifies desired quantity and maximum price per item.
3. Taker selects beneficiary (whether self or other account).
4. Taker prompted to review the details, including review and acknowledgement of the fee on top when applicable.
5. For any co-signed listing orders, client requests co-signatures.
6. The most applicable `sweepCollection` function should be called. [Applicability Details](#sweep-collection)
7. Marketplace calls the appropriate PaymentProcessorEncoder function to generate the calldata to fill the sweep.
8. Wallet pops up a transaction confirmation of the applicable `sweepCollection` call.
9. Taker confirms or rejects the transaction through their wallet interface.

#### Filling A Single Offer (Accept Offer)

1. Taker browser offers where the offer criteria matches items they own and chooses one.
2. Taker selects "Accept Offer".
3. Taker prompted to review the details, including review and acknowledgement of the current on-chain royalty fee, maker marketplace fee, and fee on top when applicable.
4. If the offer order was co-signed, client requests a co-signature for the offer.
5. The most applicable `acceptOffer` function should be called. [Applicability Details](#accept-offer)
6. Marketplace calls the appropriate PaymentProcessorEncoder function to generate the calldata to fill the order.
7. Wallet pops up a transaction confirmation of the applicable `acceptOffer` call.
8. Taker confirms or rejects the transaction through their wallet interface.

#### Filling A Batch Of Offers (Offer Cart)

1. Taker browser offers where the offer criteria matches items they own and chooses several.
2. Taker selects "Add To Offer Cart" for each item.
3. Taker reviews cart and "Checks Out".
4. Taker prompted to review the details, including review and acknowledgement of the current on-chain royalty fees for each item, the maker marketplace fees for each item, and the fees on top when applicable.
5. For any co-signed offer orders, client requests co-signatures.
7. The most applicable `bulkAcceptOffers` function should be called.  [Applicability Details](#bulk-accept-offers)
8. Marketplace calls the appropriate PaymentProcessorEncoder function to generate the calldata to bulk fill the orders.
9. Wallet pops up a transaction confirmation of the applicable `bulkAcceptOffers` call.
10. Taker confirms or rejects the transaction through their wallet interface.

***Note: There are other steps marketplaces may need to implement to prompt users in the workflow.  For instance: approving PaymentProcessor to transfer NFTs and ERC-20 payments, prompting to wrap native currency or swap currencies when needed, or prompting buyers to perform a one-time signature to prove they are EOAs [for select ERC721-C security levels only].***
