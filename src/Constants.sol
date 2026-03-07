//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

bytes32 constant COSIGNATURE_HASH = keccak256("Cosignature(uint8 v,bytes32 r,bytes32 s,uint256 expiration,address taker)");
bytes32 constant COLLECTION_OFFER_APPROVAL_HASH = keccak256("CollectionOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)");
bytes32 constant ITEM_OFFER_APPROVAL_HASH = keccak256("ItemOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce)");
bytes32 constant TOKEN_SET_OFFER_APPROVAL_HASH = keccak256("TokenSetOfferApproval(uint8 protocol,address cosigner,address buyer,address beneficiary,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 nonce,uint256 masterNonce,bytes32 tokenSetMerkleRoot)");
bytes32 constant SALE_APPROVAL_HASH = keccak256("SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)");
bytes32 constant PERMITTED_TRANSFER_SALE_APPROVAL = keccak256("PermitTransferFromWithAdditionalData(uint256 tokenType,address token,uint256 id,uint256 amount,uint256 nonce,address operator,uint256 expiration,uint256 masterNonce,SaleApproval approval)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)");
bytes32 constant PERMITTED_ORDER_SALE_APPROVAL = keccak256("PermitOrderWithAdditionalData(uint256 tokenType,address token,uint256 id,uint256 amount,uint256 salt,address operator,uint256 expiration,uint256 masterNonce,SaleApproval approval)SaleApproval(uint8 protocol,address cosigner,address seller,address marketplace,address fallbackRoyaltyRecipient,address paymentMethod,address tokenAddress,uint256 tokenId,uint256 amount,uint256 itemPrice,uint256 expiration,uint256 marketplaceFeeNumerator,uint256 maxRoyaltyFeeNumerator,uint256 nonce,uint256 masterNonce,uint256 protocolFeeVersion)");

// The denominator used when calculating the marketplace fee.
// 0.5% fee numerator is 50, 1% fee numerator is 100, 10% fee numerator is 1,000 and so on.
uint256 constant FEE_DENOMINATOR = 100_00;

// Default Payment Method Whitelist Id
uint32 constant DEFAULT_PAYMENT_METHOD_WHITELIST_ID = 0;

// Convenience to avoid magic number in bitmask get/set logic.
uint256 constant ZERO = uint256(0);
uint256 constant ONE = uint256(1);

/**
 * @dev Defines condition to apply to order execution.
 */
// 0: ERC721 order that must execute in full or not at all.
uint256 constant ORDER_PROTOCOLS_ERC721_FILL_OR_KILL = 0;
// 1: ERC1155 order that must execute in full or not at all.
uint256 constant ORDER_PROTOCOLS_ERC1155_FILL_OR_KILL = 1;
// 2: ERC1155 order that may be partially executed.
uint256 constant ORDER_PROTOCOLS_ERC1155_FILL_PARTIAL = 2;
// 3: Invalid order protocol for type check.
uint256 constant ORDER_PROTOCOLS_INVALID = 3;

/**
 * @dev Defines types of offers to be executed
 */
// 0: Offer for any item in a collection.
uint256 constant OFFER_TYPE_COLLECTION_OFFER = 0;
// 1: Offer for a specific item in a collection.
uint256 constant OFFER_TYPE_ITEM_OFFER = 1;
// 2: Offer for a set of tokens in a collection.
uint256 constant OFFER_TYPE_TOKEN_SET_OFFER = 2;

/// @dev The default protocol fee settings.
uint16 constant DEFAULT_PROTOCOL_FEE_MINIMUM_BPS = 25;
uint16 constant DEFAULT_PROTOCOL_FEE_MARKETPLACE_TAX_BPS = 15_00;
uint16 constant DEFAULT_PROTOCOL_FEE_FEE_ON_TOP_TAX_BPS = 25_00;

// The default admin role for NFT collections using Access Control.
bytes32 constant DEFAULT_ACCESS_CONTROL_ADMIN_ROLE = 0x00;

/// @dev The plain text message to sign for cosigner self-destruct signature verification
string constant COSIGNER_SELF_DESTRUCT_MESSAGE_TO_SIGN = "COSIGNER_SELF_DESTRUCT";

/**************************************************************/
/*                   PRECOMPUTED SELECTORS                    */
/**************************************************************/

