//
//  QRCodeOverlay.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 08.11.24.
//

import Foundation
import AppKit


class QRCodeOverlay : BaseOverlay {
    var qrCodes: [QrCode]?
    var imageSize: CGSize = CGSize()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        //self.wantsLayer = true
        //self.layer?.backgroundColor = NSColor.green.cgColor
        
        
        var qrCodes = [QrCode]()
        let qrCode = QrCode(message: "Test", bounds: NSRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: 100, height: 100)))
        qrCodes.append(qrCode)
        self.drawDetectedQRCodeBounds(qrCodes: qrCodes, imageSize: CGSize(width: 640, height: 480))
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func drawDetectedRects(rects: [NSRect], imageSize: CGSize) {
        super.drawDetectedRects(rects: rects, imageSize: imageSize)
        self.imageSize = imageSize
        
        var qrCodes = [QrCode]()
        
        for rect in rects {
            let qrCode = QrCode(message: "Test", bounds: rect)
            qrCodes.append(qrCode)
        }
        
        self.drawDetectedQRCodeBounds(qrCodes: qrCodes, imageSize: imageSize)
    }
    
    func drawDetectedQRCodeBounds(qrCodes: [QrCode], imageSize: CGSize) {
        print("drawDetectedQRCodeBounds : \(qrCodes.count) imageSize: \(imageSize)")
        self.qrCodes = qrCodes
        self.imageSize = imageSize
        
        
        self.setNeedsDisplay(self.frame)
    }
    
    
    override func draw(_ rect: CGRect) {
        //super.draw(rect)
        print("draw")
        guard self.qrCodes != nil && self.qrCodes!.count > 0 else {
            self.drawClear(rect: rect)
            return
        }
        
        self.drawRectangles(rect: rect)
        self.qrCodes!.removeAll()
        
    }
    
    func drawClear(rect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else {
            return
        }
        ctx.clear(rect)
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
        
        for qrCode in self.qrCodes! {
            print("qrcode: \(qrCode.message) -> \(qrCode.bounds)")
            ctx.stroke(self.convertDrawRect(detectedRect: qrCode.bounds!, previewSize: self.frame.size, imageSize: self.imageSize))
        }
        defer { ctx.restoreGState() }
        
    }
    
    
    func convertDrawRect(detectedRect: NSRect, previewSize: CGSize, imageSize: CGSize) -> NSRect {
        var imageW: CGFloat = 0
        var imageH: CGFloat = 0
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        
        var factor: CGFloat = 1
        
        if imageSize.width/imageSize.height >= previewSize.width/previewSize.height {
            imageW = previewSize.width
            imageH = imageW * imageSize.height / imageSize.width
            
            
            offsetY = (previewSize.height - imageH) / 2
            
            
            factor = imageSize.width / imageW
        } else {
            imageH = previewSize.height
            imageW = imageH * imageSize.width / imageSize.height

            offsetX = (previewSize.width - imageW) / 2
            
            factor = imageSize.height / imageH

        }
        
        print("show image size: \(imageH)- \(imageW) offset: \(offsetX)-\(offsetY) factor: \(factor)")
        
        var rect = NSRect()
        rect.origin.x = offsetX + detectedRect.origin.x / factor
        rect.origin.y = offsetY + detectedRect.origin.y / factor
        
        rect.size.width = detectedRect.size.width / factor
        rect.size.height = detectedRect.size.height / factor
        
        print("convertDrawRect: \(rect) from \(detectedRect)")
        return rect
        
    }
}
