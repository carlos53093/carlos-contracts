# Benchmark

 ## OptimizerTest contract
<br />
1. Function toBigNumber

 | input value | gas fee in normal | gas fee in Asm
| ------ | ------ | ------ |
| 2 ** 249 |  1370 | 524 | 
| 2 ** 251 |  1488 | 542 | 
| 2 ** 166 |  1166 | 492 | 
| 2 ** 66 |  930 | 460 | 
| 2 ** 181 |  1252 | 506 | 
| 2 ** 79 |  1252 | 510 | 
| 2 ** 216 |  1166 | 492 | 
| 2 ** 176 |  1048 | 474 | 

<br />

2. Function fromBigNumber

| input value | gas fee in normal | gas fee in Asm
| ------ | ------ | ------ |
| 1556798, 12 |  21 | 16 |
| 21356479, 31 |  21 | 16 |

<br />

3. mulDivNormal 

| input value | gas fee in normal | gas fee in Asm
| ------ | ------ | ------ |
| 281474976710656, 265046402172, 178478830197 |  187 | 391 |
| 102844034832575377634685573909834406561420991602098741459288064, 1027019694637, 757246257059 |  187 | 381 |
| 73786976294838206464, 573760658354, 207165067338 |  187 | 391 |
| 8796093022208, 399742225182, 282148078136 |  187 | 391 |

<br />

4. decompileBigNumber

| input value | gas fee in normal | gas fee in Asm
| ------ | ------ | ------ |
| 264532943550 |  38 | 38 |
| 851894766435 |  38 | 38 |

<br />

5. mostSignificantBit

| input value | gas fee in normal | gas fee in Asm
| ------ | ------ | ------ |
| 11972621413014756705924586149611790497021399392059392 |  946 | 403 |
| 10141204801825835211973625643008 |  946 | 407 |
| 32768 |  828 | 389 |
| 842498333348457493583344221469363458551160763204392890034487820288 |  1064 | 421 |
| 8 |  592 | 353 |

<br />

6. mulDivBignumber

| input value | gas fee in normal | gas fee in Asm
| ------ | ------ | ------ |
| 1068907126826 39614081257132168796771975168 2 |  1509 | 667 |
| 53905846627 5708990770823839524233143877797980545530986496 618970019642690137449562112 |  1305 | 635 |
| 86575854077 8796093022208 5986310706507378352962293074805895248510699696029696 |  1014 | 1651 |
| 897048098013 2048 144115188075855872 |  1014 | 1651 |
| 188104851293 4 1024 |  1160 | 618 |


 ## ConverterTest contract

| Function Name | gas fee in normal | gas fee in Asm
| ------ | ------ | ------ |
| store | 278 | 42 |
| restore | 303 | 57 |


 <br/>
 
 ## TickMathLib Library

| function name | Input | gas fee in normal | gas fee in Asm
| ------ | ------ | ------ | ------ |
| getRatioAtTick | 426646 | 1804 | 807
| getTickAtRatio | 267272052060619743615293038242434371837443759873 | 2214 | 935
| getRatioAtTick | 243681 | 2106 | 854
| getTickAtRatio | 3028878391613283229097180315929250081113 | 2762 | 1063
| getRatioAtTick | 3053 | 1788 | 812
| getTickAtRatio | 107513514821244845233501614951 | 2762 | 1063
| getRatioAtTick | -210789 | 1886 | 796
| getTickAtRatio | 55576004513528156572 | 2665 | 1028
| getRatioAtTick | -365577 | 1462 | 740
| getTickAtRatio | 10540615953074 | 1953 | 876
| getRatioAtTick | 292805 | 2000 | 840
| getTickAtRatio | 411721347530044828534398204668445426249575 | 2584 | 1025

 <br/>

## GasFee defference between Upgradable and non-Upgradable contract

Tested with addThree() in "./contracts/Proxy_GasFee/Add.sol"

| function name | upgradable | no-upgradable
| ------ | ------ | ------
| addThree | 28216 | 22113

Difference between them is 6,103.

you can check this via here.
https://goerli.etherscan.io/tx/0x6800863f99244aa0d16651d53a876c65110ee19db7ccb45ab28108cb07fac2e2#eventlog
or
https://goerli.etherscan.io/tx/0x7392df38d5c293f692f8d0f54ea9346a7d99b9863f66a8f2334c18ecc6b52728#eventlog

<br />

## GasFee defference between Normal clone and Minimal clone contract

Tested in "./contracts/CloneFactory" directory.

| Minimal Factory | Clone Factory using create2 | Normal Factory
| ------ | ------ | ------ 
| 41143 | 113870 | 112216


