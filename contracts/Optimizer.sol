// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;


library Optimizer{
    error InvalidOffset();
    error InvalidSize();
    function storeNumber(uint256 store, uint256 value, uint8 offset, uint8 size) internal pure returns(uint256) {
        // if(offset > 0xff) {
        //     revert InvalidOffset();
        // }
        // if(size>0xff || size==0) {
        //     revert InvalidSize();
        // }
        assembly{
            store := or(and(store, not(shl(offset, sub(shl(size, 1), 1)))), shl(offset, value))
        }
        return store;

        // value <<= offset;
        // store &= ( ~(((1 << size) - 1) << offset) );
        // return store |= value;
    }

    function restoreNumber(uint256 store, uint8 offset, uint8 size) internal pure returns(uint256) {
        // if(offset > 0xff) {
        //     revert InvalidOffset();
        // }
        // if(offset > 0xff || size == 0) {
        //     revert InvalidSize();
        // }
        assembly{
            store := and(sub(shl(size, 1), 1), shr(offset, store))
        }
        return store;
        // store>>=offset;
        // return store &= ((1 << size) - 1);
    }
}

contract OptimizerTest {
    using Optimizer for uint256;
    
    uint256 _store = 93;

    function store(uint256 value, uint8 offset, uint8 size) external {
        uint256 tmp = value;
        // _store.restoreNumber(offset, size);
        _store.storeNumber(value, offset, size);
        // _store = _store.storeNumber(value, offset, size);
        _store = tmp;
    }

    function restore(uint8 offset, uint8 size) external view returns(uint256) {
        uint tmp = _store;
        // return tmp.restoreNumber(offset, size);
    }
}
