// SPDX-License-Identifier: MIT OR Apache-2.0

/// @title 

pragma solidity ^0.8.12;

/// @title library that represent a number in BigNumber(coefficient and exponent) format and store in uint40.
/// @notice uint40 is divided into two parts: uint32 for coefficient and uint8 for exponent

library Converter{
    uint8 constant COEFFICIENTMAXSIZE = 0x20;
    uint8 constant EXPONENTMAXSIZE = 0x08;
    uint256 internal constant EXPONENTMASK = 0xff;

    /***
        Normal number to BigNumber with exponent and coefficient
      * @format: 
      * 5035703444687813576399599 (normal) = (coefficient[32bits], exponent[8bits])[40bits]
      * 5035703444687813576399599 (decimal) => 10000101010010110100000011111011110010100110100000000011100101001101001101011101111 (binary)
      *                                     => 10000101010010110100000011111011000000000000000000000000000000000000000000000000000
      *                                                                        ^-------------------- 51(exponent) -------------- ^

      * coefficient = 1000,0101,0100,1011,0100,0000,1111,1011               (2236301563)
      * exponent =                                            0011,0011     (51)
      * bigNumber =   1000,0101,0100,1011,0100,0000,1111,1011,0011,0011     (572493200179)

      * params: normal => input value with decimal format
      * return:  coefficient, exponent, bigNumber
    ***/
    function toBigNumber(uint256 normal) internal pure returns(uint256 coefficient, uint256 exponent, uint256 bigNumber) {
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
            if lt(lastBit_, COEFFICIENTMAXSIZE) {  // for throw exception
                lastBit_ := COEFFICIENTMAXSIZE
            }
            exponent := sub(lastBit_, COEFFICIENTMAXSIZE)
            coefficient := shr(exponent, normal)
            bigNumber := shl(EXPONENTMAXSIZE, coefficient)
            bigNumber := add(bigNumber, exponent)
        }
    }

    /***
        fromBigNumber function
        get Normal number from coefficient and exponent
      * @format: 
      * (coefficient[32bits], exponent[8bits])[40bits] => (_number) 
      * (2236301563, 51) = 10000101010010110100000011111011000000000000000000000000000000000000000000000000000

      * coefficient = 1000,0101,0100,1011,0100,0000,1111,1011 (2236301563)
      * exponent =    0011,0011 (51)
      * _number =     10000101010010110100000011111011000000000000000000000000000000000000000000000000000  (5035703442907428892442624)
      *                                               ^-------------------- 51(exponent) -------------- ^
    ***/

    function fromBigNumber(uint256 coefficient, uint256 exponent) internal pure returns(uint256 _number) {
        assembly{
            _number := shl(exponent, coefficient)
        }
    }

    /***
        mulDivNormal function
        @formula
        res = _number * _bigNumber1 / _bigNumber2

        @Input format
        _number:  normal number format 281474976710656
        _bigNumber1: bigNumber format 265046402172 [(0011,1101,1011,0101,1111,1111,0010,0100)Coefficient, (0111,1100)Exponent]
        _bigNumber2: bigNumber format 178478830197 [(0010 1001 1000 1110 0010 1010 1101 0010)Coefficient, (0111 0101)Exponent]

        @return format 
        res: normal number 53503841411969141
    ***/
    function mulDivNormal(uint256 number1, uint256 bigNumber1, uint256 bigNumber2 ) internal pure returns(uint256 res) {
        assembly {
            let coefficient1_ := shr(EXPONENTMAXSIZE, bigNumber1)
            let exponent1_ := and(bigNumber1, EXPONENTMASK)
            let coefficient2_ := shr(EXPONENTMAXSIZE, bigNumber2)
            let exponent2_ := and(bigNumber2, EXPONENTMASK)
            let X := gt(exponent1_, exponent2_)   // bigNumber2 > bigNumber1
            if X {
                coefficient1_ := shl(sub(exponent1_, exponent2_),coefficient1_)
            }
            if iszero(X) {
                coefficient2_ := shl(sub(exponent2_, exponent1_),coefficient2_)
            }
            res := div(mul( number1, coefficient1_), coefficient2_)
        }
    }

    /***
        decompileBigNumber function
      * @format: 
      * _number[40bits] => coefficient[32bits], exponent[8bits]  
      * 1000,0101,0100,1011,0100,0000,1111,1011,0011,0011 => 1000,0101,0100,1011,0100,0000,1111,1011(Coe)      0011,0011(Exp)

      * coefficient = 1000,0101,0100,1011,0100,0000,1111,1011 (2236301563)
      * exponent =    0011,0011 (51)
    ***/
    function decompileBigNumber(uint256 bigNumber) internal pure returns(uint256 coefficient, uint256 exponent) {
        assembly {
            coefficient := shr(EXPONENTMAXSIZE, bigNumber)
            exponent := and(bigNumber, EXPONENTMASK)
        }
    }

    /***
        mostSignificantBit function
        get length of given Number of binary format

      * @format: 
      * 5035703444687813576399599 = 10000101010010110100000011111011110010100110100000000011100101001101001101011101111
      * lastBit =                  ^---------------------------------   83   ----------------------------------------^
    ***/
    function mostSignificantBit(uint256 normal) internal pure returns (uint8 lastBit) {
        assembly{
            let number_ := normal
            if gt(normal, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) {
                number_ := shr(0x80, number_)
                lastBit := 0x80
            }
            if gt(number_, 0xFFFFFFFFFFFFFFFF) {
                number_ := shr(0x40, number_)
                lastBit := add(lastBit, 0x40)
            }
            if gt(number_, 0xFFFFFFFF) {
                number_ := shr(0x20, number_)
                lastBit := add(lastBit, 0x20)
            }
            if gt(number_, 0xFFFF) {
                number_ := shr(0x10, number_)
                lastBit := add(lastBit, 0x10)
            }
            if gt(number_, 0xFF) {
                number_ := shr(0x8, number_)
                lastBit := add(lastBit, 0x8)
            }
            if gt(number_, 0xF) {
                number_ := shr(0x4, number_)
                lastBit := add(lastBit, 0x4)
            }
            if gt(number_, 0x3) {
                number_ := shr(0x2, number_)
                lastBit := add(lastBit, 0x2)
            }
            if gt(number_, 0x1) {
                lastBit := add(lastBit, 1)
            }
            if gt(number_, 0) {
                lastBit := add(lastBit, 1)
            }
        }
    }

    /***
        mulDivBignumber function
        @formula
        res = bigNumber * number1 / number2
        
        @Input format
        bigNumber: bigNumber format 86575854077 [(0001 0100 0010 1000 0101 0010 1011 0001)Coefficient, (1111 1101)Exponent]
        number1:   normal number format 8796093022208
        number2:   normal number format 5986310706507378352962293074805895248510699696029696

        @return format 
        res: bigNumber format 408 [(0000 0000 0000 0000 0000 0000 0000 0001)Coefficient, (1001 1000)Expoent]
    ***/

    function mulDivBignumber (uint256 bigNumber, uint256 number1, uint256 number2) internal pure returns(uint256 result) {
        unchecked{
            uint256 _resultNumerator;
            uint256 _exponent1;
            assembly{
                _exponent1 := and(bigNumber, EXPONENTMASK)
                _resultNumerator := mul(shr(EXPONENTMAXSIZE, bigNumber), number1)
            }

            if (_resultNumerator < number2) {
                uint256 diffMsb = mostSignificantBit(number2 / _resultNumerator);
                if (diffMsb > _exponent1) return 0;
                assembly{
                    _exponent1 := sub(_exponent1, diffMsb)
                    number2 := shr(diffMsb, number2)
                }
            }
            (, , result) = toBigNumber(_resultNumerator / number2);
            result = result + _exponent1;
        }
    }
}
