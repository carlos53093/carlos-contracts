# Benchmark

 ### OptimizerTest contract

| mode | gasfee in store | gasfee in restore |
| ------ | ------ | ------ |
| using bitwise operation |  2367 | 2340 |
| using bitwise operation (remove if conditions) |  2314 | 2289 |
| using assembly |  2277 | 2253 |
| using uint8 instead of uint256 (remove if conditions) |  10 | 2184 |

When using assembly for if conditions were also efficient but no more than using uint8 instead of uint256.
When using uint8, we don't need to use require statement.
When not using require statement the gas fee of restore() funtion was 100 and store() function was 0.

**function storeNumber(uint256 store, uint256 value, uint8 offset, uint8 size) internal pure returns(uint256);**<br>
**function restoreNumber(uint256 store, uint8 offset, uint8 size) internal pure returns(uint256);** 
are the most efficient in final.

I pushed it into new file "FOptimizer.sol"

You can check it in this file