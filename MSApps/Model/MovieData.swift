//
//  MovieData.swift
//  MSApps
//
//  Created by Eli Mehaudy on 02/05/2021.
//

import Foundation

struct MovieData: Codable {
    let title: String
    let image: String
    let rating: Double
    let releaseYear: Int32
    let genre: [String]
}
