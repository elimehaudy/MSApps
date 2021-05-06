//
//  QRSCannerViewController.swift
//  MSApps
//
//  Created by Eli Mehaudy on 04/05/2021.
//

import UIKit
import AVFoundation

class QRSCannerViewController: UIViewController, Storyboarded {
    
    var viewModel: QRScannerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        viewModel?.willUseScanner()
    }
}

extension QRSCannerViewController: QRScannerViewModelDelegate {
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }
    }
    
    func removeSubrange() {
        self.view.layer.sublayers?.removeSubrange(1...)
    }
    
    func configurePreviewLayerFrame(camera: AVCaptureVideoPreviewLayer) {
        camera.frame = view.frame
        view.layer.insertSublayer(camera, at: 0)
    }
}

