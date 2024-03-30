//
//  MovieDetailController.swift
//  TMDbMoviesApp
//
//  Created by Pradeep Gianchandani on 28/03/24.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController, UIScrollViewDelegate {
    
    lazy private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        return scrollView
    }()
    private let movieTitleYearLabel = UILabel(font: .boldSystemFont(ofSize: 25), textColor: .black, numberOfLines: 1, alignment: .left)
    private let overviewLabel = UILabel(font: .systemFont(ofSize: 20), textColor: .black, numberOfLines: 0, alignment: .left)
    private let movieBackDropView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private var movieViewModel: MovieViewModel?
    private let extraSwipingHeight: CGFloat = 40
    
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        scrollView.addSubview(movieBackDropView)
        
        let overviewLabelsStackView = StackView(axis: .vertical, arrangedSubviews: [movieTitleYearLabel, overviewLabel], spacing: 8, alignment: .leading)
        scrollView.addSubview(overviewLabelsStackView)
        overviewLabelsStackView.anchor(top: movieBackDropView.bottomAnchor,
                                       leading: view.leadingAnchor,
                                       bottom: nil,
                                       trailing: view.trailingAnchor,
                                       padding: .init(top: 20, left: 10, bottom: 20, right: 10))
    }
    
    override func viewDidLoad() {
        setupLayout()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        movieBackDropView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width, height: 0.8 * width + extraSwipingHeight)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        movieBackDropView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.8 * view.frame.width + extraSwipingHeight)
    }
    
}

extension MovieDetailViewController: ConfigureDataInViewProtocol {
    func updateDataInView(from viewModel: ViewModelProtocol) {
        if let movieViewModel = viewModel as? MovieViewModel {
            movieBackDropView.sd_setImage(with: movieViewModel.backdropImageURL)
            movieTitleYearLabel.text = movieViewModel.movieTitleWithReleaseYear
            overviewLabel.text = movieViewModel.movieSummary
        }
    }
}
