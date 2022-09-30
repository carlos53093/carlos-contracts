// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0

// This is the most efficient for gas reduction

pragma solidity ^0.8.12;


library Converter{
    error InvalidLen();
    function mostSignificantBit(uint256 number_) private pure returns (uint8 lastBit_) {
        if (number_ > type(uint128).max) {
            number_ >>= 128;
            lastBit_ += 128;
        }
        if (number_ > type(uint64).max) {
            number_ >>= 64;
            lastBit_ += 64;
        }
        if (number_ > type(uint32).max) {
            number_ >>= 32;
            lastBit_ += 32;
        }
        if (number_ > type(uint16).max) {
            number_ >>= 16;
            lastBit_ += 16;
        }
        if (number_ > type(uint8).max) {
            number_ >>= 8;
            lastBit_ += 8;
        }
        if (number_ > 0xF) {
            number_ >>= 4;
            lastBit_ += 4;
        }
        if (number_ > 0x3) {
            number_ >>= 2;
            lastBit_ += 2;
        }
        if (number_ > 0x1) ++lastBit_;
        if (number_ > 0x0) ++lastBit_;
    }

    function N2B(uint256 normal) internal pure returns(uint256 coefficient, uint256 exponent, uint256 bigNumber) {
        uint8 len = mostSignificantBit(normal);
        assembly{
            if lt(len, 0x20) {  // for throw exception
                len := 0x20
            }
            coefficient := shr(sub(len,0x20), normal)
            exponent := sub(len,0x20)
            bigNumber := add(shl(0x08, coefficient), exponent)
        }
    }

    function B2N(uint256 coefficient, uint256 exponent) internal pure returns(uint256 _number) {
        assembly{
            _number := shl(exponent, coefficient)
        }
    }
}

contract ConverterTest {
    using Converter for uint256;
    
    function NumberToBigNum(uint256 nomal) external view returns (uint256, uint, uint, uint) {
        uint256 initialGas = gasleft();
        (uint256 coefficient, uint256 exponent, uint256 bigNumber ) = nomal.N2B();
        uint256 gasUsed = initialGas - gasleft();
        return (gasUsed, coefficient, exponent, bigNumber);
        
    }

    function BigNumToNum(uint256 coefficient, uint256 exponent) external view returns(uint256, uint) {
        uint256 initialGas = gasleft();
        uint num = Converter.B2N(coefficient, exponent);
        return (initialGas - gasleft(), num);
    }
}
