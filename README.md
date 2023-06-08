# Payment Processor Contracts

**Limit Break is introducing the world's first ERC721-C compatible payment processing layer for NFT marketplace integrations.  Combined with the whitelisted transfer and wrapper mechanics introduced in [Creator Token Contracts](https://github.com/limitbreakinc/creator-token-contracts), the Payment Processor contract can be used to securely process NFT sales with secondary market royalty enforcement built-in.  The Payment Processor, as implemented, enables truly enforceable programmable royalty systems to be built by NFT creators.** 

## Overview

The following contracts are available for use/integration by NFT developers and NFT marketplaces:

- ***Payment Processor***: The world's first ERC721-C compatible marketplace contract!  This contract is available for community use. 

## Features

<ul>
  <li>Creator Defined Security Profiles</li>
  <ul>
    <li>Exchange Whitelist On/Off</li>
    <li>Payment Method Whitelist On/Off</li>
    <li>Pricing Constraints On/Off</li>
    <li>Private Sales On/Off</li>
    <li>Delegate Purchase Wallets On/Off</li>
    <li>Smart Contract Buyers/Sellers On/Off</li>
    <li>Exchange Whitelist Bypass for EOAs On/Off</li>
  </ul>
  <li>Enforceable/Programmable Fees</li>
  <ul>
    <li>Built-in EIP-2981 Royalty Enforcement</li>
    <li>Built-in Marketplace Fee Enforcement</li>
  </ul>
  <li>Multi-Standard Support</li>
  <ul>
    <li>ERC721-C</li>
    <li>ERC1155-C</li>
    <li>ERC721 + EIP-2981</li>
    <li>ERC1155 + EIP-2981</li>
  </ul>
  <li>Payments</li>
  <ul>
    <li>Native Currency (ETH or Equivalent)</li>
    <li>ERC-20 Coin Payments</li>
  </ul>
  <li>A Multitude of Supported Sale Types</li>
  <ul>
    <li>Buy Single Listing</li>
    <ul>
      <li>Collection-Level Offers</li>
      <li>Item-Specific Offers</li>
    </ul>
    <li>Buy Batch of Listings (Shopping Cart)</li>
    <li>Buy Bundled Listing (From One Collection)</li>
    <li>Sweep Listings (From One Collection)</li>
    <li>Partial Order Fills (When ERC-20 Payment Method Is Used)</li>
  </ul>
 </ul>


## Contract Addresses

Testnet, Mainnet, and L2 contract addresses will be provided after the contracts are audited and officially released.

## Code Documentation

To generate the latest code-level documentation from the natspec comments, download the source code and run the following commands.

```
> forge doc -s
```

## Marketplace Integration Guide

The Payment Processor smart contract in this repository will be deployed to Ethereum Mainnet, as well as select EVM-compatible L2s.

### For NFT Developers

All ERC-721 and ERC-1155 tokens are compatible with the Payment Processor contract.  There is nothing preventing marketplaces from executing sales of any NFT using the Payment Processor.  However, in order to guarantee that the payment and control flow goes through the Payment Processor, a transfer whitelist is needed that exclusively lists the Payment Processor as the only allowed operator.  Doing so allows for secondary marketplace royalties that are truly enforceable.

See Limit Break's [Creator Token Contracts](https://github.com/limitbreakinc/creator-token-contracts) code repository and [NPM package](https://www.npmjs.com/package/@limitbreak/creator-token-contracts?activeTab=readme) to get started with ERC721-C, ERC1155-C tokens.

#### Security Profiles

The Payment Processor gives NFT creators control over how their collections can be bought and sold.  By default, all NFT collections fallback to the default security profile.  The default profile is very open and permissive, allowing private sale, delegated purchases, buys and sell amongst EOAs and multi-sigs, and is open to any marketplace to integrate.  In case of abuse, NFT collection creators may create or use a custom security profile that is fully under their control.  Thus, this contract can be considered to be a ***Creator Defined Marketplace***.

