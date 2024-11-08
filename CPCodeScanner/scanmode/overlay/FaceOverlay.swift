//
//  FaceOverlay.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 08.11.24.
//

import Foundation
import AppKit


class FaceOverlay : BaseOverlay {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.blue.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
