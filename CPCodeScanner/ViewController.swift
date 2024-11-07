//
//  ViewController.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 07.11.24.
//

import Cocoa
import AVFoundation
class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.askPermissionsForCameraFeed()
    }
    
    func askPermissionsForCameraFeed() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                print("authorized")
                self.setupCaptureSession()
            
            case .notDetermined: // The user has not yet been asked for camera access.
                print("notDetermined")
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.setupCaptureSession()
                    }
                }
            
            case .denied: // The user has previously denied access.
                print("denied")
                return

            case .restricted: // The user can't grant access due to restrictions.
                print("restricted")
                return
            }
        }

    func setupCaptureSession() {
        let devices = AVCaptureDevice.devices()//for: AVMediaType.video)
        let webcam = devices[0] as? AVCaptureDevice
        
        do {
          let webcamInput: AVCaptureDeviceInput = try AVCaptureDeviceInput(device: webcam!)
          /*
            if videoSession.canAddInput(webcamInput){
              videoSession.addInput(webcamInput)
              print("---> Adding webcam input")
          }
           */
        } catch let err as NSError {
          print("---> Error adding webcam)")
        }
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

