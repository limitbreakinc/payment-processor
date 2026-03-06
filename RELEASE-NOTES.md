## 3.0.0 (2024-mm-dd)

### Updated Software Licensing

### Breaking Changes

* Replace `bool isCollectionLevelOrder` field in offers with `uint256 offerType` field, simplifying offer processing logic.
* Remove `bytes32 rootHash` field from `TokenSetProof` struct, as it is more gas efficient to simply compute the `rootHash` during proof verification than passing it in via calldata.
* Add `uint256 protocolFeeVersion` field to EIP-712 typed data hashes (`SALE_APPROVAL_HASH`, `PERMITTED_TRANSFER_SALE_APPROVAL`, `PERMITTED_ORDER_SALE_APPROVAL`, all `BULK_SALE_APPROVAL` type hashes).
* Add `uint256 protocolFeeVersion` field to `Order` struct.
* Remove `PushPaymentGasLimitOverriddenByCollection` event, as gas limits have been removed for native transfer of funds.
* Cap item prices at type(uint240).max.  This should not impact operations but allows more gas efficient math when computing payment splits.
* ***Note: These breaking interface changes result in new trading function selectors and an update to calldata encoding, so use latest `PaymentProcessorEncoder`.***


### New Features

* Support permissionless deployment of Payment Processor by any wallet on any EVM chain so it is freely deployable by the community.
* Add Tstorish re-entrancy guard for gas-cost effective, more comprehensive reentrancy protections while allowing down stream payment composability.
  * Allowed removal of native push payment gas limits and gas limit overrides.
  * Allowed native refunds to be securely issued directly instead of wrapping refunds.
* Add Limit Break's deterministic, permissionlessly deployable Wrapped Native token as a default payment method.
* Add mutable protocol fee that can be adjusted up or down by permissioned `FEE_MANAGER` role, based on market conditions or to initiate a migration to future versions of Payment Processor.  Protocol fee versioning system allows for fee version grace periods to ensure orders are not instantly invalidated and that exchange integrators have built-in time to integrate new versions.
  * Unless otherwise adjusted after deployment, the protocol fees are initialized by default to 0.25% minimum protocol fee, 15% tax on exchange fees, and 25% tax on fee on top.  When exchange fee tax is insufficient to cover the minimum, the shortfall is deducted from the seller's proceeds.  When the exchange fee tax fully covers the minimum protocol fee, the seller's proceeds are unaffected.
  * Exchanges can stay current on protocol fees by subscribing to the new `ProtocolFeesUpdated` event.

### Gas Optimizations

* Replace OpenZeppelin SafeERC20 library with new Limit Break ERC20 transfer library.
* Refactor payments for fee on top to optimize payout flow for protocol fees.
* Limit item price to `type(uint240).max` to allow for unchecked math in payment split computation.
* Change diamond storage slot from the hash of a string value to `0x9A1D`.
* Allow malleable signatures since order replay is prevented by order hash.
* Replace standard ABI encoding/hashing with new Limit Break Efficient Hash library.
* Remove token set proof root hash from calldata, calculate based on item + proof and validate with offer signature.
* Change optimization runs from 30,000 to 40,000.

## 2.1.0 (2024-05-24)

### Breaking Changes

* Domain Separator has been removed from all trading function calldata.  Instead, domain separator is looked up from a cached immutable variable, making trades more gas efficient.  Marketplaces/exchanges should use the new v2.1.0 `PaymentProcessorEncoder` contract when generating calldata to ensure compatibility.
* Added a collection-level only Pricing Constraints payment type.  This saves gas for collections that do not use token-level min/max floors.
* Remove banned accounts feature - this is moving to the core Creator Token Standards in order to persist across marketplace versions.
* Calldata format has changed for all trading functions - use the new v2.1.0 `PaymentProcessorEncoder` to ensure compatibility.
* Order digest for partial fills no longer includes the full EIP-712 type hash and domain separator.  Instead, partially fillable ERC1155 orders are now tracked solely through the hash of the order data itself.
* Removed the following events:
    * `event BannedAccountAddedForCollection(address indexed tokenAddress, address indexed account);`
    * `event BannedAccountRemovedForCollection(address indexed tokenAddress, address indexed account);`
* Added the following events:
    * `event PermittedOrderNonceInvalidated(uint256 indexed permitNonce, uint256 indexed orderNonce, address indexed account, bool wasCancellation);`
    * `event PermittedOrderNonceRestored(uint256 indexed permitNonce, uint256 indexed orderNonce, address indexed account);`
    * `event PushPaymentGasLimitOverriddenByCollection(address indexed tokenAddress, uint256 pushPaymentGasLimit);`
    * `event TrustedPermitProcessorAdded(address indexed permitProcessor);`
    * `event TrustedPermitProcessorRemoved(address indexed permitProcessor);`
* Modified definitions of the following events:
    * `OrderDigestOpened`
    * `OrderDigestItemsFilled`
    * `OrderDigestItemsRestored`
    * `UpdatedCollectionPaymentSettings`

### New Features

* Added Advanced Orders
    * Added Bulk Order Signing - listings and bids may be bulk signed.  A bulk listing or bulk bid may include up to 1024 individual orders signed by the maker with a single signature. 
    * Added Permit-C Integration - sellers may optionally list NFTs using Permit-C approvals vs of `approvalForAll`. When accepting bids, the seller also has the option to sign a permit as part of the bid acceptance process or use `approvalForAll`.  This can increase asset security for collectors.
* Added optional push payment gas limit override for creators - By default, Payment Processor strictly controls the amount of gas forwarded when sending native funds to either the seller, royalty account, or marketplace fee account.  This helps control re-entrancy risks.  Some creators use push payment splitters, which run out of gas due to these limits.  The use of pull payment splitters is preferred, but for collections where this is not possible, the collection owner can now override this limit with their own setting.
* Added ability for creators to specify royalty backfill as the primary source of royalties - this saves gas querying collections that do not implement 2981 royalties, and it allows collections that have an unused `royaltyInfo` implementation to collect royalties using the backfill instead.
* Added Creator Settings Lazy Loading - from V2.1.0 onwards, creators will no longer have to apply their settings to every new Payment Processor instance, as they will be loaded one-time automatically from a settings registry upon the first trade on each collection.  Lists such as custom payment method whitelists, trusted channel lists, and token-level pricing bounds are loaded and cached locally on an as-needed basis.

### Bug Fixes and Optimizations

* Various gas optimizations for trading flows
* Fix edge case caused by fallback functions

## 2.0.1 (2024-02-26)

* Fix burning of order nonce/partial fill order digest when NFT transfer fails