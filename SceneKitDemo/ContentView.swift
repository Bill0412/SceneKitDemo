//
//  ContentView.swift
//  SceneKitDemo
//
//  Created by Fenghe Xu on 2021/12/20.
//

import SwiftUI
import ARKit
import RealityKit
import SceneKit

extension simd_float4x4 {
    func position() -> SCNVector3 {
        return SCNVector3(columns.3.x, columns.3.y, columns.3.z)
    }
    
    func position() -> simd_float3 {
        return simd_float3(columns.3.x, columns.3.y, columns.3.z)
    }
}

/**
 This is the SwiftUI version of the ARKitCube project.
 This is file 2 of 2 used. This is not the main file. This file contains the code for the ARKit Scene View, which is native to UIKit.
 To use the ARKit Scene View in SwiftUI, you must wrap it in an UIViewRepresentable, which is what the code in this file does.
 The other file, ContentView.swift, contains the main code for the interface.
 */

struct SwiftUIARSCNView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    /// Make an ARKit scene view
    let arKitSceneView = ARSCNView()
    
    /// The main method required by UIViewRepresentable. Defines what the view should be.
    func makeUIView(context: Context) -> ARSCNView {
        
        /// Make voiceover allow directly tapping the scene view.
        arKitSceneView.isAccessibilityElement = true
        arKitSceneView.accessibilityTraits = .allowsDirectInteraction
        arKitSceneView.accessibilityLabel = "Use the rotor to enable Direct Touch"
//        arKitSceneView.debugOptions = [.showSceneUnderstanding]
        
        /// Configure the AR Session
        /// This will make ARKit track the device's position and orientation
        let worldTrackingConfiguration = ARWorldTrackingConfiguration()
        
        worldTrackingConfiguration.planeDetection = [.horizontal, .vertical]
        
        // may use Picker
        worldTrackingConfiguration.sceneReconstruction = .mesh
        worldTrackingConfiguration.environmentTexturing = .automatic
        
        // inherited from ARConfiguration
        worldTrackingConfiguration.frameSemantics = .sceneDepth
        
        /// Run the configuration
        arKitSceneView.session.run(worldTrackingConfiguration)
        
//        arKitSceneView.delegate = ARSCNViewCoordinator()
        arKitSceneView.session.delegate = context.coordinator
        arKitSceneView.delegate = context.coordinator
        
        context.coordinator.arKitSceneView = arKitSceneView
        
        /// Return the ARKit Scene View to the UIViewRepresentable.
        return arKitSceneView
    }

    /// No need for this, but UIViewRepresentable requires it
    func updateUIView(_ uiView: ARSCNView, context: Context) {

    }
    
    class Coordinator: NSObject, ARSessionDelegate, ARSCNViewDelegate {
        weak var arKitSceneView: ARSCNView?
        var prevCameraTransform: simd_float4x4? = nil
        var counter = 0
        var limiter = 0
        var positions: [simd_float3] = []
        var cylinderRootNode = SCNNode()
        
        
        func redDot(position: simd_float4x4) -> SCNNode {
            let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.001))
            sphereNode.position = position.position()
            let shpereMaterial = SCNMaterial()
            shpereMaterial.diffuse.contents = CGColor(red: 1.0, green: 0, blue: 0, alpha: 1)
            sphereNode.geometry!.firstMaterial = shpereMaterial
            return sphereNode
        }
        
        func CylinderNode(from: simd_float3, to: simd_float3, radius: CGFloat = 0.01) -> SCNNode {
            let translationVector = to - from
            
            let cylinderNode = SCNNode(geometry:
                                        SCNCylinder(radius: 0.01, height: CGFloat(length(translationVector))))
            cylinderNode.position = SCNVector3((to + from) / 2)
            cylinderNode.simdOrientation = simd_quatf(from: [0.0, 1.0, 0.0], to: normalize(translationVector)).normalized
            return cylinderNode
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            counter += 1
            
            
            guard prevCameraTransform != nil else {
                print("No previous camera transform matrix yet")
                prevCameraTransform = frame.camera.transform
                positions.append(frame.camera.transform.position())
                return
            }
            
            if counter == 60 {
                if limiter < 5 {
                    limiter += 1
                    cylinderRootNode.addChildNode(
                        CylinderNode(from: prevCameraTransform!.position(), to: frame.camera.transform.position()))
                    positions.append(frame.camera.transform.position())
                    
                    
                    prevCameraTransform = frame.camera.transform
                } else {
                    // move the cylinders using C API
                   
                    let newCylinderRootNode = SCNNode()
                    
                    // add the points to the newCylinderRootNode after modifying using the C function
                    
                    // test: modify using swift
//                    for i in 0..<(positions.count) {
//                        positions[i] += simd_float3(0, 0.01, 0)
//                    }
//
                    // test: modify using C API
                    updatePositions(UnsafeMutablePointer(mutating: positions), CInt(positions.count))
                    
                    for i in 0..<(positions.count-1) {
                        newCylinderRootNode.addChildNode(CylinderNode(from: positions[i], to: positions[i+1]))
                    }
                    cylinderRootNode.removeFromParentNode()
                    
                    // update cylinderRootNode
                    cylinderRootNode = newCylinderRootNode
                    
                }
                
                if let isContain = arKitSceneView?.scene.rootNode.contains(cylinderRootNode), !isContain {
                    arKitSceneView?.scene.rootNode.addChildNode(cylinderRootNode)
                }
                
                counter = 0
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all, edges: .all)
            SwiftUIARSCNView()
                .ignoresSafeArea()
        }
        
    }
}
