//
//  ViewController.swift
//  MSApps
//
//  Created by Eli Mehaudy on 02/05/2021.
//

import UIKit

class SplashViewController: UIViewController, Storyboarded {
    
    var viewModel: SplashViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        viewModel?.getMovies()
    }
    
}

