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
    public var delegate: UserTableViewController?
    private let closeButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // Make status bar visible.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        
        let captureSession = AVCaptureSession()
        captureSession.addInput(input)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeCode39Code]
        
        // Add video preview.
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)!
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        captureSession.startRunning()
        
        // Camera starts on top of views.
//        closeButton.layer.zPosition = 1
        
    }
    
    // Video capture delegate.
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        guard metadataObjects != nil && metadataObjects.count != 0 else { return }
        guard let metadata = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else { return }
        
        if metadata.type == AVMetadataObjectTypeCode39Code {
            if let code = metadata.stringValue {
                let user = User(fromCode: code)
                
                DispatchQueue.main.async {
                    user.update { }
                }
                delegate?.add(user: user)
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
