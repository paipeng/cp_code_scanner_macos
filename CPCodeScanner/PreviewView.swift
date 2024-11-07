//
//  PreviewView.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 07.11.24.
//


import Cocoa
import AppKit
import AVFoundation

class PreviewView: NSView {
    /*
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
     */
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // other code
        self.layer = CALayer()
        //self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    //or customized constructor/ init
    init(frame frameRect: NSRect, otherInfo:Int) {
        super.init(frame:frameRect);
    }
}
