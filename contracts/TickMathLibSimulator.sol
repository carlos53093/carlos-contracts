// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;
import "./libs_normal/TickMathLib.sol";
import "./libs_normal/TickMathLib2.sol";
import "./libs_asm/TickMathLib.sol";
import "./libs_asm/TickMathLib2.sol";

contract TickMathLibSimulator {
    
    function getRatioAtTick(int24 tick_) external view returns(uint256 asmres, uint256 res, uint256 asmgasUsed, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        res = TickMathNormal.getRatioAtTick(tick_);
        gasUsed = initialGas - gasleft();

        initialGas = gasleft();
        asmres = TickMath.getRatioAtTick(tick_);
        asmgasUsed = initialGas - gasleft();
    }

    function getTickAtRatio(uint256 ratio) external view returns(int24 asmtick, int24 tick, uint256 asmgasUsed, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        tick = TickMathNormal.getTickAtRatio(ratio);
        gasUsed = initialGas - gasleft();

        initialGas = gasleft();
        asmtick = TickMath.getTickAtRatio(ratio);
        asmgasUsed = initialGas - gasleft();
    }

    function getRatioAtTick2(int24 tick_) external view returns(uint256 asmres, uint256 res, uint256 asmgasUsed, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        res = TickMathNormal2.getRatioAtTick(tick_);
        gasUsed = initialGas - gasleft();

        initialGas = gasleft();
        asmres = TickMath2.getRatioAtTick(tick_);
        asmgasUsed = initialGas - gasleft();
    }

    function getTickAtRatio2(uint256 ratio) external view returns(int24 asmtick, int24 tick, uint256 asmgasUsed, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        tick = TickMathNormal2.getTickAtRatio(ratio);
        gasUsed = initialGas - gasleft();

        initialGas = gasleft();
        asmtick = TickMath2.getTickAtRatio(ratio);
        asmgasUsed = initialGas - gasleft();
    }
}