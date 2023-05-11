//
//  GameViewController.swift
//  MaxstARSampleSceneKit
//
//  Created by Kimseunglee on 2018. 1. 24..
//  Copyright © 2018년 Maxst. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import Metal
import MetalKit
import MaxstARSDKFramework

class MarkerViewController: UIViewController, SCNSceneRendererDelegate {
    
    
    @IBOutlet var scenekitView: SCNView!
    var cameraDevice:MasCameraDevice = MasCameraDevice()
    var trackingManager:MasTrackerManager = MasTrackerManager()
    var cameraResultCode:MasResultCode = MasResultCode.CameraPermissionIsNotResolved
    
    var backgroundCameraQuad:BackgroundCameraQuad! = nil
    var screenSizeWidth:Float = 0.0
    var screenSizeHeight:Float = 0.0
    
    var arSceneView:SCNView! = nil
    var metalLayer: CAMetalLayer! = nil
    
    var cameraNode:SCNNode! = nil
    var mainCamera:SCNCamera! = nil
    
    var firstNode:SCNNode! = nil
    var secondNode:SCNNode! = nil
    var thirdNode:SCNNode! = nil
    var fourthNode:SCNNode! = nil
    
    var firstTransform:SCNMatrix4! = nil
    var secondTransform:SCNMatrix4! = nil
    var thirdTransform:SCNMatrix4! = nil
    var fourthTransform:SCNMatrix4! = nil
    
    private var foxAnimation: CAAnimation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        let foxScene = SCNScene(named: "art.scnassets/ship.scn")!
        firstNode = foxScene.rootNode
        firstTransform = firstNode.transform
        
        let dvsScene = SCNScene(named: "art.scnassets/dvs001.scn")!
        secondNode = dvsScene.rootNode
        secondTransform = secondNode.transform
        
        let jugScene = SCNScene(named: "art.scnassets/Jug1_OBJ/Jug1.scn")!
        thirdNode = jugScene.rootNode
        thirdTransform = thirdNode.transform
        
        let bambooScene = SCNScene(named: "art.scnassets/Book3/bookobj.scn")!
        fourthNode = bambooScene.rootNode
        fourthTransform = fourthNode.transform
        
        let scene = SCNScene()
        
