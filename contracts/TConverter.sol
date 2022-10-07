// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0

// This is the most efficient for gas reduction
pragma solidity ^0.8.12;

import "./libs/Optimizer.sol";
import "hardhat/console.sol";

library Converter{
    using Optimizer for uint256;
    uint8 constant coefficientMaxSize = 0x20;
    uint8 constant exponentMaxSize  = 0x08;
    uint256 internal constant EXPONENTMASK = 0xff;

    function mostSignificantBit(uint256 normal) private pure returns (uint8 lastBit_) {
        assembly{
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
        }
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
        bigNumber = bigNumber.storeNumber(coefficient, exponentMaxSize, coefficientMaxSize);
    }

    function N2BWithMostSignificantBitUsingAssembly(uint256 normal) internal pure returns(uint256 coefficient, uint256 exponent, uint256 bigNumber) {
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
        }
        bigNumber = bigNumber.storeNumber(exponent, 0, exponentMaxSize);
        bigNumber = bigNumber.storeNumber(coefficient, exponentMaxSize, coefficientMaxSize);
    }

    function N2BWithMostSignificantBitUsingAssemblyTwo(uint256 normal) internal pure returns(uint256 coefficient, uint256 exponent, uint256 bigNumber) {
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
            //  bigNumber := or(and(bigNumber, not(shl(0, sub(shl(40, 1), 1)))), shl(0, tmp))
            // bigNumber := or(and(bigNumber, not(sub(shl(40, 1), 1))), tmp)                // same gas fee as above
        }
        // uint256 tmp = coefficient << exponentMaxSize;
        // tmp = tmp + exponent;
        // bigNumber = bigNumber.storeNumber(tmp, 0, 40);
        // bigNumber = bigNumber.storeNumber(coefficient, exponentMaxSize, coefficientMaxSize);
    }

    function B2N(uint256 coefficient, uint256 exponent) internal pure returns(uint256 _number) {
        assembly{
            _number := shl(exponent, coefficient)
        }
    }

    function mulDivNormal(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2 ) internal pure returns(uint256 res) {
        (uint256 coefficient1, uint256 exponent1,) = N2BWithMostSignificantBitUsingAssemblyTwo(_bigNumber1);
        (uint256 coefficient2, uint256 exponent2,) = N2BWithMostSignificantBitUsingAssemblyTwo(_bigNumber2);
        if (exponent1 > exponent2) {
            coefficient1 <<= (exponent1 - exponent2);
        } else {
            coefficient2 <<= (exponent2 - exponent1);
        }
        return _number * coefficient1 / coefficient2;
    }

    function mulDivNormal2(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2 ) internal pure returns(uint256 res) {
        (uint256 coefficient1, uint256 exponent1) = decompileBigNumber(_bigNumber1);
        (uint256 coefficient2, uint256 exponent2) = decompileBigNumber(_bigNumber2);
        if (exponent1 > exponent2) {
            coefficient1 <<= (exponent1 - exponent2);
        } else {
            coefficient2 <<= (exponent2 - exponent1);
        }
        return _number * coefficient1 / coefficient2;
    }

    function mulDivNormal3(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2 ) internal pure returns(uint256 res) {
        (uint256 coefficient1, uint256 exponent1) = decompileBigNumber(_bigNumber1);
        (uint256 coefficient2, uint256 exponent2) = decompileBigNumber(_bigNumber2);
        assembly {
            if gt(exponent1, exponent2) {
                coefficient1 := shl(sub(exponent1, exponent2),coefficient1)
            }
            if or(lt(exponent1, exponent2), eq(exponent1, exponent2)) {
                coefficient2 := shl(sub(exponent2, exponent1),coefficient2)
            }
            res := div(mul(_number, coefficient1), coefficient2)
        }
    }

    function mulDivNormal4(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2 ) internal pure returns(uint256 res) {
        // (uint256 coefficient1, uint256 exponent1) = decompileBigNumber(_bigNumber1);
        // (uint256 coefficient2, uint256 exponent2) = decompileBigNumber(_bigNumber2);
        assembly {
            function decompileBigNumber(bigNumber) -> coefficient, exponent {
                coefficient := shr(exponentMaxSize, bigNumber)
                exponent := and(bigNumber, sub(shl(exponentMaxSize, 1),1))
            }
            let coefficient1, exponent1 := decompileBigNumber(_bigNumber1)
            let coefficient2, exponent2 := decompileBigNumber(_bigNumber2)
            if gt(exponent1, exponent2) {
                coefficient1 := shl(sub(exponent1, exponent2),coefficient1)
            }
            if or(lt(exponent1, exponent2), eq(exponent1, exponent2)) {
                coefficient2 := shl(sub(exponent2, exponent1),coefficient2)
            }
            res := div(mul(_number, coefficient1), coefficient2)
        }
    }

    function mulDivNormal5(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2 ) internal pure returns(uint256 res) {
        // (uint256 coefficient1, uint256 exponent1) = decompileBigNumber(_bigNumber1);
        // (uint256 coefficient2, uint256 exponent2) = decompileBigNumber(_bigNumber2);
        assembly {
            let coefficient1 := shr(exponentMaxSize, _bigNumber1)
            let exponent1 := and(_bigNumber1, sub(shl(exponentMaxSize, 1),1))
            let coefficient2 := shr(exponentMaxSize, _bigNumber2)
            let exponent2 := and(_bigNumber2, sub(shl(exponentMaxSize, 1),1))
            if gt(exponent1, exponent2) {
                coefficient1 := shl(sub(exponent1, exponent2),coefficient1)
            }
            if or(lt(exponent1, exponent2), eq(exponent1, exponent2)) {
                coefficient2 := shl(sub(exponent2, exponent1),coefficient2)
            }
            res := div(mul(_number, coefficient1), coefficient2)
        }
    }

    function mulDivNormal6NonCommonMask(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2 ) internal pure returns(uint256 res) {
        assembly {
            let coefficient1 := shr(exponentMaxSize, _bigNumber1)
            let exponent1 := and(sub(shl(exponentMaxSize, 1),1), _bigNumber1)
            let coefficient2 := shr(exponentMaxSize, _bigNumber2)
            let exponent2 := and(sub(shl(exponentMaxSize, 1),1), _bigNumber2)
            if gt(exponent1, exponent2) {
                coefficient1 := shl(sub(exponent1, exponent2),coefficient1)
            }
            if or(lt(exponent1, exponent2), eq(exponent1, exponent2)) {
                coefficient2 := shl(sub(exponent2, exponent1),coefficient2)
            }
            res := div(mul(_number, coefficient1), coefficient2)
        }
    }

    function mulDivNormal6UsingCommonMask(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2 ) internal pure returns(uint256 res) {
        assembly {
            let coefficient1 := shr(exponentMaxSize, _bigNumber1)
            // let commonMask := sub(shl(exponentMaxSize, 1),1)
            let exponent1 := and(EXPONENTMASK, _bigNumber1)
            let coefficient2 := shr(exponentMaxSize, _bigNumber2)
            let exponent2 := and(EXPONENTMASK, _bigNumber2)
            if gt(exponent1, exponent2) {
                coefficient1 := shl(sub(exponent1, exponent2),coefficient1)
            }
            if or(lt(exponent1, exponent2), eq(exponent1, exponent2)) {
                coefficient2 := shl(sub(exponent2, exponent1),coefficient2)
            }
            res := div(mul(_number, coefficient1), coefficient2)
        }
    }

    function mulDivNormal7(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2 ) internal pure returns(uint256 res) {
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

    function mulDivBignumber (uint256 bigNumber, uint256 number1, uint256 number2) internal pure returns(uint256 result) {
        (uint256 coefficient1, uint256 exponent1) = decompileBigNumber(bigNumber);
        (uint coefficient2, uint256 exponent2,) = N2BWithMostSignificantBitUsingAssemblyTwo(number1);
        (uint coefficient3, uint256 exponent3,) = N2BWithMostSignificantBitUsingAssemblyTwo(number2);

        uint256 resultCoefficient = coefficient1 * coefficient2;
        uint256 resultExponent = exponent1 + exponent2;
        if(resultCoefficient < coefficient3) {
 
            if(resultExponent < 32) return 0;
            resultExponent -= 32;
            resultCoefficient = resultCoefficient << 32;
        }
         if(resultExponent < exponent3) return 0;
        resultCoefficient  = resultCoefficient / coefficient3;
        resultExponent -= exponent3;
        uint len2 = mostSignificantBit(resultCoefficient);
        if(len2 > 32) {
            resultCoefficient = resultCoefficient >> (len2 - 32);
            resultExponent += (len2 - 32);
        }
        return (resultCoefficient<<8) + resultExponent;
    }
}

