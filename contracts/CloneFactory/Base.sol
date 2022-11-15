// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract Base {
    address public owner;
    uint public foo;

    constructor(address _owner, uint _foo) {
        owner = _owner;
        foo = _foo;
    }

    function getFoo() external view returns(uint256) {
        return foo;
    }

    function setFoo(uint256 _foo) external {
        foo = _foo;
    }

    function getOwner() external view returns(address) {
        return owner;
    }

    function setOwner(address _owner) external {
        owner = _owner;
    }
}