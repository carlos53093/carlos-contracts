// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0

// This is the most efficient for gas reduction
pragma solidity ^0.8.12;

import "./FOptimizer.sol";

library Converter{
    using Optimizer for uint256;
    uint8 constant coefficientMaxSize = 0x20;
    uint8 constant exponentMaxSize  = 0x08;
    uint256 internal constant EXPONENTMASK = 0xff;

    function N2B(uint256 normal) internal pure returns(uint256 coefficient, uint256 exponent, uint256 bigNumber) {
        assembly{
            let lastBit_
            let number_ := normal
            if gt(normal, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) {
                number_ := shr(0x80, number_)
                lastBit_ := 0x80
            }
            if gt(number_, 0xFFFFFFFFFFFFFFFF) {
                number_ := shr(0x40, number_)
                lastBit_ := add(lastBit_, 0x40)
            }
            if gt(number_, 0xFFFFFFFF) {
                number_ := shr(0x20, number_)
                lastBit_ := add(lastBit_, 0x20)
            }
            if gt(number_, 0xFFFF) {
                number_ := shr(0x10, number_)
                lastBit_ := add(lastBit_, 0x10)
            }
            if gt(number_, 0xFF) {
                number_ := shr(0x8, number_)
                lastBit_ := add(lastBit_, 0x8)
            }
            if gt(number_, 0xF) {
                number_ := shr(0x4, number_)
                lastBit_ := add(lastBit_, 0x4)
            }
            if gt(number_, 0x3) {
                number_ := shr(0x2, number_)
                lastBit_ := add(lastBit_, 0x2)
            }
            if gt(number_, 0x1) {
                lastBit_ := add(lastBit_, 1)
            }
            if gt(number_, 0) {
                lastBit_ := add(lastBit_, 1)
            }
            if lt(lastBit_, coefficientMaxSize) {  // for throw exception
                lastBit_ := coefficientMaxSize
            }
            exponent := sub(lastBit_, coefficientMaxSize)
            coefficient := shr(exponent, normal)
            bigNumber := shl(exponentMaxSize, coefficient)
            bigNumber := add(bigNumber, exponent)
        }
    }

    function B2N(uint256 coefficient, uint256 exponent) internal pure returns(uint256 _number) {
        assembly{
            _number := shl(exponent, coefficient)
        }
    }

    function mulDivNormal(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2 ) internal pure returns(uint256 res) {
        assembly {
            let coefficient1 := shr(exponentMaxSize, _bigNumber1)
            let exponent1 := and(_bigNumber1, EXPONENTMASK)
            let coefficient2 := shr(exponentMaxSize, _bigNumber2)
            let exponent2 := and(_bigNumber2, EXPONENTMASK)
            let X := gt(exponent1, exponent2)
            if X {
                coefficient1 := shl(sub(exponent1, exponent2),coefficient1)
            }
            if iszero(X) {
                coefficient2 := shl(sub(exponent2, exponent1),coefficient2)
            }
            res := div(mul(_number, coefficient1), coefficient2)
        }
    }

    function decompileBigNumber(uint256 bigNumber) internal pure returns(uint256 coefficient, uint256 exponent) {
        assembly {
            coefficient := shr(exponentMaxSize, bigNumber)
            exponent := and(bigNumber, EXPONENTMASK)
        }
    }
}

contract ConverterTest {
    using Converter for uint256;
    
    function NumberToBigNum(uint256 nomal) external view returns (uint256, uint, uint, uint) {
        uint256 initialGas = gasleft();
        (uint256 coefficient, uint256 exponent, uint256 bigNumber ) = nomal.N2B();
        uint256 gasUsed = initialGas - gasleft();
        return (gasUsed, coefficient, exponent, bigNumber);
    }

    function BigNumToNum(uint256 coefficient, uint256 exponent) external view returns(uint256, uint) {
        uint256 initialGas = gasleft();
        uint num = Converter.B2N(coefficient, exponent);
        return (initialGas - gasleft(), num);
    }

    function mulDivNormal(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2) external view returns(uint256 res, uint gasUsed) {
        uint256 initialGas = gasleft();
        res = _number.mulDivNormal(_bigNumber1, _bigNumber2);
        gasUsed = initialGas - gasleft();
    }

    function decompileBigNumber(uint256 bigNumber) external view returns(uint256 coefficient, uint256 exponent, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        (coefficient, exponent) = bigNumber.decompileBigNumber();
        gasUsed = initialGas - gasleft();
    }
}
