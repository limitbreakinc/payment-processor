pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../PaymentProcessorModule.t.sol";

contract ModulePaymentSettingsTest is PaymentProcessorModuleTest {

    function testReassignOwnershipOfDefaultPaymentMethodWhitelist(address newOwner) public {
        _sanitizeAddress(newOwner, new address[](0));
        assertEq(collectionSettingsRegistry.paymentMethodWhitelistOwners(DEFAULT_PAYMENT_METHOD_WHITELIST_ID), address(this));
        _reassignOwnershipOfPaymentMethodWhitelist(address(this), DEFAULT_PAYMENT_METHOD_WHITELIST_ID, newOwner, EMPTY_SELECTOR);
        assertEq(collectionSettingsRegistry.paymentMethodWhitelistOwners(DEFAULT_PAYMENT_METHOD_WHITELIST_ID), newOwner);
    }

    function testRenounceOwnershipOfDefaultPaymentMethodWhitelist() public {
        assertEq(collectionSettingsRegistry.paymentMethodWhitelistOwners(DEFAULT_PAYMENT_METHOD_WHITELIST_ID), address(this));
        _renounceOwnershipOfPaymentMethodWhitelist(address(this), DEFAULT_PAYMENT_METHOD_WHITELIST_ID, EMPTY_SELECTOR);
        assertEq(collectionSettingsRegistry.paymentMethodWhitelistOwners(DEFAULT_PAYMENT_METHOD_WHITELIST_ID), address(0));
    }

    function testReassignOwnershipOfPaymentMethodWhitelist(address listCreator, address newOwner) public {
        _sanitizeAddress(listCreator, new address[](0));
        _sanitizeAddress(newOwner, new address[](0));
        vm.assume(listCreator != newOwner);

        vm.startPrank(listCreator);
        uint32 listId = collectionSettingsRegistry.createPaymentMethodWhitelist("");
        vm.stopPrank();

        assertEq(collectionSettingsRegistry.paymentMethodWhitelistOwners(listId), listCreator);
        _reassignOwnershipOfPaymentMethodWhitelist(listCreator, listId, newOwner, EMPTY_SELECTOR);
        assertEq(collectionSettingsRegistry.paymentMethodWhitelistOwners(listId), newOwner);
    }

    function testRenounceOwnershipOfPaymentMethodWhitelist(address listCreator) public {
        _sanitizeAddress(listCreator, new address[](0));
        vm.startPrank(listCreator);
        uint32 listId = collectionSettingsRegistry.createPaymentMethodWhitelist("");
        vm.stopPrank();

        assertEq(collectionSettingsRegistry.paymentMethodWhitelistOwners(listId), listCreator);
        _renounceOwnershipOfPaymentMethodWhitelist(listCreator, listId, EMPTY_SELECTOR);
        assertEq(collectionSettingsRegistry.paymentMethodWhitelistOwners(listId), address(0));
    }

    function testRevertsWhenUnauthorizedUserReassignsOwnershipOfPaymentMethodWhitelist(address listCreator, address unauthorized, address newOwner) public {
        _sanitizeAddress(listCreator, new address[](0));
        _sanitizeAddress(newOwner, new address[](0));
        _sanitizeAddress(unauthorized, new address[](0));
        vm.assume(listCreator != newOwner);
        vm.assume(listCreator != unauthorized);
        vm.assume(newOwner != unauthorized);

        vm.startPrank(listCreator);
        uint32 listId = collectionSettingsRegistry.createPaymentMethodWhitelist("");
        vm.stopPrank();

        _reassignOwnershipOfPaymentMethodWhitelist(unauthorized, listId, newOwner, CollectionSettingsRegistry__CallerDoesNotOwnPaymentMethodWhitelist.selector);
    }

    function testRevertsWhenListOwnerReassignsOwnershipOfPaymentMethodWhitelistToZeroAddress(address listCreator) public {
        _sanitizeAddress(listCreator, new address[](0));

        vm.startPrank(listCreator);
        uint32 listId = collectionSettingsRegistry.createPaymentMethodWhitelist("");
        vm.stopPrank();

        _reassignOwnershipOfPaymentMethodWhitelist(listCreator, listId, address(0), CollectionSettingsRegistry__PaymentMethodWhitelistOwnershipCannotBeTransferredToZeroAddress.selector);
    }

    function testRevertsWhenUnauthorizedUserRenouncesOwnershipOfPaymentMethodWhitelist(address listCreator, address unauthorized) public {
        _sanitizeAddress(listCreator, new address[](0));
        _sanitizeAddress(unauthorized, new address[](0));
        vm.assume(listCreator != unauthorized);

        vm.startPrank(listCreator);
        uint32 listId = collectionSettingsRegistry.createPaymentMethodWhitelist("");
        vm.stopPrank();

        _renounceOwnershipOfPaymentMethodWhitelist(unauthorized, listId, CollectionSettingsRegistry__CallerDoesNotOwnPaymentMethodWhitelist.selector);
    }
}