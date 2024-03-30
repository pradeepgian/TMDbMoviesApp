//
//  MovieViewModel.swift
//  TMDbMoviesApp
//
//  Created by Pradeep Gianchandani on 26/03/24.
//

import Foundation
import TMDbNetworkSDK

struct MovieViewModel: ViewModelProtocol {
    
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var movieImageURL: URL? {
        guard let posterPath = movie.posterPath else { return nil }
        let urlString = TMDbSDKConstants.imageBaseURL + posterPath
        return URL(string: urlString)
    }
    
    var backdropImageURL: URL? {
        guard let posterPath = movie.posterPath else { return nil }
        let urlString = TMDbSDKConstants.imageBaseURL + posterPath
        return URL(string: urlString)
    }
    
    var movieTitle: String {
        return movie.title
    }
    
    var releaseDate: String {
        return movie.releaseDate.formatDateString(from: "yyyy-MM-dd", to: "MMM d, yyyy") ?? ""
    }
    
    var movieSummary: String {
        return movie.overview
    }
    
    var movieTitleWithReleaseYear: String {
        guard let year = movie.releaseDate.extractYear() else {
            return movieTitle
        }
        return "\(movieTitle) (\(year))"
    }
    
}