Functions that NFT developers can use to create and manage their own security profiles are:

  - `function createSecurityPolicy(bool enforceExchangeWhitelist, bool enforcePaymentMethodWhitelist, bool enforcePricingConstraints, bool disablePrivateListings, bool disableDelegatedPurchases, bool disableEIP1271Signatures, bool disableExchangeWhitelistEOABypass, uint32 pushPaymentGasLimit,string calldata registryName)`
  - `function updatedSecurityPolicy(bool enforceExchangeWhitelist, bool enforcePaymentMethodWhitelist, bool enforcePricingConstraints, bool disablePrivateListings, bool disableDelegatedPurchases, bool disableEIP1271Signatures, bool disableExchangeWhitelistEOABypass, uint32 pushPaymentGasLimit,string calldata registryName)`
  - `function transferSecurityPolicyOwnership(uint256 securityPolicyId, address newOwner)`
  - `function renounceSecurityPolicyOwnership(uint256 securityPolicyId)`
  - `function setCollectionSecurityPolicy(address tokenAddress, uint256 securityPolicyId)`
  - `function setCollectionPaymentCoin(address tokenAddress, address coin)`
  - `function setCollectionPricingBounds(address tokenAddress, PricingBounds calldata pricingBounds)`
  - `function setTokenPricingBounds(address tokenAddress, uint256[] calldata tokenIds, PricingBounds[] calldata pricingBounds)`
  - `function whitelistExchange(uint256 securityPolicyId, address account)`
  - `function unwhitelistExchange(uint256 securityPolicyId, address account)`
  - `function whitelistPaymentMethod(uint256 securityPolicyId, address coin)`
  - `function unwhitelistPaymentMethod(uint256 securityPolicyId, address coin)`
  - `function getSecurityPolicy(uint256 securityPolicyId)`
  - `function isWhitelisted(uint256 securityPolicyId, address account)`
  - `function isPaymentMethodApproved(uint256 securityPolicyId, address coin)`
  - `function getTokenSecurityPolicyId(address collectionAddress)`
  - `function isCollectionPricingImmutable(address tokenAddress)`
  - `function isTokenPricingImmutable(address tokenAddress, uint256 tokenId)`
  - `function getFloorPrice(address tokenAddress, uint256 tokenId)`
  - `function getCeilingPrice(address tokenAddress, uint256 tokenId)`

#### Payment Methods

By default, the approved payment methods are ETH/WETH (or the equivalents for the current chain), USDC, USDT, and DAI.  To choose custom payment methods that are approved for their collections, creators may make use of the custom security profile feature to establish their own list of approved payments.

### For NFT Marketplaces

#### Supported Purchase Flows/Scenarios

1. Seller Lists A Single Item and Buyer Is Matched Using a "Buy Now" or "Auction" style feature.  Buyer or their delegated purchaser account accepts and pays gas to execute the transaction. (ETH or ERC-20 Payments Acccepted)
2. Seller Lists A Single Item for a designated Buyer (Private Sale).  Buyer or their delegated purchaser account accepts and pays gas to execute the transaction. (ETH or ERC-20 Payments Acccepted)
3. Buyer makes a "Collection-Level" offer for a desired collection.  A Seller accepts the offer at the offer price and pays gas to execute the transaction.  (ONLY ERC-20 Payments Accepted).
4. Buyer makes an "Item-Specific" offer for a desired token id in a collection.  The owner of the item can accept the offer at the offer price and pays gas to execute the transaction.  (ONLY ERC-20 Payments Accepted).
5. Multiple distinct Sellers List items and a Buyer adds the desired items to their "cart".  Buyer or their delegated purchaser account accepts and pays gas to executed the transaction. Purchased batch of items can be from one or more collections, and any combination of ETH and ERC-20 Payments are accepted. (Private and Public sales are supported in batches)
6. Multiple distinct Buyers make collection-level or item-specific offers.  A Seller that has many NFTs with offers can choose a subset of these offers to accept and execute the sale in a batch.  In this case, the Seller accepts the desired offers and pays gas to execute the transaction.  Sold items can be from one or more collections, and any combination of ERC-20 Payments are accepted. (ONLY ERC-20 Payments Accepted).
7. A seller with many NFTs in a single collection lists a subset of their NFTs in a single bundled listing, pricing each item individually.  A Buyer is Matched Using a "Buy Bundle Now" feature (exact bundle price only).  Buyer or their delegated purchaser account accepts and pays gas to execute the transaction.  (ETH or ERC-20 Payments Accepted, but note that all items in the bundle must be priced in the same currency).
8. A buyer "sweeps" a single collection to obtain many NFTs.  They may purchase any number of NFTs on a single collection by accepting the listing price on many distinct sellers' items.  The Buyer or their delegated purchaser account pays gas to execute the transaction.  (ETH or ERC-20 Payments Accepted, but note that all swept items must be priced in the same currency).

