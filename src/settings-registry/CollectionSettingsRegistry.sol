//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "./Errors.sol";
import "./SettingsConstants.sol";
import "./SettingsDataTypes.sol";
import "./IPaymentProcessorSettings.sol";
import "./ICollectionSettingsRegistry.sol";
import "@limitbreak/tm-core-lib/src/utils/structs/EnumerableSet.sol";
import "@limitbreak/tm-core-lib/src/licenses/LicenseRef-PolyForm-Strict-1.0.0.sol";

/** 
* @title CollectionSettingsRegistry
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 
contract CollectionSettingsRegistry is ICollectionSettingsRegistry {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint32 public lastPaymentMethodWhitelistId;

    // Core Settings Available For All Payment Processor Versions (3.0+)
    mapping (address collection => CollectionRegistryPaymentSettings) private _collectionPaymentSettings;
    mapping (address => address) private _collectionExclusiveBountyReceivers;
    mapping (address => address) private _collectionBoundedPricingPaymentMethods;
    mapping (address => RegistryPricingBounds) private _collectionPricingBounds;
    mapping (address => mapping (uint256 => RegistryPricingBounds)) private _tokenPricingBounds;
    mapping (address => EnumerableSet.AddressSet) private _collectionTrustedChannels;

    /// @dev An enumerable set of trusted permit processors that may be used with a Payment Processor.
    EnumerableSet.AddressSet private _trustedPermitProcessors;

    // Payment Method Whitelists
    mapping (uint32 => address) private _paymentMethodWhitelistOwners;
    mapping (uint32 => EnumerableSet.AddressSet) private _paymentMethodWhitelists;

    // Extended Settings Available For All Future Payment Processor Versions (3.0+)
    mapping (address collection => mapping (bytes32 extension => bytes data)) private _collectionSettingsExtensionData;
    mapping (address collection => mapping (bytes32 extension => bytes32 word)) private _collectionSettingsExtensionWords;

    constructor(address defaultContractOwner_) {
        unchecked {
            uint32 paymentMethodWhitelistId = lastPaymentMethodWhitelistId++;
            if (paymentMethodWhitelistId != DEFAULT_PAYMENT_METHOD_WHITELIST_ID || 
                lastPaymentMethodWhitelistId <= DEFAULT_PAYMENT_METHOD_WHITELIST_ID) {
                revert CollectionSettingsRegistry__PaymentMethodWhitelistInvalidState();
            }
            _paymentMethodWhitelistOwners[paymentMethodWhitelistId] = defaultContractOwner_;
            emit CreatedPaymentMethodWhitelist(paymentMethodWhitelistId, defaultContractOwner_, "Default Payment Methods");
        }
    }

    /**
     * @notice Allows any user to create a new custom payment method whitelist.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. The payment method whitelist id tracker has been incremented by `1`.
     * @dev    2. The caller has been assigned as the owner of the payment method whitelist.
     * @dev    3. A `CollectionSettingsRegistry__CreatedPaymentMethodWhitelist` event has been emitted.
     *
     * @param  whitelistName             The name of the payment method whitelist.
     * @return paymentMethodWhitelistId  The id of the newly created payment method whitelist.
     */
    function createPaymentMethodWhitelist(
        string calldata whitelistName
    ) external returns (uint32 paymentMethodWhitelistId) {
        address listCreator = msg.sender;
        paymentMethodWhitelistId = lastPaymentMethodWhitelistId++;
        _paymentMethodWhitelistOwners[paymentMethodWhitelistId] = listCreator;
        emit CreatedPaymentMethodWhitelist(paymentMethodWhitelistId, listCreator, whitelistName);
    }

    /**
     * @notice Transfer ownership of a payment method whitelist list to a new owner.
     *
     * @dev Throws when the new owner is the zero address.
     * @dev Throws when the caller does not own the specified list.
     *
     * @dev <h4>Postconditions:</h4>
     *      1. The payment method whitelist list ownership is transferred to the new owner.
     *      2. A `ReassignedPaymentMethodWhitelistOwnership` event is emitted.
     *
     * @param id       The id of the payment method whitelist.
     * @param newOwner The address of the new owner.
     */
    function reassignOwnershipOfPaymentMethodWhitelist(uint32 id, address newOwner) external {
        if(newOwner == address(0)) {
            revert CollectionSettingsRegistry__PaymentMethodWhitelistOwnershipCannotBeTransferredToZeroAddress();
        }

        _reassignOwnershipOfPaymentMethodWhitelist(id, newOwner);
    }

    /**
     * @notice Renounce the ownership of a payment method whitelist, rendering the list immutable.
     *
     * @dev Throws when the caller does not own the specified list.
     *
     * @dev <h4>Postconditions:</h4>
     *      1. The ownership of the specified payment method whitelist is renounced.
     *      2. A `ReassignedPaymentMethodWhitelistOwnership` event is emitted.
     *
     * @param id The id of the payment method whitelist.
     */
    function renounceOwnershipOfPaymentMethodWhitelist(uint32 id) external {
        _reassignOwnershipOfPaymentMethodWhitelist(id, address(0));
    }

    /**
     * @notice Allows custom payment method whitelist owners to approve a new coin for use as a payment currency.
     *
     * @dev    Throws when caller is not the owner of the specified payment method whitelist.
     * @dev    Throws when the specified coin is already whitelisted under the specified whitelist id.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. `paymentMethod` has been approved in `paymentMethodWhitelist` mapping.
     * @dev    2. A `PaymentMethodAddedToWhitelist` event has been emitted.
     *
     * @param  paymentMethodWhitelistId The id of the payment method whitelist to update.
     * @param  paymentMethods           The address of the payment method to whitelist.
     */
    function whitelistPaymentMethod(
        uint32 paymentMethodWhitelistId, 
        address[] calldata paymentMethods,
        address[] calldata paymentProcessorsToSync
    ) external {
        _requireCallerOwnsPaymentMethodWhitelist(paymentMethodWhitelistId);

        EnumerableSet.AddressSet storage ptrPaymentMethods = _paymentMethodWhitelists[paymentMethodWhitelistId];
        for (uint256 i; i < paymentMethods.length;) {
            address paymentMethod = paymentMethods[i];

            if (ptrPaymentMethods.add(paymentMethod)) {
                emit PaymentMethodAddedToWhitelist(paymentMethodWhitelistId, paymentMethod);
            }

            unchecked {
                ++i;
            }
        }

        for (uint256 i; i < paymentProcessorsToSync.length;) {
            IPaymentProcessorSettings(paymentProcessorsToSync[i]).registryUpdateWhitelistPaymentMethods(paymentMethodWhitelistId, paymentMethods, true);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Allows custom payment method whitelist owners to remove a coin from the list of approved payment 
     *         currencies.
     *
     * @dev    Throws when caller is not the owner of the specified payment method whitelist.
     * @dev    Throws when the specified coin is not currently whitelisted under the specified whitelist id.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. `paymentMethod` has been removed from the `paymentMethodWhitelist` mapping.
     * @dev    2. A `CollectionSettingsRegistry__PaymentMethodRemovedFromWhitelist` event has been emitted.
     *
     * @param  paymentMethodWhitelistId  The id of the payment method whitelist to update.
     * @param  paymentMethods             The address of the payment method to unwhitelist.
     */
    function unwhitelistPaymentMethod(
        uint32 paymentMethodWhitelistId, 
        address[] calldata paymentMethods,
        address[] calldata paymentProcessorsToSync
    ) external {
        _requireCallerOwnsPaymentMethodWhitelist(paymentMethodWhitelistId);

        EnumerableSet.AddressSet storage ptrPaymentMethods = _paymentMethodWhitelists[paymentMethodWhitelistId];
        for (uint256 i; i < paymentMethods.length;) {
            address paymentMethod = paymentMethods[i];

            if (ptrPaymentMethods.remove(paymentMethod)) {
                emit PaymentMethodRemovedFromWhitelist(paymentMethodWhitelistId, paymentMethod);
            }

            unchecked {
                ++i;
            }
        }

        for (uint256 i; i < paymentProcessorsToSync.length;) {
            IPaymentProcessorSettings(paymentProcessorsToSync[i]).registryUpdateWhitelistPaymentMethods(paymentMethodWhitelistId, paymentMethods, false);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Forces sync of removed payment methods from the whitelist. This is unowned to allow for anyone to trigger updates of removed payment methods.
     *
     * @dev    Leaving this unowned allows for anyone to trigger the removal of payment methods from the whitelist.
     * @dev    If there is an issue with a payment method, this allows for a quick removal from all payment processors.
     * @dev    Throws when the specified payment method is still whitelisted under the specified whitelist id.
     * 
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. `paymentMethod` has been removed from each payment processor in the `paymentProcessorsToSync` array.
     * @dev    2. X * Y `PaymentMethodRemovedFromWhitelist` events have been emitted where X is the number of payment methods and Y is the number of payment processors to sync.
     *
     * @param  paymentMethodWhitelistId   The id of the payment method whitelist to update.
     * @param  paymentMethods             An array of payment method addresses to remove.
     * @param  paymentProcessorsToSync    An array of the payment processors to sync the removal with.
     */
    function syncRemovedPaymentMethodsFromWhitelist(
        uint32 paymentMethodWhitelistId, 
        address[] calldata paymentMethods,
        address[] calldata paymentProcessorsToSync
    ) external {
        EnumerableSet.AddressSet storage ptrPaymentMethods = _paymentMethodWhitelists[paymentMethodWhitelistId];
        for (uint256 i; i < paymentMethods.length;) {
            if (ptrPaymentMethods.contains(paymentMethods[i])) {
                revert CollectionSettingsRegistry__CannotSyncRemovalOfWhitelistedPaymentMethod();
            }

            unchecked {
                ++i;
            }
        }

        for (uint256 i; i < paymentProcessorsToSync.length;) {
            IPaymentProcessorSettings(paymentProcessorsToSync[i]).registryUpdateWhitelistPaymentMethods(paymentMethodWhitelistId, paymentMethods, false);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Allows the trusted permit processor list owner to add a new trusted permit processor and sync.
     *
     * @dev    Throws when caller is not the owner of the trusted permit processor list.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. `trustedPermitProcessor` has been approved in `_trustedPermitProcessors` list.
     * @dev    2. A `TrustedPermitProcessorAdded` event has been emitted.
     *
     * @param  permitProcessors           The addresses of trusted permit processors to add to the list.
     * @param  paymentProcessorsToSync    An array of the payment processors to sync the removal with.
     */
    function addTrustedPermitProcessors(
        address[] calldata permitProcessors,
        address[] calldata paymentProcessorsToSync
    ) external {
        _requireCallerOwnsTrustedPermitProcessorList();

        for (uint256 i; i < permitProcessors.length;) {
            address trustedPermitProcessor = permitProcessors[i];

            if (_trustedPermitProcessors.add(trustedPermitProcessor)) {
                emit TrustedPermitProcessorAdded(trustedPermitProcessor);
            }

            unchecked {
                ++i;
            }
        }

        for (uint256 i; i < paymentProcessorsToSync.length;) {
            IPaymentProcessorSettings(paymentProcessorsToSync[i]).registryUpdateTrustedPermitProcessors(permitProcessors, true);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Allows the trusted permit processor list owner to remove a trusted permit processor and sync.
     *
     * @dev    Throws when caller is not the owner of the trusted permit processor list.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. `trustedPermitProcessor` has been removed from the `_trustedPermitProcessors` list.
     * @dev    2. A `TrustedPermitProcessorRemoved` event has been emitted.
     *
     * @param  permitProcessors           The addresses of trusted permit processors to remove from the list.
     * @param  paymentProcessorsToSync    An array of the payment processors to sync the removal with.
     */
    function removeTrustedPermitProcessors(
        address[] calldata permitProcessors,
        address[] calldata paymentProcessorsToSync
    ) external {
        _requireCallerOwnsTrustedPermitProcessorList();

        for (uint256 i; i < permitProcessors.length;) {
            address trustedPermitProcessor = permitProcessors[i];

            if (_trustedPermitProcessors.remove(trustedPermitProcessor)) {
                emit TrustedPermitProcessorRemoved(trustedPermitProcessor);
            }

            unchecked {
                ++i;
            }
        }

        for (uint256 i; i < paymentProcessorsToSync.length;) {
            IPaymentProcessorSettings(paymentProcessorsToSync[i]).registryUpdateTrustedPermitProcessors(permitProcessors, false);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Allows the smart contract, the contract owner, or the contract admin of any NFT collection to 
     *         specify the payment settings for their collections.
     *
     * @dev    Throws when the specified tokenAddress is address(0).
     * @dev    Throws when the caller is not the contract, the owner or the administrator of the specified tokenAddress.
     * @dev    Throws when the royalty backfill numerator is greater than 10,000.
     * @dev    Throws when the royalty bounty numerator is greater than 10,000.
     * @dev    Throws when the specified payment method whitelist id does not exist.
     * 
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. The `PaymentSettings` type for the collection has been set.
     * @dev    2. The `paymentMethodWhitelistId` for the collection has been set, if applicable.
     * @dev    3. The `constrainedPricingPaymentMethod` for the collection has been set, if applicable.
     * @dev    4. The `royaltyBackfillNumerator` for the collection has been set.
     * @dev    5. The `royaltyBackfillReceiver` for the collection has been set.
     * @dev    6. The `royaltyBountyNumerator` for the collection has been set.
     * @dev    7. The `exclusiveBountyReceiver` for the collection has been set.
     * @dev    8. The `blockTradesFromUntrustedChannels` for the collection has been set.
     * @dev    8. An `UpdatedCollectionPaymentSettings` event has been emitted.
     *
     * @param  tokenAddress             The smart contract address of the NFT collection.
     * @param  params                   The payment settings parameters for the collection.
     * @param  dataExtensions           The data extensions to set.
     * @param  dataSettings             The data settings to set.
     * @param  wordExtensions           The word extensions to set.
     * @param  wordSettings             The word settings to set.
     * @param  paymentProcessorsToSync  An array of the payment processors to sync the removal with.
     */
    function setCollectionPaymentSettings(
        address tokenAddress, 
        CollectionPaymentSettingsParams memory params,
        bytes32[] memory dataExtensions, 
        bytes[] memory dataSettings,
        bytes32[] memory wordExtensions,
        bytes32[] memory wordSettings,
        address[] calldata paymentProcessorsToSync
    ) external {
        _requireCallerIsNFTOrContractOwnerOrAdmin(tokenAddress);

        if (dataExtensions.length != dataSettings.length) {
            revert CollectionSettingsRegistry__InputArrayLengthMismatch();
        }

        if (wordExtensions.length != wordSettings.length) {
            revert CollectionSettingsRegistry__InputArrayLengthMismatch();
        }

        if (params.royaltyBackfillNumerator > FEE_DENOMINATOR) {
            revert CollectionSettingsRegistry__RoyaltyBackfillNumeratorCannotExceedFeeDenominator();
        }

        if (params.royaltyBountyNumerator > FEE_DENOMINATOR) {
            revert CollectionSettingsRegistry__RoyaltyBountyNumeratorCannotExceedFeeDenominator();
        }

        RegistryPricingBounds memory pricingBounds;

        if (
            params.paymentSettings == PAYMENT_SETTINGS_DEFAULT_WHITELIST || 
            params.paymentSettings == PAYMENT_SETTINGS_ALLOW_ANY
        ) {
            params.paymentMethodWhitelistId = 0;
            params.constrainedPricingPaymentMethod = address(0);
        } else if (params.paymentSettings == PAYMENT_SETTINGS_CUSTOM_WHITELIST) {
            params.constrainedPricingPaymentMethod = address(0);
        } else if (params.paymentSettings == PAYMENT_SETTINGS_PRICING_CONSTRAINTS || 
            params.paymentSettings == PAYMENT_SETTINGS_PRICING_CONSTRAINTS_COLLECTION_ONLY) {
            params.paymentMethodWhitelistId = 0;

            if(params.collectionMinimumFloorPrice > params.collectionMaximumCeilingPrice) {
                revert CollectionSettingsRegistry__CeilingPriceMustBeGreaterThanFloorPrice();
            }

            pricingBounds.ceilingPrice = params.collectionMaximumCeilingPrice;
            pricingBounds.floorPrice = params.collectionMinimumFloorPrice;
            pricingBounds.isSet = true;
        }

        if (params.paymentMethodWhitelistId > lastPaymentMethodWhitelistId) {
            revert CollectionSettingsRegistry__PaymentMethodWhitelistDoesNotExist();
        }

        _collectionPricingBounds[tokenAddress] = pricingBounds;
        _collectionBoundedPricingPaymentMethods[tokenAddress] = params.constrainedPricingPaymentMethod;
        _collectionExclusiveBountyReceivers[tokenAddress] = params.exclusiveBountyReceiver;

        _collectionPaymentSettings[tokenAddress] = CollectionRegistryPaymentSettings({
            initialized: true, 
            paymentSettingsType: params.paymentSettings,
            paymentMethodWhitelistId: params.paymentMethodWhitelistId,
            royaltyBackfillReceiver: params.royaltyBackfillReceiver,
            royaltyBackfillNumerator: params.royaltyBackfillNumerator,
            royaltyBountyNumerator: params.royaltyBountyNumerator,
            extraData: params.extraData
        });

        if (dataExtensions.length > 0) {
            mapping (bytes32 => bytes) storage ptrSettingsForCollection = _collectionSettingsExtensionData[tokenAddress];

            for (uint256 i = 0; i < dataExtensions.length;) {
                ptrSettingsForCollection[dataExtensions[i]] = dataSettings[i];

                unchecked {
                    ++i;
                }
            }
        }

        if (wordExtensions.length > 0) {
            mapping (bytes32 => bytes32) storage ptrSettingsForCollection = _collectionSettingsExtensionWords[tokenAddress];

            for (uint256 i = 0; i < wordExtensions.length;) {
                ptrSettingsForCollection[wordExtensions[i]] = wordSettings[i];

                unchecked {
                    ++i;
                }
            }
        }

        for (uint256 i; i < paymentProcessorsToSync.length;) {
            IPaymentProcessorSettings(paymentProcessorsToSync[i]).registrySyncSettings(tokenAddress);

            unchecked {
                ++i;
            }
        }
        
        emit UpdatedCollectionPaymentSettings(tokenAddress, params);
    }

    /**
     * @notice Allows the smart contract, the contract owner, or the contract admin of any NFT collection to 
     *         specify their own bounded price at the individual token level.
     *
     * @dev    Throws when the specified tokenAddress is address(0).
     * @dev    Throws when the caller is not the contract, the owner or the administrator of the specified tokenAddress.
     * @dev    Throws when the lengths of the tokenIds and pricingBounds array don't match.
     * @dev    Throws when the tokenIds or pricingBounds array length is zero. 
     * @dev    Throws when the any of the specified floor prices is greater than the ceiling price for that token id.
     * 
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. The token-level pricing bounds for the specified tokenAddress and token ids has been set.
     * @dev    2. An `UpdatedTokenLevelPricingBoundaries` event has been emitted.
     *
     * @param  tokenAddress             The smart contract address of the NFT collection.
     * @param  tokenIds                 An array of token ids for which pricing bounds are being set.
     * @param  pricingBounds            An array of pricing bounds used to set the floor and ceiling per token.
     * @param  paymentProcessorsToSync  An array of the payment processors to sync the removal with.
     */
    function setTokenPricingBounds(
        address tokenAddress, 
        uint256[] calldata tokenIds, 
        RegistryPricingBounds[] calldata pricingBounds,
        address[] calldata paymentProcessorsToSync
    ) external {
        _requireCallerIsNFTOrContractOwnerOrAdmin(tokenAddress);

        if(tokenIds.length != pricingBounds.length) {
            revert CollectionSettingsRegistry__InputArrayLengthMismatch();
        }

        if(tokenIds.length == 0) {
            revert CollectionSettingsRegistry__InputArrayLengthCannotBeZero();
        }

        mapping (uint256 => RegistryPricingBounds) storage ptrTokenPricingBounds = 
            _tokenPricingBounds[tokenAddress];

        uint256 tokenId;
        for(uint256 i = 0; i < tokenIds.length;) {
            tokenId = tokenIds[i];
            RegistryPricingBounds calldata pricingBounds_ = pricingBounds[i];

            if(pricingBounds_.floorPrice > pricingBounds_.ceilingPrice) {
                revert CollectionSettingsRegistry__CeilingPriceMustBeGreaterThanFloorPrice();
            }

            ptrTokenPricingBounds[tokenId] = pricingBounds_;

            emit UpdatedTokenLevelPricingBoundaries(
                tokenAddress, 
                tokenId, 
                pricingBounds_.floorPrice, 
                pricingBounds_.ceilingPrice);
            
            unchecked {
                ++i;
            }
        }

        for (uint256 i; i < paymentProcessorsToSync.length;) {
            IPaymentProcessorSettings(paymentProcessorsToSync[i]).registryUpdateTokenPricingBounds(tokenAddress, tokenIds, pricingBounds);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Allows trusted channels to be added to a collection.
     *
     * @dev    Throws when the specified tokenAddress is address(0).
     * @dev    Throws when the caller is not the contract, the owner or the administrator of the specified tokenAddress.
     * @dev    Throws when the specified address is not a trusted forwarder.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. `channel` has been approved for trusted forwarding of trades on a collection.
     * @dev    2. A `TrustedChannelAddedForCollection` event has been emitted.
     *
     * @param  tokenAddress             The smart contract address of the NFT collection.
     * @param  channels                 The smart contract address of the trusted channel.
     * @param  paymentProcessorsToSync  An array of the payment processors to sync the addition with.
     */
    function addTrustedChannelForCollection(
        address tokenAddress, 
        address[] calldata channels,
        address[] calldata paymentProcessorsToSync
    ) external {
        _requireCallerIsNFTOrContractOwnerOrAdmin(tokenAddress);

        EnumerableSet.AddressSet storage ptrCollectionTrustedChannels = _collectionTrustedChannels[tokenAddress];
        for (uint256 i; i < channels.length;) {
            address channel = channels[i];
            if (ptrCollectionTrustedChannels.add(channel)) {
                emit TrustedChannelAddedForCollection(tokenAddress, channel);
            }

            unchecked {
                ++i;
            }
        }

        for (uint256 i; i < paymentProcessorsToSync.length;) {
            IPaymentProcessorSettings(paymentProcessorsToSync[i]).registryUpdateTrustedChannels(tokenAddress, channels, true);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Allows trusted channels to be removed from a collection.
     *
     * @dev    Throws when the specified tokenAddress is address(0).
     * @dev    Throws when the caller is not the contract, the owner or the administrator of the specified tokenAddress.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. `channel` has been dis-approved for trusted forwarding of trades on a collection.
     * @dev    2. A `TrustedChannelRemovedForCollection` event has been emitted.
     *
     * @param  tokenAddress             The smart contract address of the NFT collection.
     * @param  channels                 The smart contract address of the trusted channel to remove.
     * @param  paymentProcessorsToSync  The payment processors to sync with.
     */
    function removeTrustedChannelForCollection(
        address tokenAddress, 
        address[] calldata channels,
        address[] calldata paymentProcessorsToSync
    ) external {
        _requireCallerIsNFTOrContractOwnerOrAdmin(tokenAddress);

        EnumerableSet.AddressSet storage ptrCollectionTrustedChannels = _collectionTrustedChannels[tokenAddress];
        for (uint256 i; i < channels.length;) {
            address channel = channels[i];
            if (ptrCollectionTrustedChannels.remove(channel)) {
                emit TrustedChannelRemovedForCollection(tokenAddress, channel);
            }

            unchecked {
                ++i;
            }
        }

        for (uint256 i; i < paymentProcessorsToSync.length;) {
            IPaymentProcessorSettings(paymentProcessorsToSync[i]).registryUpdateTrustedChannels(tokenAddress, channels, false);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Returns if the collection settings have been initialized.
     *
     * @param  tokenAddress   The smart contract address of the NFT collection.
     * @return isInitialized  True if the collection settings have been initialized.
     */
    function isCollectionSettingsInitialized(address tokenAddress) external view returns (bool isInitialized) {
        isInitialized = _collectionPaymentSettings[tokenAddress].initialized;
    }

    /**
     * @notice Returns the settings for a collection.
     *
     * @param  tokenAddress     The smart contract address of the NFT collection.
     * @param  dataExtensions   The data extensions to retrieve.
     * @param  wordExtensions   The word extensions to retrieve.
     */
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
    ) {
        collectionCoreSettings = _collectionPaymentSettings[tokenAddress];

        if (collectionCoreSettings.paymentSettingsType == PAYMENT_SETTINGS_PRICING_CONSTRAINTS || 
            collectionCoreSettings.paymentSettingsType == PAYMENT_SETTINGS_PRICING_CONSTRAINTS_COLLECTION_ONLY) {
            collectionPricingBounds = _collectionPricingBounds[tokenAddress];
            constrainedPricingPaymentMethod = _collectionBoundedPricingPaymentMethods[tokenAddress];
        }

        if (_isFlagSet(uint8(collectionCoreSettings.extraData), FLAG_IS_ROYALTY_BOUNTY_EXCLUSIVE)) {
            exclusiveBountyReceiver = _collectionExclusiveBountyReceivers[tokenAddress];
        }

        data = getCollectionSettingsExtendedData(tokenAddress, dataExtensions);
        words = getCollectionSettingsExtendedWords(tokenAddress, wordExtensions);
    }

    /**
     * @notice Returns only the extended data for a collection.
     *
     * @param  tokenAddress     The smart contract address of the NFT collection.
     * @param  extensions       The extensions to retrieve.
     */
    function getCollectionSettingsExtendedData(
        address tokenAddress, 
        bytes32[] calldata extensions
    ) public view returns (bytes[] memory data) {
        if(extensions.length > 0) {
            mapping (bytes32 => bytes) storage ptrSettingsForCollection = _collectionSettingsExtensionData[tokenAddress];

            data = new bytes[](extensions.length);
            for (uint256 i = 0; i < extensions.length;) {
                data[i] = ptrSettingsForCollection[extensions[i]];

                unchecked {
                    ++i;
                }
            }
        }
    }

    /**
     * @notice Returns only the extended words for a collection.
     *
     * @param  tokenAddress     The smart contract address of the NFT collection.
     * @param  extensions       The extensions to retrieve.
     */
    function getCollectionSettingsExtendedWords(
        address tokenAddress, 
        bytes32[] calldata extensions
    ) public view returns (bytes32[] memory words) {
        if(extensions.length > 0) {
            mapping (bytes32 => bytes32) storage ptrSettingsForCollection = _collectionSettingsExtensionWords[tokenAddress];

            words = new bytes32[](extensions.length);
            for (uint256 i = 0; i < extensions.length;) {
                words[i] = ptrSettingsForCollection[extensions[i]];

                unchecked {
                    ++i;
                }
            }
        }
    }

    /**
     * @notice Returns if the `paymentMethod` is whitelisted for the specified `whitelistId`.
     *
     * @param  whitelistId    The id of the payment method whitelist.
     * @param  paymentMethod  The address of the payment method to check.
     */
    function isWhitelistedPaymentMethod(
        uint32 whitelistId,
        address paymentMethod
    ) external view returns (bool paymentMethodWhitelisted) {
        paymentMethodWhitelisted = _paymentMethodWhitelists[whitelistId].contains(paymentMethod);
    }

    /**
     * @notice Returns if the `channel` is trusted for the specified `tokenAddress`.
     *
     * @param  tokenAddress The smart contract address of the NFT collection.
     * @param  channel      The address of the channel to check.
     */
    function isTrustedChannelForCollection(
        address tokenAddress,
        address channel
    ) external view returns (bool channelIsTrusted) {
        channelIsTrusted = _collectionTrustedChannels[tokenAddress].contains(channel);
    }

    /**
     * @notice Returns if the `permitProcessor` is trusted.
     * 
     * @param  permitProcessor The address of the permit processor to check.
     */
    function isTrustedPermitProcessor(
        address permitProcessor
    ) external view returns (bool isTrusted) {
        isTrusted = _trustedPermitProcessors.contains(permitProcessor);
    }

    /**
     * @notice Returns the pricing bounds for the provided `tokenAddress` and `tokenId` combination.
     *
     * @param  tokenAddress The smart contract address of the NFT collection.
     * @param  tokenId      The id of the token.
     */
    function getTokenBoundPricing(
        address tokenAddress,
        uint256 tokenId
    ) external view returns (RegistryPricingBounds memory pricingBounds) {
        pricingBounds = _tokenPricingBounds[tokenAddress][tokenId];
    }

    /**
     * @notice Returns the address of the account that owns the specified payment method whitelist id.
     */
    function paymentMethodWhitelistOwners(uint32 paymentMethodWhitelistId) external view returns (address) {
        return _paymentMethodWhitelistOwners[paymentMethodWhitelistId];
    }

    /**
     * @notice Returns true if the specified payment method is whitelisted for the specified payment method whitelist.
     */
    function isPaymentMethodWhitelisted(uint32 paymentMethodWhitelistId, address paymentMethod) external view returns (bool) {
        return _paymentMethodWhitelists[paymentMethodWhitelistId].contains(paymentMethod);
    }

    /**
     * @notice Returns the set of payment methods for a given payment method whitelist.
     */
    function getWhitelistedPaymentMethods(uint32 paymentMethodWhitelistId) external view returns (address[] memory) {
        return _paymentMethodWhitelists[paymentMethodWhitelistId].values();
    }

    /**
     * @notice Returns the set of trusted channels for a given collection.
     */
    function getTrustedChannels(address tokenAddress) external view returns (address[] memory) {
        return _collectionTrustedChannels[tokenAddress].values();
    }

    /**
     * @notice Transfers ownership of a payment method whitelist.
     * 
     * @dev    Throws when the caller is not the owner of the payment method whitelist.
     *
     * @param id       The payment method whitelist id to transfer ownership of.
     * @param newOwner The address to transfer ownership to.
     */
    function _reassignOwnershipOfPaymentMethodWhitelist(uint32 id, address newOwner) internal {
        _requireCallerOwnsPaymentMethodWhitelist(id);
        _paymentMethodWhitelistOwners[id] = newOwner;
        emit ReassignedPaymentMethodWhitelistOwnership(id, newOwner);
    }

    /**
     * @notice Reverts the transaction if the caller is not the owner of the payment method whitelist.
     *
     * @dev    Throws when the caller is not the owner of the payment method whitelist.
     *
     * @param paymentMethodWhitelistId The payment method whitelist id to check ownership for.
     */
    function _requireCallerOwnsPaymentMethodWhitelist(uint32 paymentMethodWhitelistId) internal view {
        if(msg.sender != _paymentMethodWhitelistOwners[paymentMethodWhitelistId]) {
            revert CollectionSettingsRegistry__CallerDoesNotOwnPaymentMethodWhitelist();
        }
    }

    /**
     * @notice Reverts the transaction if the caller is not the owner of the trusted permit processor list.
     * @notice The owner of the trusted permit processor list is the owner of the default payment method whitelist.
     *
     * @dev    Throws when the caller is not the owner of the trusted permit processor list.
     */
    function _requireCallerOwnsTrustedPermitProcessorList() internal view {
        if (msg.sender != _paymentMethodWhitelistOwners[DEFAULT_PAYMENT_METHOD_WHITELIST_ID]) {
            revert CollectionSettingsRegistry__CallerDoesNotOwnTrustedPermitProcessorList();
        }
    }

    /**
     * @notice Reverts the transaction if the caller is not the owner or assigned the default
     * @notice admin role of the contract at `tokenAddress`.
     *
     * @dev    Throws when the caller is neither owner nor assigned the default admin role.
     * 
     * @param tokenAddress The smart contract address of the NFT collection to check permissions for.
     */
    function _requireCallerIsNFTOrContractOwnerOrAdmin(address tokenAddress) internal view {
        address caller = msg.sender;
        
        if(caller == tokenAddress) {
            return;
        }

        (address contractOwner,) = _safeOwner(tokenAddress);
        if(caller == contractOwner) {
            return;
        }

        (bool callerIsContractAdmin,) = _safeHasRole(tokenAddress, DEFAULT_ACCESS_CONTROL_ADMIN_ROLE, caller);
        if(callerIsContractAdmin) {
            return;
        }

        revert CollectionSettingsRegistry__CallerMustHaveElevatedPermissionsForSpecifiedNFT();
    }

    /**
     * @notice A gas efficient, and fallback-safe way to call the owner function on a token contract.
     *
     * @dev    This will get the owner if it exists - and when the function is unimplemented, the
     * @dev    presence of a fallback function will not result in halted execution.
     *
     * @param tokenAddress The smart contract address of the NFT collection to check the owner for.
     */
    function _safeOwner(
        address tokenAddress
    ) internal view returns(address owner, bool isError) {
        assembly {
            function _callOwner(_tokenAddress) -> _owner, _isError {
                mstore(0x00, 0x8da5cb5b)
                if and(iszero(lt(returndatasize(), 0x20)), staticcall(gas(), _tokenAddress, 0x1C, 0x04, 0x00, 0x20)) {
                    _owner := mload(0x00)
                    leave
                }
                _isError := true
            }
            owner, isError := _callOwner(tokenAddress)
        }
    }
    
    /**
     * @notice A gas efficient, and fallback-safe way to call the hasRole function on a token contract.
     *
     * @dev    This will check if the account `hasRole` if `hasRole` exists - and when the function is unimplemented, the
     * @dev    presence of a fallback function will not result in halted execution.
     *
     * @param tokenAddress The smart contract address of the NFT collection to check the roles of.
     * @param role         The role to check for.
     * @param account      The account to check for the role.
     */
    function _safeHasRole(
        address tokenAddress,
        bytes32 role,
        address account
    ) internal view returns(bool hasRole, bool isError) {
        assembly {
            function _callHasRole(_tokenAddress, _role, _account) -> _hasRole, _isError {
                let ptr := mload(0x40)
                mstore(0x40, add(ptr, 0x60))
                mstore(ptr, 0x91d14854)
                mstore(add(0x20, ptr), _role)
                mstore(add(0x40, ptr), _account)
                if and(iszero(lt(returndatasize(), 0x20)), staticcall(gas(), _tokenAddress, add(ptr, 0x1C), 0x44, 0x00, 0x20)) {
                    _hasRole := mload(0x00)
                    leave
                }
                _isError := true
            }
            hasRole, isError := _callHasRole(tokenAddress, role, account)
        }
    }

    /**
     * @notice Returns true if the `flagValue` has the `flag` set, false otherwise.
     *
     * @dev    This function uses the bitwise AND operator to check if the `flag` is set in `flagValue`.
     *
     * @param flagValue  The value to check for the presence of the `flag`.
     * @param flag       The flag to check for in the `flagValue`.
     */
    function _isFlagSet(uint8 flagValue, uint8 flag) internal pure returns (bool flagSet) {
        flagSet = (flagValue & flag) != 0;
    }
}