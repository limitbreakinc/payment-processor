//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "./Constants.sol";
import "./Errors.sol";
import "./interfaces/IPaymentProcessorConfiguration.sol";
import "./interfaces/IPaymentProcessorEvents.sol";
import "./settings-registry/IPaymentProcessorSettings.sol";
import "./modules/PaymentProcessorModule.sol";
import "./storage/PaymentProcessorStorageAccess.sol";
import "./settings-registry/ICollectionSettingsRegistry.sol";

import "@limitbreak/tm-core-lib/src/licenses/LicenseRef-PolyForm-Strict-1.0.0.sol";
import "@limitbreak/tm-core-lib/src/utils/security/RoleClient.sol";
import "@limitbreak/tm-core-lib/src/utils/security/TstorishReentrancyGuard.sol";

/*
                                                     @@@@@@@@@@@@@@             
                                                    @@@@@@@@@@@@@@@@@@(         
                                                   @@@@@@@@@@@@@@@@@@@@@        
                                                  @@@@@@@@@@@@@@@@@@@@@@@@      
                                                           #@@@@@@@@@@@@@@      
                                                               @@@@@@@@@@@@     
                            @@@@@@@@@@@@@@*                    @@@@@@@@@@@@     
                           @@@@@@@@@@@@@@@     @               @@@@@@@@@@@@     
                          @@@@@@@@@@@@@@@     @                @@@@@@@@@@@      
                         @@@@@@@@@@@@@@@     @@               @@@@@@@@@@@@      
                        @@@@@@@@@@@@@@@     #@@             @@@@@@@@@@@@/       
                        @@@@@@@@@@@@@@.     @@@@@@@@@@@@@@@@@@@@@@@@@@@         
                       @@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@            
                      @@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@             
                     @@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@           
                    @@@@@@@@@@@@@@@     @@@@@&%%%%%%%%&&@@@@@@@@@@@@@@          
                    @@@@@@@@@@@@@@      @@@@@               @@@@@@@@@@@         
                   @@@@@@@@@@@@@@@     @@@@@                 @@@@@@@@@@@        
                  @@@@@@@@@@@@@@@     @@@@@@                 @@@@@@@@@@@        
                 @@@@@@@@@@@@@@@     @@@@@@@                 @@@@@@@@@@@        
                @@@@@@@@@@@@@@@     @@@@@@@                 @@@@@@@@@@@&        
                @@@@@@@@@@@@@@     *@@@@@@@               (@@@@@@@@@@@@         
               @@@@@@@@@@@@@@@     @@@@@@@@             @@@@@@@@@@@@@@          
              @@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           
             @@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@            
            @@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@              
           .@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                 
           @@@@@@@@@@@@@@%     @@@@@@@@@@@@@@@@@@@@@@@@(                        
          @@@@@@@@@@@@@@@                                                       
         @@@@@@@@@@@@@@@                                                        
        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                         
       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                          
       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&                                          
      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                           
 
* @title Payment Processor
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 

contract PaymentProcessor is TstorishReentrancyGuard, RoleClient, PaymentProcessorStorageAccess, IPaymentProcessorEvents, IPaymentProcessorSettings, PaymentProcessorModule {
    using EnumerableSet for EnumerableSet.AddressSet;

    /// @dev The On-Chain Cancellation module implements of all on-chain cancellation-related functionality.
    address private immutable _moduleOnChainCancellation;

    /// @dev Implements buyListing and bulkBuyListings trade-related functionality.
    address private immutable _moduleBuyListings;

    /// @dev Implements acceptOffer and bulkAcceptOffers trade-related functionality.
    address private immutable _moduleAcceptOffers;

    /// @dev Implements collection sweep trade-related functionality.
    address private immutable _moduleSweeps;

    constructor(address configurationContract, address roleServer) 
    TstorishReentrancyGuard() 
    RoleClient(roleServer) 
    PaymentProcessorModule(configurationContract) {
        (
            address defaultContractOwner_,
            PaymentProcessorModules memory paymentProcessorModules
        ) = IPaymentProcessorConfiguration(configurationContract).getPaymentProcessorDeploymentParams();
        
        
        if (defaultContractOwner_ == address(0) ||
            paymentProcessorModules.moduleOnChainCancellation == address(0) ||
            paymentProcessorModules.moduleBuyListings == address(0) ||
            paymentProcessorModules.moduleAcceptOffers == address(0) ||
            paymentProcessorModules.moduleSweeps == address(0)) {
            revert PaymentProcessor__InvalidConstructorArguments();
        }

        _moduleOnChainCancellation = paymentProcessorModules.moduleOnChainCancellation;
        _moduleBuyListings = paymentProcessorModules.moduleBuyListings;
        _moduleAcceptOffers = paymentProcessorModules.moduleAcceptOffers;
        _moduleSweeps = paymentProcessorModules.moduleSweeps;

        appStorage().protocolFeeVersions[0] = ProtocolFees({
            protocolFeeReceiver: _defaultInfrastructureFeeReceiver,
            minimumProtocolFeeBps: DEFAULT_PROTOCOL_FEE_MINIMUM_BPS,
            marketplaceFeeProtocolTaxBps: DEFAULT_PROTOCOL_FEE_MARKETPLACE_TAX_BPS,
            feeOnTopProtocolTaxBps: DEFAULT_PROTOCOL_FEE_FEE_ON_TOP_TAX_BPS,
            versionExpiration: type(uint48).max
        });
    }

    /**************************************************************/
    /*                         MODIFIERS                          */
    /**************************************************************/

    /**
     * @dev Function modifier that generates a delegatecall to `module` with `selector` as the calldata
     * @dev This delegatecall is for functions that do not have parameters. The only calldata added is
     * @dev the extra calldata from a trusted forwarder, when present.
     * 
     * @param module The contract address being called in the delegatecall.
     * @param selector The 4 byte function selector for the function to call in `module`.
     */
    modifier delegateCallNoData(address module, bytes4 selector) {
        assembly {
            // This protocol is designed to work both via direct calls and calls from a trusted forwarder that
            // preserves the original msg.sender by appending an extra 20 bytes to the calldata.  
            // The following code supports both cases.

            let ptr := mload(0x40)
            mstore(ptr, selector)
            mstore(0x40, add(ptr, calldatasize()))
            calldatacopy(add(ptr, 0x04), 0x04, sub(calldatasize(), 0x04))
            let result := delegatecall(gas(), module, ptr, calldatasize(), 0, 0)
            if iszero(result) {
                // Call has failed, retrieve the error message and revert
                let size := returndatasize()
                returndatacopy(0, 0, size)
                revert(0, size)
            }
        }
        _;
    }

    /**
     * @dev Function modifier that generates a delegatecall to `module` with `selector` and `data` as the 
     * @dev calldata. This delegatecall is for functions that have parameters but **DO NOT** take domain
     * @dev separator as a parameter. Additional calldata from a trusted forwarder is appended to the end, when present.
     * 
     * @param module The contract address being called in the delegatecall.
     * @param selector The 4 byte function selector for the function to call in `module`.
     * @param data The calldata to send to the `module`.
     */
    modifier delegateCall(address module, bytes4 selector, bytes calldata data) {
        assembly {
            // This protocol is designed to work both via direct calls and calls from a trusted forwarder that
            // preserves the original msg.sender by appending an extra 20 bytes to the calldata.  
            // The following code supports both cases.  The magic number of 68 is:
            // 4 bytes for the selector
            // 32 bytes calldata offset to the data parameter
            // 32 bytes for the length of the data parameter
            let lengthWithAppendedCalldata := sub(calldatasize(), 68)

            let ptr := mload(0x40)
            mstore(ptr, selector)
            calldatacopy(add(ptr,0x04), data.offset, lengthWithAppendedCalldata)
            mstore(0x40, add(ptr,add(0x04, lengthWithAppendedCalldata)))

            let result := delegatecall(gas(), module, ptr, add(lengthWithAppendedCalldata, 4), 0, 0)
            if iszero(result) {
                // Call has failed, retrieve the error message and revert
                let size := returndatasize()
                returndatacopy(0, 0, size)
                revert(0, size)
            }
        }        
        _;
    }

    /**************************************************************/
    /*                    READ ONLY ACCESSORS                     */
    /**************************************************************/

    /**
     * @notice Returns the domain separator for the Payment Processor contract.
     */
    function getDomainSeparator() public view returns (bytes32) {
        return _cachedDomainSeparator;
    }

    /**
     * @notice Returns the address of the wrapped native coin for the network.
     */
    function wrappedNativeCoinAddress() public view returns (address) {
        return _wrappedNativeCoinAddress;
    }

    /**
     * @notice Returns the user-specific master nonce that allows order makers to efficiently cancel all listings or offers
     * @notice they made previously. The master nonce for a user only changes when they explicitly request to revoke all
     * @notice existing listings and offers.
     *
     * @dev    When prompting makers to sign a listing or offer, marketplaces must query the current master nonce of
     * @dev    the user and include it in the listing/offer signature data.
     */
    function masterNonces(address account) public view returns (uint256) {
        return appStorage().masterNonces[account];
    }

    /**
     * @notice Returns true if the nonce for the given account has been used or cancelled. In comparison to a master nonce for
     * @notice a user, this nonce value is specific to a single order and may only be used or cancelled a single time.
     *
     * @dev    When prompting makers to sign a listing or offer, marketplaces must generate a unique nonce value that
     * @dev    has not been previously used for filled, unfilled or cancelled orders. User nonces are unique to each
     * @dev    user but common to that user across all marketplaces that utilize Payment Processor and do not reset
     * @dev    when the master nonce is incremented. Nonces are stored in a BitMap for gas efficiency so it is recommended
     * @dev    to utilize sequential numbers that do not overlap with other marketplaces.
     */
    function isNonceUsed(address account, uint256 nonce) public view returns (bool isUsed) {
        // The following code is equivalent to, but saves gas:
        //
        // uint256 slot = nonce / 256;
        // uint256 offset = nonce % 256;
        // uint256 slotValue = appStorage().invalidatedSignatures[account][slot];
        // isUsed = ((slotValue >> offset) & ONE) == ONE;

        isUsed = ((appStorage().invalidatedSignatures[account][uint248(nonce >> 8)] >> uint8(nonce)) & ONE) == ONE;
    }

    /**
     * @notice Returns the state and remaining fillable quantity of an order digest given the maker address.
     */
    function remainingFillableQuantity(
        address account, 
        bytes32 orderDigest
    ) external view returns (PartiallyFillableOrderStatus memory) {
        return appStorage().partiallyFillableOrderStatuses[account][orderDigest];
    }

    /**
     * @notice Returns the payment settings for a given collection.
     *
     * @notice paymentSettings: The payment setting type for a given collection 
     *         (DefaultPaymentMethodWhitelist|AllowAnyPaymentMethod|CustomPaymentMethodWhitelist|PricingConstraints)
     * @notice paymentMethodWhitelistId: The payment method whitelist id for a given collection.  
     *         Applicable only when paymentSettings is CustomPaymentMethodWhitelist
     * @notice constrainedPricingPaymentMethod: The payment method that min/max priced collections are priced in.
     *         Applicable only when paymentSettings is PricingConstraints.
     * @notice royaltyBackfillNumerator: The royalty backfill percentage for a given collection.  Used only as a
     *         fallback when a collection does not implement EIP-2981.
     * @notice royaltyBountyNumerator: The royalty bounty percentage for a given collection.  When set, this percentage
     *         is applied to the creator's royalty amount and paid to the maker marketplace as a bounty.
     * @notice isRoyaltyBountyExclusive: When true, only the designated marketplace is eligible for royalty bounty.
     * @notice blockTradesFromUntrustedChannels: When true, only transactions from channels that the collection 
     *         authorizes will be allowed to execute.
     */
    function collectionPaymentSettings(address tokenAddress) external view returns (CollectionPaymentSettings memory) {
        CollectionPaymentSettings memory collectionPaymentSettings_ = 
            appStorage().collectionPaymentSettings[tokenAddress];
        if (collectionPaymentSettings_.initialized) {
            return collectionPaymentSettings_;
        } else {
            bytes32[] memory emptyBytes32;
            (CollectionRegistryPaymentSettings memory collectionCoreSettings,,,,,) = ICollectionSettingsRegistry(collectionSettingsRegistry).getCollectionSettings(tokenAddress, emptyBytes32, emptyBytes32);
            return CollectionPaymentSettings({
                initialized: false,
                paymentSettings: PaymentSettings(collectionCoreSettings.paymentSettingsType),
                paymentMethodWhitelistId: collectionCoreSettings.paymentMethodWhitelistId,
                royaltyBackfillReceiver: collectionCoreSettings.royaltyBackfillReceiver,
                royaltyBackfillNumerator: collectionCoreSettings.royaltyBackfillNumerator,
                royaltyBountyNumerator: collectionCoreSettings.royaltyBountyNumerator,
                flags: uint8(collectionCoreSettings.extraData)
            });
        }
    }

    /**
     * @notice Returns the optional creator-defined royalty bounty settings for a given collection.
     * 
     * @return royaltyBountyNumerator  The royalty bounty percentage for a given collection.  When set, this percentage
     *         is applied to the creator's royalty amount and paid to the maker marketplace as a bounty.
     * @return exclusiveBountyReceiver When non-zero, only the designated marketplace is eligible for royalty bounty.
     */
    function collectionBountySettings(
        address tokenAddress
    ) external view returns (uint16 royaltyBountyNumerator, address exclusiveBountyReceiver) {
        CollectionPaymentSettings memory collectionPaymentSettings_ = 
            appStorage().collectionPaymentSettings[tokenAddress];
        if (collectionPaymentSettings_.initialized) {

            return (
                collectionPaymentSettings_.royaltyBountyNumerator, 
                _isFlagSet(collectionPaymentSettings_.flags, FLAG_IS_ROYALTY_BOUNTY_EXCLUSIVE) ? 
                        appStorage().collectionExclusiveBountyReceivers[tokenAddress] : 
                        address(0));
        } else {
            bytes32[] memory emptyBytes32;
            (
                CollectionRegistryPaymentSettings memory collectionCoreSettings,,,
                address exclusiveBountyReceiver_,,
            ) = ICollectionSettingsRegistry(collectionSettingsRegistry).getCollectionSettings(tokenAddress, emptyBytes32, emptyBytes32);
            return (
                collectionCoreSettings.royaltyBountyNumerator, 
                _isFlagSet(uint8(collectionCoreSettings.extraData), FLAG_IS_ROYALTY_BOUNTY_EXCLUSIVE) ? 
                    exclusiveBountyReceiver_ : address(0));
        }
    }

    /**
     * @notice Returns the optional creator-defined royalty backfill settings for a given collection.
     *         This is useful for legacy collection lacking EIP-2981 support, as the collection owner can instruct
     *         PaymentProcessor to backfill missing on-chain royalties.
     * 
     * @return royaltyBackfillNumerator  The creator royalty percentage for a given collection.  
     *         When set, this percentage is applied to the item sale price and paid to the creator if the attempt
     *         to query EIP-2981 royalties fails.
     * @return royaltyBackfillReceiver When non-zero, this is the destination address for backfilled creator royalties.
     */
    function collectionRoyaltyBackfillSettings(
        address tokenAddress
    ) external view returns (uint16 royaltyBackfillNumerator, address royaltyBackfillReceiver) {
        CollectionPaymentSettings memory collectionPaymentSettings_ = 
            appStorage().collectionPaymentSettings[tokenAddress];
        if (collectionPaymentSettings_.initialized) {
            royaltyBackfillNumerator = collectionPaymentSettings_.royaltyBackfillNumerator;
            royaltyBackfillReceiver = collectionPaymentSettings_.royaltyBackfillReceiver;
        } else {
            bytes32[] memory emptyBytes32;
            (
                CollectionRegistryPaymentSettings memory collectionCoreSettings,,,,,
            ) = ICollectionSettingsRegistry(collectionSettingsRegistry).getCollectionSettings(tokenAddress, emptyBytes32, emptyBytes32);
            royaltyBackfillNumerator = collectionCoreSettings.royaltyBackfillNumerator;
            royaltyBackfillReceiver = collectionCoreSettings.royaltyBackfillReceiver;
        }
    }

    /**
     * @notice Returns true if the specified payment method is whitelisted for the specified payment method whitelist.
     */
    function isPaymentMethodWhitelisted(uint32 paymentMethodWhitelistId, address paymentMethod) external view returns (bool) {
        if (appStorage().collectionPaymentMethodWhitelists[paymentMethodWhitelistId].contains(paymentMethod)) {
            return true;
        }
        if (ICollectionSettingsRegistry(collectionSettingsRegistry).isWhitelistedPaymentMethod(paymentMethodWhitelistId, paymentMethod)) {
            return true;
        }
        return false;
    }

    /**
     * @notice Returns the constrained payment method for a given collection, when applicable.
     *
     * @dev    The constrained payment method is only enforced when the collection payment settings are set to
     *         the PricingContraints type.
     *
     * @param tokenAddress The address of the collection.
     */
    function collectionConstrainedPaymentMethod(address tokenAddress) external view returns (address) {
        CollectionPaymentSettings memory collectionPaymentSettings_ = 
            appStorage().collectionPaymentSettings[tokenAddress];
        if (collectionPaymentSettings_.initialized) {
            if (collectionPaymentSettings_.paymentSettings == PaymentSettings.PricingConstraints ||
                collectionPaymentSettings_.paymentSettings == PaymentSettings.PricingConstraintsCollectionOnly) {
                return appStorage().collectionConstrainedPricingPaymentMethods[tokenAddress];
            }
        } else {
            bytes32[] memory emptyBytes32;
            (
                ,,address constrainedPricingPaymentMethod,,,
            ) = ICollectionSettingsRegistry(collectionSettingsRegistry).getCollectionSettings(tokenAddress, emptyBytes32, emptyBytes32);
            return constrainedPricingPaymentMethod;
        }
        return address(0);
    }

    /**
     * @notice Returns the pricing bounds floor price for a given collection and token id, when applicable.
     *
     * @dev    The pricing bounds floor price is only enforced when the collection payment settings are set to
     *         the PricingContraints type.
     *
     * @param tokenAddress The address of the collection.
     * @param tokenId The token id of the item.
     */
    function getFloorPrice(address tokenAddress, uint256 tokenId) external view returns (uint256) {
        PricingBounds memory tokenLevelPricingBounds = appStorage().tokenPricingBounds[tokenAddress][tokenId];
        if (!tokenLevelPricingBounds.initialized) {
            RegistryPricingBounds memory registryPricingBounds = ICollectionSettingsRegistry(collectionSettingsRegistry).getTokenBoundPricing(tokenAddress, tokenId);

            if (registryPricingBounds.isSet) {
                return registryPricingBounds.floorPrice;
            }
        }
        if (tokenLevelPricingBounds.isSet) {
            return tokenLevelPricingBounds.floorPrice;
        } else {
            CollectionPaymentSettings memory collectionPaymentSettings_ = 
                appStorage().collectionPaymentSettings[tokenAddress];
            if (collectionPaymentSettings_.initialized) {
                PricingBounds memory collectionLevelPricingBounds = appStorage().collectionPricingBounds[tokenAddress];
                if (collectionLevelPricingBounds.isSet) {
                    return collectionLevelPricingBounds.floorPrice;
                }
            } else {
                bytes32[] memory emptyBytes32;
                (
                    ,RegistryPricingBounds memory collectionPricingBounds,,,,
                ) = ICollectionSettingsRegistry(collectionSettingsRegistry).getCollectionSettings(tokenAddress, emptyBytes32, emptyBytes32);
                if (collectionPricingBounds.isSet) {
                    return collectionPricingBounds.floorPrice;
                }
            }
        }

        return 0;
    }

    /**
     * @notice Returns the pricing bounds ceiling price for a given collection and token id, when applicable.
     *
     * @dev    The pricing bounds ceiling price is only enforced when the collection payment settings are set to
     *         the PricingConstraints type.
     *
     * @param tokenAddress  The address of the collection.
     * @param tokenId       The token id of the item.
     */
    function getCeilingPrice(address tokenAddress, uint256 tokenId) external view returns (uint256) {
        PricingBounds memory tokenLevelPricingBounds = appStorage().tokenPricingBounds[tokenAddress][tokenId];
        if (!tokenLevelPricingBounds.initialized) {
            RegistryPricingBounds memory registryPricingBounds = ICollectionSettingsRegistry(collectionSettingsRegistry).getTokenBoundPricing(tokenAddress, tokenId);

            if (registryPricingBounds.isSet) {
                return registryPricingBounds.ceilingPrice;
            }
        }
        if (tokenLevelPricingBounds.isSet) {
            return tokenLevelPricingBounds.ceilingPrice;
        } else {
            CollectionPaymentSettings memory collectionPaymentSettings_ = 
                appStorage().collectionPaymentSettings[tokenAddress];
            if (collectionPaymentSettings_.initialized) {
                PricingBounds memory collectionLevelPricingBounds = appStorage().collectionPricingBounds[tokenAddress];
                if (collectionLevelPricingBounds.isSet) {
                    return collectionLevelPricingBounds.ceilingPrice;
                }
            } else {
                bytes32[] memory emptyBytes32;
                (
                    ,RegistryPricingBounds memory collectionPricingBounds,,,,
                ) = ICollectionSettingsRegistry(collectionSettingsRegistry).getCollectionSettings(tokenAddress, emptyBytes32, emptyBytes32);
                if (collectionPricingBounds.isSet) {
                    return collectionPricingBounds.ceilingPrice;
                }
            }
        }

        return type(uint256).max;
    }

    /**************************************************************/
    /*           PAYMENT SETTINGS MANAGEMENT OPERATIONS           */
    /**************************************************************/

    /**
     * @notice Returns true if the specified payment method is on the deploy-time default payment method whitelist
     *         or post-deploy default payment method whitelist (id 0).
     *
     * @param  paymentMethod The address of the payment method to check.
     */
    function isDefaultPaymentMethod(address paymentMethod) external view returns (bool) {
        address[] memory defaultPaymentMethods = _getDefaultPaymentMethods();

        for (uint256 i = 0; i < defaultPaymentMethods.length;) {
            if (paymentMethod == defaultPaymentMethods[i]) {
                return true;
            }

            unchecked {
                ++i;
            }
        }

        return ICollectionSettingsRegistry(collectionSettingsRegistry).isWhitelistedPaymentMethod(
            DEFAULT_PAYMENT_METHOD_WHITELIST_ID, 
            paymentMethod
        );
    }

    /**
     * @notice Returns an array of the immutable default payment methods specified at deploy time.  
     *         However, if any post-deployment default payment methods have been added, they are
     *         not returned here because using an enumerable payment method whitelist would make trades
     *         less gas efficient.  For post-deployment default payment methods, exchanges should index
     *         the `PaymentMethodAddedToWhitelist` and `PaymentMethodRemovedFromWhitelist` events.
     */
    function getDefaultPaymentMethods() external view returns (address[] memory) {
        return _getDefaultPaymentMethods();
    }

    /**
     * @notice Returns if the specified whitelistId contains the specified payment method.
     *
     * @param  whitelistId    The id of the whitelist to check.
     * @param  paymentMethod  The address of the payment method to check.
     */
    function checkWhitelistedPaymentMethod(
        uint32 whitelistId,
        address paymentMethod
    ) external returns (bool isWhitelisted) {
        _requireCallerIsCollectionSettingsRegistryOrSelf();

        if (ICollectionSettingsRegistry(collectionSettingsRegistry).isWhitelistedPaymentMethod(whitelistId, paymentMethod)) {
            _addWhitelistedPaymentMethod(appStorage().collectionPaymentMethodWhitelists[whitelistId], whitelistId, paymentMethod);
            return true;
        }
        return false;
    }

    /**
     * @notice Updates the payment method whitelist with the specified payment methods.
     *
     * @param  paymentMethodWhitelistId  The id of the whitelist to update.
     * @param  paymentMethods            The array of payment methods to add or remove.
     * @param  paymentMethodsAdded       True if the payment methods are being added, false if they are being removed.
     */
    function registryUpdateWhitelistPaymentMethods(
        uint32 paymentMethodWhitelistId,
        address[] calldata paymentMethods,
        bool paymentMethodsAdded
    ) external {
        _requireCallerIsCollectionSettingsRegistryOrSelf();

        EnumerableSet.AddressSet storage ptrPaymentMethods = appStorage().collectionPaymentMethodWhitelists[paymentMethodWhitelistId];
        if (paymentMethodsAdded) {
            for (uint256 i; i < paymentMethods.length;) {
                _addWhitelistedPaymentMethod(ptrPaymentMethods, paymentMethodWhitelistId, paymentMethods[i]);

                unchecked {
                    ++i;
                }
            }
        } else {
            for (uint256 i; i < paymentMethods.length;) {
                _removeWhitelistedPaymentMethod(ptrPaymentMethods, paymentMethodWhitelistId, paymentMethods[i]);

                unchecked {
                    ++i;
                }
            }
        }
    }

    /**
     * @notice Checks the collection settings registry if the provided `tokenAddress` has been initialized.
     * @notice If it has, pulls the collection settings from the registry and updates the cache, if not,
     * @notice initializes the cache with the default settings.
     *
     * @param tokenAddress The address of the collection to check.
     */
    function checkSyncCollectionSettings(address tokenAddress) external {
        _requireCallerIsCollectionSettingsRegistryOrSelf();

        if (ICollectionSettingsRegistry(collectionSettingsRegistry).isCollectionSettingsInitialized(tokenAddress)) {
            _syncCollectionSettings(tokenAddress);
        } else {
            appStorage().collectionPaymentSettings[tokenAddress].initialized = true;
        }
    }

    /**
     * @notice Force syncs the collection settings for the specified token address.
     *
     * @param tokenAddress The address of the collection to sync.
     */
    function registrySyncSettings(address tokenAddress) external {
        _requireCallerIsCollectionSettingsRegistryOrSelf();
        _syncCollectionSettings(tokenAddress);
    }

    /**
     * @notice Returns if the specified channel is a trusted channel for the specified collection and caches the result.
     *
     * @param tokenAddress The address of the collection to check.
     * @param channel      The address of the channel to check.
     */
    function checkCollectionTrustedChannels(
        address tokenAddress,
        address channel
    ) external returns (bool isAllowed) {
        _requireCallerIsCollectionSettingsRegistryOrSelf();

        if (ICollectionSettingsRegistry(collectionSettingsRegistry).isTrustedChannelForCollection(tokenAddress, channel)) {
            _addCollectionTrustedChannel(appStorage().collectionTrustedChannels[tokenAddress], tokenAddress, channel);
            return true;
        }
        return false;
    }

    /**
     * @notice Updates the local cache of trusted channels to add or remove the provided `channelsToUpdate`.
     *
     * @param tokenAddress     The address of the collection to update.
     * @param channelsToUpdate The array of channels to add or remove.
     * @param channelsAdded     True if the channels are being added, false if they are being removed.
     */
    function registryUpdateTrustedChannels(
        address tokenAddress,
        address[] calldata channelsToUpdate,
        bool channelsAdded
    ) external {
        _requireCallerIsCollectionSettingsRegistryOrSelf();

        EnumerableSet.AddressSet storage ptrTrustedChannels = appStorage().collectionTrustedChannels[tokenAddress];
        if (channelsAdded) {
            for (uint256 i; i < channelsToUpdate.length;) {
                _addCollectionTrustedChannel(ptrTrustedChannels, tokenAddress, channelsToUpdate[i]);

                unchecked {
                    ++i;
                }
            }
        } else {
            for (uint256 i; i < channelsToUpdate.length;) {
                _removeCollectionTrustedChannel(ptrTrustedChannels, tokenAddress, channelsToUpdate[i]);

                unchecked {
                    ++i;
                }
            }
        }
    }

    /**
     * @notice Returns if the specified permit processor is a trusted permit processor for the specified collection
     * @notice and caches the result.
     *
     * @param permitProcessor The address of the permit processor to check.
     */
    function checkTrustedPermitProcessors(
        address permitProcessor
    ) external returns (bool isTrusted) {
        _requireCallerIsCollectionSettingsRegistryOrSelf();

        if (ICollectionSettingsRegistry(collectionSettingsRegistry).isTrustedPermitProcessor(permitProcessor)) {
            _addTrustedPermitProcessor(permitProcessor);
            return true;
        }
        return false;
    }

    /**
     * @notice Updates the local cache of trusted permit processors to add or remove the provided `permitProcessors`.
     *
     * @param permitProcessors       The array of permit processors to add or remove.
     * @param permitProcessorsAdded  True if the permit processors are being added, false if they are being removed.
     */
    function registryUpdateTrustedPermitProcessors(
        address[] calldata permitProcessors,
        bool permitProcessorsAdded
    ) external {
        _requireCallerIsCollectionSettingsRegistryOrSelf();

        if (permitProcessorsAdded) {
            for (uint256 i; i < permitProcessors.length;) {
                _addTrustedPermitProcessor(permitProcessors[i]);

                unchecked {
                    ++i;
                }
            }
        } else {
            for (uint256 i; i < permitProcessors.length;) {
                _removeTrustedPermitProcessor(permitProcessors[i]);

                unchecked {
                    ++i;
                }
            }
        }
    }

    /**
     * @notice Returns the token pricing bounds for the specified token id and caches the result.
     *
     * @param tokenAddress The address of the collection to check.
     * @param tokenId      The token id of the item.
     */
    function checkSyncTokenPricingBounds(
        address tokenAddress,
        uint256 tokenId
    ) external returns (uint256, uint256) {
        _requireCallerIsCollectionSettingsRegistryOrSelf();

        PricingBounds storage tokenLevelPricingBounds = appStorage().tokenPricingBounds[tokenAddress][tokenId];
        RegistryPricingBounds memory registryPricingBounds = ICollectionSettingsRegistry(collectionSettingsRegistry).getTokenBoundPricing(tokenAddress, tokenId);
        if (registryPricingBounds.isSet) {
            tokenLevelPricingBounds.initialized = true;
            tokenLevelPricingBounds.isSet = registryPricingBounds.isSet;
            tokenLevelPricingBounds.floorPrice = registryPricingBounds.floorPrice;
            tokenLevelPricingBounds.ceilingPrice = registryPricingBounds.ceilingPrice;

            emit UpdatedTokenLevelPricingBoundaries(
                tokenAddress, 
                tokenId, 
                registryPricingBounds.floorPrice, 
                registryPricingBounds.ceilingPrice);
        } else {
            tokenLevelPricingBounds.initialized = true;
        }

        if (tokenLevelPricingBounds.isSet) {
            return (tokenLevelPricingBounds.floorPrice, tokenLevelPricingBounds.ceilingPrice);
        } else {
            PricingBounds memory collectionLevelPricingBounds = appStorage().collectionPricingBounds[tokenAddress];
            if (collectionLevelPricingBounds.isSet) {
                return (collectionLevelPricingBounds.floorPrice, collectionLevelPricingBounds.ceilingPrice);
            }
        }

        return (0, type(uint256).max);
    }

    /**
     * @notice Updates the local cache of token pricing bounds to add or remove the provided `tokenIds`.
     *
     * @param tokenAddress  The address of the collection to update.
     * @param tokenIds      The array of token ids to update.
     * @param pricingBounds The array of pricing bounds to update.
     */
    function registryUpdateTokenPricingBounds(
        address tokenAddress, 
        uint256[] calldata tokenIds, 
        RegistryPricingBounds[] calldata pricingBounds
    ) external {
        _requireCallerIsCollectionSettingsRegistryOrSelf();

        mapping (uint256 => PricingBounds) storage ptrTokenPricingBounds = 
            appStorage().tokenPricingBounds[tokenAddress];

        uint256 tokenId;
        for(uint256 i = 0; i < tokenIds.length;) {
            tokenId = tokenIds[i];
            RegistryPricingBounds calldata pricingBounds_ = pricingBounds[i];
            PricingBounds memory currentPricingBounds = ptrTokenPricingBounds[tokenId];

            if(!(currentPricingBounds.isSet == pricingBounds_.isSet &&
                currentPricingBounds.floorPrice == pricingBounds_.floorPrice &&
                currentPricingBounds.ceilingPrice == pricingBounds_.ceilingPrice)
            ) {
                ptrTokenPricingBounds[tokenId] = PricingBounds({
                    initialized: true,
                    isSet: pricingBounds_.isSet,
                    floorPrice: pricingBounds_.floorPrice,
                    ceilingPrice: pricingBounds_.ceilingPrice
                });

                emit UpdatedTokenLevelPricingBoundaries(
                    tokenAddress, 
                    tokenId, 
                    pricingBounds_.floorPrice, 
                    pricingBounds_.ceilingPrice);
            }
            
            unchecked {
                ++i;
            }
        }
    }

    /**************************************************************/
    /*              ON-CHAIN CANCELLATION OPERATIONS              */
    /**************************************************************/

    /**
     * @notice Allows a cosigner to destroy itself, never to be used again.  This is a fail-safe in case of a failure
     *         to secure the co-signer private key in a Web2 co-signing service.  In case of suspected cosigner key
     *         compromise, or when a co-signer key is rotated, the cosigner MUST destroy itself to prevent past listings 
     *         that were cancelled off-chain from being used by a malicious actor.
     *
     * @dev    Throws when the cosigner did not sign an authorization to self-destruct.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. The cosigner can never be used to co-sign orders again.
     * @dev    2. A `DestroyedCosigner` event has been emitted.
     *
     * @param  data Calldata encoded with PaymentProcessorEncoder.  Matches calldata for:
     *              `destroyCosigner(address cosigner, SignatureECDSA signature)`
     */
    function destroyCosigner(bytes calldata data) external
    delegateCall(_moduleOnChainCancellation, SELECTOR_DESTROY_COSIGNER, data) {}

    /**
     * @notice Allows a maker to revoke/cancel all prior signatures of their listings and offers.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. The maker's master nonce has been incremented by `1` in contract storage, rendering all signed
     *            approvals using the prior nonce unusable.
     * @dev    2. A `MasterNonceInvalidated` event has been emitted.
     */
    function revokeMasterNonce() external 
    delegateCallNoData(_moduleOnChainCancellation, SELECTOR_REVOKE_MASTER_NONCE) {}

    /**
     * @notice Allows a maker to revoke/cancel a single, previously signed listing or offer by specifying the
     *         nonce of the listing or offer.
     *
     * @dev    Throws when the maker has already revoked the nonce.
     * @dev    Throws when the nonce was already used by the maker to successfully buy or sell an NFT.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. The specified `nonce` for the `_msgSender()` has been revoked and can
     *            no longer be used to execute a sale or purchase.
     * @dev    2. A `NonceInvalidated` event has been emitted.
     *
     * @param  data Calldata encoded with PaymentProcessorEncoder.  Matches calldata for:
     *              `revokeSingleNonce(uint256 nonce)`
     */
    function revokeSingleNonce(bytes calldata data) external 
    delegateCall(_moduleOnChainCancellation, SELECTOR_REVOKE_SINGLE_NONCE, data) {}

    /**
     * @notice Allows a maker to revoke/cancel a partially fillable order by specifying the order digest hash.
     *
     * @dev    Throws when the maker has already revoked the order digest.
     * @dev    Throws when the order digest was already used by the maker and has been fully filled.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. The specified `orderDigest` for the `_msgSender()` has been revoked and can
     *            no longer be used to execute a sale or purchase.
     * @dev    2. An `OrderDigestInvalidated` event has been emitted.
     *
     * @param  data Calldata encoded with PaymentProcessorEncoder.  Matches calldata for:
     *              `revokeOrderDigest(bytes32 orderDigest)`
     */
    function revokeOrderDigest(bytes calldata data) external 
    delegateCall(_moduleOnChainCancellation, SELECTOR_REVOKE_ORDER_DIGEST, data) {}

    /**************************************************************/
    /*                      TAKER OPERATIONS                      */
    /**************************************************************/

    /**
     * @notice Executes a buy listing transaction for a single order item.
     *
     * @dev    Throws when the maker's nonce has already been used or has been cancelled.
     * @dev    Throws when the order has expired.
     * @dev    Throws when the combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when the taker fee on top exceeds 100% of the item sale price.
     * @dev    Throws when the maker's master nonce does not match the order details.
     * @dev    Throws when the order does not comply with the collection payment settings.
     * @dev    Throws when the maker's signature is invalid.
     * @dev    Throws when the order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when the taker does not have or did not send sufficient funds to complete the purchase.
     * @dev    Throws when the token transfer fails for any reason such as lack of approvals or token no longer owned by maker.
     * @dev    Throws when the maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Any unused native token payment will be returned to the taker as wrapped native token.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Maker's nonce is marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Maker's partially fillable order state is updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. An `BuyListingERC721` event has been emitted for a ERC721 purchase.
     * @dev    6. An `BuyListingERC1155` event has been emitted for a ERC1155 purchase.
     * @dev    7. A `NonceInvalidated` event has been emitted for a ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for a ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  data Calldata encoded with PaymentProcessorEncoder.  Matches calldata for:
     *              `function buyListing(
     *                  bytes32 domainSeparator, 
     *                  Order memory saleDetails, 
     *                  SignatureECDSA memory sellerSignature,
     *                  Cosignature memory cosignature,
     *                  FeeOnTop memory feeOnTop)`
     */
    function buyListing(bytes calldata data) external payable 
    nonReentrant delegateCall(_moduleBuyListings, SELECTOR_BUY_LISTING, data) {}

    /**
     * @notice Executes an offer accept transaction for a single order item.
     *
     * @dev    Throws when the maker's nonce has already been used or has been cancelled.
     * @dev    Throws when the order has expired.
     * @dev    Throws when the combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when the taker fee on top exceeds 100% of the item sale price.
     * @dev    Throws when the maker's master nonce does not match the order details.
     * @dev    Throws when the order does not comply with the collection payment settings.
     * @dev    Throws when the maker's signature is invalid.
     * @dev    Throws when the order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when the maker does not have sufficient funds to complete the purchase.
     * @dev    Throws when the token transfer fails for any reason such as lack of approvals or token not owned by the taker.
     * @dev    Throws when the token the offer is being accepted for does not match the conditions set by the maker.
     * @dev    Throws when the maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Maker's nonce is marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Maker's partially fillable order state is updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. An `AcceptOfferERC721` event has been emitted for a ERC721 sale.
     * @dev    6. An `AcceptOfferERC1155` event has been emitted for a ERC1155 sale.
     * @dev    7. A `NonceInvalidated` event has been emitted for a ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for a ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  data Calldata encoded with PaymentProcessorEncoder.  Matches calldata for:
     *              `function acceptOffer(
     *                  bytes32 domainSeparator, 
     *                  uint256 offerType, 
     *                  Order memory saleDetails, 
     *                  SignatureECDSA memory buyerSignature,
     *                  TokenSetProof memory tokenSetProof,
     *                  Cosignature memory cosignature,
     *                  FeeOnTop memory feeOnTop)`
     */
    function acceptOffer(bytes calldata data) external payable 
    nonReentrant delegateCall(_moduleAcceptOffers, SELECTOR_ACCEPT_OFFER, data) {}

    /**
     * @notice Executes a buy listing transaction for multiple order items.
     *
     * @dev    Throws when a maker's nonce has already been used or has been cancelled.
     * @dev    Throws when any order has expired.
     * @dev    Throws when any combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when any taker fee on top exceeds 100% of the item sale price.
     * @dev    Throws when a maker's master nonce does not match the order details.
     * @dev    Throws when an order does not comply with the collection payment settings.
     * @dev    Throws when a maker's signature is invalid.
     * @dev    Throws when an order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when the taker does not have or did not send sufficient funds to complete the purchase.
     * @dev    Throws when a maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Will NOT throw when a token fails to transfer but also will not disperse payments for failed items.
     * @dev    Any unused native token payment will be returned to the taker as wrapped native token.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Makers nonces are marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Makers partially fillable order states are updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. `BuyListingERC721` events have been emitted for each ERC721 purchase.
     * @dev    6. `BuyListingERC1155` events have been emitted for each ERC1155 purchase.
     * @dev    7. A `NonceInvalidated` event has been emitted for each ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for each ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  data Calldata encoded with PaymentProcessorEncoder.  Matches calldata for:
     *              `function bulkBuyListings(
     *                  bytes32 domainSeparator, 
     *                  Order[] calldata saleDetailsArray,
     *                  SignatureECDSA[] calldata sellerSignatures,
     *                  Cosignature[] calldata cosignatures,
     *                  FeeOnTop[] calldata feesOnTop)`
     */
    function bulkBuyListings(bytes calldata data) external payable 
    nonReentrant delegateCall(_moduleBuyListings, SELECTOR_BULK_BUY_LISTINGS, data) {}

    /**
     * @notice Executes an accept offer transaction for multiple order items.
     *
     * @dev    Throws when a maker's nonce has already been used or has been cancelled.
     * @dev    Throws when any order has expired.
     * @dev    Throws when any combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when any taker fee on top exceeds 100% of the item sale price.
     * @dev    Throws when a maker's master nonce does not match the order details.
     * @dev    Throws when an order does not comply with the collection payment settings.
     * @dev    Throws when a maker's signature is invalid.
     * @dev    Throws when an order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when a maker does not have sufficient funds to complete the purchase.
     * @dev    Throws when the token an offer is being accepted for does not match the conditions set by the maker.
     * @dev    Throws when a maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Will NOT throw when a token fails to transfer but also will not disperse payments for failed items.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Makers nonces are marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Makers partially fillable order states are updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. `AcceptOfferERC721` events have been emitted for each ERC721 sale.
     * @dev    6. `AcceptOfferERC1155` events have been emitted for each ERC1155 sale.
     * @dev    7. A `NonceInvalidated` event has been emitted for each ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for each ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  data Calldata encoded with PaymentProcessorEncoder.  Matches calldata for:
     *              `function bulkAcceptOffers(
     *                  bytes32 domainSeparator, 
     *                  BulkAcceptOffersParams memory params)`
     */
    function bulkAcceptOffers(bytes calldata data) external payable 
    nonReentrant delegateCall(_moduleAcceptOffers, SELECTOR_BULK_ACCEPT_OFFERS, data) {}

    /**
     * @notice Executes a sweep transaction for buying multiple items from the same collection.
     *
     * @dev    Throws when the sweep order protocol is ERC1155_PARTIAL_FILL (unsupported).
     * @dev    Throws when a maker's nonce has already been used or has been cancelled.
     * @dev    Throws when any order has expired.
     * @dev    Throws when any combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when the taker fee on top exceeds 100% of the combined item sale prices.
     * @dev    Throws when a maker's master nonce does not match the order details.
     * @dev    Throws when an order does not comply with the collection payment settings.
     * @dev    Throws when a maker's signature is invalid.
     * @dev    Throws when an order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when the taker does not have or did not send sufficient funds to complete the purchase.
     * @dev    Will NOT throw when a token fails to transfer but also will not disperse payments for failed items.
     * @dev    Any unused native token payment will be returned to the taker as wrapped native token.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Makers nonces are marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Makers partially fillable order states are updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. `BuyListingERC721` events have been emitted for each ERC721 purchase.
     * @dev    6. `BuyListingERC1155` events have been emitted for each ERC1155 purchase.
     * @dev    7. A `NonceInvalidated` event has been emitted for each ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     *
     * @param  data Calldata encoded with PaymentProcessorEncoder.  Matches calldata for:
     *              `function sweepCollection(
     *                  bytes32 domainSeparator, 
     *                  FeeOnTop memory feeOnTop,
     *                  SweepOrder memory sweepOrder,
     *                  SweepItem[] calldata items,
     *                  SignatureECDSA[] calldata signedSellOrders,
     *                  Cosignature[] memory cosignatures)`
     */
    function sweepCollection(bytes calldata data) external payable 
    nonReentrant delegateCall(_moduleSweeps, SELECTOR_SWEEP_COLLECTION, data) {}

    /**
     * @notice Executes an advanced buy listing transaction for a single order item.
     *
     * @dev    Throws when the maker's nonce has already been used or has been cancelled.
     * @dev    Throws when the order has expired.
     * @dev    Throws when the combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when the taker fee on top exceeds 100% of the item sale price.
     * @dev    Throws when the maker's master nonce does not match the order details.
     * @dev    Throws when the order does not comply with the collection payment settings.
     * @dev    Throws when the maker's signature is invalid.
     * @dev    Throws when the order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when the taker does not have or did not send sufficient funds to complete the purchase.
     * @dev    Throws when the token transfer fails for any reason such as lack of approvals or token no longer owned by maker.
     * @dev    Throws when the maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Any unused native token payment will be returned to the taker as wrapped native token.
     * @dev    Throws when the provided bulk order merkle proof and order index are invalid.
     * @dev    Throws when the provided permit processor does not have approval to move the token or receives an invalid signature.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Maker's nonce is marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Maker's partially fillable order state is updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. An `BuyListingERC721` event has been emitted for a ERC721 purchase.
     * @dev    6. An `BuyListingERC1155` event has been emitted for a ERC1155 purchase.
     * @dev    7. A `NonceInvalidated` event has been emitted for a ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for a ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  data Calldata encoded with PaymentProcessorEncoder.  Matches calldata for:
     *                `function buyListingAdvanced(
     *                   bytes32 domainSeparator,
     *                   AdvancedListing memory advancedListing,
     *                   BulkOrderProof memory bulkOrderProof,
     *                   FeeOnTop memory feeOnTop)`
     */
    function buyListingAdvanced(bytes calldata data) external payable 
    nonReentrant delegateCall(_moduleBuyListings, SELECTOR_BUY_LISTING_ADVANCED, data) {}

    /**
     * @notice Executes an advanced offer accept transaction for a single order item.
     *
     * @dev    Throws when the maker's nonce has already been used or has been cancelled.
     * @dev    Throws when the order has expired.
     * @dev    Throws when the combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when the taker fee on top exceeds 100% of the item sale price.
     * @dev    Throws when the maker's master nonce does not match the order details.
     * @dev    Throws when the order does not comply with the collection payment settings.
     * @dev    Throws when the maker's signature is invalid.
     * @dev    Throws when the order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when the maker does not have sufficient funds to complete the purchase.
     * @dev    Throws when the token transfer fails for any reason such as lack of approvals or token not owned by the taker.
     * @dev    Throws when the token the offer is being accepted for does not match the conditions set by the maker.
     * @dev    Throws when the maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when the order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Throws when the provided bulk order merkle proof and order index are invalid.
     * @dev    Throws when the provided permit processor does not have approval to move the token or receives an invalid signature.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Maker's nonce is marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Maker's partially fillable order state is updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. An `AcceptOfferERC721` event has been emitted for a ERC721 sale.
     * @dev    6. An `AcceptOfferERC1155` event has been emitted for a ERC1155 sale.
     * @dev    7. A `NonceInvalidated` event has been emitted for a ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for a ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  data  Calldata encoded with PaymentProcessorEncoder.  Matches calldata for:
     *               `function acceptOfferAdvanced(
     *                 bytes32 domainSeparator,
     *                 AdvancedBid memory advancedBid,
     *                 BulkOrderProof memory bulkOrderProof,
     *                 FeeOnTop memory feeOnTop,
     *                 TokenSetProof memory tokenSetProof)`
     */
    function acceptOfferAdvanced(bytes calldata data) external payable 
    nonReentrant delegateCall(_moduleAcceptOffers, SELECTOR_ACCEPT_OFFER_ADVANCED, data) {}

    /**
     * @notice Executes an advanced buy listing transaction for multiple order items.
     *
     * @dev    Throws when a maker's nonce has already been used or has been cancelled.
     * @dev    Throws when any order has expired.
     * @dev    Throws when any combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when any taker fee on top exceeds 100% of the item sale price.
     * @dev    Throws when a maker's master nonce does not match the order details.
     * @dev    Throws when an order does not comply with the collection payment settings.
     * @dev    Throws when a maker's signature is invalid.
     * @dev    Throws when an order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when the taker does not have or did not send sufficient funds to complete the purchase.
     * @dev    Throws when a maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Throws when any provided bulk order merkle proof and order index are invalid.
     * @dev    Throws when any provided permit processor does not have approval to move the token or receives an invalid signature.
     * @dev    Will NOT throw when a token fails to transfer but also will not disperse payments for failed items.
     * @dev    Any unused native token payment will be returned to the taker as wrapped native token.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Makers nonces are marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Makers partially fillable order states are updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. `BuyListingERC721` events have been emitted for each ERC721 purchase.
     * @dev    6. `BuyListingERC1155` events have been emitted for each ERC1155 purchase.
     * @dev    7. A `NonceInvalidated` event has been emitted for each ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for each ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  data  Calldata encoded with PaymentProcessorEncoder.  Matches calldata for:
     *                `function bulkBuyListingsAdvanced(
     *                  bytes32 domainSeparator,
     *                  AdvancedListing[] calldata advancedListingsArray,
     *                  BulkOrderProof[] calldata bulkOrderProofs,
     *                  FeeOnTop[] calldata feesOnTop)`
     */
    function bulkBuyListingsAdvanced(bytes calldata data) external payable 
    nonReentrant delegateCall(_moduleBuyListings, SELECTOR_BULK_BUY_LISTINGS_ADVANCED, data) {}

    /**
     * @notice Executes an advanced offer accept transaction for multiple order items.
     *
     * @dev    Throws when a maker's nonce has already been used or has been cancelled.
     * @dev    Throws when any order has expired.
     * @dev    Throws when any combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when any taker fee on top exceeds 100% of the item sale price.
     * @dev    Throws when a maker's master nonce does not match the order details.
     * @dev    Throws when an order does not comply with the collection payment settings.
     * @dev    Throws when a maker's signature is invalid.
     * @dev    Throws when an order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when a maker does not have sufficient funds to complete the purchase.
     * @dev    Throws when any token transfer fails for any reason such as lack of approvals or token not owned by the taker.
     * @dev    Throws when the token an offer is being accepted for does not match the conditions set by the maker.
     * @dev    Throws when a maker has revoked the order digest on a ERC1155_PARTIAL_FILL order.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the item price is not evenly divisible by the amount.
     * @dev    Throws when an order is an ERC1155_PARTIAL_FILL order and the remaining fillable quantity is less than the requested minimum fill amount.
     * @dev    Throws when the provided bulk order merkle proof and order index are invalid.
     * @dev    Throws when the provided permit processor does not have approval to move the token or receives an invalid signature.
     * @dev    Will NOT throw when a token fails to transfer but also will not disperse payments for failed items.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Maker's nonce is marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Maker's partially fillable order state is updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. An `AcceptOfferERC721` event has been emitted for a ERC721 sale.
     * @dev    6. An `AcceptOfferERC1155` event has been emitted for a ERC1155 sale.
     * @dev    7. A `NonceInvalidated` event has been emitted for a ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     * @dev    8. A `OrderDigestInvalidated` event has been emitted for a ERC1155_PARTIAL_FILL order, if fully filled.
     *
     * @param  data    Calldata encoded with PaymentProcessorEncoder.  Matches calldata for:
     *                  `function bulkAcceptOffersAdvanced(
     *                    bytes32 domainSeparator,
     *                    AdvancedBid[] calldata advancedBids,
     *                    BulkOrderProof[] calldata bulkOrderProofs,
     *                    FeeOnTop[] calldata feesOnTop,
     *                    TokenSetProof[] calldata tokenSetProofs)`
     */
    function bulkAcceptOffersAdvanced(bytes calldata data) external payable 
    nonReentrant delegateCall(_moduleAcceptOffers, SELECTOR_BULK_ACCEPT_OFFERS_ADVANCED, data) {}

    /**
     * @notice Executes an advanced sweep transaction for buying multiple items from the same collection.
     *
     * @dev    Throws when the sweep order protocol is ERC1155_PARTIAL_FILL (unsupported).
     * @dev    Throws when a maker's nonce has already been used or has been cancelled.
     * @dev    Throws when any order has expired.
     * @dev    Throws when any combined marketplace and royalty fee exceeds 100%.
     * @dev    Throws when the taker fee on top exceeds 100% of the combined item sale prices.
     * @dev    Throws when a maker's master nonce does not match the order details.
     * @dev    Throws when an order does not comply with the collection payment settings.
     * @dev    Throws when a maker's signature is invalid.
     * @dev    Throws when an order is a cosigned order and the cosignature is invalid.
     * @dev    Throws when the transaction originates from an untrusted channel if untrusted channels are blocked.
     * @dev    Throws when the taker does not have or did not send sufficient funds to complete the purchase.
     * @dev    Throws when the provided bulk order merkle proof and order index are invalid.
     * @dev    Throws when the provided permit processor does not have approval to move the token or receives an invalid signature.
     * @dev    Will NOT throw when a token fails to transfer but also will not disperse payments for failed items.
     * @dev    Any unused native token payment will be returned to the taker as wrapped native token.
     *
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. Payment amounts and fees are sent to their respective recipients.
     * @dev    2. Purchased tokens are sent to the beneficiary.
     * @dev    3. Makers nonces are marked as used for ERC721_FILL_OR_KILL and ERC1155_FILL_OR_KILL orders.
     * @dev    4. Makers partially fillable order states are updated for ERC1155_PARTIAL_FILL orders.
     * @dev    5. `BuyListingERC721` events have been emitted for each ERC721 purchase.
     * @dev    6. `BuyListingERC1155` events have been emitted for each ERC1155 purchase.
     * @dev    7. A `NonceInvalidated` event has been emitted for each ERC721_FILL_OR_KILL or ERC1155_FILL_OR_KILL order.
     *
     * @param data             Calldata encoded with PaymentProcessorEncoder.  Matches calldata for:
     *                       `function sweepCollectionAdvanced(
     *                         bytes32 domainSeparator,
     *                         AdvancedSweep calldata advancedSweep)`
     */
    function sweepCollectionAdvanced(bytes calldata data) external payable 
    nonReentrant delegateCall(_moduleSweeps, SELECTOR_SWEEP_COLLECTION_ADVANCED, data) {}

    /**************************************************************/
    /*                       PROTOCOL FEES                        */
    /**************************************************************/

    /**
     * @notice Sets the protocol fees for the marketplace.
     * @dev    If either the fee receiver is set to the zero address or all fees are set to zero, the protocol fees 
     *         will be disabled entirely.
     * 
     * @dev    Throws when `msg.sender` does not have the `FEE_MANAGER` role.
     * @dev    Throws when the grace period, in seconds, exceeds uint24 max (about 194 days).
     * @dev    Throws when the marketplace fee or fee on top tax rate exceeds the cap.
     * 
     * @dev    <h4>Postconditions:</h4>
     * @dev    1. The protocol fees have been updated.
     * @dev    2. A `ProtocolFeesUpdated` event has been emitted.
     *
     * @param  protocolFees  The new protocol fees to set.
     */
    function setProtocolFees(ProtocolFees calldata protocolFees, uint256 gracePeriodSeconds) external callerHasRole(FEE_MANAGER) {
        if (gracePeriodSeconds > type(uint24).max) {
            revert PaymentProcessor__MaxGracePeriodExceeded();
        }

        ProtocolFees memory protocolFeesUpdated = protocolFees;
        protocolFeesUpdated.versionExpiration = type(uint48).max;

        if (protocolFeesUpdated.protocolFeeReceiver == address(0)) {
            protocolFeesUpdated.minimumProtocolFeeBps = 0;
            protocolFeesUpdated.marketplaceFeeProtocolTaxBps = 0;
            protocolFeesUpdated.feeOnTopProtocolTaxBps = 0;
        } else {
            if (protocolFeesUpdated.marketplaceFeeProtocolTaxBps > FEE_DENOMINATOR) {
                revert PaymentProcessor__ProtocolFeeOrTaxExceedsCap();
            }

            if (protocolFeesUpdated.feeOnTopProtocolTaxBps > FEE_DENOMINATOR) {
                revert PaymentProcessor__ProtocolFeeOrTaxExceedsCap();
            }

            if (protocolFeesUpdated.minimumProtocolFeeBps | 
                protocolFeesUpdated.marketplaceFeeProtocolTaxBps | 
                protocolFeesUpdated.feeOnTopProtocolTaxBps == 0) {
                protocolFeesUpdated.protocolFeeReceiver = address(0);
            }
        }
        
        unchecked {
            uint48 gracePeriod = uint48(block.timestamp + gracePeriodSeconds);
            uint256 nextVersion = ++appStorage().currentProtocolFeeVersion;
            appStorage().protocolFeeVersions[nextVersion - 1].versionExpiration = gracePeriod;
            appStorage().protocolFeeVersions[nextVersion] = protocolFeesUpdated;

            emit ProtocolFeesUpdated(
                protocolFeesUpdated.protocolFeeReceiver, 
                protocolFeesUpdated.minimumProtocolFeeBps, 
                protocolFeesUpdated.marketplaceFeeProtocolTaxBps, 
                protocolFeesUpdated.feeOnTopProtocolTaxBps,
                gracePeriod);
        }
    }

    /**
     * @notice Returns the current protocol fee version.
     */
    function getProtocolFeeVersion() external view returns (uint256) {
        return appStorage().currentProtocolFeeVersion;
    }

    /**
     * @notice Returns the current protocol fees for the marketplace.
     */
    function getProtocolFees() external view returns (ProtocolFees memory protocolFees) {
        protocolFees = appStorage().protocolFeeVersions[appStorage().currentProtocolFeeVersion];
    }

    /**
     * @notice Returns the protocol fees for a specific historical version.
     */
    function getProtocolFees(uint256 version) external view returns (ProtocolFees memory protocolFees) {
        protocolFees = appStorage().protocolFeeVersions[version];
    }

    function _setupRoles() internal virtual override {
        _setupRole(FEE_MANAGER, 0);
    }
}