//
//  Util.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 07.11.24.
//

import Foundation
import AVFoundation
import CoreImage



public class Util {
    init() {
        //super.init()
    }
    
    
    open func printDate(string: String, file: NSString = #file, line: Int = #line, fn: String = #function) {
#if DEBUG
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSSS"
        let log = "[\(Thread.current)] \(file.lastPathComponent) \(fn) [\(line)]_\(formatter.string(from: date)): "
        print(log + " " + string)
#endif
    }
    
    func getBundle() -> Bundle {
        return Bundle(identifier: "com.paipeng.CPCodeScanner")!
    }
    
    
    func decode(ciImage: CIImage) -> [QrCode] {
        let detectorOptions = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: CIContext(), options: detectorOptions)
        let decoderOptions = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
        let features = qrDetector?.features(in: ciImage, options: decoderOptions)
        //let qrcodeFeature = (features?.first as? CIQRCodeFeature)
        //print("qrcodeFeature: \(qrcodeFeature)")
        //return qrcodeFeature?.messageString
        //print("features count: \(features?.count)")
        var qrCodes = [QrCode]()
        for feature in features! {
            let qrCode = QrCode(message: (feature as! CIQRCodeFeature).messageString, bounds: (feature as! CIQRCodeFeature).bounds)
            qrCodes.append(qrCode)
        }
        return qrCodes
    }
    
    
    open func detectFace(ciImage: CIImage) -> [CIFaceFeature]? {
        let detectorOptions = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: CIContext(), options: detectorOptions)
        let decoderOptions = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
        let faces = faceDetector?.features(in: ciImage, options: decoderOptions)
        //let face = (faces?.first as? CIFaceFeature)
        //print("qrcodeFeature: \(qrcodeFeature)")
        //print("Found face at \(face!.bounds)")
        return (faces ?? nil) as [CIFaceFeature]
    }
}
