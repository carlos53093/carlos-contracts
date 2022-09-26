// contracts/NFT.sol
// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;

contract Normal {
    uint256[] _store;

    function store(uint256 value) external {
        _store.push(value);
    }

    function restore(uint256 offset) external view returns(uint256) {
        return _store[offset];
    }

}
