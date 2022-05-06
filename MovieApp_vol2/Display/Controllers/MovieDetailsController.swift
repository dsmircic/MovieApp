//
//  MovieDetailsController.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 04.05.2022..
//

import Foundation
import UIKit

class MovieDetailsController : UIViewController {
    private let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 24)
    private let descriptionFont = UIFont(name: "Proxima Nova", size: 14)
    
    private var stackView: UIStackView = {
        var stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        
        return stackView
    }()
    
    private var topView: UIView = UIView()
    private var bottomView: UIView = UIView()
    
    private var networkService: NetworkService = NetworkService()
    private var movieDetails: MovieDetails?
    
    private var movieTitle: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .white
        
        return titleLabel
    }()
    
    private var releaseDateLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .white
        
        return titleLabel
    }()
    
    private var genreLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .white
        
        return titleLabel
    }()
    
    private var movieDurationLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .white
        
        return titleLabel
    }()
    
    private var movieDescription: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        return titleLabel
    }()
    
    private var overviewLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.text = "Overview"
        titleLabel.textColor = UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 1)
        
        return titleLabel
    }()
    
    private var userScoreLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = .white
        
        return titleLabel
    }()
    
    private var userScoreBar: UIProgressView = {
        let scoreBar = UIProgressView()
        
        scoreBar.trackTintColor = .systemGray
        scoreBar.progressTintColor = .systemGreen
        
        return scoreBar
    }()
    
    private var poster: UIImageView = {
        let image = UIImageView()
        
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.tintColor = UIColor(hue: 0.9, saturation: 0.8, brightness: 0.3, alpha: 0.2)
        
        return image
    }()
    
    private let starButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.circle.fill"))
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private let heartButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "heart.circle.fill"))
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private let tabsButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "line.3.horizontal.circle.fill"))
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private let bookmarkButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "bookmark.circle.fill"))
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        initializeNavigationView()
        
        createView()
        addConstraints()
        styleView()
    }
    
    private func initialize() {
        networkService = NetworkService()
        
        topView = UIView()
        bottomView = UIView()

    }
    
    private func initializeNavigationView() {
        let title = UILabel()
        
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        title.text = "TMDB"
        title.textColor = .systemGreen
        
        navigationItem.titleView = title
    }
    
    private func configureText() {
        movieTitle.text = movieDetails?.title
        movieDescription.text = movieDetails?.overview
        
        configureUserScore()
        configureReleaseDate()
        configureDuration()
        configureGenreLabel()
    }
    
    private func configureUserScore() {
        let progress = (movieDetails?.voteAverage)! / 10
        let percentage = (movieDetails?.voteAverage)! * 10
        userScoreLabel.text = (percentage.description)
        userScoreLabel.text! += "% User Score"
        userScoreBar.setProgress(progress, animated: true)
    }
    
    private func configureReleaseDate() {
        releaseDateLabel.text = movieDetails?.releaseDate ?? "1/2/3/4"
    }
    
    private func configureDuration() {
        movieDurationLabel.text = movieDetails?.runtime?.description ?? "2"
        movieDurationLabel.text! += "h"
    }
    
    private func configureGenreLabel() {
        genreLabel.text = ""
        if (movieDetails?.genres != nil) {
            for i in 0...movieDetails!.genres.count - 1 {
                genreLabel.text! += (movieDetails!.genres[i].name) + " "
            }
        }
    }
    
    
    private func configureView() {
        configureText()
        configureImage()
    }
    
    private func fetchMovieDetails(movieId: Int) {
        let base = "https://api.themoviedb.org/3/"
        let key = "ba92a6994b75de1c153255ddb4932fdf"
        
        let url = URL(string: base + "movie/\(movieId)?language=en-US&page=1&api_key=\(key)")
        var request = URLRequest(url: url ?? URL(string: "www.fer.hr")!)
        
        request.httpMethod = "GET"
        request.setValue("movie/\(movieId)", forHTTPHeaderField: "Content-Type")
        
        networkService.executeUrlRequest(request) {
            (result: Result<MovieDetails, RequestError>) in
            switch result {
            case .success(_):
                do {
                    self.movieDetails = try result.get()
                    self.configureView()
                }
                catch {
                    print("Error")
                }
                
            case .failure(let fail):
                print("Fail \(fail)")
            }
        }
    }
        
    private func createView() {
        topView.addSubview(poster)
        
        topView.addSubview(movieTitle)
        topView.addSubview(releaseDateLabel)
        topView.addSubview(genreLabel)
        topView.addSubview(userScoreBar)
        topView.addSubview(userScoreLabel)
        topView.addSubview(movieDurationLabel)
        topView.addSubview(starButton)
        topView.addSubview(heartButton)
        topView.addSubview(bookmarkButton)
        topView.addSubview(tabsButton)
        
        bottomView.addSubview(overviewLabel)
        bottomView.addSubview(movieDescription)
        
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(bottomView)
        
        view.addSubview(stackView)
    }
    
    private func addConstraints() {
        poster.autoPinEdgesToSuperviewEdges()
        
        // user score text label constraints
        userScoreLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 21)
        
        // user score "progress bar" constraints
        userScoreBar.autoPinEdge(.top, to: .bottom, of: userScoreLabel, withOffset: 8)
        userScoreBar.autoPinEdge(toSuperviewEdge: .leading, withInset: 21)
        userScoreBar.autoSetDimensions(to: CGSize(width: 200, height: 6))
        
        // movie title label constraints
        movieTitle.autoPinEdge(.top, to: .bottom, of: userScoreBar, withOffset: 9)
        movieTitle.autoPinEdge(toSuperviewEdge: .leading, withInset: 21)
        
        // release date label constraints
        releaseDateLabel.autoPinEdge(.top, to: .bottom, of: movieTitle, withOffset: 3)
        releaseDateLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 21)
        
        // genre label constraints
        genreLabel.autoPinEdge(.top, to: .bottom, of: releaseDateLabel, withOffset: 3)
        genreLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 21)
        
        genreLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 67)
        
        overviewLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        overviewLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 18)
        
        // movie description label constraints
        movieDescription.autoPinEdge(.top, to: .bottom, of: overviewLabel, withOffset: 7)
        movieDescription.autoPinEdge(toSuperviewEdge: .leading, withInset: 18)
        movieDescription.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        
        // icon constraints
        tabsButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 21)
        tabsButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
        tabsButton.autoSetDimensions(to: CGSize(width: 32, height: 32))
        
        heartButton.autoPinEdge(.leading, to: .trailing, of: tabsButton, withOffset: 24)
        heartButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
        heartButton.autoSetDimensions(to: CGSize(width: 32, height: 32))
        
        bookmarkButton.autoPinEdge(.leading, to: .trailing, of: heartButton, withOffset: 24)
        bookmarkButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
        bookmarkButton.autoSetDimensions(to: CGSize(width: 32, height: 32))
        
        starButton.autoPinEdge(.leading, to: .trailing, of: bookmarkButton, withOffset: 24)
        starButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
        starButton.autoSetDimensions(to: CGSize(width: 32, height: 32))
        
        stackView.autoPinEdgesToSuperviewEdges()
    }
    
    private func styleView() {
        view.backgroundColor = .white
        
        movieTitle.font = titleFont
        movieDescription.font = descriptionFont
        
        movieTitle.textColor = .white
        movieDescription.textColor = .black
        
        userScoreLabel.font = descriptionFont
        releaseDateLabel.font = descriptionFont
        genreLabel.font = descriptionFont
        
        overviewLabel.font = titleFont
    }
    
    
    private func configureImage() {
        let base = "https://image.tmdb.org/t/p/original"
        let url = URL(string: base + (movieDetails?.posterPath ?? ""))
        
        URLSession.shared.dataTask(with: url ?? URL(string: "www.fer.hr")!) { data, response, error in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Empty data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.poster.image = image
                    self.reloadInputViews()
                }
            }
            
        }.resume()
    }
    
    public func configure(id: Int) {
        self.poster.image = nil
        self.movieTitle.text = nil
        self.movieDescription.text = nil
        
        fetchMovieDetails(movieId: id)
    }
}
