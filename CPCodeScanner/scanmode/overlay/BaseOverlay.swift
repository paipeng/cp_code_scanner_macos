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
}
