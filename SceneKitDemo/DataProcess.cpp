//
//  DataProcess.cpp
//  SceneKitDemo
//
//  Created by Fenghe Xu on 2021/12/23.
//

#include "DataProcess.hpp"
#include <vector>

void updatePositionsUtil(std::vector<simd_float3>& positions) {
    for(auto& position: positions) {
        position[1] += 0.01;
    }
}

void updatePositions(simd_float3* arr, int arrSize) {
    std::vector<simd_float3> positions(arrSize);
    for(int i = 0; i < arrSize; ++i) {
        positions[i] = arr[i];
    }
    
    updatePositionsUtil(positions);
    
    for(int i = 0; i < arrSize; ++i) {
        arr[i] = positions[i];
    }
}
