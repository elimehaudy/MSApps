//
//  MainCoordinator.swift
//  MSApps
//
//  Created by Eli Mehaudy on 02/05/2021.
//

import UIKit
import CoreData

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var networkManager = NetworkManager()
    var movieManager = MovieManager()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SplashViewController.instantiate()
        let viewModel = SplashViewModel(networkManager: networkManager, movieManager: movieManager)
        viewModel.didFinish = { [weak self] in
            self?.goToTable()
        }
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToTable() {
        let vc = MoviesListViewController.instantiate()
        let viewModel = MoviesListViewModel(movieManager: movieManager)
        viewModel.didSelectMovie = { [weak self] (movie) in
            self?.showMovieDetails(selectedMovie: movie)
        }
        viewModel.didSelectCamera = { [weak self] in
            self?.goToCamera()
        }
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showMovieDetails(selectedMovie: Movie?) {
        if selectedMovie != nil {
            let vc = MovieDetailsViewController.instantiate()
            let viewModel = MovieDetailsViewModel()
            viewModel.passMovieDetails(movie: selectedMovie)
            DispatchQueue.main.async {
                self.navigationController.present(vc, animated: true)
            }
            vc.viewModel = viewModel
            vc.selectedMovie = selectedMovie
        }
    }
    
    func goToCamera() {
        let vc = QRSCannerViewController.instantiate()
        let viewModel = QRScannerViewModel(networkManager: networkManager, movieManager: movieManager)
        viewModel.didFinishQRScan = { [weak self] (movie) in
            self?.navigationController.popViewController(animated: true)
            self?.showMovieDetails(selectedMovie: movie)
        }
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