#### Required Approvals

On ERC-721 and ERC-1155 contracts, prompt the user to `setApprovalForAll(paymentProcessor.address, true)`.  This needs to be done once per token contract the seller wishes to sell.

For buyers purchasing with ERC-20 coins, the buyer must approve the payment processor to transfer the funds using `function approve(address _spender, uint256 _value) public returns (bool success)` on the coin contract.

#### Signing Single Listings

The seller must be prompted to sign an EIP-712 sale approval in the following format.  

*Note: one of the fields that will be signed is the maximum royalty fee that will be deducted from the proceeds.  Upon each signature request, this max royalty fee amount should be queried from the NFT contract using the EIP-2981 `royaltyInfo` function.  If the on-chain royalty increases after the listing has been signed, sales will not execute.  However, if the on-chain royalty is reduced, the reduced royalty fee is paid during the sale.*

```js
EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)

SaleApproval(uint8 protocol,bool sellerAcceptedOffer,address marketplace,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,address privateBuyer,address seller,address tokenAddress,uint256 tokenId,uint256 amount,uint256 minPrice,uint256 expiration,uint256 nonce,uint256 masterNonce,address coin)
```

#### Signing Single Offers

For item-specific offers or purchases where a specific token id was listed, the buyer must be prompted to sign an EIP-712 offer approval in the following format.  

```js
EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)

OfferApproval(uint8 protocol,address marketplace,uint256 marketplaceFeeNumerator,address delegatedPurchaser,address buyer,address tokenAddress,uint256 tokenId,uint256 amount,uint256 price,uint256 expiration,uint256 nonce,uint256 masterNonce,address coin)
```

For collection-level offers where not specific token id is requested, the buyer must be prompted to sign an EIP-712 offer approval in the following format.  

```js
EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)

CollectionOfferApproval(uint8 protocol,bool collectionLevelOffer,address marketplace,uint256 marketplaceFeeNumerator,address delegatedPurchaser,address buyer,address tokenAddress,uint256 amount,uint256 price,uint256 expiration,uint256 nonce,uint256 masterNonce,address coin)
```

#### Signing Bundled Listings

Sellers can also list a bundle of NFTs from the same collection with a single signature.  The signature format for a bundled listing is:

```js
EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)

BundledSaleApproval(uint8 protocol,address marketplace,uint256 marketplaceFeeNumerator,address privateBuyer,address seller,address tokenAddress,uint256 expiration,uint256 nonce,uint256 masterNonce,address coin,uint256[] tokenIds,uint256[] amounts,uint256[] maxRoyaltyFeeNumerators,uint256[] itemPrices)
```

#### Signing Bundled Offers (Offers on Listed Bundle or Collection Sweeps)

For offers on bundled listings or collection sweeps, buyers can sign a bulk offer approval.  The signature format for bundled offers is:

```js
EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)

BundledOfferApproval(uint8 protocol,address marketplace,uint256 marketplaceFeeNumerator,address delegatedPurchaser,address buyer,address tokenAddress,uint256 price,uint256 expiration,uint256 nonce,uint256 masterNonce,address coin,uint256[] tokenIds,uint256[] amounts,uint256[] itemSalePrices)
```

#### Canceling Listings or Offers

To cancel a listing, prompt the seller to `revokeSingleNonce(marketplace.address, listingNonce)`.  Provide the nonce of the listing the user has selected for cancellation.

To cancel an offer, prompt the buyer to `revokeSingleNonce(marketplace.address, offerNonce)`.  Provide the nonce of the offer the user has selected for cancellation.

Users may cancel all existing listings and offers by calling `revokeMasterNonce()`.

#### Executing Sale Functions

The purchase flows described above can be achieved by executing one of the following `buy` functions.

  - `buySingleListing(MatchedOrder memory saleDetails, SignatureECDSA memory signedListing, SignatureECDSA memory signedOffer)`
  - `buyBatchOfListings(MatchedOrder[] calldata saleDetailsArray, SignatureECDSA[] calldata signedListings, SignatureECDSA[] calldata signedOffers)`
  - `buyBundledListing(SignatureECDSA memory signedListing, SignatureECDSA memory signedOffer, MatchedOrderBundleExtended memory bundleDetails,BundledItem[] calldata bundleItems)`
  - `sweepCollection(SignatureECDSA memory signedOffer,MatchedOrderBundleBase memory bundleDetails, BundledItem[] calldata bundleItems, SignatureECDSA[] calldata signedListings)`

