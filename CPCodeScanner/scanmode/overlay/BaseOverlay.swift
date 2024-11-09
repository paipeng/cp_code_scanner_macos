//
//  BaseOverlay.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 08.11.24.
//

import Foundation
import AppKit


class BaseOverlay : NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // other code
        self.layer = CALayer()
        //self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.green.cgColor
    }
    
    
    func drawDetectedRects(rects: [NSRect], imageSize: CGSize) {
        
    }
    
    
    
    func drawClear(rect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else {
            return
        }
        ctx.clear(rect)
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
