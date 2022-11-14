// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract Base {
    address public owner;
    uint public foo;

    constructor(address _owner, uint _foo) payable {
        owner = _owner;
        foo = _foo;
    }
}