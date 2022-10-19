import { ethers } from "hardhat";
import { BigNumber } from "ethers";
import { expect } from "chai";

let Contract
let Factory

let Contract2
let Factory2

describe("Converter", function () {
    beforeEach(async function () {
        Factory = await ethers.getContractFactory('Benchmark')
        Contract = await Factory.deploy()
        // Factory2 = await ethers.getContractFactory('OptimizerTest')
        // Contract2 = await Factory2.deploy()
    })

    it("testing...", async function () {

        let test = await Contract.getRatioAtTick(262143)
        console.log("======getRatioAtTick=====", 262143, test)
        console.log(test.res.toString())
        test = await Contract.getTickAtRatio(test.res.toString())
        console.log("======getTickAtRatio=====", test)
        test = await Contract.getRatioAtTick(-262143)
        console.log("======getRatioAtTick=====", -262143, test)
        console.log(test.res.toString())
        test = await Contract.getTickAtRatio(test.res.toString())
        console.log("======getTickAtRatio=====", test)
        test  = ethers.BigNumber.from(2).pow(128);
        test = await Contract.N2B(test.toString())
        console.log("======N2B=====", "2**128", test)

        test = await Contract.B2N(10, 6)
        console.log("======B2N=====", test)

        test = await Contract.mulDivNormal("2332387983773948", "9793278532989823979898", "6327987932873948")
        console.log("======mulDivNormal=====", test)

        test = await Contract.decompileBigNumber("9793278532989823979898")
        console.log("======decompileBigNumber=====", test)

        test = await Contract.mostSignificantBit("9793278532989823979898")
        console.log("======mostSignificantBit=====", test)

        // test = await Contract.storeNumber("9793278532989823979898")
        // console.log("======mostSignificantBit=====", test)

        // test = await Contract.restoreNumber("9793278532989823979898")
        // console.log("======mostSignificantBit=====", test)
    });
});