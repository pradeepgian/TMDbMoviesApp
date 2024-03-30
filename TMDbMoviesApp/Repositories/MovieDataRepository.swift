//
//  MovieDataRepository.swift
//  TMDbMoviesApp
//
//  Created by Pradeep Gianchandani on 25/03/24.
//

import Foundation
import Combine
import TMDbNetworkSDK

class MovieDataRepository: MovieRepository {
    private let networkClient: TMDbNetworkClient
    
    init(networkClient: TMDbNetworkClient) {
        self.networkClient = networkClient
    }
    
    func getPopularMovies() -> AnyPublisher<[Movie], Error> {
        return networkClient.fetchPopularMovies()
            .map { (response: MovieListResponse) -> [Movie] in
                return Array(response.results)
            }
            .eraseToAnyPublisher()
    }
    
    func getLatestMovies() -> AnyPublisher<[Movie], Error> {
        return networkClient.fetchLatestMovies()
            .map { (response: MovieListResponse) -> [Movie] in
                return Array(response.results)
            }
            .eraseToAnyPublisher()
    }
}

