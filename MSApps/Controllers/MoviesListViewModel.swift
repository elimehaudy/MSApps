//
//  MoviesListViewModel.swift
//  MSApps
//
//  Created by Eli Mehaudy on 03/05/2021.
//

import Foundation

protocol MoviesListViewModelDelegate {
    func viewIsVisible()
}

class MoviesListViewModel {
    
    var didSelectMovie: ((Movie)-> Void)?
    var didSelectCamera: (()-> Void)?
    var moviesArray = [Movie]()
    var delegate: MoviesListViewModelDelegate?
    
    private let movieManager: MovieManager
    
    init(movieManager: MovieManager) {
        self.movieManager = movieManager
    }
    
    func fetchMovies(){
        if let movies = movieManager.loadMovies() {
            moviesArray = movies
        }
    }
    
    func passMovie(movie: Movie?){
        if movie != nil {
            didSelectMovie?(movie!)
        }
    }
    
    func openCamera(){
        didSelectCamera?()
    }
}
