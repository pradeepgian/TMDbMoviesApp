//
//  MovieCell.swift
//  TMDbMoviesApp
//
//  Created by Pradeep Gianchandani on 26/03/24.
//

import Foundation
import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
    
    static let cellIdentifier = "MovieCell_Identifier"
    
    private let movieImageView = UIImageView()
    private let movieNameLabel = UILabel(text: "Movie Name", font: .boldSystemFont(ofSize: 16), textColor: .black, numberOfLines: 1, alignment: .left)
    private let releaseDateLabel = UILabel(text: "01-01-2002", font: .systemFont(ofSize: 13), textColor: .black, numberOfLines: 1, alignment: .left)
    private let movieSummaryLabel = UILabel(text: "Movie Summary", font: .systemFont(ofSize: 13), textColor: .black, numberOfLines: 0, alignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(movieImageView)
        movieImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil)
        movieImageView.constrainWidth(constant: 100)
        movieImageView.layer.masksToBounds = true
        movieImageView.contentMode = .scaleAspectFill
        
        let titleDateLabelStackView = StackView(axis: .vertical, arrangedSubviews: [movieNameLabel, releaseDateLabel], alignment: .leading)
        let labelsStackView = StackView(axis: .vertical, arrangedSubviews: [titleDateLabelStackView, movieSummaryLabel], spacing: 10, alignment: .leading)
        titleDateLabelStackView.constrainHeight(constant: 45)
        contentView.addSubview(labelsStackView)
        labelsStackView.anchor(top: topAnchor, leading: movieImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 15, left: 20, bottom: 20, right: 4))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        stylizeCell()
    }
    
    private func stylizeCell() {
        contentView.layer.cornerRadius = 20.0
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.gray.cgColor
        
    }
    
    func updateDataInView(from viewModel: ViewModelProtocol) {
        let movieViewModel = viewModel as? MovieViewModel
        movieImageView.sd_setImage(with: movieViewModel?.movieImageURL)
        movieNameLabel.text = movieViewModel?.movieTitle
        releaseDateLabel.text = movieViewModel?.releaseDate
        movieSummaryLabel.text = movieViewModel?.movieSummary
    }
    
}
