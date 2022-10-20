// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.12;
import "./libs_asm/Optimizer.sol";
import "./libs_normal/Optimizer.sol";

contract OptimizerSimulator {
    
    function store(uint store_, uint256 value, uint8 offset, uint8 size) external view returns(uint256 resAsm, uint res, uint256 gasUsedAsm, uint gasUsed) {
        uint256 initialGas = gasleft();
        res = OptimizerNormal.storeNumber(store_, value, offset, size);
        gasUsed = initialGas - gasleft();

        initialGas = gasleft();
        resAsm = Optimizer.storeNumber(store_, value, offset, size);
        gasUsedAsm = initialGas - gasleft();
    }

    function restore(uint store_, uint8 offset, uint8 size) external view returns(uint256 resAsm, uint256 res, uint256 gasUsedAsm, uint256 gasUsed) {
        uint256 initialGas = gasleft();
        res = OptimizerNormal.restoreNumber(store_, offset, size);
        gasUsed = initialGas - gasleft();

        initialGas = gasleft();
        resAsm = Optimizer.restoreNumber(store_, offset, size);
        gasUsedAsm = initialGas - gasleft();
    }
    
}
