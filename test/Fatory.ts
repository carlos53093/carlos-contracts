import { ethers } from "hardhat";
import { BigNumber } from "ethers";
import { expect } from "chai";

let Contract
let Factory

let Contract2
let Factory2

let Contract3
let Factory3

let Contract4
let Factory4

describe("Factory", function () {
    // beforeEach(async function () {
    //     Factory = await ethers.getContractFactory('FactoryAssembly')
    //     Contract = await Factory.deploy()

    //     Factory2 = await ethers.getContractFactory('MinimalProxy')
    //     Contract2 = await Factory2.deploy()

    //     Factory3 = await ethers.getContractFactory('Base')
    //     Contract3 = await Factory3.deploy("0xf827c3E5fD68e78aa092245D442398E12988901C", "100")

    //     Factory4 = await ethers.getContractFactory('NormalFactory')
    //     Contract4 = await Factory4.deploy()
    // })

    // it("testing...", async function () {

    //     let test;
    //     test = await Contract2.clone(Contract3.address)
    //     test = await test.wait();
    //     // console.log("Normal Factory",test.logs[0].data)
    //     console.log("Minimal Factory",ethers.BigNumber.from(test.logs[0].data).toString())
    //     console.log("Log================", test.logs[1].data)
    //     // test = await Contract.deploy("0xf827c3E5fD68e78aa092245D442398E12988901C", "100", "1")
    //     // test = await test.wait();
    //     // // console.log("Minimal Factory", test.logs[0].data)
    //     // console.log("Factory", ethers.BigNumber.from(test.logs[0].data).toString())

    //     test = await Contract4.deploy("0xf827c3E5fD68e78aa092245D442398E12988901C", "1000")
    //     test = await test.wait();
    //     // console.log("Minimal Factory", test.logs[0].data)
    //     console.log("Normal clone", ethers.BigNumber.from(test.logs[0].data).toString())


    //     test = await Contract3.setFoo("123");
    //     test = await test.wait();
    //     // console.log("Log================", ethers.BigNumber.from(test.logs[0].data).toString())
    //     // test = await Contract3.getFoo()
    //     // console.log(test.toString())


    // });
});