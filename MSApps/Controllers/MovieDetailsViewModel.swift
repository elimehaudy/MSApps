//
//  MovieDetailsViewModel.swift
//  MSApps
//
//  Created by Eli Mehaudy on 05/05/2021.
//

import Foundation

class MovieDetailsViewModel {
        
    var movieDetailsToBeShown: Movie?
    
    func passMovieDetails(movie: Movie?) {
        movieDetailsToBeShown = movie
    }
}
