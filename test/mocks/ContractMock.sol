// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.24;

contract ContractMock {
    constructor() {}

    fallback() external payable {}
    receive() external payable {}

    function onERC1155Received(address, address, uint256, uint256, bytes calldata)
        external
        virtual
        returns (bytes4)
    {
        return ContractMock.onERC1155Received.selector;
    }
}