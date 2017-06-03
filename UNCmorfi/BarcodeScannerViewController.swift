//
//  BarcodeScannerViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 5/23/17.
//  Copyright © 2017 George Alegre. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // MARK: Properties
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var barcodeFrameView: UIView?
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: Model
    var user: User?
    
    // MARK: Actions
    @IBAction func close(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToUserList", sender: self)
    }
    
    // Make status bar visible.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Camera starts on top of views.
        closeButton.layer.zPosition = 1
        
        /* Prepare camera related stuff.
         */
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeCode39Code]
            
            // Add video preview.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
        } catch {
            print(error)
            return
        }
    }
    
    // Video capture delegate.
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 { return }
        
        // Get the metadata object.
        let metadata = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadata.type == AVMetadataObjectTypeCode39Code {
            if let code = metadata.stringValue {
                user = User(code: code)
                
                DispatchQueue.main.async {
                    self.user!.update { }
                }
                
                self.performSegue(withIdentifier: "unwindToUserList", sender: self)
            }
        }
    }
}
