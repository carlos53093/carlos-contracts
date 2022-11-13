// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract Add3 {
    uint256 ourNumber;
    event GasFee(uint256);

    function initialize() public {
        ourNumber = 0x64;
    }

    function getNumber() public view returns (uint256) {
        return ourNumber;
    }

    function addThree() public {
        uint256 initialGas = gasleft();
        assembly {
            sstore(ourNumber.slot,10)
        }
        initialGas = initialGas - gasleft();
        emit GasFee(initialGas);
    }
}
