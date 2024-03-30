//
//  PopularMoviesViewModel.swift
//  TMDbMoviesApp
//
//  Created by Pradeep Gianchandani on 26/03/24.
//

import Foundation
import Combine

class MoviesViewModel: ViewModelProtocol {
    
    private let repository: MovieRepository
    
    @Published var popularMovies: [Movie] = []
    @Published var latestMovies: [Movie] = []
    
    @Published var fetchPopularMoviesState: ScreenState = .idle
    @Published var fetchLatestMoviesState: ScreenState = .idle
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func fetchPopularMovies() {
        fetchPopularMoviesState = .loading
        repository.getPopularMovies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                    case .finished:
                        self.fetchPopularMoviesState = .complete
                    case .failure(let error):
                        self.fetchPopularMoviesState = .error(error)
                }
            }, receiveValue: { [weak self] movies in
                guard let self = self else { return }
                self.popularMovies = movies
                print("popular movies = \(popularMovies)")
            })
            .store(in: &cancellables)
    }
    
    func fetchLatestMovies() {
        fetchLatestMoviesState = .loading
        repository.getLatestMovies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                    case .finished:
                        self.fetchLatestMoviesState = .complete
                    case .failure(let error):
                        self.fetchLatestMoviesState = .error(error)
                }
            }, receiveValue: { [weak self] movies in
                guard let self = self else { return }
                self.latestMovies = movies
                print("latest movies = \(latestMovies)")
            })
            .store(in: &cancellables)
    }
    
    func numberOfRowsForPopularMoviesIn(section: Int) -> Int {
        popularMovies.count
    }
    
    func numberOfRowsForLatestMoviesIn(section: Int) -> Int {
        latestMovies.count
    }
    
    func getPopularMovieCellViewModel(for indexPath: IndexPath) -> ViewModelProtocol? {
        let movieViewModel = MovieViewModel(movie: popularMovies[indexPath.row])
        return movieViewModel
    }
    
    func getLatestMovieCellViewModel(for indexPath: IndexPath) -> ViewModelProtocol? {
        let movieViewModel = MovieViewModel(movie: latestMovies[indexPath.row])
        return movieViewModel
    }
    
}
