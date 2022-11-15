// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Base.sol";

contract NormalFactory {
    event Deployed(address addr, uint salt);
    event GasFee(uint256);

    function deploy(address _owner, uint _foo) public {
        Base b = new Base(_owner, _foo);
        uint256 initialGas = gasleft();
        // uint foo = b.getFoo(); 
        // b.setFoo(100);
        b.setOwner(0xf827c3E5fD68e78aa092245D442398E12988901C);
        emit GasFee(initialGas - gasleft());
    }
}