// SPDX-License-Identifier: MIT OR Apache-2.0

// This is the most efficient for gas reduction
pragma solidity ^0.8.12;

library ConverterNormal{
    uint8 constant coefficientMaxSize = 0x20;
    uint8 constant exponentMaxSize  = 0x08;
    uint256 internal constant EXPONENTMASK = 0xff;

    error InvalidLen();

    /**
    *   
    **/
    function N2B(uint256 normal) internal pure returns(uint256 coefficient, uint256 exponent, uint256 bigNumber) {
        uint8 len = mostSignificantBit(normal);
        if(len < 32) {
           len = 32;
        }
        exponent = len - coefficientMaxSize;
        coefficient = normal >> exponent;
        bigNumber = (coefficient << exponentMaxSize) + exponent;
    }

    function B2N(uint256 coefficient, uint256 exponent) internal pure returns(uint256 _number) {
        _number = coefficient << exponent;
    }

    function mulDivNormal(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2 ) internal pure returns(uint256 res) {
        uint256 coefficient1 = _bigNumber1 >> exponentMaxSize;
        uint exponent1 = EXPONENTMASK & _bigNumber1;
        uint256 coefficient2 = _bigNumber2 >> exponentMaxSize;
        uint256 exponent2 = EXPONENTMASK & _bigNumber2;
        if(exponent1 > exponent2) {
            coefficient1 = coefficient1 << (exponent1 - exponent2);
        } else {
            coefficient2 = coefficient2 << (exponent2 - exponent1);
        }
        res = _number * coefficient1 / coefficient2;
    }

    function decompileBigNumber(uint256 bigNumber) internal pure returns(uint256 coefficient, uint256 exponent) {
        coefficient = bigNumber >> exponentMaxSize;
        exponent = EXPONENTMASK & bigNumber;
    }

    function mostSignificantBit(uint256 number_) internal pure returns (uint8 lastBit_) {
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

    function mulDivBignumber (uint256 bigNumber, uint256 number1, uint256 number2) internal pure returns(uint256 result) {
        unchecked{
            uint256 resultNumerator = (bigNumber >> exponentMaxSize) * number1;
            uint256 exponent1 = bigNumber & EXPONENTMASK;

            if (resultNumerator < number2) {
                uint256 diffMsb = mostSignificantBit(number2 / resultNumerator);
                if (diffMsb > exponent1) return 0;
                exponent1 = exponent1 - diffMsb;
                number2 = number2 >> diffMsb;
            }
            (, , result) = N2B(resultNumerator / number2);
            result = result + exponent1;
        }
    }
}