bytes4 constant SELECTOR_DESTROY_COSIGNER = hex"aa04bf59";
bytes4 constant SELECTOR_REVOKE_MASTER_NONCE = hex"226d4adb";
bytes4 constant SELECTOR_REVOKE_SINGLE_NONCE = hex"b6d7dc33";
bytes4 constant SELECTOR_REVOKE_ORDER_DIGEST = hex"96ae0380";

bytes4 constant SELECTOR_BUY_LISTING = hex"27c46dc4";
bytes4 constant SELECTOR_ACCEPT_OFFER = hex"dbbb7e9d";
bytes4 constant SELECTOR_BULK_BUY_LISTINGS = hex"69bdcb08";
bytes4 constant SELECTOR_BULK_ACCEPT_OFFERS = hex"0aa91514";
bytes4 constant SELECTOR_SWEEP_COLLECTION = hex"6a89f68a";

bytes4 constant SELECTOR_BUY_LISTING_ADVANCED = hex"679d2803";
bytes4 constant SELECTOR_ACCEPT_OFFER_ADVANCED = hex"06814765";
bytes4 constant SELECTOR_BULK_BUY_LISTINGS_ADVANCED = hex"7497030d";
bytes4 constant SELECTOR_BULK_ACCEPT_OFFERS_ADVANCED = hex"088df090";
bytes4 constant SELECTOR_SWEEP_COLLECTION_ADVANCED = hex"b9d8d5a6";

/**************************************************************/
/*                   EXPECTED BASE msg.data LENGTHS           */
/**************************************************************/

uint256 constant PROOF_ELEMENT_SIZE = 32;

// | 4        | 544         | 96              | 192         | 64       | = 900 bytes
// | selector | saleDetails | sellerSignature | cosignature | feeOnTop |
uint256 constant BASE_MSG_LENGTH_BUY_LISTING = 900;

// | 4        | 32                     | 544         |  96             | 32 + (64 + (32 * proof.length)) | 192         | 64       | = 1028 bytes + (32 * proof.length)
// | selector | offerType              | saleDetails |  buyerSignature | tokenSetProof                   | cosignature | feeOnTop |
uint256 constant BASE_MSG_LENGTH_ACCEPT_OFFER = 1028;

// | 4        | 64              | 544 * length      | 64              | 96 * length      | 64              | 192 * length | 64              | 64 * length | = 260 bytes + (896 * saleDetailsArray.length)
// | selector | length + offset | saleDetailsArray  | length + offset | sellerSignatures | length + offset | cosignatures | length + offset | feesOnTop   |
uint256 constant BASE_MSG_LENGTH_BULK_BUY_LISTINGS = 260;
uint256 constant BASE_MSG_LENGTH_BULK_BUY_LISTINGS_PER_ITEM = 896;

// | 4        | 64               | 32 * length      | 32 * length            | 544 * length      | 96 * length  | 192 * length | 64               | 64               | 64 * length | 64               | 32 + (64 + (32 * proof.length)) | = 228 bytes + (1056 * saleDetailsArray.length) + (32 * proof.length [for each element])
// | selector | length + offsets | offsets          | offerType              | saleDetails       | signature    | cosignature  | length + offset  | length + offsets | feesOnTop   | length + offsets | tokenSetProof                   |
uint256 constant BASE_MSG_LENGTH_BULK_ACCEPT_OFFERS = 196;
uint256 constant BASE_MSG_LENGTH_BULK_ACCEPT_OFFERS_PER_ITEM = 1024;

// | 4        | 64       | 128        | 64              | 352 * length | 64              | 96 * length      | 64              | 192 * length | = 388 bytes + (640 * items.length)
// | selector | feeOnTop | sweepOrder | length + offset | items        | length + offset | signedSellOrders | length + offset | cosignatures |
uint256 constant BASE_MSG_LENGTH_SWEEP_COLLECTION = 388;
uint256 constant BASE_MSG_LENGTH_SWEEP_COLLECTION_PER_ITEM = 640;

// Advanced Trade Functions

// | 4        | 544         | 96        | 192         | 64       | 64            | 32 + (96 + (32 * proof.length)) | = 1092 bytes + (32 * proof.length)
// | selector | saleDetails | signature | cosignature | feeOnTop | permitContext | bulkOrderProof                  |
uint256 constant BASE_MSG_LENGTH_BUY_LISTING_ADVANCED = 1092;

