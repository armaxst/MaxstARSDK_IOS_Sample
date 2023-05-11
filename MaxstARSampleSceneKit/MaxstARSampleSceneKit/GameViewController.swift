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

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    
    @IBOutlet var scenekitView: SCNView!
    var cameraDevice:MasCameraDevice = MasCameraDevice()
    var sensorDevice:MasSensorDevice = MasSensorDevice()
    var trackingManager:MasTrackerManager = MasTrackerManager()
    var cameraResultCode:MasResultCode = MasResultCode.CameraPermissionIsNotResolved
    
    var backgroundCameraQuad:BackgroundCameraQuad! = nil
    var screenSizeWidth:Float = 0.0
    var screenSizeHeight:Float = 0.0
    
    var arSceneView:SCNView! = nil
    var metalLayer: CAMetalLayer! = nil
    
    var cameraNode:SCNNode! = nil
    var mainCamera:SCNCamera! = nil
    var foxNode:SCNNode! = nil
    
    var foxTransform:SCNMatrix4! = nil
  
    private var foxAnimation: CAAnimation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        let foxScene = SCNScene(named: "art.scnassets/panda.scn")!
        foxNode = foxScene.rootNode
        foxTransform = foxNode.transform
        
        let scene = SCNScene()
        
        // create and add a camera to the scene
        cameraNode = SCNNode()
        mainCamera = SCNCamera()
        cameraNode.camera = mainCamera
    
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
  
        cameraNode.addChildNode(foxNode)

        foxAnimation = CAAnimation.animationWithSceneNamed("art.scnassets/panda.scn")
        foxAnimation.usesSceneTimeBase = false
        foxAnimation.fadeInDuration = 0.3
        foxAnimation.fadeOutDuration = 0.3
        foxAnimation.repeatCount = Float.infinity
        
        foxNode.addAnimation(foxAnimation, forKey: "idle")
       
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
    
    @IBAction func clickStartButton(_ sender: Any) {
        let button:UIButton = sender as! UIButton
        
        if button.titleLabel?.text == "START" {
            
            trackingManager.findSurface()
            button.setTitle("STOP", for: .normal)
        } else if button.titleLabel?.text == "STOP"{
            trackingManager.quitFindingSurface()
            button.setTitle("START", for: .normal)
        }
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
        sensorDevice.stop()
    }
    
    @objc func enterBackgournd() {
        pauseAR()
    }
    
    @objc func resumeAR() {
        trackingManager.start(.TRACKER_TYPE_INSTANT)
        openCamera()
    }
    
    func openCamera() {
        
        cameraResultCode = cameraDevice.start(0, width: 1280, height: 720)
        
        if cameraResultCode != MasResultCode.Success {
            print("Camera Permission error! : \(cameraResultCode.rawValue)")
        }
        sensorDevice.start()
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

        self.trackingManager.start(.TRACKER_TYPE_INSTANT)
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
        
        if trackingCount > 0 {
            for i in stride(from: 0, to: trackingCount, by: 1) {
                let trackable:MasTrackable = result.getTrackable(i)
                let projectionSCNMatrix4 = SCNMatrix4.init(projectionMatrix)
                let poseSCNMatrix4 = SCNMatrix4.init(trackable.getPose())
                cameraNode.camera?.projectionTransform = projectionSCNMatrix4
                foxNode.transform = SCNMatrix4Mult(foxTransform, poseSCNMatrix4)
            }
        }
        else {
            foxNode.scale = SCNVector3Make(0.0, 0.0, 0.0)
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

