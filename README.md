## Benchmark

    - OptimizerTest contract
        Depolying gasFee => 176671

        1 input value => storeNumber(1, 0), gasFee => 44078
        2 input value => storeNumber(3, 1), gasFee => 26990
        3 input value => storeNumber(98431, 29), gasFee => 27014
        4 input value => storeNumber(8888888, 20), gasFee => 27014
        5 input value => storeNumber(123456789, 44), gasFee => 27026

        1 input value => restoreNumber(1, 0), gasFee => 329
        2 input value => restoreNumber(3, 1), gasFee => 329
        3 input value => restoreNumber(98431, 29), gasFee => 329
        4 input value => restoreNumber(8888888, 20), gasFee => 329
        5 input value => restoreNumber(123456789, 44), gasFee => 329

        avg gasFee in calling function => 29508
        total gasFee in calling function 6 times => 177,048
