//
//  MovieDetailsViewController.swift
//  MSApps
//
//  Created by Eli Mehaudy on 03/05/2021.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController, Storyboarded {
    
    var viewModel: MovieDetailsViewModel?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    var selectedMovie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        populateViewWithDetails()
    }

    func populateViewWithDetails() {
        if selectedMovie != nil {
            imageView.sd_setImage(with: URL(string: selectedMovie!.image!), placeholderImage: UIImage(named: "movieLogo"))
            titleLabel.text = selectedMovie?.title
            if let yearInt = selectedMovie?.releaseYear {
                yearLabel.text = String(yearInt)
            }
            if let ratingDouble = selectedMovie?.rating {
                ratingLabel.text = String(format: "%.1f",  ratingDouble)
            }
            guard let genres = selectedMovie?.childGenres?.value(forKey: "genre") as? NSSet else { return }
            guard let genresArray = genres.allObjects as? [String] else { return }
            
            genreLabel.text = genresArray.joined(separator: ", ")
        }
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
