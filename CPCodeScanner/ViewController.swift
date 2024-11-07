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
    
    @IBOutlet weak var previewView: PreviewView!
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
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        
        var webcam: AVCaptureDevice? = nil
        // Find the FaceTime HD camera object
        for device in devices {
            print(device)
            
            // Camera object found and assign it to captureDevice
            if ((device as AnyObject).hasMediaType(AVMediaType.video)) {
                print(device)
                webcam = device as? AVCaptureDevice
            }
        }
        
        //let webcam = devices[0] as? AVCaptureDevice
        guard (webcam != nil) else {
            return
        }
        do {
            let webcamInput: AVCaptureDeviceInput = try AVCaptureDeviceInput(device: webcam!)
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
           
            
            // Start camera
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
