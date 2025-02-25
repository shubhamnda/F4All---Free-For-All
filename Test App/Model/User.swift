//
//  User.swift
//  Test App
//
//  Created by Shubham Nanda on 24/02/25.
//

import Foundation
struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let backdropPath: String?
    let posterPath: String?

    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
       
    }
}

// TMDb API returns results in a "results" array
struct MovieResponse: Codable {
    let results: [Movie]
}