# Payment Process vs Seaport Gas Comparison

A "Cold" purchase is one where the seller and buyer have never interacted with either the marketplace or NFT contract before.  These tend to be the most expensive, one-time transactions because they often involve setting storage slot values from zero to non-zero values at a cost of 20K gas units each.  A "Warm" purchase is one where the seller and buyer have both interacted with the marketplace contract before and where the buyer's NFT balance is already greater than zero.  The "Warm" transaction cost is more representative of the majority of transactions as buyers and sellers are far more likely to buy and sell more than one NFT over the lifetime of the wallet.

Also note that transaction costs will vary a lot depending on a large number of variables that impact control flow of the smart contract (ETH vs ERC20 payment, ERC721 vs ERC1155, warm vs cold sells/buys, custom conduits/zones/advanced order criteria in Seaport, etc).  For purposes of benchmarking identical scenarios we have focused on the following scenarios:

**Sale Types:**
- Buy Single Listing
- Buy Bundled Listing (1 buyer, 1 seller, multiple items from a single collection)
- Collection Sweep (1 buyer, multiple sellers, multiple items from a single collection)

**Conditions:**

- Native ETH Payment
- ERC721 Token Sales
- No Fees
- Marketplace-Only Fees, 
- Marketplace and Royalty Fees
- Warm vs Cold Purchases

## Benchmark - Buy Single Listing (Seaport vs Payment Processor)

Number of Runs: 100

| Items | Benchmark                       | Seaport 1.5 Gas (Warm) | Payment Processor Gas (Warm) | +/- Gas Usage | Seaport 1.5 Gas (Cold) | Payment Processor Gas (Cold) | +/- Gas Usage |
|-------|---------------------------------|------------------------|------------------------------|---------------|------------------------|------------------------------|---------------|
| 1     | No Fees                         | 42,087                 | 37,123                       | -4,964        | 66,362                 | 101,906                      | +35,544       |
| 1     | Marketplace Fees                | 49,007                 | 42,794                       | -6,213        | 75,262                 | 111,406                      | +36,144       |
| 1     | Marketplace and Royalty Fees    | 55,929                 | 48,697                       | -7,232        | 84,164                 | 121,234                      | +37,070       |

## Benchmark - Buy Single Listing (Blur vs Payment Processor)

Number of Runs: 100

| Items | Benchmark                       | Blur (Warm) | Payment Processor Gas (Warm) | +/- Gas Usage | Blur Gas (Cold) | Payment Processor Gas (Cold) | +/- Gas Usage |
|-------|---------------------------------|-------------|------------------------------|---------------|-----------------|------------------------------|---------------|
| 1     | No Fees                         | 184,886     | 37,123                       | -147,763      | 198,432         | 101,906                      | -96,526       |
| 1     | Marketplace Fees                | 195,228     | 42,794                       | -152,434      | 208,758         | 111,406                      | -97,352       |
| 1     | Marketplace and Royalty Fees    | 205,557     | 48,697                       | -156,860      | 219,100         | 121,234                      | -97,866       |

## Benchmark - Buy Bundled Listing (Seaport vs Payment Processor)

Number of Runs: 100

