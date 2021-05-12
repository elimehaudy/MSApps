//
//  MoviesTableViewController.swift
//  MSApps
//
//  Created by Eli Mehaudy on 02/05/2021.
//

import UIKit
import CoreData

class MoviesListViewController: UIViewController, Storyboarded{
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var viewModel: MoviesListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        registerTableViewCell()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraTapped))
        navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel?.fetchMovies()
            self.moviesTableView.reloadData()
        }
    }
    
    @objc func cameraTapped() {
        viewModel?.openCamera()
    }
    
    private func registerTableViewCell() {
        let movieCell = UINib(nibName: "MovieCell", bundle: nil)
        moviesTableView.register(movieCell, forCellReuseIdentifier: "movieCell")
    }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.moviesArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as? MovieCell {
            if let movieImage = viewModel?.moviesArray[indexPath.row].image {
                cell.cellImage.image = UIImage(named: "movieLogo")
                cell.cellImage.loadImageFromURL(url: URL(string: movieImage)!)
            }
            cell.cellTitle.text = viewModel?.moviesArray[indexPath.row].title
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedMovieUnwrapped = viewModel?.moviesArray[indexPath.row] {
            viewModel?.passMovie(movie: selectedMovieUnwrapped)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
