pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../PaymentProcessorModule.t.sol";

contract ProtocolFeesTest is PaymentProcessorModuleTest {
    
    function testDefaultProtocolFees() public {
        ProtocolFees memory protocolFees = _paymentProcessor.getProtocolFees();
        assertEq(protocolFees.protocolFeeReceiver, infrastructureFeeRecipient);
        assertEq(protocolFees.minimumProtocolFeeBps, DEFAULT_PROTOCOL_FEE_MINIMUM_BPS);
        assertEq(protocolFees.marketplaceFeeProtocolTaxBps, DEFAULT_PROTOCOL_FEE_MARKETPLACE_TAX_BPS);
        assertEq(protocolFees.feeOnTopProtocolTaxBps, DEFAULT_PROTOCOL_FEE_FEE_ON_TOP_TAX_BPS);
        assertEq(protocolFees.versionExpiration, type(uint48).max);
    }

    function testSetProtocolFeesNullReceiver(ProtocolFees memory protocolFees, uint256 gracePeriodSeconds) public {
        protocolFees.protocolFeeReceiver = address(0);

        protocolFees.minimumProtocolFeeBps = protocolFees.minimumProtocolFeeBps % 10001;
        protocolFees.marketplaceFeeProtocolTaxBps = protocolFees.marketplaceFeeProtocolTaxBps % 10001;
        protocolFees.feeOnTopProtocolTaxBps = protocolFees.feeOnTopProtocolTaxBps % 10001;

        gracePeriodSeconds = uint24(bound(gracePeriodSeconds, 0, type(uint24).max));
        uint48 oldVersionExpiration = uint48(block.timestamp + gracePeriodSeconds);
        
        vm.expectEmit(true, false, false, true);
        emit ProtocolFeesUpdated(
            address(0), 
            0, 
            0, 
            0, 
            oldVersionExpiration);

        _paymentProcessor.setProtocolFees(protocolFees, gracePeriodSeconds);

        ProtocolFees memory updatedProtocolFees = _paymentProcessor.getProtocolFees();
        ProtocolFees memory lastProtocolFeeVersion = _paymentProcessor.getProtocolFees(0);

        assertEq(1, _paymentProcessor.getProtocolFeeVersion());
        assertEq(updatedProtocolFees.protocolFeeReceiver, address(0));
        assertEq(updatedProtocolFees.minimumProtocolFeeBps, 0);
        assertEq(updatedProtocolFees.marketplaceFeeProtocolTaxBps, 0);
        assertEq(updatedProtocolFees.feeOnTopProtocolTaxBps, 0);
        assertEq(updatedProtocolFees.versionExpiration, type(uint48).max);

        assertEq(lastProtocolFeeVersion.protocolFeeReceiver, infrastructureFeeRecipient);
        assertEq(lastProtocolFeeVersion.minimumProtocolFeeBps, DEFAULT_PROTOCOL_FEE_MINIMUM_BPS);
        assertEq(lastProtocolFeeVersion.marketplaceFeeProtocolTaxBps, DEFAULT_PROTOCOL_FEE_MARKETPLACE_TAX_BPS);
        assertEq(lastProtocolFeeVersion.feeOnTopProtocolTaxBps, DEFAULT_PROTOCOL_FEE_FEE_ON_TOP_TAX_BPS);
        assertEq(lastProtocolFeeVersion.versionExpiration, oldVersionExpiration);
    }

    function testSetProtocolFeesNullFees(ProtocolFees memory protocolFees, uint256 gracePeriodSeconds) public {
        vm.assume(protocolFees.protocolFeeReceiver != address(0));

        protocolFees.minimumProtocolFeeBps = 0;
        protocolFees.marketplaceFeeProtocolTaxBps = 0;
        protocolFees.feeOnTopProtocolTaxBps = 0;

        gracePeriodSeconds = uint24(bound(gracePeriodSeconds, 0, type(uint24).max));
        uint48 oldVersionExpiration = uint48(block.timestamp + gracePeriodSeconds);
        
        vm.expectEmit(true, false, false, true);
        emit ProtocolFeesUpdated(
            address(0), 
            0, 
            0, 
            0, 
            oldVersionExpiration);

        _paymentProcessor.setProtocolFees(protocolFees, gracePeriodSeconds);

        ProtocolFees memory updatedProtocolFees = _paymentProcessor.getProtocolFees();
        ProtocolFees memory lastProtocolFeeVersion = _paymentProcessor.getProtocolFees(0);

        assertEq(1, _paymentProcessor.getProtocolFeeVersion());
        assertEq(updatedProtocolFees.protocolFeeReceiver, address(0));
        assertEq(updatedProtocolFees.minimumProtocolFeeBps, 0);
        assertEq(updatedProtocolFees.marketplaceFeeProtocolTaxBps, 0);
        assertEq(updatedProtocolFees.feeOnTopProtocolTaxBps, 0);
        assertEq(updatedProtocolFees.versionExpiration, type(uint48).max);

        assertEq(lastProtocolFeeVersion.protocolFeeReceiver, infrastructureFeeRecipient);
        assertEq(lastProtocolFeeVersion.minimumProtocolFeeBps, DEFAULT_PROTOCOL_FEE_MINIMUM_BPS);
        assertEq(lastProtocolFeeVersion.marketplaceFeeProtocolTaxBps, DEFAULT_PROTOCOL_FEE_MARKETPLACE_TAX_BPS);
        assertEq(lastProtocolFeeVersion.feeOnTopProtocolTaxBps, DEFAULT_PROTOCOL_FEE_FEE_ON_TOP_TAX_BPS);
        assertEq(lastProtocolFeeVersion.versionExpiration, oldVersionExpiration);
    }

    function testSetProtocolFees(ProtocolFees memory protocolFees, uint256 gracePeriodSeconds) public {
        vm.assume(protocolFees.protocolFeeReceiver != address(0));

        protocolFees.minimumProtocolFeeBps = protocolFees.minimumProtocolFeeBps % 10001;
        protocolFees.marketplaceFeeProtocolTaxBps = protocolFees.marketplaceFeeProtocolTaxBps % 10001;
        protocolFees.feeOnTopProtocolTaxBps = protocolFees.feeOnTopProtocolTaxBps % 10001;

        gracePeriodSeconds = uint24(bound(gracePeriodSeconds, 0, type(uint24).max));
        uint48 oldVersionExpiration = uint48(block.timestamp + gracePeriodSeconds);

        if (protocolFees.feeOnTopProtocolTaxBps | protocolFees.marketplaceFeeProtocolTaxBps | protocolFees.minimumProtocolFeeBps == 0) {
            protocolFees.protocolFeeReceiver = address(0);
        }

        vm.expectEmit(true, false, false, true);
        emit ProtocolFeesUpdated(
            protocolFees.protocolFeeReceiver, 
            protocolFees.minimumProtocolFeeBps, 
            protocolFees.marketplaceFeeProtocolTaxBps, 
            protocolFees.feeOnTopProtocolTaxBps, 
            oldVersionExpiration);

        _paymentProcessor.setProtocolFees(protocolFees, gracePeriodSeconds);

        ProtocolFees memory updatedProtocolFees = _paymentProcessor.getProtocolFees();
        ProtocolFees memory lastProtocolFeeVersion = _paymentProcessor.getProtocolFees(0);

        assertEq(1, _paymentProcessor.getProtocolFeeVersion());
        assertEq(updatedProtocolFees.protocolFeeReceiver, protocolFees.protocolFeeReceiver);
        assertEq(updatedProtocolFees.minimumProtocolFeeBps, protocolFees.minimumProtocolFeeBps);
        assertEq(updatedProtocolFees.marketplaceFeeProtocolTaxBps, protocolFees.marketplaceFeeProtocolTaxBps);
        assertEq(updatedProtocolFees.feeOnTopProtocolTaxBps, protocolFees.feeOnTopProtocolTaxBps);
        assertEq(updatedProtocolFees.versionExpiration, type(uint48).max);

        assertEq(lastProtocolFeeVersion.protocolFeeReceiver, infrastructureFeeRecipient);
        assertEq(lastProtocolFeeVersion.minimumProtocolFeeBps, DEFAULT_PROTOCOL_FEE_MINIMUM_BPS);
        assertEq(lastProtocolFeeVersion.marketplaceFeeProtocolTaxBps, DEFAULT_PROTOCOL_FEE_MARKETPLACE_TAX_BPS);
        assertEq(lastProtocolFeeVersion.feeOnTopProtocolTaxBps, DEFAULT_PROTOCOL_FEE_FEE_ON_TOP_TAX_BPS);
        assertEq(lastProtocolFeeVersion.versionExpiration, oldVersionExpiration);
    }

    function testSetProtocolFeesRevertsWhenGracePeriodTooLong(ProtocolFees memory protocolFees, uint256 gracePeriodSeconds) public {
        protocolFees.minimumProtocolFeeBps = protocolFees.minimumProtocolFeeBps % 10001;
        protocolFees.marketplaceFeeProtocolTaxBps = protocolFees.marketplaceFeeProtocolTaxBps % 10001;
        protocolFees.feeOnTopProtocolTaxBps = protocolFees.feeOnTopProtocolTaxBps % 10001;
        gracePeriodSeconds = bound(gracePeriodSeconds, 1 + uint256(type(uint24).max), type(uint256).max);

        vm.expectRevert(PaymentProcessor__MaxGracePeriodExceeded.selector);
        _paymentProcessor.setProtocolFees(protocolFees, gracePeriodSeconds);
    }

    function testSetProtocolFeesRevertsWhenMarketplaceFeeTaxExceeds100Percent(ProtocolFees memory protocolFees, uint256 gracePeriodSeconds) public {
        vm.assume(protocolFees.protocolFeeReceiver != address(0));
        protocolFees.minimumProtocolFeeBps = protocolFees.minimumProtocolFeeBps % 10001;
        protocolFees.marketplaceFeeProtocolTaxBps = uint16(bound(protocolFees.marketplaceFeeProtocolTaxBps, FEE_DENOMINATOR + 1, type(uint16).max));
        protocolFees.feeOnTopProtocolTaxBps = protocolFees.feeOnTopProtocolTaxBps % 10001;
        gracePeriodSeconds = bound(gracePeriodSeconds, 0, type(uint24).max);

        vm.expectRevert(PaymentProcessor__ProtocolFeeOrTaxExceedsCap.selector);
        _paymentProcessor.setProtocolFees(protocolFees, gracePeriodSeconds);
    }

    function testSetProtocolFeesRevertsWhenFeeOnTopTaxExceeds100Percent(ProtocolFees memory protocolFees, uint256 gracePeriodSeconds) public {
        vm.assume(protocolFees.protocolFeeReceiver != address(0));
        protocolFees.minimumProtocolFeeBps = protocolFees.minimumProtocolFeeBps % 10001;
        protocolFees.marketplaceFeeProtocolTaxBps = protocolFees.marketplaceFeeProtocolTaxBps % 10001;
        protocolFees.feeOnTopProtocolTaxBps = uint16(bound(protocolFees.marketplaceFeeProtocolTaxBps, FEE_DENOMINATOR + 1, type(uint16).max));
        gracePeriodSeconds = bound(gracePeriodSeconds, 0, type(uint24).max);

        vm.expectRevert(PaymentProcessor__ProtocolFeeOrTaxExceedsCap.selector);
        _paymentProcessor.setProtocolFees(protocolFees, gracePeriodSeconds);
    }
}