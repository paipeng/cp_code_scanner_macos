//
//  HtwmQrScanMode.swift
//  CPCodeScanner
//
//  Created by Pai Peng on 10.11.24.
//

import Foundation
import AVFoundation
import AppKit
import HtwmRestful


class HtwmQrScanMode : BaseScanMode {
    var decode: RestApi.Types.Request.Decode = RestApi.Types.Request.Decode()
    
    override init(scanModeName: String, overlayRect: NSRect, delegate: ScanModeDelegate) {
        super.init(scanModeName: scanModeName, overlayRect: overlayRect, delegate: delegate)
        overlay = HtwmQrOverlay(frame: overlayRect)
    }
    
    override func captureOutput(sampleBuffer: CMSampleBuffer) {
        //super.captureOutput(sampleBuffer: sampleBuffer)
    }
    
    override func handleCapturePhoto(photo: AVCapturePhoto) {
        //super.handleCapturePhoto(photo: photo)
        
        let image = NSImage.fromAVCapturePhoto(photo: photo)
        //self.decode(image: image!.ciImage()!)
        let currentDir = NSHomeDirectory()
        print("currentDir: \(currentDir)")
        image!.writePNG(toURL: URL(fileURLWithPath: currentDir + "/Documents/photo.png"))
        self.decodeImage(image: image!)
    }
    
    func decodeImage(image: NSImage) {
        let qrCodes = Util().decode(ciImage: image.ciImage()!)
        
        
        //self.delegate?.decodeQRCode(qrData ?? "no decoded")
        
        Task {
            await MainActor.run { [weak self] in
                (overlay as! HtwmQrOverlay).drawDetectedQRCodeBounds(qrCodes: qrCodes, imageSize: image.size )
            }
        }
        
        if qrCodes.count > 0 {
            // crop image area of qrcode
            let qrCode = qrCodes.first
            let croppedImage = image.crop(to: qrCode!.bounds!, margin: 40)
            let currentDir = NSHomeDirectory()
            croppedImage.writePNG(toURL: URL(fileURLWithPath: currentDir + "/Documents/test.png"))
            
            // htwm restful to online decoding
            
            decode.scanMode = 5
            let rectClient = RestApi.RestClient(token: UserSetting().getToken()!)
            
            rectClient.decode(body: decode) { (result: Result<RestApi.Types.Response.Decode, RestApi.Types.RestError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        print(success)
                        Util().printDate(string: "alert dismiss now")
                        //alert!.dismiss(animated: true, completion: nil)
                        var txt: String = " authentic: \(success.authentic) message: \(success.message) score: \(success.score) packageId: \(success.packageId) element: \(success.element) error: \(success.error)"
                        switch (success.error) {
                        case 0:
                            txt = txt + " " + NSLocalizedString("cp_camera_htwm_response_error_0", comment: "")
                            break
                        case 1:
                            txt = txt + " " + NSLocalizedString("cp_camera_htwm_response_error_1", bundle: Util().getBundle(),comment: "")
                            break
                        case 2:
                            txt = txt + " " + NSLocalizedString("cp_camera_htwm_response_error_2", bundle: Util().getBundle(), comment: "")
                            break
                        case 3:
                            txt = txt + " " + NSLocalizedString("cp_camera_htwm_response_error_3", bundle: Util().getBundle(), comment: "")
                            break
                        case 4:
                            txt = txt + " " + NSLocalizedString("cp_camera_htwm_response_error_4", bundle: Util().getBundle(), comment: "")
                            break
                        case 5:
                            txt = txt + " " + NSLocalizedString("cp_camera_htwm_response_error_5", bundle: Util().getBundle(), comment: "")
                            break
                        case 6:
                            txt = txt + " " + NSLocalizedString("cp_camera_htwm_response_error_6", bundle: Util().getBundle(), comment: "")
                            break
                        case 7:
                            txt = txt + " " + NSLocalizedString("cp_camera_htwm_response_error_7", bundle: Util().getBundle(), comment: "")
                            break
                        case 8:
                            txt = txt + " " + NSLocalizedString("cp_camera_htwm_response_error_8", bundle: Util().getBundle(), comment: "")
                            break
                        case 9:
                            txt = txt + " " + NSLocalizedString("cp_camera_htwm_response_error_9", bundle: Util().getBundle(), comment: "")
                            break
                        default:
                            break
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500), execute: {
                            //self.showAlert(title: NSLocalizedString("cp_camera_alert_ok", comment: ""), message: NSLocalizedString("cp_camera_upload_success", comment: "") + txt )
                            // TODO delegate show result
                        })
                        
                        
                        //self.delegate!.showAuthorizationResult(result: success)
                    case .failure(let failure):
                        print("failed: \(failure)")
                        
                        
                        var message: String = NSLocalizedString("cp_camera_network_error", bundle: Util().getBundle(), comment: "") + " " + failure.errorDescription!
                        if failure.errorDescription!.contains("User not logged: no valid token found") {
                            message = NSLocalizedString("cp_camera_user_no_login", bundle: Util().getBundle(), comment: "")
                        } else if failure.errorDescription!.contains("413") {
                            message = NSLocalizedString("cp_camera_http_response_code_413", bundle: Util().getBundle(), comment: "")
                        }
                        
                        DispatchQueue.main.async {
                            //alert!.dismiss(animated: false)
                            //alert = CPCameraUtil().showMessageAlert(title: NSLocalizedString("cp_camera_alert_error", bundle: CPCameraUtil().getBundle(), comment: ""), message: message)
                            //self.delegate!.getParent().present(alert!, animated: true, completion: nil)
                            
                            // TODO close alert -> continue capture
                            
                            //self.delegate!.showAuthorizationResult(result: nil)
                        }
                    }
                }
            }
            
            
            // show result in async
        }
    }
    
    override func decode(image: CIImage) {        
        //get UIImage out of CIImage
        let qrCodes = Util().decode(ciImage: image)
        
        
        //self.delegate?.decodeQRCode(qrData ?? "no decoded")
        
        Task {
            await MainActor.run { [weak self] in
                (overlay as! HtwmQrOverlay).drawDetectedQRCodeBounds(qrCodes: qrCodes, imageSize: image.extent.size )
            }
        }
        
        
        // crop image area of qrcode
        
        // htwm restful to online decoding
        
        // show result in async
    }
}
