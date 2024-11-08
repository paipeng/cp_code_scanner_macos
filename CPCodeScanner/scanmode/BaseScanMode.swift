//
//  BaseScanMode.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 08.11.24.
//

import Foundation
import AVFoundation
import AppKit



class BaseScanMode : NSObject {
    
    weak var delegate: ScanModeDelegate?
    init(scanModeName: String, delegate: ScanModeDelegate) {
        self.delegate = delegate
    }
    
    
    func captureOutput(sampleBuffer: CMSampleBuffer) {
        guard let cvBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        //get a CIImage out of the CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        let rep = NSCIImageRep(ciImage: ciImage)
        let image = NSImage(size: rep.size)
        image.addRepresentation(rep)
        self.decode(image: ciImage)
        
    }
    func handleCapturePhoto(photo: AVCapturePhoto) {
        let image = NSImage(data: photo.fileDataRepresentation()!)
        print("image size: \(image!.size)")

    }
    
    func decode(image: CIImage) {
        
    }
}