| Items | Benchmark                       | Seaport 1.5 Gas (Warm) | Payment Processor Gas (Warm) | +/- Gas Usage | Seaport 1.5 Gas (Cold) | Payment Processor Gas (Cold) | +/- Gas Usage |
|-------|---------------------------------|------------------------|------------------------------|---------------|------------------------|------------------------------|---------------|
| 2     | No Fees                         | 62,125                 | 55,355                       | -6,770        | 86,400                 | 124,638                      | +38,238       |
| 2     | Marketplace Fees                | 77,577                 | 61,061                       | -16,516       | 107,049                | 134,203                      | +27,154       |
| 2     | Marketplace and Royalty Fees    | 93,316                 | 66,372                       | -26,944       | 128,799                | 144,304                      | +15,505       |
| 3     | No Fees                         | 77,413                 | 66,798                       | -10,615       | 104,377                | 138,886                      | +34,509       |
| 3     | Marketplace Fees                | 102,934                | 72,540                       | -30,394       | 135,753                | 148,516                      | +12,763       |
| 3     | Marketplace and Royalty Fees    | 131,652                | 78,847                       | -52,805       | 167,135                | 158,870                      | -8,265        |
| 5     | No Fees                         | 112,191                | 92,041                       | -20,150       | 142,535                | 167,460                      | -24,925       |
| 5     | Marketplace Fees                | 160,357                | 99,287                       | -61,070       | 193,176                | 177,220                      | -15,956       |
| 5     | Marketplace and Royalty Fees    | 208,537                | 107,652                      | -100,885      | 243,831                | 188,040                      | -55,791       |
| 30    | No Fees                         | 589,814                | 456,110                      | -133,704      | 620,158                | 531,527                      | -88,631       |
| 30    | Marketplace Fees                | 879,669                | 464,479                      | -415,190      | 912,488                | 542,412                      | -370,076      |
| 30    | Marketplace and Royalty Fees    | 1,170,030              | 479,167                      | -690,863      | 1,205,324              | 559,577                      | -645,747      |
| 100   | No Fees                         | 1,933,443              | 1,540,973                    | -392,470      | 1,963,787              | 1,616,390                    | -347,397      |
| 100   | Marketplace Fees                | 2,908,756              | 1,552,491                    | -1,356,265    | 2,941,575              | 1,630,405                    | -1,311,170    |
| 100   | Marketplace and Royalty Fees    | 3,889,693              | 1,584,891                    | -2,304,802    | 3,924,987              | 1,665,300                    | -2,259,687    |

## Benchmark - Buy Bundled Listing (Blur vs Payment Processor)

Number of Runs: 100

| Items | Benchmark                       | Blur (Warm)            | Payment Processor Gas (Warm) | +/- Gas Usage | Blur Gas (Cold) | Payment Processor Gas (Cold) | +/- Gas Usage |
|-------|---------------------------------|------------------------|------------------------------|---------------|-----------------|------------------------------|---------------|
| 2     | No Fees                         | 321,257                | 55,355                       | -265,902      | 334,647         | 124,638                      | -210,009      |
| 2     | Marketplace Fees                | 340,570                | 61,061                       | -279,509      | 357,321         | 134,203                      | -223,118      |
| 2     | Marketplace and Royalty Fees    | 363,933                | 66,372                       | -297,561      | 380,692         | 144,304                      | -236,388      |
| 3     | No Fees                         | 438,912                | 66,798                       | -372,114      | 455,645         | 138,886                      | -316,759      |
| 3     | Marketplace Fees                | 472,737                | 72,540                       | -400,197      | 489,503         | 148,516                      | -341,987      |
| 3     | Marketplace and Royalty Fees    | 506,551                | 78,847                       | -427,704      | 523,318         | 158,870                      | -364,448      |
| 5     | No Fees                         | 682,440                | 92,041                       | -590,399      | 699,115         | 167,460                      | -531,655      |
| 5     | Marketplace Fees                | 737,182                | 99,287                       | -637,895      | 753,925         | 177,220                      | -576,705      |
| 5     | Marketplace and Royalty Fees    | 791,848                | 107,652                      | -684,196      | 808,576         | 188,040                      | -620,536      |
| 30    | No Fees                         | 3,730,935              | 456,110                      | -3,274,825    | 3,746,397       | 531,527                      | -3,214,870    |
| 30    | Marketplace Fees                | 4,047,087              | 464,479                      | -3,582,608    | 4,062,670       | 542,412                      | -3,520,258    |
| 30    | Marketplace and Royalty Fees    | 4,362,865              | 479,167                      | -3,883,698    | 4,378,440       | 559,577                      | -3,818,863    |

## Benchmark - Collection Sweeps (Seaport vs Payment Processor)

Number of Runs: 50

