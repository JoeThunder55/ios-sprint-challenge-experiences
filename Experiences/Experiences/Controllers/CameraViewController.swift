//
//  CameraViewController.swift
//  Experiences
//
//  Created by Joe on 5/20/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit
import AVFoundation
class CameraViewController: UIViewController {

    lazy private var captureSession = AVCaptureSession()
    @IBOutlet var cameraView: CameraPreviewView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.videoPlayerLayer.videoGravity = .resizeAspectFill
       setupCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    private func setupCamera() {
        let camera = bestCamera()
        captureSession.beginConfiguration()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            preconditionFailure("Can't create input from the camera, but we should do something better than crashing!")
        }
        guard captureSession.canAddInput(cameraInput) else {
            preconditionFailure("This session can't capture from the camera: \(cameraInput)")
        }
        captureSession.addInput(cameraInput)
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        preconditionFailure("No Cameras on device match the specs that we need")
    }
}
