// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;

/// @title library that calculates number "tick" and "ratioX96" from this: ratioX96 = (1.0001^tick) * 2^96
/// @notice "tick" supports between -443636 and 443636.  "ratioX96" supports between  4295558251 and 1461300573427867316570072651998408279850435624081

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

    uint256 internal constant ZEROTICKSCALEDRATIO = 0x1000000000000000000000000; // 1 << 96
    uint256 internal constant _1E18 = 1000000000000000000;
    /**
     * @notice ratioX96 = (1.0001^tick) * 2^96
     * @dev Throws if |tick| > max tick
     * @param tick The input tick for the above formula
     * @return ratioX96 ratio = (debt amount/collateral amount)
     */

    function getRatioAtTick(int24 tick)
        internal
        pure
        returns (uint256 ratioX96) 
    {
        assembly{
            let absTick_ := tick
            absTick_ := sub(xor(tick, sar(255, tick)), sar(255, tick))
            if eq(absTick_, MAX_TICK) {
                revert(0, 0)
            }
            let factor_ := FACTOR00
            // let cond := 
            if and(absTick_, 0x1) {
                factor_ := FACTOR01
            }
            if and(absTick_, 0x2) {
                factor_ := shr(128, mul(factor_, FACTOR02))
            }
            if and(absTick_, 0x4) {
                factor_ := shr(128, mul(factor_, FACTOR03))
            }
            if and(absTick_, 0x8) {
                factor_ := shr(128, mul(factor_, FACTOR04))
            }
            if and(absTick_, 0x10) {
                factor_ := shr(128, mul(factor_, FACTOR05))
            }
            if and(absTick_, 0x20) {
                factor_ := shr(128, mul(factor_, FACTOR06))
            }
            if and(absTick_, 0x40) {
                factor_ := shr(128, mul(factor_, FACTOR07))
            }
            if and(absTick_, 0x80) {
                factor_ := shr(128, mul(factor_, FACTOR08))
            }
            if and(absTick_, 0x100) {
                factor_ := shr(128, mul(factor_, FACTOR09))
            }
            if and(absTick_, 0x200) {
                factor_ := shr(128, mul(factor_, FACTOR10))
            }
            if and(absTick_, 0x400) {
                factor_ := shr(128, mul(factor_, FACTOR11))
            }
            if and(absTick_, 0x800) {
                factor_ := shr(128, mul(factor_, FACTOR12))
            }
            if and(absTick_, 0x1000) {
                factor_ := shr(128, mul(factor_, FACTOR13))
            }
            if and(absTick_, 0x2000) {
                factor_ := shr(128, mul(factor_, FACTOR14))
            }
            if and(absTick_, 0x4000) {
                factor_ := shr(128, mul(factor_, FACTOR15))
            }
            if and(absTick_, 0x8000) {
                factor_ := shr(128, mul(factor_, FACTOR16))
            }
            if and(absTick_, 0x10000) {
                factor_ := shr(128, mul(factor_, FACTOR17))
            }
            if and(absTick_, 0x20000) {
                factor_ := shr(128, mul(factor_, FACTOR18))
            }
            if and(absTick_, 0x40000) {
                factor_ := shr(128, mul(factor_, FACTOR19))
            }
            let precision_ := 0
            if iszero(and(tick, 0x8000000000000000000000000000000000000000000000000000000000000000)) {
                factor_ := div(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,  factor_)
                // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
                if mod(factor_, 0x100000000) {
                    precision_ := 1
                }
            }
            ratioX96 := add(shr(32, factor_), precision_)
        }
    }

       /**
     * @notice ratioX96 = (1.0001^tick) * 2^96
     * @dev Throws if ratioX96 > max ratio || ratioX96 < min ratio
     * @param ratioX96 The input ratio; ratio = (debt amount/collateral amount)
     * @return tick The output tick for the above formula
     */

    function getTickAtRatio(uint256 ratioX96)
        internal
        pure
        returns (int24 tick)
    {
        assembly {
            if or(gt(ratioX96, MAX_RATIOX96), lt(ratioX96, MIN_RATIOX96)) {
                revert(0, 0)
            }
            let cond := lt(ratioX96, ZEROTICKSCALEDRATIO)
            let factor_
            if iszero(cond) {
                factor_ := div(mul(ratioX96, _1E18), ZEROTICKSCALEDRATIO)
            }
            if cond {
                factor_ := div(mul(ZEROTICKSCALEDRATIO, _1E18), ratioX96)
            }

            if iszero(lt(factor_, 242214459604341000000000000000)) {
                tick := or(tick, 0x40000)
                factor_ := div(mul(factor_, _1E18), 242214459604341000000000000000)
            }
            if iszero(lt(factor_, 492152882348911000000000)) {
                tick := or(tick, 0x20000)
                factor_ := div(mul(factor_, _1E18), 492152882348911000000000)
            }
            if iszero(lt(factor_, 701536087702486600000)) {
                tick := or(tick, 0x10000)
                factor_ := div(mul(factor_, _1E18), 701536087702486600000)
            }
            if iszero(lt(factor_, 26486526531474190000)) {
                tick := or(tick, 0x8000)
                factor_ := div(mul(factor_, _1E18), 26486526531474190000)
            }
            if iszero(lt(factor_, 5146506245160322000)) {
                tick := or(tick, 0x4000)
                factor_ := div(mul(factor_, _1E18), 5146506245160322000)
            }
            if iszero(lt(factor_, 2268591246822644000)) {
                tick := or(tick, 0x2000)
                factor_ := div(mul(factor_, _1E18), 2268591246822644000)
            }
            if iszero(lt(factor_, 1506184333613467000)) {
                tick := or(tick, 0x1000)
                factor_ := div(mul(factor_, _1E18), 1506184333613467000)
            }
            if iszero(lt(factor_, 1227267018058200000)) {
                tick := or(tick, 0x800)
                factor_ := div(mul(factor_, _1E18), 1227267018058200000)
            }
            if iszero(lt(factor_, 1107820842039993000)) {
                tick := or(tick, 0x400)
                factor_ := div(mul(factor_, _1E18), 1107820842039993000)
            }
            if iszero(lt(factor_, 1052530684607338000)) {
                tick := or(tick, 0x200)
                factor_ := div(mul(factor_, _1E18), 1052530684607338000)
            }
            if iszero(lt(factor_, 1025929181087729000)) {
                tick := or(tick, 0x100)
                factor_ := div(mul(factor_, _1E18), 1025929181087729000)
            }
            if iszero(lt(factor_, 1012881622445451000)) {
                tick := or(tick, 0x80)
                factor_ := div(mul(factor_, _1E18), 1012881622445451000)
            }
            if iszero(lt(factor_, 1006420201727613000)) {
                tick := or(tick, 0x40)
                factor_ := div(mul(factor_, _1E18), 1006420201727613000)
            }
            if iszero(lt(factor_, 1003204964963598000)) {
                tick := or(tick, 0x20)
                factor_ := div(mul(factor_, _1E18), 1003204964963598000)
            }
            if iszero(lt(factor_, 1001601200560182000)) {
                tick := or(tick, 0x10)
                factor_ := div(mul(factor_, _1E18), 1001601200560182000)
            }
            if iszero(lt(factor_, 1000800280056006999)) {
                tick := or(tick, 0x8)
                factor_ := div(mul(factor_, _1E18), 1000800280056006999)
            }
            if iszero(lt(factor_, 1000400060004000000)) {
                tick := or(tick, 0x4)
                factor_ := div(mul(factor_, _1E18), 1000400060004000000)
            }
            if iszero(lt(factor_, 1000200010000000000)) {
                tick := or(tick, 0x2)
                factor_ := div(mul(factor_, _1E18), 1000200010000000000)
            }
            if iszero(lt(factor_, 1000100000000000000)) {
                tick := or(tick, 0x1)
            }
            if cond {
                tick := add(not(tick), 1)
            }
        }
    }
}