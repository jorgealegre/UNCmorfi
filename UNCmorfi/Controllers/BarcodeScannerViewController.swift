//
//  BarcodeScannerViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 5/23/17.
//
//  LICENSE is at the root of this project's repository.
//

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // MARK: Properties
    public var delegate: UserTableViewController?
    
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

        navigationItem.title = NSLocalizedString("barcodescanner.nav.label", comment: "Barcode Scanner")

        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice!) else {
            return
        }
        
        let captureSession = AVCaptureSession()
        captureSession.addInput(input)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.code39]
        
        // Add video preview.
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        captureSession.startRunning()
    }
    
    // Video capture delegate.
    func metadataOutput(captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count != 0 else { return }
        guard let metadata = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else { return }
        
        if metadata.type == AVMetadataObject.ObjectType.code39, let code = metadata.stringValue {
            let user = User(fromCode: code)
            delegate?.add(user: user)
            navigationController?.popViewController(animated: true)
        }
    }
}
