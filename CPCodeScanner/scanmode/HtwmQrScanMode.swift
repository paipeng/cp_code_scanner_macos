//
//  HtwmQrScanMode.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 10.11.24.
//

import Foundation
import AVFoundation
import AppKit


class HtwmQrScanMode : BaseScanMode {
    
    override init(scanModeName: String, overlayRect: NSRect, delegate: ScanModeDelegate) {
        super.init(scanModeName: scanModeName, overlayRect: overlayRect, delegate: delegate)
        overlay = HtwmQrOverlay(frame: overlayRect)
    }
    
    override func captureOutput(sampleBuffer: CMSampleBuffer) {
        //super.captureOutput(sampleBuffer: sampleBuffer)
    }
    
    override func handleCapturePhoto(photo: AVCapturePhoto) {
        //super.handleCapturePhoto(photo: photo)
        
        let image = NSImage(data: photo.fileDataRepresentation()!)
        print("image size: \(image!.size)")
        self.decode(image: image!.ciImage()!)
    }
    
    
    override func decode(image: CIImage) {        
        //get UIImage out of CIImage
        let qrCodes = Util().decode(ciImage: image)
        
        
        //self.delegate?.decodeQRCode(qrData ?? "no decoded")
        
        Task {
            await MainActor.run { [weak self] in
                (overlay as! HtwmQrOverlay).drawDetectedQRCodeBounds(qrCodes: qrCodes, imageSize: image.extent.size )
            }
        }
    }
}
