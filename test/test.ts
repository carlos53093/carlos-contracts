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
        Factory = await ethers.getContractFactory('TickMathTest')
        Contract = await Factory.deploy()
        // Factory2 = await ethers.getContractFactory('OptimizerTest')
        // Contract2 = await Factory2.deploy()
    })

    it("testing...", async function () {

        // // We get an instance of the contract
        // const [ owner ] = await ethers.getSigners();
        // let tx;

        const test3 = await Contract.getRatioAtTick("64")
        console.log("====================getRatioAtTick=====================",test3)
        const test = await Contract.getTickAtRatio(test3.toString())
        console.log("==========================getTickAtRatio===================",test)
        
    });
});