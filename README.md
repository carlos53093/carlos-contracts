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
| getRatioAtTick | 443635(max op) | 2000 |
| getRatioAtTickAsm | 443635(max op) | 840 |
| getTickAtRatioUpdate | 443635 | 2590 |
| getTickAtRatioAsm | 443635 | 1037 |


 ## Gas Fee For Each Library

 | function name | Input | gas fee |
| ------ | ------ | ------ |
| getRatioAtTick | 262143 (Max Ops) | **938** |
| getTickAtRatio | 19188287740063442132407564769516272930365 | 1303 |
| getRatioAtTick | -262143 | 894 |
| getTickAtRatio | 327131936961767012 (max op) | **1307** |
| N2B | 2**128 | **438** |
| B2N | _any_ | 21 |
| mulDivNormal | "2332387983773948", "9793278532989823979898", "6327987932873948" | 187 |
| decompileBigNumber | 9793278532989823979898 | 38 |
| mostSignificantBit | 9793278532989823979898 | 371 |
| storeNumber | _ | 60 |
| restoreNumber | _ | 45 |