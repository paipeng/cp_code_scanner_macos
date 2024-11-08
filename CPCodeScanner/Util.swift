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
    
    open func decode(ciImage: CIImage) -> String? {
        let detectorOptions = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: CIContext(), options: detectorOptions)
        let decoderOptions = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
        let features = qrDetector?.features(in: ciImage, options: decoderOptions)
        let qrcodeFeature = (features?.first as? CIQRCodeFeature)
        //print("qrcodeFeature: \(qrcodeFeature)")
        return qrcodeFeature?.messageString
    }
}
