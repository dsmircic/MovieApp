//
//  SearchMovieListController.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 07.04.2022..
//

import Foundation
import MovieAppData
import PureLayout

class SearchMovieController : UIViewController {
    var tableView: UITableView!
    private let vc: MovieListViewController = MovieListViewController()
    private var detailsPage: MovieDetailsController!
    private var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMovies()

        createViews()
        addConstraints()
        styleViews()
    }
    
    private func createViews() {
        tableView = UITableView()
        detailsPage = MovieDetailsController()
        
        view.addSubview(tableView)
        
        tableView.register(SearchTableCell.self, forCellReuseIdentifier: SearchTableCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func addConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    private func styleViews() {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.showsLargeContentViewer = false
        tableView.separatorStyle = .none
    }
    
    private func loadMovies() {
        let networkService = NetworkService()
        let request = NetworkService.makeUrlRequest(category: .popular)
        
        networkService.executeUrlRequest(request) {
        (result: Result<ModelMovie, RequestError>) in
            switch result {
            case .success(_):
                do {
                    self.movies = try result.get().results
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                catch {
                    print("Error")
                }
                
            case .failure(_):
                print("Fail")
            }
        }
        
    }
}


extension SearchMovieController : UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchTableCell.identifier,
                for: indexPath) as? SearchTableCell else { return UITableViewCell() }
        
        let movieInfo = movies[indexPath.row]
        let baseURL = "https://image.tmbd.org/t/p/original"
        
        let movieImageUrl = URL(string: baseURL + movieInfo.posterPath)
        let movieTitle = movieInfo.title
        let movieDescription = movieInfo.overview
        
        cell.configure(posterUrl: movieImageUrl!, movieTitle: movieTitle, description: movieDescription)
                
        return cell
    }
    
}

extension SearchMovieController : UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        detailsPage.configure(title: movies[indexPath.row].title)
        print(movies[indexPath.row].title)
        
        vc.showDetailsPage()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
        
}
