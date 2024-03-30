//
//  MovieDataRepositoryTests.swift
//  TMDbMoviesAppTests
//
//  Created by Pradeep Gianchandani on 30/03/24.
//

import XCTest
import Combine
import TMDbNetworkSDK
@testable import TMDbMoviesApp

class MovieDataRepositoryTests: XCTestCase {
    
    var mockNetworkClient: TMDbNetworkClientMock!
    var movieDataRepository: MovieDataRepository!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = TMDbNetworkClientMock(apiKey: APIConstants.apiKey)
        movieDataRepository = MovieDataRepository(networkClient: mockNetworkClient)
    }
    
    override func tearDown() {
        mockNetworkClient = nil
        movieDataRepository = nil
        super.tearDown()
    }
    
    func testGetPopularMovies() {
        let mockResponse = loadMockResponse(filename: "popular_movies")
        mockNetworkClient.fetchPopularMoviesReturnValue = Just(mockResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        mockNetworkClient.fetchPopularMoviesReturnValue = Just(mockResponse).setFailureType(to: Error.self).eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "Fetch popular movies")
        
        var receivedMovies: [Movie] = []
        let cancellable = movieDataRepository.getPopularMovies()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // Success
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            }, receiveValue: { movies in
                receivedMovies = movies
            })
        
        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(receivedMovies, mockResponse.results)
        cancellable.cancel()
    }
    
    func testGetLatestMovies() {
        // Mock successful response
        let mockResponse = loadMockResponse(filename: "latest_movies")
        mockNetworkClient.fetchLatestMoviesReturnValue = Just(mockResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        mockNetworkClient.fetchLatestMoviesReturnValue = Just(mockResponse).setFailureType(to: Error.self).eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "Fetch latest movies")
        
        var receivedMovies: [Movie] = []
        let cancellable = movieDataRepository.getLatestMovies()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // Success
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            }, receiveValue: { movies in
                receivedMovies = movies
            })
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(receivedMovies, mockResponse.results)
        cancellable.cancel()
    }
    
    func loadMockResponse(filename: String) -> MovieListResponse {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: filename, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        let response = try! decoder.decode(MovieListResponse.self, from: data)
        return response
    }
    
}

class TMDbNetworkClientMock: TMDbNetworkClient {
    var fetchPopularMoviesReturnValue: AnyPublisher<MovieListResponse, Error>!
    var fetchLatestMoviesReturnValue: AnyPublisher<MovieListResponse, Error>!
    
    override func fetchPopularMovies<T: Decodable>() -> AnyPublisher<T, Error> {
        return fetchPopularMoviesReturnValue as! AnyPublisher<T, Error>
    }
    
    override func fetchLatestMovies<T: Decodable>() -> AnyPublisher<T, Error> {
        return fetchLatestMoviesReturnValue as! AnyPublisher<T, Error>
    }
}

