pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "./PaymentProcessorModule.t.sol";

contract PaymentProcessorTest is PaymentProcessorModuleTest {
    function testGetDefaultPaymentMethods() public {
        address[] memory defaultPaymentMethods = _paymentProcessor.getDefaultPaymentMethods();
        assertEq(defaultPaymentMethods.length, 6);
        assertEq(defaultPaymentMethods[0], address(0));
        assertEq(defaultPaymentMethods[1], address(nativeWrapper));
        assertEq(defaultPaymentMethods[2], address(weth));
        assertEq(defaultPaymentMethods[3], address(usdc));
        assertEq(defaultPaymentMethods[4], address(usdt));
        assertEq(defaultPaymentMethods[5], address(dai));
    }

    function testIsDefaultPaymentMethod(address postDeployMethod1, address postDeployMethod2, address nonDefault) public {
        address[] memory exclusionList = new address[](5);
        exclusionList[0] = address(nativeWrapper);
        exclusionList[1] = address(weth);
        exclusionList[2] = address(usdc);
        exclusionList[3] = address(usdt);
        exclusionList[4] = address(dai);

        _sanitizeAddress(postDeployMethod1, exclusionList);
        _sanitizeAddress(postDeployMethod2, exclusionList);
        _sanitizeAddress(nonDefault, exclusionList);

        vm.assume(postDeployMethod1 != postDeployMethod2);
        vm.assume(postDeployMethod1 != nonDefault);
        vm.assume(postDeployMethod2 != nonDefault);

        _whitelistPaymentMethod(address(this), DEFAULT_PAYMENT_METHOD_WHITELIST_ID, address(postDeployMethod1), true);
        _whitelistPaymentMethod(address(this), DEFAULT_PAYMENT_METHOD_WHITELIST_ID, address(postDeployMethod2), true);
        
        assertTrue(_paymentProcessor.isDefaultPaymentMethod(address(0)));
        assertTrue(_paymentProcessor.isDefaultPaymentMethod(address(weth)));
        assertTrue(_paymentProcessor.isDefaultPaymentMethod(address(usdc)));
        assertTrue(_paymentProcessor.isDefaultPaymentMethod(address(usdt)));
        assertTrue(_paymentProcessor.isDefaultPaymentMethod(address(dai)));
        assertTrue(_paymentProcessor.isDefaultPaymentMethod(postDeployMethod1));
        assertTrue(_paymentProcessor.isDefaultPaymentMethod(postDeployMethod2));
        assertFalse(_paymentProcessor.isDefaultPaymentMethod(nonDefault));

        _unwhitelistPaymentMethod(address(this), DEFAULT_PAYMENT_METHOD_WHITELIST_ID, address(postDeployMethod1), true);
        _unwhitelistPaymentMethod(address(this), DEFAULT_PAYMENT_METHOD_WHITELIST_ID, address(postDeployMethod2), true);

        assertTrue(_paymentProcessor.isDefaultPaymentMethod(address(0)));
        assertTrue(_paymentProcessor.isDefaultPaymentMethod(address(nativeWrapper)));
        assertTrue(_paymentProcessor.isDefaultPaymentMethod(address(weth)));
        assertTrue(_paymentProcessor.isDefaultPaymentMethod(address(usdc)));
        assertTrue(_paymentProcessor.isDefaultPaymentMethod(address(usdt)));
        assertTrue(_paymentProcessor.isDefaultPaymentMethod(address(dai)));
        assertFalse(_paymentProcessor.isDefaultPaymentMethod(postDeployMethod1));
        assertFalse(_paymentProcessor.isDefaultPaymentMethod(postDeployMethod2));
        assertFalse(_paymentProcessor.isDefaultPaymentMethod(nonDefault));
    }
}