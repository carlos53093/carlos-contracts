// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;

/// @title library that calculates number "tick" and "ratioX96" from this: ratioX96 = (1.0001^tick) * 2^96
/// @notice "tick" supports between -443636 and 443636.  "ratioX96" supports between  4295558251 and 1461300573427867316570072651998408279850435624081

library TickMath2 {
    // The minimum tick that may be passed to #getRatioFromTick computed from (log base 1.0015 of 2**-128) / 2
    int24 internal constant MIN_TICK = -32768;
    // The maximum tick that may be passed to #getRatioFromTick computed from log base 1.0015 of 2**128
    int24 internal constant MAX_TICK = 32768;

    uint256 internal constant FACTOR00 = 0x100000000000000000000000000000000;
    uint256 internal constant FACTOR01 = 0xff9dd7de423466c20352b1246ce4856f;
    uint256 internal constant FACTOR02 = 0xff3bd55f4488ad277531fa1c725a66d0;        // 1.0015 ** 2
    uint256 internal constant FACTOR03 = 0xfe78410fd6498b73cb96a6917f853259;        // 1.0015 ** 4
    uint256 internal constant FACTOR04 = 0xfcf2d9987c9be178ad5bfeffaa123273;        // 1.0015 ** 8

    // TODO: calculate factors: Formula:= factor => (uint256.max / ((1.0015 ** tick) << 128))
    uint256 internal constant FACTOR05 = 0xf9ef02c4529258b057769680fc6601b3;      // 1.0015 ** 16
    uint256 internal constant FACTOR06 = 0xf402d288133a85a17784a411f7aba082;      // 1.0015 ** 32
    uint256 internal constant FACTOR07 = 0xe895615b5beb6386553757b0352bda90;      // 1.0015 ** 64
    uint256 internal constant FACTOR08 = 0xd34f17a00ffa00a8309940a15930391a;      // 1.0015 ** 128
    uint256 internal constant FACTOR09 = 0xae6b7961714e20548d88ea5123f9a0ff;      // 1.0015 ** 256
    uint256 internal constant FACTOR10 = 0x76d6461f27082d74e0feed3b388c0ca1;      // 1.0015 ** 512
    uint256 internal constant FACTOR11 = 0x372a3bfe0745d8b6b19d985d9a8b85bb;      // 1.0015 ** 1024
    uint256 internal constant FACTOR12 = 0x0be32cbee48979763cf7247dd7bb539d;      // 1.0015 ** 2048
    uint256 internal constant FACTOR13 = 0x8d4f70c9ff4924dac37612d1e2921e;      // 1.0015 ** 4096
    uint256 internal constant FACTOR14 = 0x4e009ae5519380809a02ca7aec77;      // 1.0015 ** 8192
    uint256 internal constant FACTOR15 = 0x17c45e641b6e95dee056ff10;      // 1.0015 ** 16384
    uint256 internal constant FACTOR16 = 0x0234df96a9058b8e;      // 1.0015 ** 32768

    // The minimum value that can be returned from #getRatioAtTick. Equivalent to getRatioAtTick(MIN_TICK)
    uint256 internal constant MIN_RATIOX96 = 37019542;
    // The maximum value that can be returned from #getRatioAtTick. Equivalent to getRatioAtTick(MAX_TICK)
    uint256 internal constant MAX_RATIOX96 =
        169561839080424764793230651497174835072620786440549; // TODO: calculate this after building the getRatioAtTick(MAX_TICK) function

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
            if gt(absTick_, MAX_TICK) {
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

            if iszero(lt(factor_, 2140171293886774000000000000000000000000)) {
                tick := or(tick, 0x8000)
                factor_ := div(mul(factor_, _1E18), 2140171293886774000000000000000000000000)
            }
            if iszero(lt(factor_, 46261985407965080000000000000)) {
                tick := or(tick, 0x4000)
                factor_ := div(mul(factor_, _1E18), 46261985407965080000000000000)
            }
            if iszero(lt(factor_, 215085995378511500000000)) {
                tick := or(tick, 0x2000)
                factor_ := div(mul(factor_, _1E18), 215085995378511500000000)
            }
            if iszero(lt(factor_, 463773646705493100000)) {
                tick := or(tick, 0x1000)
                factor_ := div(mul(factor_, _1E18), 463773646705493100000)
            }
            if iszero(lt(factor_, 21535404493658640000)) {
                tick := or(tick, 0x800)
                factor_ := div(mul(factor_, _1E18), 21535404493658640000)
            }
            if iszero(lt(factor_, 4640625442077678000)) {
                tick := or(tick, 0x400)
                factor_ := div(mul(factor_, _1E18), 4640625442077678000)
            }
            if iszero(lt(factor_, 2154211095059552000)) {
                tick := or(tick, 0x200)
                factor_ := div(mul(factor_, _1E18), 2154211095059552000)
            }
            if iszero(lt(factor_, 1467723098905087000)) {
                tick := or(tick, 0x100)
                factor_ := div(mul(factor_, _1E18), 1467723098905087000)
            }
            if iszero(lt(factor_, 1211496223231870000)) {
                tick := or(tick, 0x80)
                factor_ := div(mul(factor_, _1E18), 1211496223231870000)
            }
            if iszero(lt(factor_, 1100679891354371000)) {
                tick := or(tick, 0x40)
                factor_ := div(mul(factor_, _1E18), 1100679891354371000)
            }
            if iszero(lt(factor_, 1049132923587078000)) {
                tick := or(tick, 0x20)
                factor_ := div(mul(factor_, _1E18), 1049132923587078000)
            }
            if iszero(lt(factor_, 1024271899247010000)) {
                tick := or(tick, 0x10)
                factor_ := div(mul(factor_, _1E18), 1024271899247010000)
            }
            if iszero(lt(factor_, 1012063189354799999)) {
                tick := or(tick, 0x8)
                factor_ := div(mul(factor_, _1E18), 1012063189354799999)
            }
            if iszero(lt(factor_, 1006013513505062000)) {
                tick := or(tick, 0x4)
                factor_ := div(mul(factor_, _1E18), 1006013513505062000)
            }
            if iszero(lt(factor_, 1003002250000000000)) {
                tick := or(tick, 0x2)
                factor_ := div(mul(factor_, _1E18), 1003002250000000000)
            }
            if iszero(lt(factor_, 1001500000000000000)) {
                tick := or(tick, 0x1)
            }
            if cond {
                tick := add(not(tick), 1)
            }
        }
    }
}