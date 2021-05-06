//
//  QRScannerViewModel.swift
//  MSApps
//
//  Created by Eli Mehaudy on 04/05/2021.
//

import Foundation
import AVFoundation

protocol QRScannerViewModelDelegate {
    func showAlert(withTitle title: String, message: String)
    func removeSubrange()
    func configurePreviewLayerFrame(camera: AVCaptureVideoPreviewLayer)
}

class QRScannerViewModel {
    
    var didFinishQRScan: ((Movie)-> Void)?
    private let networkManager: NetworkManager
    private let movieManager: MovieManager
    private let cameraManager = CameraManager()
    var delegate: QRScannerViewModelDelegate?
    
    init(networkManager: NetworkManager, movieManager: MovieManager) {
        self.networkManager = networkManager
        self.movieManager = movieManager
        cameraManager.delegate = self
    }
    
    func willUseScanner() {
        cameraManager.checkPermissions()
        cameraManager.setupCameraLiveView()
    }
    
}

extension QRScannerViewModel: CameraManagerDelegate {
    func willShowAlert(withTitle title: String, message: String) {
        delegate?.showAlert(withTitle: title, message: message)
    }
    
    func willRemoveSubrange() {
        delegate?.removeSubrange()
    }
    
    func willConfigurePreviewLayerFrame(camera: AVCaptureVideoPreviewLayer) {
        delegate?.configurePreviewLayerFrame(camera: camera)
    }
    
    func didScanValidQRCode(QRCode: String) {
        networkManager.getRequest(url: QRCode) { [weak self] (movieData: MovieData?, error) in
            if movieData != nil {
                let id = String(movieData!.releaseYear)+movieData!.title.replacingOccurrences(of: " ", with: "")
                self?.movieManager.setValuesForMovie(id: id, title: movieData!.title, image: movieData!.image, rating: movieData!.rating, releaseYear: movieData!.releaseYear, genres: movieData!.genre) { [weak self] in
                    let movie = self?.movieManager.loadMovieByID(id: id)
                    if movie != nil {
                        self?.didFinishQRScan?(movie!)
                        self?.cameraManager.stopCameraLiveView()
                    }
                }
            }
        }
    }
}
