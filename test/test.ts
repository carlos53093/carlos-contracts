/* eslint-disable @typescript-eslint/no-inferrable-types */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable prettier/prettier */
// eslint-disable-next-line prettier/prettier
import { ethers } from "hardhat";
import { BigNumber } from "ethers";
import { expect } from "chai";

let Contract
let Factory

describe("Converter", function () {
    beforeEach(async function () {
        Factory = await ethers.getContractFactory('OptimizerTest')
        Contract = await Factory.deploy()
        console.log(Contract.address);

    })

    it("testing...", async function () {

        // We get an instance of the contract
        const [ owner ] = await ethers.getSigners();
        let tx = await Contract.connect(owner).store(100, 0, 7);
        console.log("====================1,=============",tx)

        const val1 = await Contract.restore(0, 7)
        console.log("====================1,=============",val1)
    });
});