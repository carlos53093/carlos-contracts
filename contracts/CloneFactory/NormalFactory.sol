// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Base.sol";

contract NormalFactory {
    event Deployed(address addr, uint salt);
    event GasFee(uint256);

    function deploy(address _owner) public {
        Base b = new Base();
        uint256 initialGas = gasleft();
        // b.setOwner(_owner);
        b.getOwner();
        emit GasFee(initialGas - gasleft());
    }
}