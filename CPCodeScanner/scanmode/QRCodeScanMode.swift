//
//  QRCodeScanMode.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 08.11.24.
//

import Foundation
import AVFoundation
import AppKit

class QRCodeScanMode : BaseScanMode {
    
    override init(scanModeName: String, overlayRect: NSRect, delegate: ScanModeDelegate) {
        super.init(scanModeName: scanModeName, overlayRect: overlayRect, delegate: delegate)
        overlay = QRCodeOverlay(frame: overlayRect)
        
        //overlay!.wantsLayer = true
        //overlay!.layer?.backgroundColor = NSColor.green.cgColor
    }
    
    override func captureOutput(sampleBuffer: CMSampleBuffer) {
        super.captureOutput(sampleBuffer: sampleBuffer)
    }
    
    override func handleCapturePhoto(photo: AVCapturePhoto) {
        super.handleCapturePhoto(photo: photo)        
    }
    
    
    override func decode(image: CIImage) {
        
        //get UIImage out of CIImage
        let qrData: String? = Util().decode(ciImage: image)
        if qrData != nil {
            print("decoded qrData: \(qrData ?? "no decoded")")
        }
        
        self.delegate?.decodeQRCode(qrData ?? "no decoded")
    }
}
