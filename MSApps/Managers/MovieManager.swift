//
//  MovieManager.swift
//  MSApps
//
//  Created by Eli Mehaudy on 03/05/2021.
//

import UIKit
import CoreData

class MovieManager {
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func setValuesForMovie(id: String, title: String, image: String, rating: Double, releaseYear: Int32, genres: [String],  completion: (()->Void)?) {
        let newMovie: Movie!
        
        let fetchMovie: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchMovie.predicate = NSPredicate(format: "id = %@", id as String)
        
        let results = try? managedContext.fetch(fetchMovie)
        
        if results?.count == 0 {
            newMovie = Movie(context: managedContext)
            newMovie.id = id
        } else {
            newMovie = results?.first
        }
        newMovie.title = title
        newMovie.image = image
        newMovie.rating = rating
        newMovie.releaseYear = releaseYear
        
        genres.forEach { (genre) in
            setValuesForGenre(genre: genre, parentMovie: newMovie)
        }
        saveMovie()
        completion?()
    }
    
    func setValuesForGenre(genre: String, parentMovie: Movie) {
        
        let newGenre = MovieGenres(context: managedContext)
        newGenre.genre = genre
        newGenre.parentMovie = parentMovie
    }
    
    func saveMovie() {
        do {
            try managedContext.save()
        } catch {
            print("Error saving movie, \(error)")
        }
    }
    
    func loadMovies() -> [Movie]?{
        let moviesRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        do {
            let movies = try managedContext.fetch(moviesRequest)
            return movies.sorted(by: { (first, second) in
                return first.releaseYear > second.releaseYear
            })
        } catch {
            print("Couldn't load movies, \(error)")
            return nil
        }
    }
    
    func loadMovieByID(id: String) -> Movie? {
        var movieFound: Movie?
        let movies = loadMovies()
        movies?.forEach { (movie) in
            if movie.id == id {
                movieFound = movie
                return
            }
        }
       return movieFound
    }
}
