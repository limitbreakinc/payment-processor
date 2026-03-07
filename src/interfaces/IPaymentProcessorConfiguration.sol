//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "../DataTypes.sol";

/** 
* @title IPaymentProcessorConfiguration
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 
interface IPaymentProcessorConfiguration {

    /**
     * @notice Returns the ERC2771 context setup params for payment processor modules.
     */
    function getPaymentProcessorModuleERC2771ContextParams() 
        external 
        view 
        returns (
            address /*trustedForwarderFactory*/
        );

    /**
     * @notice Returns the setup params for payment processor modules.
     */
    function getPaymentProcessorModuleDeploymentParams() 
        external 
        view 
        returns (
            address, /*deterministicPaymentProcessorAddress*/
            address, /*wrappedNativeCoin*/
            DefaultPaymentMethods memory /*defaultPaymentMethods*/,
            TrustedPermitProcessors memory /*trustedPermitProcessors*/,
            address /*collectionPaymentSettings*/,
            address /*infrastructureFeeReceiver*/
        );

    /**
     * @notice Returns the setup params for payment processor.
     */
    function getPaymentProcessorDeploymentParams()
        external
        view
        returns (
            address, /*defaultContractOwner*/
            PaymentProcessorModules memory /*paymentProcessorModules*/
        );
}