        // create and add a camera to the scene
        cameraNode = SCNNode()
        mainCamera = SCNCamera()
        cameraNode.camera = mainCamera
        
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
        cameraNode.addChildNode(firstNode)
        cameraNode.addChildNode(secondNode)
        cameraNode.addChildNode(thirdNode)
        cameraNode.addChildNode(fourthNode)
        
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor.white
        omniLightNode.position = SCNVector3Make(0, -50, -50)
        scene.rootNode.addChildNode(omniLightNode)
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 30
        ambientLight.color = UIColor.white
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)

        
        let scnView:SCNView = self.scenekitView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = false
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        scnView.isPlaying = true
        
        arSceneView = scnView
        arSceneView.delegate = self
        
        setupEngine()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseAR), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackgournd), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeAR), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pauseAR()
        trackingManager.destroyTracker()
        MasMaxstAR.deinit()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func pauseAR() {
        trackingManager.stopTracker()
        cameraDevice.stop()
    }
    
    @objc func enterBackgournd() {
        pauseAR()
    }
    
    @objc func resumeAR() {
        trackingManager.start(.TRACKER_TYPE_MARKER)
        trackingManager.setTrackingOption(.JITTER_REDUCTION_ACTIVATION)
        openCamera()
    }
    
    func openCamera() {
        
        cameraResultCode = cameraDevice.start(0, width: 1280, height: 720)
        
        if cameraResultCode != MasResultCode.Success {
            print("Camera Permission error! : \(cameraResultCode.rawValue)")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setOrientaionChange()
    }
    
    func setOrientaionChange() {
        if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            screenSizeWidth = Float(UIScreen.main.nativeBounds.size.width)
            screenSizeHeight = Float(UIScreen.main.nativeBounds.size.height)
            MasMaxstAR.setScreenOrientation(.PORTRAIT_UP)
        } else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
            screenSizeWidth = Float(UIScreen.main.nativeBounds.size.width)
            screenSizeHeight = Float(UIScreen.main.nativeBounds.size.height)
            MasMaxstAR.setScreenOrientation(.PORTRAIT_DOWN)
        } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            screenSizeWidth = Float(UIScreen.main.nativeBounds.size.height)
            screenSizeHeight = Float(UIScreen.main.nativeBounds.size.width)
            MasMaxstAR.setScreenOrientation(.LANDSCAPE_LEFT)
        } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            screenSizeWidth = Float(UIScreen.main.nativeBounds.size.height)
            screenSizeHeight = Float(UIScreen.main.nativeBounds.size.width)
            MasMaxstAR.setScreenOrientation(.LANDSCAPE_RIGHT)
        }
        
        MasMaxstAR.onSurfaceChanged(Int32(screenSizeWidth), height: Int32(screenSizeHeight))
    }
    
    func setStatusBarOrientaionChange() {
        let orientation:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
        
        if orientation == UIInterfaceOrientation.portrait {
            screenSizeWidth = Float(UIScreen.main.nativeBounds.size.width)
            screenSizeHeight = Float(UIScreen.main.nativeBounds.size.height)
            MasMaxstAR.setScreenOrientation(.PORTRAIT_UP)
        } else if orientation == UIInterfaceOrientation.portraitUpsideDown {
            screenSizeWidth = Float(UIScreen.main.nativeBounds.size.width)
            screenSizeHeight = Float(UIScreen.main.nativeBounds.size.height)
            MasMaxstAR.setScreenOrientation(.PORTRAIT_DOWN)
        } else if orientation == UIInterfaceOrientation.landscapeLeft {
            screenSizeWidth = Float(UIScreen.main.nativeBounds.size.height)
            screenSizeHeight = Float(UIScreen.main.nativeBounds.size.width)
            MasMaxstAR.setScreenOrientation(.LANDSCAPE_RIGHT)
        } else if orientation == UIInterfaceOrientation.landscapeRight {
            screenSizeWidth = Float(UIScreen.main.nativeBounds.size.height)
            screenSizeHeight = Float(UIScreen.main.nativeBounds.size.width)
            MasMaxstAR.setScreenOrientation(.LANDSCAPE_LEFT)
        }
        
        MasMaxstAR.onSurfaceChanged(Int32(screenSizeWidth), height: Int32(screenSizeHeight))
    }
    
    func setupEngine() {
        
        screenSizeWidth = Float(UIScreen.main.nativeBounds.size.width)
        screenSizeHeight = Float(UIScreen.main.nativeBounds.size.height)
        
        MasMaxstAR.onSurfaceChanged(Int32(screenSizeWidth), height: Int32(screenSizeHeight))
        
        MasMaxstAR.setLicenseKey("")
        openCamera()
        setStatusBarOrientaionChange()
        
        self.trackingManager.start(.TRACKER_TYPE_MARKER)
        trackingManager.setTrackingOption(.JITTER_REDUCTION_ACTIVATION)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        if backgroundCameraQuad == nil {
            backgroundCameraQuad = BackgroundCameraQuad(device: renderer.device, pixelFormat: renderer.colorPixelFormat)
        }
        
        let commandEncoder:MTLRenderCommandEncoder = renderer.currentRenderCommandEncoder!
        
        let trackingState:MasTrackingState = trackingManager.updateTrackingState()
        let result:MasTrackingResult = trackingState.getTrackingResult()
        
        let backgroundImage:MasTrackedImage = trackingState.getImage()
        
        let backgroundProjectionMatrix:matrix_float4x4 = cameraDevice.getBackgroundPlaneProjectionMatrix()
        
        let projectionMatrix:matrix_float4x4 = cameraDevice.getProjectionMatrix()
        
        if let cameraQuad = backgroundCameraQuad {
            if(backgroundImage.getData() != nil) {
                cameraQuad.setProjectionMatrix(projectionMatrix: backgroundProjectionMatrix)
                cameraQuad.draw(commandEncoder: commandEncoder, image: backgroundImage)
            }
        }
        
        let trackingCount:Int32 = result.getCount()
        
        firstNode.scale = SCNVector3Make(0.0, 0.0, 0.0)
        secondNode.scale = SCNVector3Make(0.0, 0.0, 0.0)
        thirdNode.scale = SCNVector3Make(0.0, 0.0, 0.0)
        fourthNode.scale = SCNVector3Make(0.0, 0.0, 0.0)
        
        if trackingCount > 0 {
            for i in stride(from: 0, to: trackingCount, by: 1) {
                let trackable:MasTrackable = result.getTrackable(i)
                let projectionSCNMatrix4 = SCNMatrix4.init(projectionMatrix)
                let poseSCNMatrix4 = SCNMatrix4.init(trackable.getPose())
                
                cameraNode.camera?.projectionTransform = projectionSCNMatrix4
                
                if trackable.getId() == "0" {
                    firstNode.transform = SCNMatrix4Mult(firstTransform, poseSCNMatrix4)
                    firstNode.scale = SCNVector3Make(3.0, 3.0, 3.0)
                } else if trackable.getId() == "1" {
                    secondNode.transform = SCNMatrix4Mult(secondTransform, poseSCNMatrix4)
                    secondNode.scale = SCNVector3Make(2.0, 2.0, 2.0)
                } else if trackable.getId() == "2" {
                    thirdNode.transform = SCNMatrix4Mult(thirdTransform, poseSCNMatrix4)
                    thirdNode.scale = SCNVector3Make(3.0, 3.0, 3.0)
                } else if trackable.getId() == "3" {
                    fourthNode.transform = SCNMatrix4Mult(fourthTransform, poseSCNMatrix4)
                    fourthNode.scale = SCNVector3Make(0.5, 0.5, 0.5)
                }
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}

