// SPDX-License-Identifier: MIT OR Apache-2.0

// This is the most efficient for gas reduction
pragma solidity ^0.8.12;

import "./libs_asm/Converter.sol";
import "./libs_normal/Converter.sol";

contract TConverterSimulator {
    function N2B(uint normal) external view returns(uint256 asmcoefficient, uint256 asmexponent, uint256 asmbigNumber, uint256 asmgasUsed, uint256 coefficient, uint256 exponent, uint256 bigNumber, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        (coefficient, exponent, bigNumber) = ConverterNormal.N2B(normal);
        gasUsed = initialGas - gasleft();

        initialGas = gasleft();
        (asmcoefficient, asmexponent, asmbigNumber) = Converter.N2B(normal);
        asmgasUsed = initialGas - gasleft();
    }

    function B2N(uint256 coefficient, uint256 exponent) external view returns(uint256 _asmnumber, uint256 asmgasUsed, uint256 _number, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        _number = ConverterNormal.B2N(coefficient, exponent);
        gasUsed = initialGas - gasleft();

        initialGas = gasleft();
        _asmnumber = Converter.B2N(coefficient, exponent);
        asmgasUsed = initialGas - gasleft();
    }

    function mulDivNormal(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2 ) external view returns(uint256 asmres, uint256 res, uint asmgasUsed, uint gasUsed) {
        uint256 initialGas = gasleft();
        res = ConverterNormal.mulDivNormal(_number, _bigNumber1, _bigNumber2);
        gasUsed = initialGas - gasleft();

        initialGas = gasleft();
        asmres = Converter.mulDivNormal(_number, _bigNumber1, _bigNumber2);
        asmgasUsed = initialGas - gasleft();
    } 

    function decompileBigNumber(uint256 bigNumber) external view returns(uint256 asmcoefficient, uint256 coefficient, uint256 asmexponent, uint256 exponent, uint asmgasUsed, uint gasUsed) {
        uint256 initialGas = gasleft();
        (coefficient, exponent) = ConverterNormal.decompileBigNumber(bigNumber);
        gasUsed = initialGas - gasleft();

        initialGas = gasleft();
        (asmcoefficient, asmexponent) = Converter.decompileBigNumber(bigNumber);
        asmgasUsed = initialGas - gasleft();
    }

    function mostSignificantBit(uint256 number_) external view returns (uint8 asmlastBit_, uint8 lastBit_, uint asmgasUsed, uint gasUsed) {
        uint256 initialGas = gasleft();
        lastBit_ = ConverterNormal.mostSignificantBit(number_);
        gasUsed = initialGas - gasleft();

        initialGas = gasleft();
        asmlastBit_ = Converter.mostSignificantBit(number_);
        asmgasUsed = initialGas - gasleft();
    }

    function mulDivBignumber (uint256 bigNumber, uint256 number1, uint256 number2) external view returns(uint256 asmresult, uint256 result, uint asmgasUsed, uint gasUsed) {
        uint256 initialGas = gasleft();
        result = ConverterNormal.mulDivBignumber(bigNumber, number1, number2);
        gasUsed = initialGas - gasleft();

        initialGas = gasleft();
        asmresult = Converter.mulDivBignumber(bigNumber, number1, number2);
        asmgasUsed = initialGas - gasleft();
    }
}
