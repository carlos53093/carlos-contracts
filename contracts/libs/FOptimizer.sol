// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0

// This is the most efficient for gas reduction

pragma solidity ^0.8.12;


library Optimizer{
    error InvalidOffset();
    error InvalidSize();
    function storeNumber(uint256 store, uint256 value, uint8 offset, uint8 size) internal pure returns(uint256) {
        assembly{
            store := or(and(store, not(shl(offset, sub(shl(size, 1), 1)))), shl(offset, value))
        }
        return store;
    }

    function restoreNumber(uint256 store, uint8 offset, uint8 size) internal pure returns(uint256) {
        assembly{
            store := and(shr(offset, store), sub(shl(size, 1), 1))
        }
        return store;
    }
}

contract FOptimizerTest {
    
    uint256 public _store;

    function store(uint256 value, uint8 offset, uint8 size) external view returns(uint256) {
        uint256 store_ = _store;
        uint256 initialGas = gasleft();
        store_ = Optimizer.storeNumber(store_, value, offset, size);
        uint256 gasUsed = initialGas - gasleft();
        return gasUsed;
    }

    function restore(uint8 offset, uint8 size) external view returns(uint256) {
        uint256 store_ = _store;
        uint256 initialGas = gasleft();
        store_ =  Optimizer.restoreNumber(store_, offset, size);
        uint256 gasUsed = initialGas - gasleft();
        return gasUsed;
    }
}
