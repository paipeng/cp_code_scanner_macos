//
//  ViewController.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 07.11.24.
//

import Cocoa
import AVFoundation
class ViewController: NSViewController {
    let captureSession: AVCaptureSession = AVCaptureSession()
    var devices: [AVCaptureDevice]? = nil
    var deviceInput: AVCaptureDeviceInput? = nil
    let photoOutput = AVCapturePhotoOutput()
    
    var scanMode: BaseScanMode? = nil
    
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var devicesComboBox: NSComboBox!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var captureButton: NSButton!
    @IBOutlet weak var qrDataTextField: NSTextField!
    @IBOutlet weak var scanResultTabView: NSTabView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scanResultTabView.delegate = self
        var rect = previewView.frame;
        rect.origin.x = 0
        rect.origin.y = 0
        scanMode = QRCodeScanMode(scanModeName: "", overlayRect: rect, delegate: self)
        previewView.addOverlay(overlay: (scanMode?.getOverlay())!)
        self.askPermissionsForCameraFeed()
        
        //self.previewView.wantsLayer = true
        //self.previewView.layer?.backgroundColor = NSColor.red.cgColor
        print("previewView frame: \(self.previewView.frame)")
    }
    
    func askPermissionsForCameraFeed() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                print("authorized")
                self.initVideoDevices()
            
            case .notDetermined: // The user has not yet been asked for camera access.
                print("notDetermined")
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.initVideoDevices()
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
    
    func initVideoDevices() {
        self.devices = AVCaptureDevice.devices(for: AVMediaType.video)
        
        self.devicesComboBox.removeAllItems()
        for device in devices! {
            print(device)
            if ((device as AnyObject).hasMediaType(AVMediaType.video)) {
                print("video device found: \(device)")
                self.devicesComboBox.addItem(withObjectValue: device.localizedName)
                self.devicesComboBox.selectItem(at: 0)
            }
        }
        
        if self.devicesComboBox.numberOfItems == 0 {
            startButton.isEnabled = false
        } else {
            startButton.isEnabled = true
        }
        startButton.title = NSLocalizedString("start", comment: "")
        captureButton.title = NSLocalizedString("capture", comment: "")
        self.setupCaptureSession()
    }

    func setupCaptureSession() {
        print("setupCaptureSession")
        do {
            captureSession.beginConfiguration()
            
            // add device
            // skip
            
            // photo output
            guard captureSession.canAddOutput(photoOutput) else { return }
            captureSession.sessionPreset = .photo
            captureSession.addOutput(photoOutput)
            
            // setup preview
            let previewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = (self.previewView.layer?.frame)!
            previewLayer.frame.origin.x = 0
            previewLayer.frame.origin.y = 0

            print("prevView layer frame: \(previewLayer.frame)")

            // Add previewLayer into custom view
            self.previewView.layer?.addSublayer(previewLayer)
            
            
            // video output
            let videoOutput = AVCaptureVideoDataOutput()
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            let queue = DispatchQueue.init(label: "preview_queue", target: nil)
            videoOutput.setSampleBufferDelegate(self, queue: queue)
            
            captureSession.commitConfiguration()
           
            
        } catch let err as NSError {
          print("---> Error setupCaptureSession) : \(err)")
        }
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func startCamera() {
        print("startCamera: \(self.devicesComboBox.indexOfSelectedItem)")

        var webcam: AVCaptureDevice? = nil
        
        for device in self.devices! {
            print(device)
            if self.devicesComboBox.indexOfSelectedItem == self.devices!.firstIndex(of: device) {
                print("selected device found: \(self.devicesComboBox.indexOfSelectedItem)")
                webcam = device
                break
            }
        }
        
        guard (webcam != nil) else {
            return
        }
        
        
        do {
            self.captureSession.beginConfiguration()
            
            // setup input device again
            if self.deviceInput != nil {
                self.captureSession.removeInput(self.deviceInput!)
            }
            self.deviceInput = try AVCaptureDeviceInput(device: webcam!)
            guard (self.deviceInput != nil) else {
                print("deviceInput invalid -> return")
                return
            }
            if self.captureSession.canAddInput(self.deviceInput!){
                self.captureSession.addInput(self.deviceInput!)
                print("---> Adding webcam input")
            }
            
            
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
           
            
        } catch let err as NSError {
          print("---> Error startCamera) : \(err)")
        }
        
    }
    
    func stopCamera() {
        self.captureSession.stopRunning()
    }

}


extension ViewController {
    @IBAction func selectDevice(_ sender: NSComboBox) {
        print("selectDevice: \(sender.indexOfSelectedItem)")
        
    }
    
    @IBAction func start(_ sender: NSButton) {
        print("start")
        if self.captureSession.isRunning {
            
            startButton.title = NSLocalizedString("start", comment: "")
            self.stopCamera()
            
            
            let _task = Task {
                try await Task.sleep(for: .seconds(1))
                self.scanMode!.clearOverlayRects()
            }
        } else {
            // Start camera
            startButton.title = NSLocalizedString("stop", comment: "")
            self.startCamera()
        }
    }
    
    @IBAction func capture(_ sender: NSButton) {
        print("capture")
        if self.captureSession.isRunning {
            
            let photoSettings: AVCapturePhotoSettings  = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg, AVVideoCompressionPropertiesKey: [AVVideoQualityKey: 100]])
            
            self.photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }
}

extension ViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //print("didOutput")
        
        scanMode!.captureOutput(sampleBuffer: sampleBuffer)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("captureOutput didDrop")
        
    }
    
}


extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("photoOutput didFinishProcessingPhoto: \(photo.photoCount)")
        guard error == nil else {
            print("Fail to capture photo: \(String(describing: error))")
            return
        }
        
        
        scanMode!.handleCapturePhoto(photo: photo)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        print("photoOutput didFinishCaptureFor")
        guard error == nil else {
                    print("Error in capture process: \(String(describing: error))")
                    return
                }
    }
}

extension ViewController: NSTabViewDelegate {
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        print("didSelect tablViewItem: \(tabViewItem?.label)")
        let index = self.scanResultTabView.indexOfTabViewItem(tabViewItem!)
        print("selected tabView index: \(index)")
        
        scanMode!.getOverlay()?.removeFromSuperview()
        var rect = previewView.frame;
        rect.origin.x = 0
        rect.origin.y = 0
        
        if index == 0 {
            scanMode = QRCodeScanMode(scanModeName: "QrCode", overlayRect: rect, delegate: self)
        } else {
            scanMode = FaceScanMode(scanModeName: "Face", overlayRect: rect, delegate: self)
        }
        
        previewView.addOverlay(overlay: (scanMode?.getOverlay())!)
    }
}

extension ViewController : ScanModeDelegate {
    func decodeQRCode(_ qrData: String) {
        print("decodeQRCode: \(qrData)")
        
        
        Task {
            await MainActor.run { [weak self] in
                qrDataTextField.stringValue = qrData
            }
        }
    }
}
