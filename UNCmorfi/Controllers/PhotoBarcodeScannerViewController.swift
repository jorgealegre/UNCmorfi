//
//  PhotoBarcodeScannerViewController.swift
//  UNCmorfi
//
//  Created by George Alegre on 13/11/2019.
//  Copyright © 2019 George Alegre. All rights reserved.
//

import UIKit
import Vision

class PhotoBarcodeScannerViewController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties

    private lazy var vnBarcodeDetectionRequest: VNDetectBarcodesRequest = {
        let request = VNDetectBarcodesRequest(completionHandler: handleBarcodeDetectionResult)
        return request
    }()

    weak var barcodeHandler: BarcodeHandler?

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        sourceType = .photoLibrary
        delegate = self
    }

    // MARK: - VNDetectBarcodeRequestHandler

    private func handleBarcodeDetectionResult(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard error == nil else {
                print("Error in detecting - \(error!)")
                return
            }

            // Force casting because we only detect barcodes. This should never fail.
            let observations = request.results as! [VNBarcodeObservation]

            guard let detectedBarcode = observations.first(where: { $0.symbology == .Code39 })?.payloadStringValue else {
                let alert = UIAlertController(title: "error".localized(),
                                              message: "noBarcodeDetected".localized(), preferredStyle: .alert)
                alert.addAction(.init(title: "ok".localized(), style: .default))
                self.present(alert, animated: true)
                return
            }

            print("Detected barcode: \(detectedBarcode)")

            self.barcodeHandler?.barcodeDetected(detectedBarcode)
            self.dismiss(animated: true)
        }
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage, let cgImage = image.cgImage else {
            return
        }

        let detectionRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try detectionRequestHandler.perform([self.vnBarcodeDetectionRequest])
            } catch {
                print("Failed to perform image request: \(error)")
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
