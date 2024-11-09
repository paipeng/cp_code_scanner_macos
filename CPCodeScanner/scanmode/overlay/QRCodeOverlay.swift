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
    
    
}
