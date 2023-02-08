import { ethers } from "hardhat";
// import { BigNumber } from "ethers";
import { expect } from "chai";
import BigNumber from "bignumber.js";

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

        for (let i = 0; i < 16; i++) {
            let tick = 2 ** i
            console.log("tick=",tick)
            test = await Contract.getRatioAtTick2(tick);
            const ratio = new BigNumber(1.0015).pow(tick)
            console.log("1.0015 ** ",tick, "         = ", ratio.toFixed(20))
            const r = new BigNumber((test.res).toString()).dividedBy(new BigNumber(2).pow(96));
            console.log("getRatioFromTick(",tick, ") = ", r.toFixed(20))
            // expect(ratio).to.be.equal(new BigNumber((test.res).toString()).dividedBy(new BigNumber(2).pow(96)))
        }

    });
});