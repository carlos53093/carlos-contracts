/* eslint-disable @typescript-eslint/no-inferrable-types */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable prettier/prettier */
// eslint-disable-next-line prettier/prettier
import { ethers } from "hardhat";
import { BigNumber } from "ethers";
import { expect } from "chai";

let Contract
let Factory

describe("Optimizer", function () {
    beforeEach(async function () {
        Factory = await ethers.getContractFactory('Optimizer')
        Contract = await Factory.deploy()
        console.log(Contract.address);
    })

    it("testing...", async function () {

        // We get an instance of the USDC contract
        const [ owner ] = await ethers.getSigners();
        let tx = await Contract.connect(owner).storeNumber(2756, 0);
        await tx.wait()
        tx = await Contract.connect(owner).storeNumber(45678, 13);
        await tx.wait()
        tx = await Contract.connect(owner).storeNumber(98431, 29);
        await tx.wait()

        const val1 = await Contract.restoreNumber(0, 12)
        console.log(val1)
        const val2 = await Contract.restoreNumber(13, 16)
        console.log(val2)
        const val3 = await Contract.restoreNumber(29, 17)
        console.log(val3)
    });
});