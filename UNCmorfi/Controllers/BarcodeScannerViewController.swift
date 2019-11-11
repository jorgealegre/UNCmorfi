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

protocol BarcodeScannerViewControllerDelegate: AnyObject {
    func barcodeScanner(_ barcodeScannerViewController: BarcodeScannerViewController,
                        didScanCode code: String)
}

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - Properties

    weak var delegate: BarcodeScannerViewControllerDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "barcodescanner.nav.label".localized()

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
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count != 0 else { return }
        guard let metadata = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else { return }
        
        if metadata.type == AVMetadataObject.ObjectType.code39, let code = metadata.stringValue {
            delegate?.barcodeScanner(self, didScanCode: code)
            dismiss(animated: true, completion: nil)
        }
    }
}
