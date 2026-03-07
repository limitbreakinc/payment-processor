//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "./SettingsDataTypes.sol";

/** 
* @title IPaymentProcessorSettings
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 
interface IPaymentProcessorSettings {
    function registrySyncSettings(address tokenAddress) external;

    function registryUpdateWhitelistPaymentMethods(
        uint32 paymentMethodWhitelistId,
        address[] calldata paymentMethods,
        bool paymentMethodsAdded
    ) external;

    function registryUpdateTrustedChannels(
        address tokenAddress,
        address[] calldata channelsToUpdate,
        bool channelsAdded
    ) external;

    function registryUpdateTokenPricingBounds(
        address tokenAddress, 
        uint256[] calldata tokenIds, 
        RegistryPricingBounds[] calldata pricingBounds
    ) external;

    function registryUpdateTrustedPermitProcessors(
        address[] calldata permitProcessors,
        bool permitProcessorsAdded
    ) external;

    function checkSyncCollectionSettings(
        address tokenAddress
    ) external;

    function checkSyncTokenPricingBounds(
        address tokenAddress,
        uint256 tokenId
    ) external returns (uint256, uint256);
    
    function checkWhitelistedPaymentMethod(
        uint32 whitelistId,
        address paymentMethod
    ) external returns (bool isWhitelisted);
    
    function checkCollectionTrustedChannels(
        address tokenAddress,
        address channel
    ) external returns (bool isAllowed);
    
    function checkTrustedPermitProcessors(
        address permitProcessor
    ) external returns (bool isTrusted);
}