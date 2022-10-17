# Benchmark

 ## OptimizerTest contract

| mode | gasfee in store | gasfee in restore |
| ------ | ------ | ------ |
| using bitwise operation |  276 | 249 |
| using bitwise operation using uint8 (remove if conditions) |  211 | 186 |
| using assembly |  186 | 162 |
| using uint8 instead of uint256 (remove if conditions) |  60 | 45 |
| using uint256 (remove if conditions) |  60 | 45 |
| **when not matching params type** |  108 | 81 |


When using assembly for if conditions were also efficient but no more than using uint8 instead of uint256.
When using uint8, we don't need to use require statement.
When not using require statement the gas fee of restore() funtion was 100 and store() function was 0.

**function storeNumber(uint256 store, uint256 value, uint8 offset, uint8 size) internal pure returns(uint256);**<br>
**function restoreNumber(uint256 store, uint8 offset, uint8 size) internal pure returns(uint256);** 
are the most efficient in final.

I pushed it into new file "FOptimizer.sol"

You can check it in this file

**when not matching params type it led to gasfee higher.**

**For example:**

![vmplayer_mSM5qWhIXY](https://user-images.githubusercontent.com/94333672/193109482-bd565e77-1dd1-404f-bc1b-5f1be4f5b4bb.png)


 ## ConverterTest contract


 | function name | gas fee |
| ------ | ------ |
| N2B |  451 |
| B2N |  16 |
| decompileBigNumber |  38 |
| mulDivNormal |  187 |
| mulDivBignumber |  974 |
| mulDivBignumberAsm |  659 |
| mulDivBignumberAsm2 |  613 |

 <br/>
 
 ## TickMathLib Library

| function name | Param | gas fee |
| ------ | ------ | ------ |
| getRatioAtTick | 443635(max op) | 3214 |
| getRatioAtTickAsm | 443635(max op) | 994 |
| getRatioAtTick | -443635 | 3266 |
| getRatioAtTickAsm | -443635 | 997 |
| getRatioAtTick | 1 | 891 |
| getRatioAtTickAsm | 1 | 788 |


| tick | ratio | tick |
| ------ | ------ | ------ |
| 0 | 79228162514264337593543950336 | 0 |
| 1 | 79236085330515764027303304732 | 1 |
| 2 | 79244008939048815603706035062 | 2 |
| 4 | 79259858533276714757314932306 | 3 |
| 8 | 79291567232598584799939703905 | 7 |
| 16 | 79355022692464371645785046467 | 15 |
| 32 | 79482085999252804386437311142 | 31 |

- using ethers constants

| tick | ratio | tick |
| ------ | ------ | ------ |
| 0 | 79228162514264337593543950336 | 0 |
| 1 | 79236085330515764027303304732 | 1 |
| 2 | 79244008939048815603706035062 | 2 |
| 4 | 79259858533276714757314932306 | 4 |
| 8 | 79291567232598584799939703905 | 7 |
| 16 | 79355022692464371645785046467 | 15 |
| 32 | 79482085999252804386437311142 | 31 |
| 223 | 79482085999252804386437311142 | 222 |
| -223 | 79482085999252804386437311142 | -222 |
| -5 | 79482085999252804386437311142 | -4 |