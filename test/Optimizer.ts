import { ethers } from "hardhat";
// import { BigNumber } from "ethers";
import { expect } from "chai";
import {BigNumber} from "bignumber.js"

let Contract
let Factory

describe("Converter", function () {
    beforeEach(async function () {
        Factory = await ethers.getContractFactory('OptimizerSimulator')
        Contract = await Factory.deploy()
    })

    it("testing...", async function () {

        let test, store;
        test = await Contract.store(0, 4356, 56, 13)
        console.log(test)
        expect(test.res).to.be.equal(test.resAsm)
        store = test.res
        test = await Contract.restore(store, 56, 13)
        console.log(test)
        expect(test.res).to.be.equal(Number(4356).toString())
        expect(test.res).to.be.equal(test.resAsm)

        test = await Contract.store(0, 888888, 24, 20)
        console.log(test)
        expect(test.res).to.be.equal(test.resAsm)
        store = test.res
        test = await Contract.restore(store, 24, 20)
        console.log(test)
        expect(test.res).to.be.equal(Number(888888).toString())
        expect(test.res).to.be.equal(test.resAsm)

        test = await Contract.store(store, 987654321, 78, 30)
        console.log(test)
        expect(test.res).to.be.equal(test.resAsm)
        store = test.res
        test = await Contract.restore(store, 78, 30)
        console.log(test)
        expect(test.res).to.be.equal(Number(987654321).toString())
        expect(test.res).to.be.equal(test.resAsm)

        test = await Contract.store(store, 84752136954, 56, 37)
        console.log(test)
        expect(test.res).to.be.equal(test.resAsm)
        store = test.res
        test = await Contract.restore(store, 56, 37)
        console.log(test)
        expect(test.res).to.be.equal(Number(84752136954).toString())
        expect(test.res).to.be.equal(test.resAsm)

        test = await Contract.store(store, 4356, 56, 13)
        console.log(test)
        expect(test.res).to.be.equal(test.resAsm)
        store = test.res
        test = await Contract.restore(store, 56, 13)
        console.log(test)
        expect(test.res).to.be.equal(Number(4356).toString())
        expect(test.res).to.be.equal(test.resAsm)
        
    });
});