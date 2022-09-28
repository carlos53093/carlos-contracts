# Benchmark

 ### OptimizerTest contract

| mode | gasfee in store | gasfee in restore | deploy fee |
| ------ | ------ | ------ | ------ |
| using bitwise operation |  266 | 239 | 147559 |
| using assembly |  189 | 168 | 132919 |
| using uint8 instead of uint256 |  215 | 194 | 151021 |
| using uint8 instead of uint256 (remove requires) |  0 | 0 | 137771 |

