// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;


library Optimizer{
    error InvalidOffset();
    error InvalidSize();
    function storeNumber(uint256 store, uint256 value, uint8 offset, uint8 size) internal pure returns(uint256) {
        assembly{
            // if slt(0xff, offset) { 
            //     revert (0,0) 
            // }
            // if and(slt(0xff, size), eq(size, 0)) { 
            //     revert (0,0)
            // }
            store := or(and(store, not(shl(offset, sub(shl(size, 1), 1)))), shl(offset, value))
            // mstore(0x0, store)
            // return(0x0, 32)
        }
        return store;
    }

    function restoreNumber(uint256 store, uint8 offset, uint8 size) internal pure returns(uint256) {
        assembly{
            // if slt(0xff, offset) { 
            //     revert (0,0) 
            // }
            // if and(slt(0xff, size), eq(size, 0)) { 
            //     revert (0,0)
            // }
            store := and(shr(offset, store), sub(shl(size, 1), 1))
            // mstore(0x0, store)
            // return(0x0, 32)
        }
        return store;
    }
}

contract OptimizerTest {
    using Optimizer for uint256;
    
    uint256 public _store;

    function store(uint256 value, uint8 offset, uint8 size) external {
        uint tmp = _store.storeNumber(value, offset, size);
        // uint tmp = _store.restoreNumber(offset, size);
        _store = value;
    }

    function restore(uint8 offset, uint8 size) external view returns(uint256) {
        uint tmp = _store;
        return tmp.restoreNumber(offset, size);
    }
}
