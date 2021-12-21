//
//  ContentView.swift
//  SceneKitDemo
//
//  Created by Fenghe Xu on 2021/12/20.
//

import SwiftUI
import ARKit
import RealityKit

extension simd_float4x4 {
    func position() -> SCNVector3 {
        return SCNVector3(columns.3.x, columns.3.y, columns.3.z)
    }
    
    func position() -> simd_float3 {
        return simd_float3(columns.3.x, columns.3.y, columns.3.z)
    }
}

//extension SCNVector3 {
//    static func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
//        return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
//    }
//
//    static func -(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
//        return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
//    }
//
//    static func /(left: SCNVector3, right: Float) -> SCNVector3 {
//        return SCNVector3(left.x / right, left.y / right, left.z / right)
//    }
//
//    func length(_ v: SCNVector3) -> Float {
//        return sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
//    }
//
//}


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
                return
            }
            
            
            
            if counter == 60 {

                arKitSceneView?.scene.rootNode.addChildNode(
                    CylinderNode(from: prevCameraTransform!.position(), to: frame.camera.transform.position()))
                
                counter = 0
                prevCameraTransform = frame.camera.transform
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
