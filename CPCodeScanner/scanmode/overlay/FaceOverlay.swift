//
//  FaceOverlay.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 08.11.24.
//

import Foundation
import AppKit


class FaceOverlay : BaseOverlay {
    var faceFeatures: [CIFaceFeature]?
    var imageSize: CGSize = CGSize()
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        //self.wantsLayer = true
        //self.layer?.backgroundColor = NSColor.blue.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func drawDetectedFaceBounds(faceFeatures: [CIFaceFeature]?, imageSize: CGSize) {
        print("drawDetectedQRCodeBounds : \(faceFeatures!.count) imageSize: \(imageSize)")
        self.faceFeatures = faceFeatures
        self.imageSize = imageSize
        
        
        self.setNeedsDisplay(self.frame)
    }
    
    
    override func draw(_ rect: CGRect) {
        //super.draw(rect)
        print("draw")
        guard self.faceFeatures != nil && self.faceFeatures!.count > 0 else {
            self.drawClear(rect: rect)
            return
        }
        
        self.drawRectangles(rect: rect)
        self.faceFeatures!.removeAll()
        
    }
    
    
    func drawRectangles(rect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else {
            return
        }

        ctx.clear(rect)
        ctx.saveGState()
        let color:NSColor = NSColor.red
        color.set()
        ctx.setStrokeColor(red: 1, green: 0.5, blue: 0, alpha: 1)
        ctx.setLineWidth(2)
        
        for faceFeature in self.faceFeatures! {
            print("qrcode: \(faceFeature.description) -> \(faceFeature.bounds)")
            ctx.stroke(self.convertDrawRect(detectedRect: faceFeature.bounds, previewSize: self.frame.size, imageSize: self.imageSize))
        }
        defer { ctx.restoreGState() }
        
    }
}
