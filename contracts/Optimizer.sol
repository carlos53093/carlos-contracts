// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;

import "hardhat/console.sol";

library Optimizer{
    error InvalidOffset();
    error InvalidSize();
    function storeNumber(uint256 store, uint256 value, uint256 offset, uint256 size) internal pure returns(uint256) {
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
        // if(offset>=256) {
        //     revert InvalidOffset();
        // }
        // if(size>=256 || size==0) {
        //     revert InvalidSize();
        // }
        // value <<= offset;
        // store &= ( ~(((1 << size) - 1) << offset) );
        // return store |= value;
    }

    function restoreNumber(uint256 store, uint256 offset, uint256 size) internal pure returns(uint256) {
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
        // if(offset>=256) {
        //     revert InvalidOffset();
        // }
        // if(size>=256 || size==0) {
        //     revert InvalidSize();
        // }
        // store>>=offset;
        // return store &= ((1 << size) - 1);
    }

    function mulDivNormal(uint256 _number, uint256 bigNumber1, uint256 bigNumber2 ) internal pure returns(uint256 res) {
        assembly{
            res := mul(_number, bigNumber1)
            res := div(res, bigNumber2)
        }
    }
}

contract OptimizerTest {
    
    uint256 public _store;

    function store(uint256 value, uint8 offset, uint8 size) external view returns(uint256) {
        uint256 store_ = _store;
        uint256 initialGas = gasleft();
        store_ = Optimizer.storeNumber(store_, value, offset, size);
        uint256 gasUsed = initialGas - gasleft();
        return gasUsed;
    }

    function mulDivNormal(uint256 _number, uint256 bigNumber1, uint256 bigNumber2) external view returns(uint256 gasfee, uint256 res) {
        uint256 initialGas = gasleft();
        res = Optimizer.mulDivNormal(_number, bigNumber1, bigNumber2);
        gasfee = initialGas - gasleft();
        // return gasfee;
    }

    function restore(uint8 offset, uint8 size) external view returns(uint256) {
        uint256 store_ = _store;
        uint256 initialGas = gasleft();
        store_ =  Optimizer.restoreNumber(store_, offset, size);
        uint256 gasUsed = initialGas - gasleft();
        return gasUsed;
    }
}
