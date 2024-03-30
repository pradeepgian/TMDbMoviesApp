//
//  Movie.swift
//  TMDbMoviesApp
//
//  Created by Pradeep Gianchandani on 26/03/24.
//

import Foundation

struct Movie: Codable, Hashable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let backdropPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
    }
    
}

struct MovieListResponse: Decodable {
    let results: [Movie]
}