| Items | Benchmark                       | Seaport 1.5 Gas (Warm) | Payment Processor Gas (Warm) | +/- Gas Usage | Seaport 1.5 Gas (Cold) | Payment Processor Gas (Cold) | +/- Gas Usage |
|-------|---------------------------------|------------------------|------------------------------|---------------|------------------------|------------------------------|---------------|
| 2     | No Fees                         | 102,160                | 70,045                       | -32,115       | 165,639                | 189,853                      | +24,214       |
| 2     | Marketplace Fees                | 122,080                | 75,753                       | -46,327       | 191,770                | 199,418                      | +7,648        |
| 2     | Marketplace and Royalty Fees    | 142,027                | 81,859                       | -60,168       | 219,111                | 209,539                      | -9,572        |
| 3     | No Fees                         | 149,670                | 96,150                       | -53,520       | 234,533                | 249,039                      | +14,506       |
| 3     | Marketplace Fees                | 179,555                | 101,895                      | -77,660       | 270,447                | 258,669                      | -11,778       |
| 3     | Marketplace and Royalty Fees    | 209,517                | 108,203                      | -101,314      | 310,274                | 269,043                      | -41,231       |
| 5     | No Fees                         | 244,782                | 148,539                      | -96,243       | 372,413                | 373,691                      | +1,278        |
| 5     | Marketplace Fees                | 294,679                | 154,336                      | -140,343      | 428,016                | 381,467                      | -46,549       |
| 5     | Marketplace and Royalty Fees    | 344,770                | 161,027                      | -183,743      | 492,942                | 390,171                      | -102,771      |
| 30    | No Fees                         | 1,450,706              | 828,888                      | -621,818      | 2,106,248              | 1,971,040                    | -135,208      |
| 30    | Marketplace Fees                | 1,759,745              | 835,596                      | -924,149      | 2,421,647              | 1,979,668                    | -441,979      |
| 30    | Marketplace and Royalty Fees    | 2,075,592              | 849,970                      | -1,225,622    | 2,814,840              | 1,993,416                    | -821,424      |
| 100   | No Fees                         | 4,925,523              | 2,860,887                    | -2,064,636    | 7,062,825              | 6,576,872                    | -485,953      |
| 100   | Marketplace Fees                | 6,048,476              | 2,870,117                    | -3,178,359    | 8,240,526              | 6,587,988                    | -1,652,538    |
| 100   | Marketplace and Royalty Fees    | 7,222,296              | 2,904,517                    | -4,317,779    | 9,695,946              | 6,615,968                    | -3,079,978    |

## Benchmark - Collection Sweeps (Blur vs Payment Processor)

Number of Runs: 100

| Items | Benchmark                       | Blur (Warm)            | Payment Processor Gas (Warm) | +/- Gas Usage | Blur Gas (Cold) | Payment Processor Gas (Cold) | +/- Gas Usage |
|-------|---------------------------------|------------------------|------------------------------|---------------|-----------------|------------------------------|---------------|
| 2     | No Fees                         | 331,899                | 70,045                       | -261,854      | 345,306         | 189,853                      | -155,453      |
| 2     | Marketplace Fees                | 350,652                | 75,753                       | -274,899      | 365,826         | 199,418                      | -166,408      |
| 2     | Marketplace and Royalty Fees    | 372,432                | 81,859                       | -290,573      | 389,180         | 209,539                      | -179,641      |
| 3     | No Fees                         | 455,922                | 96,150                       | -359,772      | 472,664         | 249,039                      | -223,625      |
| 3     | Marketplace Fees                | 489,745                | 101,895                      | -387,850      | 506,462         | 258,669                      | -247,793      |
| 3     | Marketplace and Royalty Fees    | 523,548                | 108,203                      | -415,345      | 540,306         | 269,043                      | -271,263      |
| 5     | No Fees                         | 716,446                | 148,539                      | -567,907      | 733,148         | 373,691                      | -359,457      |
| 5     | Marketplace Fees                | 771,185                | 154,336                      | -616,849      | 787,923         | 381,467                      | -406,456      |
| 5     | Marketplace and Royalty Fees    | 825,848                | 161,027                      | -664,821      | 842,554         | 390,171                      | -452,383      |
| 30    | No Fees                         | 3,977,446              | 828,888                      | -3,148,558    | 3,993,059       | 1,971,040                    | -2,022,019    |
| 30    | Marketplace Fees                | 4,293,595              | 835,596                      | -3,457,999    | 4,308,999       | 1,979,668                    | -2,329,331    |
| 30    | Marketplace and Royalty Fees    | 4,609,378              | 849,970                      | -3,759,408    | 4,624,913       | 1,993,416                    | -2,631,497    |

[The Seaport Benchmark Test Code can be found here!](https://github.com/nathanglb/seaport-gas-benchmark/blob/main/test/foundry/gas/Benchmark.t.sol)

[The Blur Benchmark Test Code can be found here!](https://github.com/nathanglb/blur-exchange-gas-benchmark/blob/main/tests/benchmark.test.ts)

[The Payment Processor Benchmark Test Code can be found here!](./test/foundry/gas/Benchmark.t.sol)

## License

This project is released under the [MIT License](LICENSE).