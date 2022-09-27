// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;


library Optimizer{
    error InvalidOffset();
    error InvalidSize();
    function storeNumber(uint256 store, uint256 value, uint256 offset, uint256 size) internal pure returns(uint256) {
        if(offset>=256) {
            revert InvalidOffset();
        }
        if(size>=256 || size==0) {
            revert InvalidSize();
        }
        value <<= offset;
        store &= ( ~(((1 << size) - 1) << offset) );
        return store |= value;
    }

    function restoreNumber(uint256 store, uint256 offset, uint256 size) internal pure returns(uint256) {
        if(offset>=256) {
            revert InvalidOffset();
        }
        if(size>=256 || size==0) {
            revert InvalidSize();
        }
        store>>=offset;
        return store &= ((1 << size) - 1);
    }
}

contract OptimizerTest {
    using Optimizer for uint256;
    
    uint256 _store;

    function store(uint256 value, uint256 offset, uint256 size) external {
        _store = _store.storeNumber(value, offset, size);
    }

    function restore(uint256 offset, uint256 size) external view returns(uint256) {
        uint tmp = _store;
        return tmp.restoreNumber(offset, size);
    }
}
