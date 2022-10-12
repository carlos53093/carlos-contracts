// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;
import "hardhat/console.sol";

library TickMath {
    // The minimum tick that may be passed to #getRatioFromTick computed from (log base 1.0001 of 2**-128) / 2
    int24 internal constant MIN_TICK = -443636;
    // The maximum tick that may be passed to #getRatioFromTick computed from (log base 1.0001 of 2**128) / 2
    int24 internal constant MAX_TICK = 443636;
    
    uint256 internal constant FACTOR00 = 1000000000000000000;
    uint256 internal constant FACTOR01 = 1000100000000000000;
    // uint256 internal constant FACTOR02 = 100020001;
    // uint256 internal constant FACTOR03 = 1000400060004;
    // uint256 internal constant FACTOR04 = 1000800280056007;
    // uint256 internal constant FACTOR05 = 100160120056;
    // uint256 internal constant FACTOR06 = 100320496496;
    // uint256 internal constant FACTOR07 = 100642020173;
    // uint256 internal constant FACTOR08 = 101288162245;
    // uint256 internal constant FACTOR09 = 101288162245;
    // uint256 internal constant FACTOR10 = 102592918109;
    // uint256 internal constant FACTOR11 = 105253068461;
    // uint256 internal constant FACTOR12 = 110782084204;
    // uint256 internal constant FACTOR13 = 122726701806;
    // uint256 internal constant FACTOR14 = 150618433361;
    // uint256 internal constant FACTOR15 = 226859124682;
    // uint256 internal constant FACTOR16 = 514650624516;
    // uint256 internal constant FACTOR17 = 264865265314;
    // uint256 internal constant FACTOR18 = 701536087701;
    // uint256 internal constant FACTOR19 = 492152882347;
    // uint256 internal constant FACTOR20 = 242214459602;

    // The minimum value that can be returned from #getRatioAtTick. Equivalent to getRatioAtTick(MIN_TICK)
    uint160 internal constant MIN_RATIOX96 = 4295128738;
    // The maximum value that can be returned from #getRatioAtTick. Equivalent to getRatioAtTick(MAX_TICK)
    uint160 internal constant MAX_RATIOX96 =
        1461446703465753933232717873162397069014578322804;

    uint256 internal constant zeroTickScaledRatio = 0x1000000000000000000000000; // 1 << 96

    /**
     * @notice ratioX96 = (1.0001^tick) * 2^96
     * @dev Throws if |tick| > max tick
     * @param tick_ The input tick for the above formula
     * @return ratioX96_ ratio = (debt amount/collateral amount)
     */
    function getRatioAtTick(int24 tick_)
        internal
        pure
        returns (uint256 ratioX96_)
    {
        uint256 absTick_ = tick_ < 0
            ? uint256(-int256(tick_))
            : uint256(int256(tick_));
        require(absTick_ <= uint24(MAX_TICK), "T");

        uint160 factor_ = absTick_ & 0x1 != 0 ? 10001 * 1e14 : 1e18;

        if (absTick_ & 0x2 != 0) factor_ = (factor_ * 100020001) / 1e8; // 1.0001 ** 2
        if (absTick_ & 0x4 != 0) factor_ = (factor_ * 1000400060004) / 1e12; // 1.0001 ** 4
        if (absTick_ & 0x8 != 0) factor_ = (factor_ * 1000800280056007) / 1e15; // 1.0001 ** 8
        if (absTick_ & 0x10 != 0) factor_ = (factor_ * 100160120056) / 1e11; // 1.0001 ** 16
        if (absTick_ & 0x20 != 0) factor_ = (factor_ * 100320496496) / 1e11; // 1.0001 ** 32
        if (absTick_ & 0x40 != 0) factor_ = (factor_ * 100642020173) / 1e11; // 1.0001 ** 64
        if (absTick_ & 0x80 != 0) factor_ = (factor_ * 101288162245) / 1e11; // 1.0001 ** 128
        if (absTick_ & 0x100 != 0) factor_ = (factor_ * 102592918109) / 1e11; // 1.0001 ** 256
        if (absTick_ & 0x200 != 0) factor_ = (factor_ * 105253068461) / 1e11; // 1.0001 ** 512
        if (absTick_ & 0x400 != 0) factor_ = (factor_ * 110782084204) / 1e11; // 1.0001 ** 1024
        if (absTick_ & 0x800 != 0) factor_ = (factor_ * 122726701806) / 1e11; // 1.0001 ** 2048
        if (absTick_ & 0x1000 != 0) factor_ = (factor_ * 150618433361) / 1e11; // 1.0001 ** 4096
        if (absTick_ & 0x2000 != 0) factor_ = (factor_ * 226859124682) / 1e11; // 1.0001 ** 8192
        if (absTick_ & 0x4000 != 0) factor_ = (factor_ * 514650624516) / 1e11; // 1.0001 ** 16384
        if (absTick_ & 0x8000 != 0) factor_ = (factor_ * 264865265314) / 1e10; // 1.0001 ** 32768
        if (absTick_ & 0x10000 != 0) factor_ = (factor_ * 701536087701) / 1e9; // 1.0001 ** 65536
        if (absTick_ & 0x20000 != 0) factor_ = (factor_ * 492152882347) / 1e6; // 1.0001 ** 131072
        if (absTick_ & 0x40000 != 0) factor_ *= 242214459602; // 1.0001 ** 262144

        if (tick_ > 0) ratioX96_ = (zeroTickScaledRatio * factor_) / 1e18;
        else ratioX96_ = (zeroTickScaledRatio * 1e18) / factor_;
    }

    function getRatioAtTickAsm(int24 tick_)
        internal
        pure
        returns (uint256 ratioX96_)
    {
        assembly{
            let absTick_ := tick_
            absTick_ := sub(xor(tick_, sar(255, tick_)), sar(255, tick_))
            if eq(absTick_, MAX_TICK) {
                revert(0, 0)
            }
            let factor_ := FACTOR00
            let cond := and(absTick_, 0x1)
            if cond {
                factor_ := FACTOR01
            }
            cond := and(absTick_, 0x2)
            if cond {
                factor_ := div(mul(factor_, 100020001), 100000000)
            }
            cond := and(absTick_, 0x4)
            if cond {
                factor_ := div(mul(factor_, 1000400060004), 1000000000000)
            }
            cond := and(absTick_, 0x8)
            if cond {
                factor_ := div(mul(factor_, 1000800280056007), 1000000000000000)
            }
            cond := and(absTick_, 0x10)
            if cond {
                factor_ := div(mul(factor_, 100160120056), 100000000000)
            }
            cond := and(absTick_, 0x20)
            if cond {
                factor_ := div(mul(factor_, 100320496496), 100000000000)
            }
            cond := and(absTick_, 0x40)
            if cond {
                factor_ := div(mul(factor_, 100642020173), 100000000000)
            }
            cond := and(absTick_, 0x80)
            if cond {
                factor_ := div(mul(factor_, 101288162245), 100000000000)
            }
            cond := and(absTick_, 0x100)
            if cond {
                factor_ := div(mul(factor_, 102592918109), 100000000000)
            }
            cond := and(absTick_, 0x200)
            if cond {
                factor_ := div(mul(factor_, 105253068461), 100000000000)
            }
            cond := and(absTick_, 0x400)
            if cond {
                factor_ := div(mul(factor_, 110782084204), 100000000000)
            }
            cond := and(absTick_, 0x800)
            if cond {
                factor_ := div(mul(factor_, 122726701806), 100000000000)
            }
            cond := and(absTick_, 0x1000)
            if cond {
                factor_ := div(mul(factor_, 150618433361), 100000000000)
            }
            cond := and(absTick_, 0x2000)
            if cond {
                factor_ := div(mul(factor_, 226859124682), 100000000000)
            }
            cond := and(absTick_, 0x4000)
            if cond {
                factor_ := div(mul(factor_, 514650624516), 100000000000)
            }
            cond := and(absTick_, 0x8000)
            if cond {
                factor_ := div(mul(factor_, 264865265314), 10000000000)
            }
            cond := and(absTick_, 0x10000)
            if cond {
                factor_ := div(mul(factor_, 701536087701), 1000000000)
            }
            cond := and(absTick_, 0x20000)
            if cond {
                factor_ := div(mul(factor_, 492152882347), 1000000)
            }
            cond := and(absTick_, 0x40000)
            if cond {
                factor_ := mul(factor_, 242214459602)
            }

            cond := and(tick_, 0x8000000000000000000000000000000000000000000000000000000000000000) 
            if iszero(cond) {
                ratioX96_ := div(mul(zeroTickScaledRatio, factor_), 1000000000000000000)
            }
            if cond {
                ratioX96_ := div(mul(zeroTickScaledRatio, 1000000000000000000), factor_)
            }
        }
    }
}

contract TickMathTest {
    
    uint256 public _store;

    function getRatioAtTick(int24 tick_) external view returns(uint256 res, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        res = TickMath.getRatioAtTick(tick_);
        gasUsed = initialGas - gasleft();
    }

    function getRatioAtTickAsm(int24 tick_) external view returns(uint256 res, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        res = TickMath.getRatioAtTickAsm(tick_);
        // assembly {
        //     let absTick_ := sub(xor(tick_, sar(255, tick_)), sar(255, tick_))
        //     res := absTick_
        // }
        gasUsed = initialGas - gasleft();
        
    }
}