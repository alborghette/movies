//
//  MovieTableViewCell.swift
//  movies
//
//  Created by Murilo Alves Alborghette on 8/19/19.
//  Copyright © 2019 Alborghette. All rights reserved.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MovieTableViewCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var textsBackgroundView: UIView!
    
    var movieId: Int?
    
    let imageWidthRequest = "w400"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    private func setupLayout() {
        selectionStyle = .none
        textsBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.60)
        containerView.roundCorners(withRadius: 5)
        
        let labels = [titleLabel, genreLabel, releaseDateLabel]
        labels.forEach { $0?.textColor = .white }
    }

    func setupCell(id: Int, title: String, imageUrl: String, genre: String, releaseDate: String) {
        
        movieId = id
        movieImageView.kf.setImage(with: URL(string: String(format:TheMovieDbConfiguration.imageBaseUrl, imageWidthRequest, imageUrl)))
        titleLabel.text = title
        genreLabel.text = genre
        releaseDateLabel.text = releaseDate
        
    }

}
