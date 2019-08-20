//
//  MovieListViewController.swift
//  movies
//
//  Created by Murilo Alves Alborghette on 8/19/19.
//  Copyright © 2019 Alborghette. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var movieBusiness: MovieBusinessProtocol = MovieBusiness()
    var genreBusiness: GenreBusinessProtocol = GenreBusiness()
    
    var movieList: MovieListModel?
    var genreList: GenreListModel?
    var currentPage = 0
    var isLoading = false
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        requestGenreList { [weak self] in
            self?.refreshMovieList()
        }
        
    }
    
    private func setupTableView() {
        title = R.string.localizable.movieListTitle()
        
        movieTableView.refreshControl = refreshControl
        movieTableView.refreshControl?.addTarget(self, action: #selector(refreshMovieList), for: .valueChanged)
        movieTableView.tableFooterView = UIView()
        movieTableView.separatorStyle = .none
        movieTableView.dataSource = self
        movieTableView.delegate = self
    }
    
    private func addFooterActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: movieTableView.frame.width, height: 44)
        movieTableView.tableFooterView = activityIndicator
    }
    
    @objc private func refreshMovieList() {
        
        if !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        }
        
        currentPage = 1
        requestMovieList(page: currentPage) { [weak self] (movieList) in
            
            guard let self = self else { return }
            
            self.movieList = movieList
            self.refreshControl.endRefreshing()
            self.addFooterActivityIndicator()
            self.movieTableView.reloadData()
        }
    }
    
    private func loadMoreMovies() {
        
        currentPage += 1
        
        requestMovieList(page: currentPage) { [weak self] (movieList) in
            
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
            self.movieList?.results.append(contentsOf: movieList.results)
            self.movieTableView.reloadData()
        }
    }
    
    private func showErrorMessage(_ message: String) {
        let alert = UIAlertController(title: R.string.localizable.movieListAlertTitle(), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.movieListAlertButtonTitle(), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func getGenresNameBy(genreIds: [Int]) -> String{
        var genres: [String] = []
        for movieGenreId in genreIds {
            
            guard let genreList = genreList?.genres else { break }
            
            for genre in genreList {
                if movieGenreId == genre.id {
                    genres.append(genre.name)
                }
            }
        }
        
        return genres.joined(separator: " / ")
    }
    
    // MARK: - Request
    
    private func requestMovieList(page: Int, completion: @escaping (MovieListModel) -> Void) {
        
        isLoading = true
        
        movieBusiness.getMovies(page: page) { [weak self] (response) in
            
            self?.isLoading = false
            
            switch response {
            case .success(let movieList):
                completion(movieList)
            case .failure:
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func requestGenreList(completion: @escaping () -> Void) {
        
        if !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        }
        
        genreBusiness.getGenres { [weak self] (response) in
            switch response {
            case .success(let genreList):
                self?.genreList = genreList
                completion()
            case .failure:
                self?.showErrorMessage(R.string.localizable.movieListGenreRequestError())
            }
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailViewController = segue.destination as? MovieDetailViewController,
            let selectedMovie = sender as? MovieModel {
            movieDetailViewController.movie = selectedMovie
            movieDetailViewController.genre = getGenresNameBy(genreIds: selectedMovie.genreIds)
        }
    }

}

extension MovieListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as? MovieTableViewCell,
            let movie = movieList?.results[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.setupCell(id: movie.id, title: movie.title, imageUrl: movie.posterPath ?? "", genre: getGenresNameBy(genreIds: movie.genreIds), releaseDate: movie.releaseDate)
        
        return cell
    }

}

extension MovieListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let movies = movieList?.results else {
                return
        }
        
        let movie = movies[indexPath.row]
        performSegue(withIdentifier: R.segue.movieListViewController.goToMovieDetail, sender: movie)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let movies = movieList?.results,
            let totalPages = movieList?.totalPages else {
                return
        }
        
        let limitToLoad = movies.count - 4
        if (!isLoading && indexPath.row > limitToLoad) {
            
            if (currentPage >= totalPages - 1) {
                tableView.tableFooterView = UIView()
                return
            }
            
            isLoading = true
            loadMoreMovies()
        }
    }
    
}
