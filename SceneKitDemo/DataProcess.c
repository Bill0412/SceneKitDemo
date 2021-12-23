//
//  DataProcess.c
//  SceneKitDemo
//
//  Created by Fenghe Xu on 2021/12/22.
//

#include "DataProcess.h"

void updatePositions(simd_float3* arr, int arrSize) {
    for(int i = 0; i < arrSize; ++i) {
        arr[i][1] += 0.01; // move the whole shape up
    }
}
