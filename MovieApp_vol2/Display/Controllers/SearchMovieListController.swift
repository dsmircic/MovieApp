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
    private var detailsPage: MovieDetailsController!
    private var noImage: URL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg")!
    private var movies = [Movie]()
    private var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMovies()

        createViews()
        addConstraints()
        styleViews()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    private func createViews() {
        tableView = UITableView()
        searchBar = UISearchBar()
        detailsPage = MovieDetailsController()
        
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        tableView.register(SearchTableCell.self, forCellReuseIdentifier: SearchTableCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
    }
    
    private func addConstraints() {
        searchBar.autoPinEdge(toSuperviewEdge: .top, withInset: 22)
        searchBar.autoPinEdge(toSuperviewEdge: .leading, withInset: 18)
        searchBar.autoPinEdge(toSuperviewEdge: .trailing, withInset: 19)
        
        tableView.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: 8)
        tableView.autoPinEdge(toSuperviewEdge: .leading)
        tableView.autoPinEdge(toSuperviewEdge: .trailing)
        tableView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    private func styleViews() {
        view.backgroundColor = .white
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.showsLargeContentViewer = false
        tableView.separatorStyle = .none
        
        searchBar.setShowsCancelButton(true, animated: false)
        searchBar.tintColor = .systemGray
        searchBar.placeholder = "Search"
        searchBar.backgroundImage = .none
    }
    
    func showDetailsPage(detailsPage: MovieDetailsController) {
        self.detailsPage = detailsPage
        navigationController?.pushViewController(detailsPage, animated: true)
    }
    
    private func loadMovies() {
        let networkService = NetworkService()
        
        for movieCategory in MovieCategory.allCases {
            let request = NetworkService.makeUrlRequest(category: movieCategory)
            
            if (movieCategory != .trending) {
                networkService.executeUrlRequest(request) {
                    (result: Result<ModelMovie, RequestError>) in
                    switch result {
                    case .success(_):
                        do {
                            self.movies = try result.get().results
                            
                        }
                        catch {
                            print("Error")
                        }
                        
                    case .failure(let fail):
                        print("Fail \(fail)")
                    }
                    
                }
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
        let baseURL = "https://image.tmdb.org/t/p/original"
        
        let movieImageUrl = URL(string: baseURL + movieInfo.posterPath) ?? noImage
        let movieTitle = movieInfo.title
        let movieDescription = movieInfo.overview
        
        cell.configure(posterUrl: movieImageUrl, movieTitle: movieTitle, description: movieDescription)
        return cell
    }
    
}

extension SearchMovieController : UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        detailsPage.configure(id: movies[indexPath.row].id)
        showDetailsPage(detailsPage: detailsPage)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
        
}

extension SearchMovieController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
    
}
