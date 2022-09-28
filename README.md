# Benchmark

 ### OptimizerTest contract

| mode | gasfee in store | gasfee in restore | deploy fee |
| ------ | ------ | ------ | ------ |
| using bitwise operation |  266 | 239 | 147559 |
| using assembly |  189 | 168 | 132919 |
| using uint8 instead of uint256 |  207 | 186 | 151021 |

