//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "./DataTypes.sol";
import "./Errors.sol";
import "./interfaces/IPaymentProcessorConfiguration.sol";

import "@limitbreak/tm-core-lib/src/licenses/LicenseRef-PolyForm-Strict-1.0.0.sol";
import "@limitbreak/tm-core-lib/src/utils/access/Ownable.sol";

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
 
* @title PaymentProcessorConfiguration
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 

contract PaymentProcessorConfiguration is Ownable, IPaymentProcessorConfiguration {
    /// @dev Track Parameter Initialization
    bool private _initializedPaymentProcessorModuleConfiguration;
    bool private _initializedPaymentProcessorConfiguration;

    ///@dev Configuration Values For Payment Processor Modules
    address private _deterministicPaymentProcessorAddress;
    address private _trustedForwarderFactory;
    address private _wrappedNativeCoin;
    DefaultPaymentMethods private _defaultPaymentMethods;
    TrustedPermitProcessors private _trustedPermitProcessors;
    address private _collectionSettingsRegistry;
    address private _infrastructureFeeReceiver;

    /// @dev Configuration Values For Payment Processor Main Contract
    address private _defaultContractOwner;
    PaymentProcessorModules private _paymentProcessorModules;

    constructor(address defaultContractOwner_) Ownable(defaultContractOwner_) {
        if (defaultContractOwner_ == address(0)) {
            revert PaymentProcessor__InvalidConstructorArguments();
        }
    }

    /**
     * @notice Sets the configuration for payment processor modules.
     *
     * @param deterministicPaymentProcessorAddress_  The address of the deterministic payment processor.
     * @param trustedForwarderFactory_               The address of the trusted forwarder factory.
     * @param wrappedNativeCoin_                     The address of the wrapped native coin.
     * @param defaultPaymentMethod1_                 The address of the default payment method 1.
     * @param defaultPaymentMethod2_                 The address of the default payment method 2.
     * @param defaultPaymentMethod3_                 The address of the default payment method 3.
     * @param defaultPaymentMethod4_                 The address of the default payment method 4.
     * @param permitProcessor1_                      The address of the permit processor 1.
     * @param permitProcessor2_                      The address of the permit processor 2.
     * @param collectionSettingsRegistry_            The address of the collection settings registry.
     */
    function setPaymentProcessorModuleConfiguration(
        address deterministicPaymentProcessorAddress_,
        address trustedForwarderFactory_,
        address wrappedNativeCoin_,
        address defaultPaymentMethod1_,
        address defaultPaymentMethod2_,
        address defaultPaymentMethod3_,
        address defaultPaymentMethod4_,
        address permitProcessor1_,
        address permitProcessor2_,
        address collectionSettingsRegistry_,
        address infrastructureFeeReceiver_
    ) external onlyOwner {
        if (deterministicPaymentProcessorAddress_ == address(0) ||
            trustedForwarderFactory_ == address(0) || 
            wrappedNativeCoin_ == address(0) || 
            collectionSettingsRegistry_ == address(0) ||
            infrastructureFeeReceiver_ == address(0)) {
            revert PaymentProcessor__InvalidConstructorArguments();
        }

        _deterministicPaymentProcessorAddress = deterministicPaymentProcessorAddress_;
        _trustedForwarderFactory = trustedForwarderFactory_;
        _wrappedNativeCoin = wrappedNativeCoin_;
        _defaultPaymentMethods.defaultPaymentMethod1 = defaultPaymentMethod1_;
        _defaultPaymentMethods.defaultPaymentMethod2 = defaultPaymentMethod2_;
        _defaultPaymentMethods.defaultPaymentMethod3 = defaultPaymentMethod3_;
        _defaultPaymentMethods.defaultPaymentMethod4 = defaultPaymentMethod4_;
        _trustedPermitProcessors.permitProcessor1 = permitProcessor1_;
        _trustedPermitProcessors.permitProcessor2 = permitProcessor2_;
        _collectionSettingsRegistry = collectionSettingsRegistry_;
        _infrastructureFeeReceiver = infrastructureFeeReceiver_;

        _initializedPaymentProcessorModuleConfiguration = true;
    }

    /**
     * @notice Sets the configuration for the payment processor.
     * 
     * @param defaultContractOwner_     The address of the default contract owner.
     * @param paymentProcessorModules_  The payment processor module addresses.
     */
    function setPaymentProcessorConfiguration(
        address defaultContractOwner_,
        PaymentProcessorModules calldata paymentProcessorModules_
    ) external onlyOwner {
        if (defaultContractOwner_ == address(0) ||
            paymentProcessorModules_.moduleOnChainCancellation == address(0) || 
            paymentProcessorModules_.moduleBuyListings == address(0) || 
            paymentProcessorModules_.moduleAcceptOffers == address(0) || 
            paymentProcessorModules_.moduleSweeps == address(0)) {
            revert PaymentProcessor__InvalidConstructorArguments();
        }

        _defaultContractOwner = defaultContractOwner_;
        _paymentProcessorModules = paymentProcessorModules_;

        _initializedPaymentProcessorConfiguration = true;
    }

    /**
     * @notice Returns the ERC2771 context setup params for payment processor modules.
     */
    function getPaymentProcessorModuleERC2771ContextParams() external view returns (address trustedForwarderFactory) {
        if (!_initializedPaymentProcessorModuleConfiguration) {
            revert PaymentProcessor__UninitializedConfiguration();
        }

        trustedForwarderFactory = _trustedForwarderFactory;
    }

    /**
     * @notice Returns the setup params for payment processor modules.
     */
    function getPaymentProcessorModuleDeploymentParams() 
        external 
        view 
        returns (
            address deterministicPaymentProcessorAddress,
            address wrappedNativeCoin,
            DefaultPaymentMethods memory defaultPaymentMethods,
            TrustedPermitProcessors memory trustedPermitProcessors,
            address collectionSettingsRegistry,
            address infrastructureFeeReceiver
        ) 
    {
        if (!_initializedPaymentProcessorModuleConfiguration) {
            revert PaymentProcessor__UninitializedConfiguration();
        }

        deterministicPaymentProcessorAddress = _deterministicPaymentProcessorAddress;
        wrappedNativeCoin = _wrappedNativeCoin;
        defaultPaymentMethods = _defaultPaymentMethods;
        trustedPermitProcessors = _trustedPermitProcessors;
        collectionSettingsRegistry = _collectionSettingsRegistry;
        infrastructureFeeReceiver = _infrastructureFeeReceiver;
    }

    /**
     * @notice Returns the setup params for payment processor.
     */
    function getPaymentProcessorDeploymentParams()
        external
        view
        returns (
            address defaultContractOwner,
            PaymentProcessorModules memory paymentProcessorModules
        )
    {
        if (!_initializedPaymentProcessorConfiguration) {
            revert PaymentProcessor__UninitializedConfiguration();
        }

        defaultContractOwner = _defaultContractOwner;
        paymentProcessorModules = _paymentProcessorModules;
    }
}