// | 4        | 32                     | 544         |  96        | 192         | 64       | 64            | 32 + (96 + (32 * proof.length)) | 32 + (64 + (32 * proof.length)) | 96                    | = 1316 bytes + (32 * tokenSetProof.length) + (32 * bulkOrderProof.length)
// | selector | offerType              | saleDetails |  signature | cosignature | feeOnTop | permitContext | bulkOrderProof                  | tokenSetProof                   | sellerPermitSignature |
uint256 constant BASE_MSG_LENGTH_ACCEPT_OFFER_ADVANCED = 1316;

// | 4        | 64              | 544 * length      | 96 * length  | 192 * length | 64 * length   | 32 + (96 + (32 * proof.length)) | 64              | 64 * length | = 132 bytes + (1088 * advancedListingsArray.length) + (32 * bulkOrderProof.proof.length [for each element])
// | selector | length + offset | saleDetails       | signature    | cosignature  | permitContext | bulkOrderProof                  | length + offset | feeOnTop    |
uint256 constant BASE_MSG_LENGTH_BULK_BUY_LISTINGS_ADVANCED = 196;
uint256 constant BASE_MSG_LENGTH_BULK_BUY_LISTINGS_ADVANCED_PER_ITEM = 1088;

// | 4        | 64              | 32 * length            | 544 * length | 96 * length | 192 * length | 64 * length   | 96 * length           | 64              | 32 + (96 + (32 * proof.length)) | 64              | 64 * length | 64              | 32 + (64 + (32 * proof.length)) | = 260 bytes + (1312 * saleDetailsArray.length) + (32 * proof.length [for each element])
// | selector | length + offset | offerType              | saleDetails  | signature   | cosignatures | permitContext | sellerPermitSignature | length + offset | bulkOrderProof                  | length + offset | feeOnTop    | length + offset | tokenSetProof                   |
uint256 constant BASE_MSG_LENGTH_BULK_ACCEPT_OFFERS_ADVANCED = 260;
uint256 constant BASE_MSG_LENGTH_BULK_ACCEPT_OFFERS_ADVANCED_PER_ITEM = 1312;

// | 4        | 64       | 128        | 64              | 352 * length | 96 * length | 192 * length | 32 + (96 + (32 * proof.length)) | = 292 bytes + (864 * items.length) + (32 * bulkOrderProof.proof.length [for each element])
// | selector | feeOnTop | sweepOrder | length + offset | items        | signature   | cosignatures | bulkOrderProof                  |
uint256 constant BASE_MSG_LENGTH_SWEEP_COLLECTION_ADVANCED = 292;
uint256 constant BASE_MSG_LENGTH_SWEEP_COLLECTION_ADVANCED_PER_ITEM = 864;

/**************************************************************/
/*                           FLAGS                            */
/**************************************************************/

// Flags are used to efficiently store and retrieve boolean values in a single uint8.
// Each flag is a power of 2, so they can be combined using bitwise OR (|) and checked using bitwise AND (&).
// For example, to set the first and third flags, you would use: flags = FLAG1 | FLAG3;
// To check if the first flag is set, you would use: if (flags & FLAG1 != 0) { ... }
uint8 constant FLAG_IS_ROYALTY_BOUNTY_EXCLUSIVE = 1 << 0;
uint8 constant FLAG_BLOCK_TRADES_FROM_UNTRUSTED_CHANNELS = 1 << 1;
uint8 constant FLAG_USE_BACKFILL_AS_ROYALTY_SOURCE = 1 << 2;

/**************************************************************/
/*                   BULK ORDER TYPEHASHES                    */
/**************************************************************/

/// @dev Constant lookup tables for bulk order typehashes. The typehash offset is 32 * (height - 1) bytes.
bytes constant BULK_SALE_APPROVAL_TYPEHASHES_LOOKUP = 
    hex"8659f55d4c88f84030fe09241169834754ebf2e61099b616e530c6b65712c6445106f4043cda72e04ca2c760016628ea8d5667309323ba590682ea5254b4e82e71267a8f42e7ccde4ac75848a93b741df7a2f7a58e40274055f2fa51dbaa69ce6e90557aed2a349f8b6efb2b652c4025c56cfa82424c5cd0c6801cc234ebf519caf42fc49ad57705ea6be2ca9e1835c9ccddf7bc6fdea8f851917329b1d53a7f09b32b6b5ffee898d5fe18398652042cc8c46449329c5a1a79e425f4ede9bc2bc2362dea3338b88607906397acfdcc5651f19b40a038ee7c89dc4ab54c736cacf2bbc4f6d7ccfa2b8aab6505f0c8f2868c5a190c6c4cfce8c0de447804904df981f99e15003039550d3597e34e6426b1e230992a5a3727cb5e230754f18f3566012178d0a6b8f8748e48411572bdc391435539737aafc91fcba6f2c24ae156cf";

