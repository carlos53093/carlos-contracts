// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Base.sol";

contract NormalFactory {
    event Deployed(address addr, uint salt);
    event GasFee(uint256);

    function deploy(address _owner, uint _foo) public {
        uint256 initialGas = gasleft();
        new Base(_owner, _foo);
        emit GasFee(initialGas - gasleft());
    }
}