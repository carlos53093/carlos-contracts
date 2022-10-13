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
    uint256 internal constant FACTOR02 = 0x01000d1b9c68abe5f76b30fb7581b74fb7;
    uint256 internal constant FACTOR03 = 0x01001a37e4a234c3d383ab782f2545c6e4;
    uint256 internal constant FACTOR04 = 0x0100347278ab0e92a34db2650c2d2fc42e;
    uint256 internal constant FACTOR05 = 0x010068efb00a1f16df532bdde9a9a1297d;
    uint256 internal constant FACTOR06 = 0x0100d20a63b02277f22587032b0bff0824;
    uint256 internal constant FACTOR07 = 0x0101a4c11c76cd769ecd75103ac7398288;
    uint256 internal constant FACTOR08 = 0x01034c35c3246536a6e0480c85b5bc2dfb;
    uint256 internal constant FACTOR09 = 0x0106a34b78cb2a21c7e9f9af5f22d820ad;
    uint256 internal constant FACTOR10 = 0x010d72a6a46fba90c8af42b88b461f971a;
    uint256 internal constant FACTOR11 = 0x011b9a258e639451c1a0c22a78f9b7cea5;
    uint256 internal constant FACTOR12 = 0x013a2e2bda06f2bc8e4ed7656c6a5b436a;
    uint256 internal constant FACTOR13 = 0x0181954be69a3dad596fd5f753133976fb;
    uint256 internal constant FACTOR14 = 0x0244c2655d15718eb315a76b4336e2c868;
    uint256 internal constant FACTOR15 = 0x0525816eeb9f38a887aff77df5292f74c7;
    uint256 internal constant FACTOR16 = 0x1a7c8d00b4ffd33ebec8206c666d8dc628;
    uint256 internal constant FACTOR17 = 0x2bd893d0b2795341e038ff13e0a159c633c;
    uint256 internal constant FACTOR18 = 0x78278e1e17e34b945308bb906466b1e5c0b99;
    // uint256 internal constant FACTOR19 = 0x38651b58d200000000000000000000000000000000;
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

    function getRatioAtTick2(int24 tick_)
        internal
        pure
        returns (uint256 ratioX96_)
    {
        uint256 absTick_ = tick_ < 0
            ? uint256(-int256(tick_))
            : uint256(int256(tick_));
        require(absTick_ <= uint24(MAX_TICK), "T");

        uint256 factor_ = absTick_ & 0x1 != 0 ? 10001 * 1e14 : 1e18;

        if (absTick_ & 0x2 != 0) factor_ = (factor_ * FACTOR02) >> 128; // 1.0001 ** 2
        if (absTick_ & 0x4 != 0) factor_ = (factor_ * FACTOR03)>>128; // 1.0001 ** 4
        if (absTick_ & 0x8 != 0) factor_ = (factor_ * FACTOR04)>>128; // 1.0001 ** 8
        if (absTick_ & 0x10 != 0) factor_ = (factor_ * FACTOR05)>>128; // 1.0001 ** 16
        if (absTick_ & 0x20 != 0) factor_ = (factor_ * FACTOR06)>>128; // 1.0001 ** 32
        if (absTick_ & 0x40 != 0) factor_ = (factor_ * FACTOR07)>>128; // 1.0001 ** 64
        if (absTick_ & 0x80 != 0) factor_ = (factor_ * FACTOR08)>>128; // 1.0001 ** 128
        if (absTick_ & 0x100 != 0) factor_ = (factor_ * FACTOR09)>>128; // 1.0001 ** 256
        if (absTick_ & 0x200 != 0) factor_ = (factor_ * FACTOR10)>>128; // 1.0001 ** 512
        if (absTick_ & 0x400 != 0) factor_ = (factor_ * FACTOR11)>>128; // 1.0001 ** 1024
        if (absTick_ & 0x800 != 0) factor_ = (factor_ * FACTOR12)>>128; // 1.0001 ** 2048
        if (absTick_ & 0x1000 != 0) factor_ = (factor_ * FACTOR13)>>128; // 1.0001 ** 4096
        if (absTick_ & 0x2000 != 0) factor_ = (factor_ * FACTOR14)>>128; // 1.0001 ** 8192
        if (absTick_ & 0x4000 != 0) factor_ = (factor_ * FACTOR15)>>128; // 1.0001 ** 16384
        if (absTick_ & 0x8000 != 0) factor_ = (factor_ * FACTOR16)>>128; // 1.0001 ** 32768
        if (absTick_ & 0x10000 != 0) factor_ = (factor_ * FACTOR17)>>128;// 1.0001 ** 65536
        if (absTick_ & 0x20000 != 0) factor_ = (factor_ * FACTOR18)>>128;// 1.0001 ** 131072
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
                factor_ := mul(factor_, 242214459602)
            }

            cond := and(tick_, 0x8000000000000000000000000000000000000000000000000000000000000000) 
            if iszero(cond) {
                ratioX96_ := div(shl(96, factor_), 1000000000000000000)
            }
            if cond {
                ratioX96_ := div(shl(96, 1000000000000000000), factor_)
            }
        }
    }

    function getTickAtRatio(uint256 ratioX96_)
        internal
        pure
        returns (int24 tick_)
    {
        require(ratioX96_ >= MIN_RATIOX96 && ratioX96_ <= MAX_RATIOX96, "R");
        uint256 factor_;
        if (ratioX96_ >= zeroTickScaledRatio) {
            factor_ = (ratioX96_ * 1e18) / zeroTickScaledRatio;
        } else {
            factor_ = (zeroTickScaledRatio * 1e18) / ratioX96_;
        }

        if (factor_ >= 242214459602) {
            tick_ |= 0x40000;
            factor_ /= 242214459602;
        }
        if (factor_ * 1e6 >= 492152882347) {
            tick_ |= 0x20000;
            factor_ = (factor_ * 1e6) / 492152882347;
        }
        if (factor_ * 1e9 >= 701536087701) {
            tick_ |= 0x10000;
            factor_ = (factor_ * 1e9) / 701536087701;
        }
        if (factor_ * 1e10 >= 264865265314) {
            tick_ |= 0x8000;
            factor_ = (factor_ * 1e10) / 264865265314;
        }
        if (factor_ * 1e11 >= 514650624516) {
            tick_ |= 0x4000;
            factor_ = (factor_ * 1e11) / 514650624516;
        }
        if (factor_ * 1e11 >= 226859124682) {
            tick_ |= 0x2000;
            factor_ = (factor_ * 1e11) / 226859124682;
        }
        if (factor_ * 1e11 >= 150618433361) {
            tick_ |= 0x1000;
            factor_ = (factor_ * 1e11) / 150618433361;
        }
        if (factor_ * 1e11 >= 122726701806) {
            tick_ |= 0x800;
            factor_ = (factor_ * 1e11) / 122726701806;
        }
        if (factor_ * 1e11 >= 110782084204) {
            tick_ |= 0x400;
            factor_ = (factor_ * 1e11) / 110782084204;
        }
        if (factor_ * 1e11 >= 105253068461) {
            tick_ |= 0x200;
            factor_ = (factor_ * 1e11) / 105253068461;
        }
        if (factor_ * 1e11 >= 102592918109) {
            tick_ |= 0x100;
            factor_ = (factor_ * 1e11) / 102592918109;
        }
        if (factor_ * 1e11 >= 101288162245) {
            tick_ |= 0x80;
            factor_ = (factor_ * 1e11) / 101288162245;
        }
        if (factor_ * 1e11 >= 100642020173) {
            tick_ |= 0x40;
            factor_ = (factor_ * 1e11) / 100642020173;
        }
        if (factor_ * 1e11 >= 100320496496) {
            tick_ |= 0x20;
            factor_ = (factor_ * 1e11) / 100320496496;
        }
        if (factor_ * 1e11 >= 100160120056) {
            tick_ |= 0x10;
            factor_ = (factor_ * 1e11) / 100160120056;
        }
        if (factor_ * 1e15 >= 1000800280056007) {
            tick_ |= 0x8;
            factor_ = (factor_ * 1e15) / 1000800280056007;
        }
        if (factor_ * 1e12 >= 1000400060004) {
            tick_ |= 0x4;
            factor_ = (factor_ * 1e12) / 1000400060004;
        }
        if (factor_ * 1e8 >= 100020001) {
            tick_ |= 0x2;
            factor_ = (factor_ * 1e8) / 100020001;
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
        returns (int24 tick_)
    {
        assembly{
            if or(lt(ratioX96_, MIN_RATIOX96), gt(ratioX96_, MAX_RATIOX96)) {
                revert(0,0)
            }
            let cond := lt(ratioX96_, zeroTickScaledRatio)
            let factor_
            if iszero(cond) {
                factor_ := div(shl(96, 1000000000000000000), ratioX96_)
            }
            if cond {
                factor_ := shr(96, mul(ratioX96_, 1000000000000000000))
            }
        }
        require(ratioX96_ >= MIN_RATIOX96 && ratioX96_ <= MAX_RATIOX96, "R");
        uint256 factor_;
        if (ratioX96_ >= zeroTickScaledRatio) {
            factor_ = (ratioX96_ * 1e18) / zeroTickScaledRatio;
        } else {
            factor_ = (zeroTickScaledRatio * 1e18) / ratioX96_;
        }

        if (factor_ >= 242214459602) {
            tick_ |= 0x40000;
            factor_ /= 242214459602;
        }
        if (factor_ * 1e6 >= 492152882347) {
            tick_ |= 0x20000;
            factor_ = (factor_ * 1e6) / 492152882347;
        }
        if (factor_ * 1e9 >= 701536087701) {
            tick_ |= 0x10000;
            factor_ = (factor_ * 1e9) / 701536087701;
        }
        if (factor_ * 1e10 >= 264865265314) {
            tick_ |= 0x8000;
            factor_ = (factor_ * 1e10) / 264865265314;
        }
        if (factor_ * 1e11 >= 514650624516) {
            tick_ |= 0x4000;
            factor_ = (factor_ * 1e11) / 514650624516;
        }
        if (factor_ * 1e11 >= 226859124682) {
            tick_ |= 0x2000;
            factor_ = (factor_ * 1e11) / 226859124682;
        }
        if (factor_ * 1e11 >= 150618433361) {
            tick_ |= 0x1000;
            factor_ = (factor_ * 1e11) / 150618433361;
        }
        if (factor_ * 1e11 >= 122726701806) {
            tick_ |= 0x800;
            factor_ = (factor_ * 1e11) / 122726701806;
        }
        if (factor_ * 1e11 >= 110782084204) {
            tick_ |= 0x400;
            factor_ = (factor_ * 1e11) / 110782084204;
        }
        if (factor_ * 1e11 >= 105253068461) {
            tick_ |= 0x200;
            factor_ = (factor_ * 1e11) / 105253068461;
        }
        if (factor_ * 1e11 >= 102592918109) {
            tick_ |= 0x100;
            factor_ = (factor_ * 1e11) / 102592918109;
        }
        if (factor_ * 1e11 >= 101288162245) {
            tick_ |= 0x80;
            factor_ = (factor_ * 1e11) / 101288162245;
        }
        if (factor_ * 1e11 >= 100642020173) {
            tick_ |= 0x40;
            factor_ = (factor_ * 1e11) / 100642020173;
        }
        if (factor_ * 1e11 >= 100320496496) {
            tick_ |= 0x20;
            factor_ = (factor_ * 1e11) / 100320496496;
        }
        if (factor_ * 1e11 >= 100160120056) {
            tick_ |= 0x10;
            factor_ = (factor_ * 1e11) / 100160120056;
        }
        if (factor_ * 1e15 >= 1000800280056007) {
            tick_ |= 0x8;
            factor_ = (factor_ * 1e15) / 1000800280056007;
        }
        if (factor_ * 1e12 >= 1000400060004) {
            tick_ |= 0x4;
            factor_ = (factor_ * 1e12) / 1000400060004;
        }
        if (factor_ * 1e8 >= 100020001) {
            tick_ |= 0x2;
            factor_ = (factor_ * 1e8) / 100020001;
        }
        if (factor_ >= 1.0001 * 1e18) {
            tick_ |= 0x1;
        }

        if (ratioX96_ < zeroTickScaledRatio) {
            tick_ = -tick_;
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
        res = TickMath.getRatioAtTick2(tick_);
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