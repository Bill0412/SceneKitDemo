//
//  DataProcess.hpp
//  SceneKitDemo
//
//  Created by Fenghe Xu on 2021/12/23.
//

#ifndef DataProcess_hpp
#define DataProcess_hpp

#include <stdio.h>

#include <simd/simd.h>

#ifdef __cplusplus
extern "C" {
#endif

void updatePositions(simd_float3* arr, int arrSize);

#ifdef __cplusplus
}
#endif

#endif /* DataProcess_hpp */
