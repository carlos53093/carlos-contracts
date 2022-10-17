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

        // We get an instance of the contract
        // const [ owner ] = await ethers.getSigners();
        // let tx;
        // // let tx = await Contract.connect(owner).NumberToBigNum("8587934592");
        // // console.log("====================1,=============",tx)

        // // tx = await Contract.connect(owner).NumberToBigNumAsm("8587934592");
        // // console.log("====================1,=============",tx)

        // // tx = await Contract.connect(owner).NumberToBigNumAsm2("8587934592");
        // // console.log("====================1,=============",tx)
        // // const val1 = await Contract.mulDivNormal("2332387983773948", "9793278532989823979898", "6327987932873948")
        // // console.log("==============mulDivNormal=============", val1)

        // // const val2 = await Contract.mulDivNormal2("2332387983773948", "570043835946", "772459464469")
        // // console.log("====================mulDivNormal2,=============",val2)


        // // const val3 = await Contract.mulDivNormal3("2332387983773948", "570043835946", "772459464469")
        // // console.log("==============mulDivNormal=============", val3)

        // // const val4 = await Contract.mulDivNormal4("2332387983773948", "570043835946", "772459464469")
        // // console.log("==============mulDivNormal=============", val4)

        // // const val5 = await Contract.mulDivNormal5("2332387983773948", "570043835946", "772459464469")
        // // console.log("==============mulDivNormal=============", val5)

        // // const val6 = await Contract.mulDivNormal6("2332387983773948", "570043835946", "772459464469")
        // // console.log("==============mulDivNormal=============", val6)

        // // const val7 = await Contract.mulDivNormal7("2332387983773948", "570043835946", "772459464469")
        // // console.log("==============mulDivNormal=============", val7)

        // // const tt1 = await Contract.NumberToBigNumAsm2("24448551293836797297757950")
        // // // const tt2 = await Contract.NumberToBigNumAsm2("3948179283")

        // // console.log(tt1)
        // // console.log(tt2)

        // // const aaa = await Contract.NumberToBigNumAsm2("4")
        // // console.log(aaa)

        // // const test1 = await Contract.mulDivBignumber("572283163178", "9817912874298", "3948179283")
        // // console.log(test1)

        // // const test2 = await Contract.mulDivBignumberAsm("572283163178", "9817912874298", "3948179283")
        // // console.log(test2)

        let test3 = await Contract.getRatioAtTick("0")
        console.log(test3)
        let test4 = await Contract.getTickAtRatio(test3.res.toString())
        console.log(test4)

        test3 = await Contract.getRatioAtTick("234")
        console.log(test3)
        test4 = await Contract.getTickAtRatio(test3.res.toString())
        console.log(test4)

        test3 = await Contract.getRatioAtTick("999")
        console.log(test3)
        test4 = await Contract.getTickAtRatio(test3.res.toString())
        console.log(test4)

        test3 = await Contract.getRatioAtTick("-987")
        console.log(test3)
        test4 = await Contract.getTickAtRatio(test3.res.toString())
        console.log(test4)

        test3 = await Contract.getRatioAtTick("-1")
        console.log(test3)
        test4 = await Contract.getTickAtRatio(test3.res.toString())
        console.log(test4)

        test3 = await Contract.getRatioAtTick("443635")
        console.log(test3)
        test4 = await Contract.getTickAtRatio(test3.res.toString())
        console.log(test4)

        test3 = await Contract.getRatioAtTick("-443635")
        console.log(test3)
        test4 = await Contract.getTickAtRatio(test3.res.toString())
        console.log(test4)
    });
});