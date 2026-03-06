//SPDX-License-Identifier: LicenseRef-PolyForm-Strict-1.0.0
pragma solidity 0.8.24;

import "../DataTypes.sol";

/** 
* @title PaymentProcessorStorageAccess
* @custom:version 3.0.0
* @author Limit Break, Inc.
*/ 
contract PaymentProcessorStorageAccess {

    /// @dev The base storage slot for Payment Processor contract storage items.
    bytes32 constant DIAMOND_STORAGE_PAYMENT_PROCESSOR = 
        0x0000000000000000000000000000000000000000000000000000000000009A1D;

    /**
     * @dev Returns a storage object that follows the Diamond standard storage pattern for
     * @dev contract storage across multiple module contracts.
     */
    function appStorage() internal pure returns (PaymentProcessorStorage storage diamondStorage) {
        bytes32 slot = DIAMOND_STORAGE_PAYMENT_PROCESSOR;
        assembly {
            diamondStorage.slot := slot
        }
    }
}