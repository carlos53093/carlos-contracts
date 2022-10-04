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

 | mode | N2B | B2N |
| ------ | ------ | ------ |
| using mostSignificantBit |  832 | 16 |
| using mostSignificantBitUsingAssembly |  651 | 16 |
| using mostSignificantBitUsingAssembly logic directly |  617 | 16 |
| using "lastBit_ := 0x80" instead of "lastBit_ := add(lastBit_, 0x80)" |  617 | 16 |
| using N2BWithMostSignificantBitUsingAssemblyTwo |  **451** | 16 |


 | function name | gas fee |
| ------ | ------ |
| using mulDivNormal |  1281 |
| using mulDivNormal2 |  489 |
| using mulDivNormal3 |  313 |
| using mulDivNormal4 |  280 |
| using mulDivNormal5 |  214 |
| using mulDivNormal6(using commonMask var) |  227 |
| using mulDivNormal7 |  199 |


**decompileBigNumber** gas fee is **77** for now