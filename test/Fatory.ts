import { ethers } from "hardhat";
import { BigNumber } from "ethers";
import { expect } from "chai";

let Contract
let Factory

let Contract2
let Factory2

let Contract3
let Factory3

describe("Factory", function () {
    beforeEach(async function () {
        Factory = await ethers.getContractFactory('FactoryAssembly')
        Contract = await Factory.deploy()

        Factory2 = await ethers.getContractFactory('MinimalProxy')
        Contract2 = await Factory2.deploy()

        Factory3 = await ethers.getContractFactory('Base')
        Contract3 = await Factory3.deploy("0xf827c3E5fD68e78aa092245D442398E12988901C", "100")
    })

    it("testing...", async function () {

        let test;
        test = await Contract2.clone(Contract3.address)
        test = await test.wait();
        // console.log("Normal Factory",test.logs[0].data)
        console.log("Minimal Factory",ethers.BigNumber.from(test.logs[0].data).toString())

        test = await Contract.deploy("0xf827c3E5fD68e78aa092245D442398E12988901C", "100", "1")
        test = await test.wait();
        // console.log("Minimal Factory", test.logs[0].data)
        console.log("Normal Factory", ethers.BigNumber.from(test.logs[0].data).toString())

    });
});