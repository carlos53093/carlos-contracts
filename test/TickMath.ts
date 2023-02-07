import { ethers } from "hardhat";
import { BigNumber } from "ethers";
import { expect } from "chai";

let Contract
let Factory

describe("Converter", function () {
    beforeEach(async function () {
        Factory = await ethers.getContractFactory('TickMathLibSimulator')
        Contract = await Factory.deploy()
    })

    it("testing...", async function () {

        let test;
        for (let i = 0; i < 20; i++) {
            let tick = Math.random() * 443635 * 2 - 443635
            tick = Math.round(tick)
            test = await Contract.getRatioAtTick(tick);
            expect(test.res).to.be.equal(test.asmres)
            test = await Contract.getTickAtRatio(test.res)
            expect(test.tick).to.be.equal(test.asmtick)
            expect(test.tick).to.be.equal(tick)
        }

        for (let i = 0; i < 17; i++) {
            let tick = Math.random() * 32768 * 2 - 32768
            tick = Math.round(tick)
            test = await Contract.getRatioAtTick2(tick);
            expect(test.res).to.be.equal(test.asmres)
            test = await Contract.getTickAtRatio2(test.res)
            expect(test.tick).to.be.equal(test.asmtick)
            expect(test.tick).to.be.equal(tick)
        }

    });
});