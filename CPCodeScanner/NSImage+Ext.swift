//
//  NSImage+Ext.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 10.11.24.
//

import Foundation

import AppKit
import AVFoundation

extension NSImage {
    static func fromAVCapturePhoto(photo: AVCapturePhoto) -> NSImage? {
        let image = NSImage(data: photo.fileDataRepresentation()!)
        print("image size: \(image!.size)")
        return image
    }
    /// Generates a CIImage for this NSImage.
    /// - Returns: A CIImage optional.
    func ciImage() -> CIImage? {
        guard let data = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: data) else {
            return nil
        }
        let ci = CIImage(bitmapImageRep: bitmap)
        return ci
    }
    
    /// Generates an NSImage from a CIImage.
    /// - Parameter ciImage: The CIImage
    /// - Returns: An NSImage optional.
    static func fromCIImage(_ ciImage: CIImage) -> NSImage {
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage
    }
    
    func crop(to rect: CGRect) -> NSImage {
        var imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let imageRef = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
            return NSImage(size: rect.size)
        }
        guard let crop = imageRef.cropping(to: rect) else {
            return NSImage(size: rect.size)
        }
        return NSImage(cgImage: crop, size: NSZeroSize)
    }
    
    
    func crop(to rect: CGRect, margin: CGFloat) -> NSImage {
        var imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        var expandRect = rect
        expandRect.origin.x = expandRect.origin.x - margin
        expandRect.origin.y = expandRect.origin.y - margin
        expandRect.size.width = rect.size.width + margin * 2
        expandRect.size.height = rect.size.height + margin * 2
        
        if (expandRect.origin.x < 0) {
            expandRect.origin.x = 0
        } else if expandRect.origin.x >= imageRect.width {
            expandRect.origin.x = imageRect.width - 1
        }
        
        if (expandRect.origin.y < 0) {
            expandRect.origin.y = 0
        } else if expandRect.origin.y >= imageRect.height {
            expandRect.origin.y = imageRect.height - 1
        }
        
        if expandRect.origin.x + expandRect.size.width > imageRect.width {
            expandRect.size.width = imageRect.width - expandRect.origin.x
        }
        
        if expandRect.origin.x + expandRect.size.width > imageRect.width {
            expandRect.size.width = imageRect.width - expandRect.origin.x
        }
        
        print("expandRect: \(expandRect)")
        
        guard let imageRef = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
            return NSImage(size: rect.size)
        }

        
        guard let crop = imageRef.cropping(to: expandRect) else {
            return NSImage(size: expandRect.size)
        }
        return NSImage(cgImage: crop, size: NSZeroSize)
    }
    
    
    public func writePNG(toURL url: URL) {
        guard let data = tiffRepresentation,
              let rep = NSBitmapImageRep(data: data),
              let imgData = rep.representation(using: .png, properties: [.compressionFactor : NSNumber(floatLiteral: 1.0)]) else {

            Swift.print("\(self) Error Function '\(#function)' Line: \(#line) No tiff rep found for image writing to \(url)")
            return
        }

        do {
            try imgData.write(to: url)
        }catch let error {
            Swift.print("\(self) Error Function '\(#function)' Line: \(#line) \(error.localizedDescription)")
        }
    }
}
