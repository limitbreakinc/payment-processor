//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

// The denominator used when calculating the marketplace fee.
// 0.5% fee numerator is 50, 1% fee numerator is 100, 10% fee numerator is 1,000 and so on.
uint256 constant FEE_DENOMINATOR = 100_00;

// Default Payment Method Whitelist Id
uint32 constant DEFAULT_PAYMENT_METHOD_WHITELIST_ID = 0;

// The default admin role for NFT collections using Access Control.
bytes32 constant DEFAULT_ACCESS_CONTROL_ADMIN_ROLE = 0x00;

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
/*                   PAYMENT SETTINGS TYPES                   */
/**************************************************************/

uint8 constant PAYMENT_SETTINGS_DEFAULT_WHITELIST = 0;
uint8 constant PAYMENT_SETTINGS_ALLOW_ANY = 1;
uint8 constant PAYMENT_SETTINGS_CUSTOM_WHITELIST = 2;
uint8 constant PAYMENT_SETTINGS_PRICING_CONSTRAINTS_COLLECTION_ONLY = 3;
uint8 constant PAYMENT_SETTINGS_PRICING_CONSTRAINTS = 4;
uint8 constant PAYMENT_SETTINGS_PAUSED = 5;