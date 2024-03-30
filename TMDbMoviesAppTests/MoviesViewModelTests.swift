//
//  MoviesViewModelTests.swift
//  TMDbMoviesAppTests
//
//  Created by Pradeep Gianchandani on 30/03/24.
//

import XCTest
import Combine
@testable import TMDbMoviesApp

class MoviesViewModelTests: XCTestCase {
    var moviesViewModel: MoviesViewModel!
    var mockRepository: MockMovieRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockMovieRepository()
        moviesViewModel = MoviesViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        mockRepository = nil
        moviesViewModel = nil
        super.tearDown()
    }
    
    func testFetchPopularMoviesChangesStateToLoading() {
        mockRepository.mockGetPopularMoviesResponse = Empty().eraseToAnyPublisher()
        moviesViewModel.fetchPopularMovies()
        XCTAssertEqual(moviesViewModel.fetchPopularMoviesState, .loading)
    }
        
    func testFetchPopularMoviesUpdatesPopularMoviesCorrectly() {
        let mockMovies = [Movie(id: 1,
                                    title: "Kung Fu Panda 4",
                                    overview: "Some overview",
                                    posterPath: "/kDp1vUBnMpe8ak4rjgl3cLELqjU.jpg",
                                    releaseDate: "2024-03-02",
                                    backdropPath: "/1XDDXPXGiI8id7MrUxK36ke7gkX.jpg"),
                              Movie(id: 2,
                                    title: "Madame Web",
                                    overview: "Some overview",
                                    posterPath: "/rULWuutDcN5NvtiZi4FRPzRYWSh.jpg",
                                    releaseDate: "2024-02-14",
                                    backdropPath: "/zAepSrO99owYwQqi0QG2AS0dHXw.jpg")]
        mockRepository.mockGetPopularMoviesResponse = Just(mockMovies).setFailureType(to: Error.self).eraseToAnyPublisher()
        let fetchExpectation = expectation(description: "Fetch popular movies")
        moviesViewModel.fetchPopularMovies()
        var receivedPopularMovies = [Movie]()
        let cancellable = moviesViewModel.$fetchPopularMoviesState
            .sink { _ in } receiveValue: { state in
                if state == .complete {
                    receivedPopularMovies = self.moviesViewModel.popularMovies
                    if receivedPopularMovies == mockMovies {
                        fetchExpectation.fulfill()
                    }
                }
            }
        waitForExpectations(timeout: 1.5)
        XCTAssertEqual(receivedPopularMovies, mockMovies)
        cancellable.cancel()
    }
    
    func testFetchPopularMoviesHandlesError() {
        let expectedError = NSError(domain: "TestError", code: 0, userInfo: nil)
        mockRepository.mockGetPopularMoviesResponse = Fail(error: expectedError).eraseToAnyPublisher()
        moviesViewModel.fetchPopularMovies()
        XCTAssertEqual(moviesViewModel.fetchPopularMoviesState, .loading)
        XCTAssertEqual(moviesViewModel.popularMovies, [])
        let expectation = XCTestExpectation(description: "Waiting for fetch to complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.moviesViewModel.fetchPopularMoviesState, .error(expectedError))
            XCTAssert(self.moviesViewModel.popularMovies.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetPopularMovieCellViewModelReturnsCorrectViewModel() {
        let movie = Movie(id: 1,
                          title: "Kung Fu Panda 4",
                          overview: "Some overview",
                          posterPath: "/kDp1vUBnMpe8ak4rjgl3cLELqjU.jpg",
                          releaseDate: "2024-03-02",
                          backdropPath: "/1XDDXPXGiI8id7MrUxK36ke7gkX.jpg")
        moviesViewModel.popularMovies = [movie]
        let movieViewModel = moviesViewModel.getPopularMovieCellViewModel(for: IndexPath(row: 0, section: 0)) as? MovieViewModel
        XCTAssertEqual(movieViewModel?.movieTitle, movie.title)
    }

    
}

class MockMovieRepository: MovieRepository {
    var mockGetPopularMoviesResponse: AnyPublisher<[Movie], Error>!
    var mockGetLatestMoviesResponse: AnyPublisher<[Movie], Error>!
    
    func getPopularMovies() -> AnyPublisher<[Movie], Error> {
        return mockGetPopularMoviesResponse
    }
    
    func getLatestMovies() -> AnyPublisher<[Movie], Error> {
        return mockGetLatestMoviesResponse
    }
}