bytes constant BULK_COLLECTION_OFFER_APPROVAL_TYPEHASHES_LOOKUP = 
    hex"fb1dd652f3a5dcde3cb90b0cbb7ff0d33df15a48f216e6ac0e2306ff3538e33632fc12675167bd2e9c23f1a9b90ce9c0a14daa7e8b3fa5a01105804ad64aa49d22beb101a4a232e5b05a7b5f4727888724dd418194d6c5b1f1ba5ead4cbeed429ba46e6a390d8f8edfb6f752177c215b1cf8b6dcf1f5da395ead6c3e19755698ae93fe4a03206f6bb45035fab04a39964c83e7d265e93fc31521c86dd25a3be4ee3cb9e25b214af21b0d321776864470916324653397b355b267b2894a009a98516d5d5306f95a17cb6d0b84e71f78919a98ac5e3c723fc4b9b1a720193d590df5b1dcad1bd5c8161d6b904513bc658d4c9b8c288b2271e0f27d5938654e418663c21e3ce7e506548c01ef4e6a27a5805f9328e0da83e9a7c765dc28266a5aa19802b2e35d72255f2ae69bed829f0104723aa156059e02dfccfe781ffc955356";

bytes constant BULK_ITEM_OFFER_APPROVAL_TYPEHASHES_LOOKUP =
    hex"243dc86e63d73b10b2764253a38ab8763ded4ac63a632adef4019e482161964a2ed4880b2bfec74882da06ca9f461158c42fa73fa5974b5abec9fcde7cdd43ee8308607f65c90c023abf48563d2c8bd8c783d1db48ffd02ec324105d9f682f961f7a30dcec9205ff30a5290b3b756e1fd1a1585539bccbc817ab4e59d69a055ecfa8c0abdff5fb2704d1818f38dc974f5bdde6dfe1a4ddc3e22a1f3e593e98f324e3124a40922800d1eb1890240fc7d07f257a303bb383e8c0820e9910be1f97c72769ff919066b8d1f586bb8b7e720ad93f735ffa9570f9e9ef0e865d13251d89338818bfd140179260dbdc6d6bf38461d49661c166f2b76d3b56727acab7adf3e381ed4335a28fa612f4068c58de673cad05c8a7fbfb5c1fd557c2c5a2de9f84c94a0cfd84379f92ed5827593e2218a1dc1b975626bbe5c6948b9d2232f7d7";

bytes constant BULK_TOKEN_SET_OFFER_APPROVAL_TYPEHASHES_LOOKUP = 
    hex"0d0b16c0b281480a518e0ae1543bf94c612edc289e45edc04e8510dac617afa4337b9c051f65323200a3580d4917087d4d82e350fcc68b3397c654c9fc7872c38f8f306a409d08a43b82756f57beb839c3bf5bdd388ba0850d9d21f5c1d0c4dc9f510b8ccf7bbda5c9bd4333d7dcfc8e280aac9eaa9427dcd2f2ffca1fa7a8338599a8fc89aae892d7419812435866d931c9da91198b2f48d1d5318acb524461a0f24864e615845dfa14bee5d4fa28950fcdcf9d31893c68c26f4cfa13402a97621dd1d4cc7477f0587a16f5cd40ea8750209653e7275ccaea3b68623860181b51e570aee92287102d49a7493d337e8aa332c1bc639273de546b428973379fa9a9415346b8de2006517a8de68b2b4147a1d6fd91ce600f4040941627c1c8c3dfb75be8e10d720cf92518936f56974bdfa8e4a723902dd12e415ffba6eb6dde12";

/**************************************************************/
/*                           ROLES                            */
/**************************************************************/

bytes32 constant FEE_MANAGER = keccak256("FEE_MANAGER");