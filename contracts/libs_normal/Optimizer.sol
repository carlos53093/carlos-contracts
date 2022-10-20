// SPDX-License-Identifier: MIT OR Apache-2.0

// This is the most efficient for gas reduction

pragma solidity ^0.8.12;


library OptimizerNormal{
    error InvalidOffset();
    error InvalidSize();
    function storeNumber(uint256 store, uint256 value, uint8 offset, uint8 size) internal pure returns(uint256) {
        if(offset>=256) {
            revert InvalidOffset();
        }
        if(size>=256 || size==0) {
            revert InvalidSize();
        }
        value <<= offset;
        store &= ( ~(((1 << size) - 1) << offset) );
        return store |= value;
    }

    function restoreNumber(uint256 store, uint8 offset, uint8 size) internal pure returns(uint256) {
        if(offset>=256) {
            revert InvalidOffset();
        }
        if(size>=256 || size==0) {
            revert InvalidSize();
        }
        store>>=offset;
        return store &= ((1 << size) - 1);
    }
}
