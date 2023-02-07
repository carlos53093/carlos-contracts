// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;

library TickMathNormal2 {
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
     * @notice ratioX96 = (1.0015^tick) * 2^96
     * @dev Throws if |tick| > max tick
     * @param tick The input tick for the above formula
     * @return ratioX96 ratio = (debt amount/collateral amount)
     */
    function getRatioAtTick(int24 tick)
        internal
        pure
        returns (uint256 ratioX96)
    {
        uint256 absTick_ = tick < 0
            ? uint256(-int256(tick))
            : uint256(int256(tick));
        require(absTick_ <= uint24(MAX_TICK), "T");

        uint256 factor_ = absTick_ & 0x1 != 0 ? FACTOR01 : FACTOR00;
        // TODO: @Vaibhav why not keep division as 1e18 in all as division has a constant gas no matter the number. Right?
        // Or even better just shift the bits similar to Uniswap?
        if (absTick_ & 0x2 != 0) factor_ = (factor_ * FACTOR02) >> 128; // 1.0015 ** 2
        if (absTick_ & 0x4 != 0) factor_ = (factor_ * FACTOR03) >> 128; // 1.0015 ** 4
        if (absTick_ & 0x8 != 0) factor_ = (factor_ * FACTOR04) >> 128; // 1.0015 ** 8
        if (absTick_ & 0x10 != 0) factor_ = (factor_ * FACTOR05) >> 128; // 1.0015 ** 16

        // TODO - update the factors according to new logics: factor => (uint256.max / ((1.0015 ** tick) << 128))
        if (absTick_ & 0x20 != 0) factor_ = (factor_ * FACTOR06) >> 128; // 1.0015 ** 32
        if (absTick_ & 0x40 != 0) factor_ = (factor_ * FACTOR07) >> 128; // 1.0015 ** 64
        if (absTick_ & 0x80 != 0) factor_ = (factor_ * FACTOR08) >> 128; // 1.0015 ** 128
        if (absTick_ & 0x100 != 0) factor_ = (factor_ * FACTOR09) >> 128; // 1.0015 ** 256
        if (absTick_ & 0x200 != 0) factor_ = (factor_ * FACTOR10) >> 128; // 1.0015 ** 512
        if (absTick_ & 0x400 != 0) factor_ = (factor_ * FACTOR11) >> 128; // 1.0015 ** 1024
        if (absTick_ & 0x800 != 0) factor_ = (factor_ * FACTOR12) >> 128; // 1.0015 ** 2048
        if (absTick_ & 0x1000 != 0) factor_ = (factor_ * FACTOR13) >> 128; // 1.0015 ** 4096
        if (absTick_ & 0x2000 != 0) factor_ = (factor_ * FACTOR14) >> 128; // 1.0015 ** 8192
        if (absTick_ & 0x4000 != 0) factor_ = (factor_ * FACTOR15) >> 128; // 1.0015 ** 16384
        if (absTick_ & 0x8000 != 0) factor_ = (factor_ * FACTOR16) >> 128; // 1.0015 ** 32768

        uint256 precision_ = 0;
        if (tick > 0) {
            factor_ = type(uint256).max / factor_;

            // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
            precision_ = factor_ % (1 << 32) == 0 ? 0 : 1;
        }

        ratioX96 = (factor_ >> 32) + precision_;
    }

       /**
     * @notice ratioX96 = (1.0015^tick) * 2^96
     * @dev Throws if ratioX96 > max ratio || ratioX96 < min ratio
     * @param ratioX96 The input ratio; ratio = (debt amount/collateral amount)
     * @return tick The output tick for the above formula
     */
    function getTickAtRatio(uint256 ratioX96)
        internal
        pure
        returns (int24 tick)
    {
        require(ratioX96 >= MIN_RATIOX96 && ratioX96 <= MAX_RATIOX96, "R");
        uint256 factor_;
        if (ratioX96 >= ZEROTICKSCALEDRATIO) {
            factor_ = (ratioX96 * 1e18) / ZEROTICKSCALEDRATIO;
        } else {
            factor_ = (ZEROTICKSCALEDRATIO * 1e18) / ratioX96;
        }

        /// TODO: Fix the updated according to the below structure

        if (factor_ >= 2140171293886774000000000000000000000000) {
            tick |= 0x8000;
            factor_ = (factor_) * 1e18 / 2140171293886774000000000000000000000000;
        }
        if (factor_ >= 46261985407965080000000000000) {
            tick |= 0x4000;
            factor_ = (factor_) * 1e18 / 46261985407965080000000000000;
        }
        if (factor_ >= 215085995378511500000000) {
            tick |= 0x2000;
            factor_ = (factor_) * 1e18 / 215085995378511500000000;
        }
        if (factor_ >= 463773646705493100000) {
            tick |= 0x1000;
            factor_ = (factor_) * 1e18 / 463773646705493100000;
        }
        if (factor_ >= 21535404493658640000) {
            tick |= 0x800;
            factor_ = (factor_) * 1e18 / 21535404493658640000;
        }
        if (factor_ >= 4640625442077678000) {
            tick |= 0x400;
            factor_ = (factor_) * 1e18 / 4640625442077678000;
        }
        if (factor_ >= 2154211095059552000) {
            tick |= 0x200;
            factor_ = (factor_) * 1e18 / 2154211095059552000;
        }
        if (factor_ >= 1467723098905087000) {
            tick |= 0x100;
            factor_ = (factor_) * 1e18 / 1467723098905087000;
        }
        if (factor_ >= 1211496223231870000) {
            tick |= 0x80;
            factor_ = (factor_) * 1e18 / 1211496223231870000;
        }
        if (factor_ >= 1100679891354371000) {
            tick |= 0x40;
            factor_ = (factor_) * 1e18 / 1100679891354371000;
        }
        if (factor_ >= 1049132923587078000) {
            tick |= 0x20;
            factor_ = (factor_) * 1e18 / 1049132923587078000;
        }
        if (factor_ >= 1024271899247010000) {
            tick |= 0x10;
            factor_ = (factor_) * 1e18 / 1024271899247010000;
        }
        if (factor_ >= 1012063189354799999) { // -1
            tick |= 0x8;
            factor_ = (factor_) * 1e18 / 1012063189354799999;
        }

        if (factor_ >= 1006013513505062000) {
            tick |= 0x4;
            factor_ = (factor_) * 1e18 / 1006013513505062000;
        }
        if (factor_ >= 1003002250000000000) {
            tick |= 0x2;
            factor_ = (factor_ * 1e18) / 1003002250000000000;
        }
        if (factor_ >= 1.0015 * 1e18) {
            tick |= 0x1;
        }

        if (ratioX96 < ZEROTICKSCALEDRATIO) {
            tick = -tick;
        }
    }
}