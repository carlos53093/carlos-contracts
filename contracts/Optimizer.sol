// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;

library Optimizer{
    function storeNumber(uint256 store, uint256 value, uint256 offset) internal pure returns(uint256) {
        require(offset<256, "1");
        value <<= offset;
        store = store | value;
        return store;
    }

    function restoreNumber(uint256 store, uint256 offset, uint256 size) internal pure returns(uint256) {
        require(offset<256, "1");
        require(size<256, "2");
        uint tmp = store;
        tmp>>=offset;
        tmp = tmp & (2 ** size - 1);
        return tmp;
    }
}

contract OptimizerTest {
    using Optimizer for uint256;
    
    uint256 _store;

    function store(uint256 value, uint256 offset) external {
        _store = _store.storeNumber(value, offset);
    }

    function restore(uint256 offset, uint256 size) external view returns(uint256) {
        return _store.restoreNumber(offset, size);
    }
}
