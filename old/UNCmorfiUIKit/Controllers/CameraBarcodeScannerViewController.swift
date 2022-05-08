//
// Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import AVFoundation

class CameraBarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - Properties

    weak var barcodeHandler: BarcodeHandler?

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private var captureSession: AVCaptureSession!

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = .scanning

        let captureDevice = AVCaptureDevice.default(for: .video)
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice!) else {
            return
        }
        
        captureSession = AVCaptureSession()
        captureSession.addInput(input)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)

        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        captureMetadataOutput.metadataObjectTypes = [.code39]
        
        // Add video preview.
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        captureSession.startRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        
        guard metadata.type == .code39, let code = metadata.stringValue else {
            return
        }

        captureSession.stopRunning()
        barcodeHandler?.barcodeDetected(code)
        dismiss(animated: true)
    }
}
