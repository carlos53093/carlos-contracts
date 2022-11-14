// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Base.sol";

contract FactoryAssembly {
    event Deployed(address addr, uint salt);
    event GasFee(uint256);

    // NOTE: _salt is a random number used to create an address
    function getAddress(bytes memory bytecode, uint _salt)
        public
        view
        returns (address)
    {
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode))
        );

        // NOTE: cast last 20 bytes of hash to address
        return address(uint160(uint(hash)));
    }

    function deploy(address _owner, uint _foo, uint _salt) public {
        uint256 initialGas = gasleft();
        bytes memory bytecode = type(Base).creationCode;
        bytecode = abi.encodePacked(bytecode, abi.encode(_owner, _foo));
        address addr;

        /*
        NOTE: How to call create2

        create2(v, p, n, s)
        create new contract with code at memory p to p + n
        and send v wei
        and return the new address
        where new address = first 20 bytes of keccak256(0xff + address(this) + s + keccak256(mem[pâ¦(p+n)))
              s = big-endian 256-bit value
        */
        assembly {
            addr := create2(
                callvalue(), // wei sent with current call
                // Actual code starts after skipping the first 32 bytes
                add(bytecode, 0x20),
                mload(bytecode), // Load the size of code contained in the first 32 bytes
                _salt // Salt from function arguments
            )

            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }

        emit GasFee(initialGas - gasleft());
        emit Deployed(addr, _salt);
    }
}