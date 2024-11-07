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
    
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var devicesComboBox: NSComboBox!
    @IBOutlet weak var startButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
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
            }
        }
    }

    func setupCaptureSession(device: AVCaptureDevice) {
        
        //let webcam = devices[0] as? AVCaptureDevice
        
        do {
            let webcamInput: AVCaptureDeviceInput = try AVCaptureDeviceInput(device: device)
            captureSession.beginConfiguration()
          
            if captureSession.canAddInput(webcamInput){
                captureSession.addInput(webcamInput)
                print("---> Adding webcam input")
                
                
                let photoOutput = AVCapturePhotoOutput()
                guard captureSession.canAddOutput(photoOutput) else { return }
                captureSession.sessionPreset = .photo
                captureSession.addOutput(photoOutput)
            }
            
            // setup preview
            
            
            var previewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = (self.previewView.layer?.frame)!
            previewLayer.frame.origin.x = 0
            previewLayer.frame.origin.y = 0

            print("prevView layer frame: \(previewLayer.frame)")

            // Add previewLayer into custom view
            self.previewView.layer?.addSublayer(previewLayer)
            
            
            let videoOutput = AVCaptureVideoDataOutput()
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            let queue = DispatchQueue.init(label: "preview_queue", target: nil)
            videoOutput.setSampleBufferDelegate(self, queue: queue)
            
            captureSession.commitConfiguration()
           
            captureSession.startRunning()
            
        } catch let err as NSError {
          print("---> Error adding webcam) : \(err)")
        }
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


extension ViewController {
    @IBAction func selectDevice(_ sender: NSComboBox) {
        print("selectDevice")
        
        /*
        var webcam: AVCaptureDevice? = nil
        // Find the FaceTime HD camera object
        for device in self.devices! {
            print(device)
            // Camera object found and assign it to captureDevice
            if ((device as AnyObject).hasMediaType(AVMediaType.video)) {
                print(device)
                webcam = device as? AVCaptureDevice
            }
        }
         */
        

        
    }
    
    @IBAction func start(_ sender: NSButton) {
        print("start")
        // Start camera
        
        var webcam: AVCaptureDevice? = nil
        for device in self.devices! {
            print(device)
            if self.devicesComboBox.indexOfSelectedItem == self.devices!.firstIndex(of: device) {
                print("selected device found: \(self.devicesComboBox.indexOfSelectedItem)")
                webcam = device as? AVCaptureDevice
                break
            }
        }
        
        guard (webcam != nil) else {
            return
        }
        self.setupCaptureSession(device: webcam!)
    }
}

extension ViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("didOutput")
        
        guard let cvBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        print("sampleBuffer size: \(CVPixelBufferGetWidth(cvBuffer)) - \(CVPixelBufferGetHeight(cvBuffer))")

        
        //get a CIImage out of the CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        let rep = NSCIImageRep(ciImage: ciImage)
        let image = NSImage(size: rep.size)
        image.addRepresentation(rep)
        
        /*
        let temporaryContext = CIContext(cgContext: nil)
        let videoImage: CGImageRef = temporaryContext.crea
        [temporaryContext
                                 createCGImage:ciImage
                                 fromRect:CGRectMake(0, 0,
                                 ,
                                 CVPixelBufferGetHeight(imageBuffer))];

               UIImage *image = [[UIImage alloc] initWithCGImage:videoImage];
        */
        
        //get UIImage out of CIImage
        let qrData: String? = Util().decode(ciImage: ciImage)
        print("decoded qrData: \(qrData ?? "no decoded")")
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("captureOutput didDrop")
        
    }
    
}
