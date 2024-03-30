//
//  MovieRepository.swift
//  TMDbMoviesApp
//
//  Created by Pradeep Gianchandani on 25/03/24.
//

import Combine

protocol MovieRepository {
    func getPopularMovies() -> AnyPublisher<[Movie], Error>
    func getLatestMovies() -> AnyPublisher<[Movie], Error>
}
