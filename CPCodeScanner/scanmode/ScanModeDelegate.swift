//
//  ScanModeDelegate.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 08.11.24.
//

import Foundation



protocol ScanModeDelegate: AnyObject {
    func decodeQRCode(_ qrData: String)
}
