// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0

// This is the most efficient for gas reduction
pragma solidity ^0.8.12;

import "./libs/FOptimizer.sol";

library Converter{
    using Optimizer for uint256;
    uint8 constant coefficientMaxSize = 0x20;
    uint8 constant exponentMaxSize  = 0x08;

    function mostSignificantBit(uint256 number_) private pure returns (uint8 lastBit_) {
        if (number_ > 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) {
            number_ >>= 128;
            lastBit_ += 128;
        }
        if (number_ > 0xFFFFFFFFFFFFFFFF) {
            number_ >>= 64;
            lastBit_ += 64;
        }
        if (number_ > 0xFFFFFFFF) {
            number_ >>= 32;
            lastBit_ += 32;
        }
        if (number_ > 0xFFFF) {
            number_ >>= 16;
            lastBit_ += 16;
        }
        if (number_ > 0xFF) {
            number_ >>= 8;
            lastBit_ += 8;
        }
        if (number_ > 0xF) {
            number_ >>= 4;
            lastBit_ += 4;
        }
        if (number_ > 0x3) {
            number_ >>= 2;
            lastBit_ += 2;
        }
        if (number_ > 0x1) ++lastBit_;
        if (number_ > 0x0) ++lastBit_;
    }

    function N2B(uint256 normal) internal pure returns(uint256 coefficient, uint256 exponent, uint256 bigNumber) {
        uint8 len = mostSignificantBit(normal);
        assembly{
            if lt(len, coefficientMaxSize) {  // for throw exception
                len := coefficientMaxSize
            }
            exponent := sub(len, coefficientMaxSize)
            coefficient := shr(exponent, normal)
        }
        bigNumber = bigNumber.storeNumber(exponent, 0, exponentMaxSize);
        bigNumber = bigNumber.storeNumber(coefficient, 7, coefficientMaxSize);
    }

    function N2BWithMostSignificantBitUsingAssembly(uint256 normal) internal pure returns(uint256 coefficient, uint256 exponent, uint256 bigNumber) {
        assembly{
            function mostSignificantBitUsingAssembly(number_) -> lastBit_ {
                if gt(number_, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) {
                    number_ := shr(0x80, number_)
                    lastBit_ := add(lastBit_, 0x80)
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
            }
            let len :=  mostSignificantBitUsingAssembly(normal)
            if lt(len, coefficientMaxSize) {  // for throw exception
                len := coefficientMaxSize
            }
            exponent := sub(len, coefficientMaxSize)
            coefficient := shr(exponent, normal)
        }
        bigNumber = bigNumber.storeNumber(exponent, 0, exponentMaxSize);
        bigNumber = bigNumber.storeNumber(coefficient, 7, coefficientMaxSize);
    }

    function B2N(uint256 coefficient, uint256 exponent) internal pure returns(uint256 _number) {
        assembly{
            _number := shl(exponent, coefficient)
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

    function NumberToBigNumAsm(uint256 nomal) external view returns (uint256, uint, uint, uint) {
        uint256 initialGas = gasleft();
        (uint256 coefficient, uint256 exponent, uint256 bigNumber ) = nomal.N2BWithMostSignificantBitUsingAssembly();
        uint256 gasUsed = initialGas - gasleft();
        return (gasUsed, coefficient, exponent, bigNumber);
    }

    function BigNumToNum(uint256 coefficient, uint256 exponent) external view returns(uint256, uint) {
        uint256 initialGas = gasleft();
        uint num = Converter.B2N(coefficient, exponent);
        return (initialGas - gasleft(), num);
    }
}
