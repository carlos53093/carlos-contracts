## Benchmark

Tested in 2 contracts:

    - OptimizerTest contract
        Depolying gasFee => 211814

        1 input value => store(1, 0), gasFee => 43734
        2 input value => store(3, 1), gasFee => 26646
        3 input value => store(98431, 29), gasFee => 26670
        4 input value => store(8888888, 20), gasFee => 26670
        5 input value => store(123456789, 44), gasFee => 26682
        6 input value => store(1, 72), gasFee => 26646

        avg gasFee in calling function => 29508
        total gasFee in calling function 6 times => 177,048


    - Normal contract
        Depolying gasFee => 115165

        1 input value => store(1), gasFee => 65624
        2 input value => store(3), gasFee => 48524
        3 input value => store(98431), gasFee => 48548
        4 input value => store(8888888), gasFee => 48548
        5 input value => store(123456789), gasFee => 48560
        6 input value => store(1), gasFee => 48524

        avg gasFee in calling function => 51388
        total gasFee in calling function 6 times => 308,328

![image](https://user-images.githubusercontent.com/94333672/192351731-ff4749e5-e719-4ec5-8a12-e433f33c290c.png)