contract TConverter {
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

    function NumberToBigNumAsm2(uint256 nomal) external view returns (uint256, uint, uint, uint) {
        uint256 initialGas = gasleft();
        (uint256 coefficient, uint256 exponent, uint256 bigNumber ) = nomal.N2BWithMostSignificantBitUsingAssemblyTwo();
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

    function mulDivNormal2(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2) external view returns(uint256 res, uint gasUsed) {
        uint256 initialGas = gasleft();
        res = _number.mulDivNormal2(_bigNumber1, _bigNumber2);
        gasUsed = initialGas - gasleft();
    }

    function mulDivNormal3(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2) external view returns(uint256 res, uint gasUsed) {
        uint256 initialGas = gasleft();
        res = _number.mulDivNormal3(_bigNumber1, _bigNumber2);
        gasUsed = initialGas - gasleft();
    }

    function mulDivNormal4(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2) external view returns(uint256 res, uint gasUsed) {
        uint256 initialGas = gasleft();
        res = _number.mulDivNormal4(_bigNumber1, _bigNumber2);
        gasUsed = initialGas - gasleft();
    }

    function mulDivNormal5(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2) external view returns(uint256 res, uint gasUsed) {
        uint256 initialGas = gasleft();
        res = _number.mulDivNormal5(_bigNumber1, _bigNumber2);
        gasUsed = initialGas - gasleft();
    }

    function mulDivNormal6(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2) external view returns(uint256 res, uint gasUsed) {
        uint256 initialGas = gasleft();
        res = _number.mulDivNormal6UsingCommonMask(_bigNumber1, _bigNumber2);
        gasUsed = initialGas - gasleft();
    }

    function mulDivNormal7(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2) external view returns(uint256 res, uint gasUsed) {
        uint256 initialGas = gasleft();
        res = _number.mulDivNormal7(_bigNumber1, _bigNumber2);
        gasUsed = initialGas - gasleft();
    }

    function decompileBigNumber(uint256 bigNumber) external view returns(uint256 coefficient, uint256 exponent, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        (coefficient, exponent) = bigNumber.decompileBigNumber();
        gasUsed = initialGas - gasleft();
    }

    function mulDivBignumber (uint256 bigNumber, uint256 number1, uint256 number2) external view returns (uint res, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        res = bigNumber.mulDivBignumber(number1, number2);
        gasUsed = initialGas - gasleft();
    }
}
