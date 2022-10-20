import { ethers } from "hardhat";
import { BigNumber } from "ethers";
import { expect } from "chai";

let Contract
let Factory

describe("Converter", function () {
    beforeEach(async function () {
        Factory = await ethers.getContractFactory('TConverterSimulator')
        Contract = await Factory.deploy()
    })

    it("testing...", async function () {

        let test;
        // for(let i = 0; i < 10; i++) {
        //     const exponent = Math.round(Math.random() * 256)
        //     test  = ethers.BigNumber.from(2).pow(exponent);
        //     test = await Contract.N2B(test.toString())
        //     console.log("======N2B=====", "2**",exponent, test)
        // }
        // console.log("================== =====================")
        // test = await Contract.B2N(1556798,12)
        // console.log("======N2B=====","Input value 15, 12,", test)

        // test = await Contract.B2N(21356479,31)
        // console.log("======N2B=====","Input value 15, 12,", test)
        // console.log("================== =====================")
        // for(let i = 0; i < 10; i++) {
        //     let exponent1 = Math.round(Math.random() * 223)
        //     const number = ethers.BigNumber.from(2).pow(exponent1);
        //     let _bigNumber1: any = Math.round(Math.random() * 4294967296)
        //     let exponent2: any = Math.round(Math.random() * 255)
        //     _bigNumber1 = ethers.BigNumber.from(_bigNumber1).mul(ethers.BigNumber.from(2).pow(8)).add(exponent2)
        //     let _bigNumber2:any = Math.round(Math.random() * 4294967296)
        //     let exponent3: any = Math.round(Math.random() * 255)
        //     _bigNumber2 = ethers.BigNumber.from(_bigNumber2).mul(ethers.BigNumber.from(2).pow(8)).add(exponent3)
        //     console.log("======mulDivNormal=====", number.toString(), _bigNumber1.toString(), _bigNumber2.toString())
        //     test = await Contract.mulDivNormal(number.toString(), _bigNumber1.toString(), _bigNumber2.toString())
        //     console.log(test)
        // }

            test = await Contract.mulDivBignumber("86575854077", "8796093022208", "5986310706507378352962293074805895248510699696029696")
            console.log("asdfasdfasdf==========================================================",test)

        // for(let i = 0; i < 10; i++) {
        //     let _bigNumber1: any = Math.round(Math.random() * 4294967296)
        //     let exponent2: any = Math.round(Math.random() * 255)
        //     _bigNumber1 = ethers.BigNumber.from(_bigNumber1).mul(ethers.BigNumber.from(2).pow(8)).add(exponent2)

        //     console.log("======decompileBigNumber=====", _bigNumber1.toString())
        //     test = await Contract.decompileBigNumber(_bigNumber1.toString())
        //     console.log(test)
        // }

        // for(let i = 0; i < 10; i++) {
        //     let _bigNumber1: any = Math.round(Math.random() * 255)
        //     _bigNumber1 = ethers.BigNumber.from(2).pow(_bigNumber1)
        //     console.log("======mostSignificantBit=====", _bigNumber1.toString())
        //     test = await Contract.mostSignificantBit(_bigNumber1.toString())
        //     console.log(test)
        // }

        // for(let i = 0; i < 10; i++) {
            
        //     let _bigNumber1: any = Math.round(Math.random() * 4294967296)
        //     let exponent2: any = Math.round(Math.random() * 255)
        //     _bigNumber1 = ethers.BigNumber.from(_bigNumber1).mul(ethers.BigNumber.from(2).pow(8)).add(exponent2)

        //     let exponent1 = Math.round(Math.random() * 223)
        //     const number1 = ethers.BigNumber.from(2).pow(exponent1);
        //     exponent1 = Math.round(Math.random() * 223)
        //     const number2 = ethers.BigNumber.from(2).pow(exponent1);
        //     console.log(_bigNumber1.toString(),number1.toString(),number2.toString())
        //     test = await Contract.mulDivBignumber(_bigNumber1.toString(),number1.toString(),number2.toString() )
        //     console.log(test)
        // }

    });
});