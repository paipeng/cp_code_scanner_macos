//
//  QrCode.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 08.11.24.
//

import Foundation


class QrCode :NSObject {
    var message : String?
    var bounds : NSRect?
    init(message: String?, bounds: NSRect?) {
        self.message = message
        self.bounds = bounds
    }
}
