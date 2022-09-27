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
        Factory = await ethers.getContractFactory('OptimizerTest')
        Contract = await Factory.deploy()
        console.log(Contract.address);

    })

    it("testing...", async function () {

        // We get an instance of the USDC contract
        const [ owner ] = await ethers.getSigners();
        let tx = await Contract.connect(owner).store(1, 0, 1);
        await tx.wait()
        const val1 = await Contract.restore(0, 1)
        console.log("====================1,=============",val1)

        tx = await Contract.connect(owner).store(3, 1, 2);
        await tx.wait()
        const val2 = await Contract.restore(1, 2)
        console.log("====================3,=============",val2)

        tx = await Contract.connect(owner).store(98431, 3, 17);
        await tx.wait()
        let val3 = await Contract.restore(3, 17)
        console.log("====================98431,=============",val3)

        tx = await Contract.connect(owner).store(8888888, 3, 25);
        await tx.wait()
        val3 = await Contract.restore(3, 25)
        console.log("====================8888888,=============",val3)

        tx = await Contract.connect(owner).store(123456789, 45, 26);
        await tx.wait()
        val3 = await Contract.restore(45, 71)
        console.log("====================123456789,=============",val3)
    });
});