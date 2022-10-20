// SPDX-License-Identifier: MIT OR Apache-2.0

// This is the most efficient for gas reduction
pragma solidity ^0.8.12;

library Converter{
    uint8 constant coefficientMaxSize = 0x20;
    uint8 constant exponentMaxSize  = 0x08;
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

    /***
        B2N function
        get Normal number from coefficient and exponent
      * @format: 
      * (coefficient[32bits], exponent[8bits])[40bits] => (_number) 
      * (2236301563, 51) = 10000101010010110100000011111011000000000000000000000000000000000000000000000000000

      * coefficient = 1000,0101,0100,1011,0100,0000,1111,1011 (2236301563)
      * exponent =    0011,0011 (51)
      * _number =     10000101010010110100000011111011000000000000000000000000000000000000000000000000000  (5035703442907428892442624)
      *                                               ^-------------------- 51(exponent) -------------- ^
    ***/

    function B2N(uint256 coefficient, uint256 exponent) internal pure returns(uint256 _number) {
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
    function mulDivNormal(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2 ) internal pure returns(uint256 res) {
        assembly {
            let coefficient1 := shr(exponentMaxSize, _bigNumber1)
            let exponent1 := and(_bigNumber1, EXPONENTMASK)
            let coefficient2 := shr(exponentMaxSize, _bigNumber2)
            let exponent2 := and(_bigNumber2, EXPONENTMASK)
            let X := gt(exponent1, exponent2)   // _bigNumber2 > _bigNumber1
            if X {
                coefficient1 := shl(sub(exponent1, exponent2),coefficient1)
            }
            if iszero(X) {
                coefficient2 := shl(sub(exponent2, exponent1),coefficient2)
            }
            res := div(mul(_number, coefficient1), coefficient2)
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
            coefficient := shr(exponentMaxSize, bigNumber)
            exponent := and(bigNumber, EXPONENTMASK)
        }
    }

    /***
        mostSignificantBit function
        get length of given Number of binary format

      * @format: 
      * 5035703444687813576399599 = 10000101010010110100000011111011110010100110100000000011100101001101001101011101111
      * lastBit_ =                  ^---------------------------------   83   ----------------------------------------^
    ***/
    function mostSignificantBit(uint256 normal) internal pure returns (uint8 lastBit_) {
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
            uint256 resultNumerator;
            uint256 exponent1;
            assembly{
                exponent1 := and(bigNumber, EXPONENTMASK)
                resultNumerator := mul(shr(exponentMaxSize, bigNumber), number1)
            }

            if (resultNumerator < number2) {
                uint256 diffMsb = mostSignificantBit(number2 / resultNumerator);
                if (diffMsb > exponent1) return 0;
                assembly{
                    exponent1 := sub(exponent1, diffMsb)
                    number2 := shr(diffMsb, number2)
                }
            }
            (, , result) = N2B(resultNumerator / number2);
            result = result + exponent1;
        }
    }
}
