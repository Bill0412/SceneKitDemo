//
//  DataProcess.h
//  SceneKitDemo
//
//  Created by Fenghe Xu on 2021/12/22.
//

#ifndef DataProcess_h
#define DataProcess_h

#include <stdio.h>
#include <simd/simd.h>

#ifdef __cplusplus
extern "c" {
#endif


void updatePositions(simd_float3* arr, int arrSize);


#ifdef __cplusplus
}
#endif

#endif /* DataProcess_h */
