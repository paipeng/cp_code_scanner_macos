//
//  QRCodeScanMode.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 08.11.24.
//

import Foundation
import AVFoundation
import AppKit

class QRCodeScanMode : NSObject {
    weak var delegate: ScanModeDelegate?
    init(scanModeName: String, delegate: ScanModeDelegate) {
        self.delegate = delegate
    }
    func captureOutput(sampleBuffer: CMSampleBuffer) {
        guard let cvBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        //print("sampleBuffer size: \(CVPixelBufferGetWidth(cvBuffer)) - \(CVPixelBufferGetHeight(cvBuffer))")
        
        
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
        if qrData != nil {
            print("decoded qrData: \(qrData ?? "no decoded")")
        }
        
        self.delegate?.decodeQRCode(qrData ?? "no decoded")
    }
    func handleCapturePhoto(photo: AVCapturePhoto) {
        //let pixelBuffer: CVPixelBuffer =
        let data = photo.fileDataRepresentation()
        
        //let rep = NSCIImageRep(ciImage: ciImage)
        //let image = NSImage(size: rep.size)
        //image.addRepresentation(rep)
        let image = NSImage(data: data!)
        print("image size: \(image!.size)")
    }
}
