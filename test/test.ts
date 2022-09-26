/* eslint-disable @typescript-eslint/no-inferrable-types */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable prettier/prettier */
// eslint-disable-next-line prettier/prettier
import { ethers } from "hardhat";
import { BigNumber } from "ethers";
import { expect } from "chai";

let Contract
let Factory

let NormalContract
let NormalFactory

describe("Optimizer", function () {
    beforeEach(async function () {
        Factory = await ethers.getContractFactory('OptimizerTest')
        Contract = await Factory.deploy()
        console.log(Contract.address);

        NormalFactory = await ethers.getContractFactory('Normal')
        NormalContract = await NormalFactory.deploy()
        console.log(Contract.address);
    })

    it("testing...", async function () {

        // We get an instance of the USDC contract
        const [ owner ] = await ethers.getSigners();
        let tx = await Contract.connect(owner).store(1, 0);
        await tx.wait()
        tx = await Contract.connect(owner).store(3, 1);
        await tx.wait()
        tx = await Contract.connect(owner).store(98431, 3);
        await tx.wait()
        tx = await Contract.connect(owner).store(8888888, 20);
        await tx.wait()
        tx = await Contract.connect(owner).store(123456789, 44);
        await tx.wait()
        tx = await Contract.connect(owner).store(1, 72);
        await tx.wait()

        const val1 = await Contract.restore(0, 1)
        console.log(val1)
        const val2 = await Contract.restore(1, 2)
        console.log(val2)
        let val3 = await Contract.restore(3, 17)
        console.log(val3)
        val3 = await Contract.restore(20, 25)
        console.log(val3)
        val3 = await Contract.restore(45, 71)
        console.log(val3)
        val3 = await Contract.restore(71, 1)
        console.log(val3)

        tx = await NormalContract.connect(owner).store(1);
        await tx.wait()
        tx = await NormalContract.connect(owner).store(3);
        await tx.wait()
        tx = await NormalContract.connect(owner).store(98431);
        await tx.wait()
        tx = await NormalContract.connect(owner).store(8888888);
        await tx.wait()
        tx = await NormalContract.connect(owner).store(123456789);
        await tx.wait()
        tx = await NormalContract.connect(owner).store(1);
        await tx.wait()

        const val4 = await NormalContract.restore(0)
        console.log(val4)
        const val5 = await NormalContract.restore(1)
        console.log(val5)
        let val6 = await NormalContract.restore(2)
        console.log(val6)
        val6 = await NormalContract.restore(3)
        console.log(val6)
        val6 = await NormalContract.restore(4)
        console.log(val6)
        val6 = await NormalContract.restore(5)
        console.log(val6)
    });
});