// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract MinimalProxy {
    event GasFee(uint256);
    event Data(bool, bytes);
    function clone(address target) external returns (address result) {
        // convert address to 20 bytes
        
        bytes20 targetBytes = bytes20(target);

        assembly {
            /*
            reads the 32 bytes of memory starting at pointer stored in 0x40

            In solidity, the 0x40 slot in memory is special: it contains the "free memory pointer"
            which points to the end of the currently allocated memory.
            */
            let clone := mload(0x40)
            // store 32 bytes to memory starting at "clone"
            mstore(
                clone,
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )

            mstore(add(clone, 0x14), targetBytes)
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
            result := create(0, clone, 0x37)
        }
        uint256 initialGas = gasleft();
        (bool success, bytes memory data) = result.delegatecall(
            abi.encodeWithSignature("setOwner(address)", 0xf827c3E5fD68e78aa092245D442398E12988901C)
        );
      emit GasFee(initialGas - gasleft());
      emit Data(success, data);
    }
}
