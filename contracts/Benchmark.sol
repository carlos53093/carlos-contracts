// SPDX-License-Identifier: MIT OR Apache-2.0

// This is the most efficient for gas reduction

import "./libs/Converter.sol";
import "./libs/Optimizer.sol";
import "./TickMathLib.sol";

pragma solidity ^0.8.12;

contract Benchmark {

    function getRatioAtTick(int24 tick_) external view returns(uint256 res, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        res = TickMath.getRatioAtTickAsm(tick_);
        gasUsed = initialGas - gasleft();
    }

    function getTickAtRatio(uint256 ratio) external view returns(int24 tick, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        tick = TickMath.getTickAtRatioAsm(ratio);
        gasUsed = initialGas - gasleft();
    }

    function N2B(uint256 normal) external view returns(uint256 coefficient, uint256 exponent, uint256 bigNumber, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        (coefficient, exponent, bigNumber) = Converter.N2B(normal);
        gasUsed = initialGas - gasleft();
    }

    function B2N(uint256 coefficient, uint256 exponent) external view returns(uint256 _number, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        _number = Converter.B2N(coefficient, exponent);
        gasUsed = initialGas - gasleft();
    }

    function mulDivNormal(uint256 _number, uint256 _bigNumber1, uint256 _bigNumber2 ) external view returns(uint256 res, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        res = Converter.mulDivNormal(_number, _bigNumber1, _bigNumber2);
        gasUsed = initialGas - gasleft();
    }

    function decompileBigNumber(uint256 bigNumber) external view returns(uint256 coefficient, uint256 exponent, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        (coefficient, exponent) = Converter.decompileBigNumber(bigNumber);
        gasUsed = initialGas - gasleft();
    }

    function mostSignificantBit(uint256 normal) external view returns (uint8 lastBit_, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        lastBit_ = Converter.mostSignificantBit(normal);
        gasUsed = initialGas - gasleft();
    }

    function storeNumber(uint256 store, uint256 value, uint8 offset, uint8 size) external view returns(uint256 res, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        res = Optimizer.storeNumber(store, value, offset, size);
        gasUsed = initialGas - gasleft();
    }

    function restoreNumber(uint256 store, uint8 offset, uint8 size) external view returns(uint256 res , uint256 gasUsed) {
        uint256 initialGas = gasleft();
        res = Optimizer.restoreNumber(store, offset, size);
        gasUsed = initialGas - gasleft();
    }
}