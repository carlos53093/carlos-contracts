/* eslint-disable @typescript-eslint/no-inferrable-types */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable prettier/prettier */
// eslint-disable-next-line prettier/prettier
import { ethers } from "hardhat";
import { BigNumber } from "ethers";
import { expect } from "chai";

let Contract
let Factory

let Contract2
let Factory2

describe("Converter", function () {
    beforeEach(async function () {
        Factory = await ethers.getContractFactory('ConverterTest')
        Contract = await Factory.deploy()
        // Factory2 = await ethers.getContractFactory('OptimizerTest')
        // Contract2 = await Factory2.deploy()
    })

    it("testing...", async function () {

        // We get an instance of the contract
        // const [ owner ] = await ethers.getSigners();
        // let tx = await Contract.connect(owner).NumberToBigNum("8587934592");
        // console.log("====================1,=============",tx)

        // tx = await Contract.connect(owner).NumberToBigNumAsm("8587934592");
        // console.log("====================1,=============",tx)

        // tx = await Contract.connect(owner).NumberToBigNumAsm2("8587934592");
        // console.log("====================1,=============",tx)

        const val1 = await Contract.mulDivNormal("2332387983773948", "9793278532989823979898", "6327987932873948")
        console.log("====================1,=============",val1.toString())

        // const val2 = await Contract2.mulDivNormal("2332387983773948", "9793278532989823979898", "6327987932873948")
        // console.log("==============/////////=============", val2)

    });
});