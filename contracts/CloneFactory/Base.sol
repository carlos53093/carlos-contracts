// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract Base {
    uint public a;
    address public owner;

    function getOwner() external view returns(address) {
        return owner;
    }

    function setOwner(address _newOwner) external {

        owner = _newOwner;
    }

    function getA() external view returns(uint) {
        return a;
    }

    function setA(uint _a) external {
        a = _a;
    }
}