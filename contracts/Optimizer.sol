// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;

contract Optimizer {
    uint256 store;

    function storeNumber(uint256 value, uint256 offset) external {
        require(offset<256, "Invalid offset");
        value <<= offset;
        store = store | value;
    }

    function restoreNumber(uint256 offset, uint256 size) external view returns(uint256) {
        require(offset<256, "Invalid offset");
        require(size<256, "Invalid size");
        uint tmp = store;
        tmp>>=offset;
        tmp = tmp & (2 ** size - 1);
        return tmp;
    }

}
