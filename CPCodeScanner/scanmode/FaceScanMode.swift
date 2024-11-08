//
//  FaceScanMode.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 08.11.24.
//

import Foundation
import AVFoundation
import AppKit


class FaceScanMode : BaseScanMode {
    override func captureOutput(sampleBuffer: CMSampleBuffer) {
        print("FaceScanMode caaptureOutput")
        super.captureOutput(sampleBuffer: sampleBuffer)
    }
    
    override func handleCapturePhoto(photo: AVCapturePhoto) {
        super.handleCapturePhoto(photo: photo)
    }
    
    
    override func decode(image: CIImage) {
        print("FaceScanMode decode")

        //get UIImage out of CIImage
        let faceData: String? = Util().detectFace(ciImage: image)
        if faceData != nil {
            print("decoded faceData: \(faceData ?? "no decoded")")
        }
        
        //self.delegate?.decodeQRCode(qrData ?? "no decoded")
    }
}
