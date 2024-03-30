//
//  LatestMoviesController.swift
//  TMDbMoviesApp
//
//  Created by Pradeep Gianchandani on 26/03/24.
//

import Foundation
import UIKit
import Combine
import TMDbNetworkSDK

class LatestMoviesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let moviesViewModel: MoviesViewModel = {
        let networkClient = TMDbNetworkClient(apiKey: APIConstants.apiKey)
        let movieRepository = MovieDataRepository(networkClient: networkClient)
        let viewModel = MoviesViewModel(repository: movieRepository)
        return viewModel
    }()
    private var cancellables = Set<AnyCancellable>()
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.cellIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        collectionView.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        moviesViewModel.fetchLatestMovies()
        latestMoviesViewModelObserver()
    }
    
    private func latestMoviesViewModelObserver() {
        moviesViewModel.$fetchLatestMoviesState
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                    case .loading:
                        self.activityIndicator.startAnimating()
                    case .complete:
                        self.activityIndicator.stopAnimating()
                        self.collectionView.reloadData()
                        break
                    case .error(let error):
                        self.activityIndicator.stopAnimating()
                        print("Something went wrong \(String(describing: error))")
                        let errorMessage = error.localizedDescription
                        print(errorMessage)
                    default:
                        break
                }
            }
            .store(in: &cancellables)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2 * 16)
        return .init(width: width, height: 150)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesViewModel.numberOfRowsForLatestMoviesIn(section: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.cellIdentifier, for: indexPath) as! MovieCell
        if let movieViewModel = moviesViewModel.getLatestMovieCellViewModel(for: indexPath) {
            cell.updateDataInView(from: movieViewModel)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailController = MovieDetailViewController()
        if let movieViewModel = moviesViewModel.getLatestMovieCellViewModel(for: indexPath) {
            movieDetailController.updateDataInView(from: movieViewModel)
        }
        navigationController?.pushViewController(movieDetailController, animated: true)
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
