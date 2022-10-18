// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;
import "hardhat/console.sol";

library TickMath {
    // The minimum tick that may be passed to #getRatioFromTick computed from (log base 1.0001 of 2**-128) / 2
    int24 internal constant MIN_TICK = -443636;
    // The maximum tick that may be passed to #getRatioFromTick computed from log base 1.0001 of 2**128
    int24 internal constant MAX_TICK = 443636;

    uint256 internal constant FACTOR00 = 0x100000000000000000000000000000000;
    uint256 internal constant FACTOR01 = 0xfff97272373d413259a46990580e213a;
    uint256 internal constant FACTOR02 = 0xfff2e50f5f656932ef12357cf3c7fdcc;        // 1.0001 ** 2
    uint256 internal constant FACTOR03 = 0xffe5caca7e10e4e61c3624eaa0941cd0;        // 1.0001 ** 4
    uint256 internal constant FACTOR04 = 0xffcb9843d60f6159c9db58835c926644;        // 1.0001 ** 8

    // TODO: calculate factors: Formula:= factor => (uint256.max / ((1.0001 ** tick) << 128))
    uint256 internal constant FACTOR05 = 0xff973b41fa98c081472e6896dfb254c0;      // 1.0001 ** 16
    uint256 internal constant FACTOR06 = 0xff2ea16466c96a3843ec78b326b52861;      // 1.0001 ** 32
    uint256 internal constant FACTOR07 = 0xfe5dee046a99a2a811c461f1969c3053;      // 1.0001 ** 64
    uint256 internal constant FACTOR08 = 0xfcbe86c7900a88aedcffc83b479aa3a4;      // 1.0001 ** 128
    uint256 internal constant FACTOR09 = 0xf987a7253ac413176f2b074cf7815e54;      // 1.0001 ** 256
    uint256 internal constant FACTOR10 = 0xf3392b0822b70005940c7a398e4b70f3;      // 1.0001 ** 512
    uint256 internal constant FACTOR11 = 0xe7159475a2c29b7443b29c7fa6e889d9;      // 1.0001 ** 1024
    uint256 internal constant FACTOR12 = 0xd097f3bdfd2022b8845ad8f792aa5825;      // 1.0001 ** 2048
    uint256 internal constant FACTOR13 = 0xa9f746462d870fdf8a65dc1f90e061e5;      // 1.0001 ** 4096
    uint256 internal constant FACTOR14 = 0x70d869a156d2a1b890bb3df62baf32f7;      // 1.0001 ** 8192
    uint256 internal constant FACTOR15 = 0x31be135f97d08fd981231505542fcfa6;      // 1.0001 ** 16384
    uint256 internal constant FACTOR16 = 0x9aa508b5b7a84e1c677de54f3e99bc9;      // 1.0001 ** 32768
    uint256 internal constant FACTOR17 = 0x5d6af8dedb81196699c329225ee604;     // 1.0001 ** 65536
    uint256 internal constant FACTOR18 = 0x2216e584f5fa1ea926041bedfe98;   // 1.0001 ** 131072
    uint256 internal constant FACTOR19 = 0x48a170391f7dc42444e8fa2;   // 1.0001 ** 262144

    // The minimum value that can be returned from #getRatioAtTick. Equivalent to getRatioAtTick(MIN_TICK)
    uint160 internal constant MIN_RATIOX96 = 4295558251;
    // The maximum value that can be returned from #getRatioAtTick. Equivalent to getRatioAtTick(MAX_TICK)
    uint160 internal constant MAX_RATIOX96 =
        1461300573427867316570072651998408279850435624081; // TODO: calculate this after building the getRatioAtTick(MAX_TICK) function

    uint256 internal constant zeroTickScaledRatio = 0x1000000000000000000000000; // 1 << 96
    uint256 internal constant _1E18 = 1000000000000000000;
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

        uint256 factor_ = absTick_ & 0x1 != 0 ? FACTOR01 : FACTOR00;
        // TODO: @Vaibhav why not keep division as 1e18 in all as division has a constant gas no matter the number. Right?
        // Or even better just shift the bits similar to Uniswap?
        if (absTick_ & 0x2 != 0) factor_ = (factor_ * FACTOR02) >> 128; // 1.0001 ** 2
        if (absTick_ & 0x4 != 0) factor_ = (factor_ * FACTOR03) >> 128; // 1.0001 ** 4
        if (absTick_ & 0x8 != 0) factor_ = (factor_ * FACTOR04) >> 128; // 1.0001 ** 8
        if (absTick_ & 0x10 != 0) factor_ = (factor_ * FACTOR05) >> 128; // 1.0001 ** 16

        // TODO - update the factors according to new logics: factor => (uint256.max / ((1.0001 ** tick) << 128))
        if (absTick_ & 0x20 != 0) factor_ = (factor_ * FACTOR06) >> 128; // 1.0001 ** 32
        if (absTick_ & 0x40 != 0) factor_ = (factor_ * FACTOR07) >> 128; // 1.0001 ** 64
        if (absTick_ & 0x80 != 0) factor_ = (factor_ * FACTOR08) >> 128; // 1.0001 ** 128
        if (absTick_ & 0x100 != 0) factor_ = (factor_ * FACTOR09) >> 128; // 1.0001 ** 256
        if (absTick_ & 0x200 != 0) factor_ = (factor_ * FACTOR10) >> 128; // 1.0001 ** 512
        if (absTick_ & 0x400 != 0) factor_ = (factor_ * FACTOR11) >> 128; // 1.0001 ** 1024
        if (absTick_ & 0x800 != 0) factor_ = (factor_ * FACTOR12) >> 128; // 1.0001 ** 2048
        if (absTick_ & 0x1000 != 0) factor_ = (factor_ * FACTOR13) >> 128; // 1.0001 ** 4096
        if (absTick_ & 0x2000 != 0) factor_ = (factor_ * FACTOR14) >> 128; // 1.0001 ** 8192
        if (absTick_ & 0x4000 != 0) factor_ = (factor_ * FACTOR15) >> 128; // 1.0001 ** 16384
        if (absTick_ & 0x8000 != 0) factor_ = (factor_ * FACTOR16) >> 128; // 1.0001 ** 32768
        if (absTick_ & 0x10000 != 0) factor_ = (factor_ * FACTOR17) >> 128; // 1.0001 ** 65536
        if (absTick_ & 0x20000 != 0) factor_ = (factor_ * FACTOR18) >> 128; // 1.0001 ** 131072
        if (absTick_ & 0x40000 != 0) factor_ = (factor_ * FACTOR19) >> 128; // 1.0001 ** 262144

        uint256 precision_ = 0;
        if (tick_ > 0) {
            factor_ = type(uint256).max / factor_;

            // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
            precision_ = factor_ % (1 << 32) == 0 ? 0 : 1;
        }

        ratioX96_ = (factor_ >> 32) + precision_;
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
                factor_ := shr(128, mul(factor_, FACTOR02))
            }
            cond := and(absTick_, 0x4)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR03))
            }
            cond := and(absTick_, 0x8)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR04))
            }
            cond := and(absTick_, 0x10)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR05))
            }
            cond := and(absTick_, 0x20)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR06))
            }
            cond := and(absTick_, 0x40)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR07))
            }
            cond := and(absTick_, 0x80)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR08))
            }
            cond := and(absTick_, 0x100)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR09))
            }
            cond := and(absTick_, 0x200)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR10))
            }
            cond := and(absTick_, 0x400)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR11))
            }
            cond := and(absTick_, 0x800)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR12))
            }
            cond := and(absTick_, 0x1000)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR13))
            }
            cond := and(absTick_, 0x2000)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR14))
            }
            cond := and(absTick_, 0x4000)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR15))
            }
            cond := and(absTick_, 0x8000)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR16))
            }
            cond := and(absTick_, 0x10000)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR17))
            }
            cond := and(absTick_, 0x20000)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR18))
            }
            cond := and(absTick_, 0x40000)
            if cond {
                factor_ := shr(128, mul(factor_, FACTOR19))
            }
            let precision_ := 0
            cond := and(tick_, 0x8000000000000000000000000000000000000000000000000000000000000000)
            if iszero(cond) {
                factor_ := div(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,  factor_)
                // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
                cond := mod(factor_, 0x100000000)
                if cond {
                    precision_ := 1
                }
            }
            ratioX96_ := add(shr(32, factor_), precision_)
        }
    }

       /**
     * @notice ratioX96 = (1.0001^tick) * 2^96
     * @dev Throws if ratioX96_ > max ratio || ratioX96 < min ratio
     * @param ratioX96_ The input ratio; ratio = (debt amount/collateral amount)
     * @return tick_ The output tick for the above formula
     */
    function getTickAtRatioUpdate(uint256 ratioX96_)
        internal
        pure
        returns (int24 tick_, uint256 factor_)
    {
        require(ratioX96_ >= MIN_RATIOX96 && ratioX96_ <= MAX_RATIOX96, "R");
        // uint256 factor_;
        if (ratioX96_ >= zeroTickScaledRatio) {
            factor_ = (ratioX96_ * 1e18) / zeroTickScaledRatio;
        } else {
            factor_ = (zeroTickScaledRatio * 1e18) / ratioX96_;
        }

        /// TODO: Fix the updated according to the below structure

        if (factor_ >= 242214459604341000000000000000) {
            tick_ |= 0x40000;
            factor_ = (factor_) * 1e18 / 242214459604341000000000000000;
        }
        if (factor_ >= 492152882348911000000000) {
            tick_ |= 0x20000;
            factor_ = (factor_) * 1e18 / 492152882348911000000000;
        }
        if (factor_ >= 701536087702486600000) {
            tick_ |= 0x10000;
            factor_ = (factor_) * 1e18 / 701536087702486600000;
        }
        if (factor_ >= 26486526531474190000) {
            tick_ |= 0x8000;
            factor_ = (factor_) * 1e18 / 26486526531474190000;
        }
        if (factor_ >= 5146506245160322000) {
            tick_ |= 0x4000;
            factor_ = (factor_) * 1e18 / 5146506245160322000;
        }
        if (factor_ >= 2268591246822644000) {
            tick_ |= 0x2000;
            factor_ = (factor_) * 1e18 / 2268591246822644000;
        }
        if (factor_ >= 1506184333613467000) {
            tick_ |= 0x1000;
            factor_ = (factor_) * 1e18 / 1506184333613467000;
        }
        if (factor_ >= 1227267018058200000) {
            tick_ |= 0x800;
            factor_ = (factor_) * 1e18 / 1227267018058200000;
        }
        if (factor_ >= 1107820842039993000) {
            tick_ |= 0x400;
            factor_ = (factor_) * 1e18 / 1107820842039993000;
        }
        if (factor_ >= 1052530684607338000) {
            tick_ |= 0x200;
            factor_ = (factor_) * 1e18 / 1052530684607338000;
        }
        if (factor_ >= 1025929181087729000) {
            tick_ |= 0x100;
            factor_ = (factor_) * 1e18 / 1025929181087729000;
        }
        if (factor_ >= 1012881622445451000) {
            tick_ |= 0x80;
            factor_ = (factor_) * 1e18 / 1012881622445451000;
        }
        if (factor_ >= 1006420201727613000) {
            tick_ |= 0x40;
            factor_ = (factor_) * 1e18 / 1006420201727613000;
        }
        if (factor_ >= 1003204964963598000) {
            tick_ |= 0x20;
            factor_ = (factor_) * 1e18 / 1003204964963598000;
        }
        if (factor_ >= 1001601200560182000) {
            tick_ |= 0x10;
            factor_ = (factor_) * 1e18 / 1001601200560182000;
        }
        if (factor_ >= 1000800280056006999) {
            tick_ |= 0x8;
            factor_ = (factor_) * 1e18 / 1000800280056006999;
        }

        if (factor_ >= 1000400060004000000) {
            tick_ |= 0x4;
            factor_ = (factor_) * 1e18 / 1000400060004000000;
        }
        if (factor_ >= 1000200010000000000) {
            tick_ |= 0x2;
            factor_ = (factor_ * 1e18) / 1000200010000000000;
        }
        if (factor_ >= 1.0001 * 1e18) {
            tick_ |= 0x1;
        }

        if (ratioX96_ < zeroTickScaledRatio) {
            tick_ = -tick_;
        }
    }

    function getTickAtRatioAsm(uint256 ratioX96_)
        internal
        pure
        returns (int24 tick_, uint256 factor_)
    {
        assembly {
            if or(gt(ratioX96_, MAX_RATIOX96), lt(ratioX96_, MIN_RATIOX96)) {
                revert(0, 0)
            }
            let cond := lt(ratioX96_, zeroTickScaledRatio)
            if iszero(cond) {
                factor_ := div(mul(ratioX96_, _1E18), zeroTickScaledRatio)
            }
            if cond {
                factor_ := div(mul(zeroTickScaledRatio, _1E18), ratioX96_)
            }

            cond := lt(factor_, 242214459604341000000000000000)
            if iszero(cond) {
                tick_ := or(tick_, 0x40000)
                factor_ := div(mul(factor_, _1E18), 242214459604341000000000000000)
            }
            cond := lt(factor_, 492152882348911000000000)
            if iszero(cond) {
                tick_ := or(tick_, 0x20000)
                factor_ := div(mul(factor_, _1E18), 492152882348911000000000)
            }
            cond := lt(factor_, 701536087702486600000)
            if iszero(cond) {
                tick_ := or(tick_, 0x10000)
                factor_ := div(mul(factor_, _1E18), 701536087702486600000)
            }
            cond := lt(factor_, 26486526531474190000)
            if iszero(cond) {
                tick_ := or(tick_, 0x8000)
                factor_ := div(mul(factor_, _1E18), 26486526531474190000)
            }
            cond := lt(factor_, 5146506245160322000)
            if iszero(cond) {
                tick_ := or(tick_, 0x4000)
                factor_ := div(mul(factor_, _1E18), 5146506245160322000)
            }
            cond := lt(factor_, 2268591246822644000)
            if iszero(cond) {
                tick_ := or(tick_, 0x2000)
                factor_ := div(mul(factor_, _1E18), 2268591246822644000)
            }
            cond := lt(factor_, 1506184333613467000)
            if iszero(cond) {
                tick_ := or(tick_, 0x1000)
                factor_ := div(mul(factor_, _1E18), 1506184333613467000)
            }
            cond := lt(factor_, 1227267018058200000)
            if iszero(cond) {
                tick_ := or(tick_, 0x800)
                factor_ := div(mul(factor_, _1E18), 1227267018058200000)
            }
            cond := lt(factor_, 1107820842039993000)
            if iszero(cond) {
                tick_ := or(tick_, 0x400)
                factor_ := div(mul(factor_, _1E18), 1107820842039993000)
            }
            cond := lt(factor_, 1052530684607338000)
            if iszero(cond) {
                tick_ := or(tick_, 0x200)
                factor_ := div(mul(factor_, _1E18), 1052530684607338000)
            }
            cond := lt(factor_, 1025929181087729000)
            if iszero(cond) {
                tick_ := or(tick_, 0x100)
                factor_ := div(mul(factor_, _1E18), 1025929181087729000)
            }
            cond := lt(factor_, 1012881622445451000)
            if iszero(cond) {
                tick_ := or(tick_, 0x80)
                factor_ := div(mul(factor_, _1E18), 1012881622445451000)
            }
            cond := lt(factor_, 1006420201727613000)
            if iszero(cond) {
                tick_ := or(tick_, 0x40)
                factor_ := div(mul(factor_, _1E18), 1006420201727613000)
            }
            cond := lt(factor_, 1003204964963598000)
            if iszero(cond) {
                tick_ := or(tick_, 0x20)
                factor_ := div(mul(factor_, _1E18), 1003204964963598000)
            }
            cond := lt(factor_, 1001601200560182000)
            if iszero(cond) {
                tick_ := or(tick_, 0x10)
                factor_ := div(mul(factor_, _1E18), 1001601200560182000)
            }
            cond := lt(factor_, 1000800280056006999)
            if iszero(cond) {
                tick_ := or(tick_, 0x8)
                factor_ := div(mul(factor_, _1E18), 1000800280056006999)
            }
            cond := lt(factor_, 1000400060004000000)
            if iszero(cond) {
                tick_ := or(tick_, 0x4)
                factor_ := div(mul(factor_, _1E18), 1000400060004000000)
            }
            cond := lt(factor_, 1000200010000000000)
            if iszero(cond) {
                tick_ := or(tick_, 0x2)
                factor_ := div(mul(factor_, _1E18), 1000200010000000000)
            }
            cond := lt(factor_, 1000100000000000000)
            if iszero(cond) {
                tick_ := or(tick_, 0x1)
            }
            cond := lt(ratioX96_, zeroTickScaledRatio)
            if cond {
                tick_ := add(not(tick_), 1)
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

    function getRatioAtTick2(int24 tick_) external view returns(uint256 res, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        res = TickMath.getRatioAtTickAsm(tick_);
        gasUsed = initialGas - gasleft();
    }

    function getTickAtRatio(uint256 ratio) external view returns(int24 tick, uint256 factor, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        (tick, factor) = TickMath.getTickAtRatioUpdate(ratio);
        gasUsed = initialGas - gasleft();
    }

    function getTickAtRatio2(uint256 ratio) external view returns(int24 tick, uint256 factor, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        (tick, factor) = TickMath.getTickAtRatioAsm(ratio);
        gasUsed = initialGas - gasleft();
    }
}