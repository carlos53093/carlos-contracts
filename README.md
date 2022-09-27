## Benchmark

    - OptimizerTest contract
        Depolying gasFee => 176671

        1 input value => storeNumber(1, 0), gasFee => 277
        2 input value => storeNumber(3, 1), gasFee => 277
        3 input value => storeNumber(98431, 29), gasFee => 277
        4 input value => storeNumber(8888888, 20), gasFee => 277
        5 input value => storeNumber(123456789, 44), gasFee => 277

        1 input value => restoreNumber(1, 0), gasFee => 250
        2 input value => restoreNumber(3, 1), gasFee => 250
        3 input value => restoreNumber(98431, 29), gasFee => 250
        4 input value => restoreNumber(8888888, 20), gasFee => 250
        5 input value => restoreNumber(123456789, 44), gasFee => 250

    
    So finally gas fee of storeNumber is 277 and gas fee of restoreNumber is 250.

