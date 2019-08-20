//
//  MovieDetailViewController.swift
//  movies
//
//  Created by Murilo Alves Alborghette on 8/19/19.
//  Copyright © 2019 Alborghette. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var movie: MovieModel?
    var genre: String?
    var posterUrl: URL?
    
    let imageWidthRequest = "w400"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupMovieData()
        setupImageViewAction()
    }
    
    private func setupLayout() {
        title = R.string.localizable.movieDetailTitle()
        overviewLabel.textAlignment = .justified
    }
    
    private func setupMovieData() {
        if let posterPath = movie?.posterPath {
            posterUrl = URL(string: String(format: TheMovieDbConfiguration.imageBaseUrl, imageWidthRequest, posterPath))
            movieImageView.kf.setImage(with: posterUrl)
        }
        titleLabel.text = movie?.title
        genreLabel.text = genre
        overviewLabel.text = movie?.overview
        releaseDateLabel.text = movie?.releaseDate
    }
    
    private func setupImageViewAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPoster))
        movieImageView.isUserInteractionEnabled = true
        movieImageView.addGestureRecognizer(tap)
    }
    
    @objc private func showPoster() {
        performSegue(withIdentifier: R.segue.movieDetailViewController.goToPosterView, sender: nil)
    }
    
    // Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let posterViewController = segue.destination as? PosterViewController {
            posterViewController.posterUrl = posterUrl
        }
    }
    
}
