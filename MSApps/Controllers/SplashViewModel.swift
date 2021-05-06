//
//  SplashViewModel.swift
//  MSApps
//
//  Created by Eli Mehaudy on 03/05/2021.
//

import Foundation

class SplashViewModel {
    
    var didFinish: (() -> Void)?
    private let networkManager: NetworkManager
    private let movieManager: MovieManager
    private let requestMoviesURL = "https://api.androidhive.info/json/movies.json"

    init(networkManager: NetworkManager, movieManager: MovieManager) {
        self.networkManager = networkManager
        self.movieManager = movieManager
    }
    
    func getMovies() {
        networkManager.getRequest(url: requestMoviesURL) { [weak self] (response: [MovieData]?, error) in
            response?.forEach { [weak self] (movie) in
                let id = String(movie.releaseYear)+movie.title.replacingOccurrences(of: " ", with: "")
                self?.movieManager.setValuesForMovie(id: id, title: movie.title, image: movie.image, rating: movie.rating, releaseYear: movie.releaseYear, genres: movie.genre, completion: nil)
            }
            self?.didFinish?()
        }
    }
}
