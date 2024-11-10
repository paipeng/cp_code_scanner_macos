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
        
        let image = NSImage.fromAVCapturePhoto(photo: photo)
        //self.decode(image: image!.ciImage()!)
        let currentDir = NSHomeDirectory()
        print("currentDir: \(currentDir)")
        image!.writePNG(toURL: URL(fileURLWithPath: currentDir + "/Documents/photo.png"))
        self.decodeImage(image: image!)
    }
    
    func decodeImage(image: NSImage) {
        let qrCodes = Util().decode(ciImage: image.ciImage()!)
        
        
        //self.delegate?.decodeQRCode(qrData ?? "no decoded")
        
        Task {
            await MainActor.run { [weak self] in
                (overlay as! HtwmQrOverlay).drawDetectedQRCodeBounds(qrCodes: qrCodes, imageSize: image.size )
            }
        }
        
        if qrCodes.count > 0 {
            // crop image area of qrcode
            let qrCode = qrCodes.first
            let croppedImage = image.crop(to: qrCode!.bounds!)
            
            // htwm restful to online decoding
            let currentDir = NSHomeDirectory()
            croppedImage.writePNG(toURL: URL(fileURLWithPath: currentDir + "/Documents/test.png"))
            
            // show result in async
        }
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
        
        
        // crop image area of qrcode
        
        // htwm restful to online decoding
        
        // show result in async
    }
}
