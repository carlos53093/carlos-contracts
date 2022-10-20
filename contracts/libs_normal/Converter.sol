// SPDX-License-Identifier: MIT OR Apache-2.0

// This is the most efficient for gas reduction
pragma solidity ^0.8.12;

library ConverterNormal{
    uint8 constant COEFFICIENTMAXSIZE = 0x20;
    uint8 constant EXPONENTMAXSIZE  = 0x08;
    uint256 internal constant EXPONENTMASK = 0xff;

    error InvalidLen();

    /**
    *   
    **/
    function toBigNumber(uint256 normal) internal pure returns(uint256 coefficient, uint256 exponent, uint256 bigNumber) {
        uint8 len_ = mostSignificantBit(normal);
        if(len_ < 32) {
           len_ = 32;
        }
        exponent = len_ - COEFFICIENTMAXSIZE;
        coefficient = normal >> exponent;
        bigNumber = (coefficient << EXPONENTMAXSIZE) + exponent;
    }

    function fromBigNumber(uint256 coefficient, uint256 exponent) internal pure returns(uint256 number) {
        number = coefficient << exponent;
    }

    function mulDivNormal(uint256 number, uint256 bigNumber1, uint256 bigNumber2 ) internal pure returns(uint256 res) {
        uint256 coefficient1 = bigNumber1 >> EXPONENTMAXSIZE;
        uint exponent1 = EXPONENTMASK & bigNumber1;
        uint256 coefficient2 = bigNumber2 >> EXPONENTMAXSIZE;
        uint256 exponent2 = EXPONENTMASK & bigNumber2;
        if(exponent1 > exponent2) {
            coefficient1 = coefficient1 << (exponent1 - exponent2);
        } else {
            coefficient2 = coefficient2 << (exponent2 - exponent1);
        }
        res = number * coefficient1 / coefficient2;
    }

    function decompileBigNumber(uint256 bigNumber) internal pure returns(uint256 coefficient, uint256 exponent) {
        coefficient = bigNumber >> EXPONENTMAXSIZE;
        exponent = EXPONENTMASK & bigNumber;
    }

    function mostSignificantBit(uint256 number) internal pure returns (uint8 lastBit) {
        if (number > 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) {
            number >>= 128;
            lastBit += 128;
        }
        if (number > 0xFFFFFFFFFFFFFFFF) {
            number >>= 64;
            lastBit += 64;
        }
        if (number > 0xFFFFFFFF) {
            number >>= 32;
            lastBit += 32;
        }
        if (number > 0xFFFF) {
            number >>= 16;
            lastBit += 16;
        }
        if (number > 0xFF) {
            number >>= 8;
            lastBit += 8;
        }
        if (number > 0xF) {
            number >>= 4;
            lastBit += 4;
        }
        if (number > 0x3) {
            number >>= 2;
            lastBit += 2;
        }
        if (number > 0x1) ++lastBit;
        if (number > 0x0) ++lastBit;
    }

    function mulDivBignumber (uint256 bigNumber, uint256 number1, uint256 number2) internal pure returns(uint256 result) {
        unchecked{
            uint256 resultNumerator = (bigNumber >> EXPONENTMAXSIZE) * number1;
            uint256 exponent1 = bigNumber & EXPONENTMASK;

            if (resultNumerator < number2) {
                uint256 diffMsb = mostSignificantBit(number2 / resultNumerator);
                if (diffMsb > exponent1) return 0;
                exponent1 = exponent1 - diffMsb;
                number2 = number2 >> diffMsb;
            }
            (, , result) = toBigNumber(resultNumerator / number2);
            result = result + exponent1;
        }
    }
}
