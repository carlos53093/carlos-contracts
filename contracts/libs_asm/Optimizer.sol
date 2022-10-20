// SPDX-License-Identifier: MIT OR Apache-2.0

// This is the most efficient for gas reduction

pragma solidity ^0.8.12;


library Optimizer{
    error InvalidOffset();
    error InvalidSize();

    /***
        storeNumber function
        @formula
        store (256bits) = XXXX..... .... ... ....0110 1011 0010 1011 .... XXXX
        offset            ^ ---- 24(offset) --- ^
        size                                     ^ ---12(size) ----^
        value                                    ^--27435(value)-- ^

        @return 
        res = XXXX..... .... ... ....0110 1011 0010 1011 .... XXXX
    ***/
    function storeNumber(uint256 store, uint256 value, uint8 offset, uint8 size) internal pure returns(uint256) {
        assembly{
            store := or(and(store, not(shl(offset, sub(shl(size, 1), 1)))), shl(offset, value))
        }
        return store;
    }

    /***
        storeNumber function
        @formula
        store (256bits) = XXXX..... .... ... ....0110 1011 0010 1011 .... XXXX
        offset            ^ ---- 24(offset) --- ^
        size                                     ^ ---12(size) ----^

        @return
        value  0110 1011 0010 1011 (decimal format 27435)
    ***/
    function restoreNumber(uint256 store, uint8 offset, uint8 size) internal pure returns(uint256) {
        assembly{
            store := and(shr(offset, store), sub(shl(size, 1), 1))
        }
        return store;
    }
}
