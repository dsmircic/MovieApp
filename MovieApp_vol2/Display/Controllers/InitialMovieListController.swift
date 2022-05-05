//
//  InitialMovieListController.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 07.04.2022..
//

import PureLayout
import MovieAppData
import Foundation

class InitialMovieListController : UIViewController {
    var tableView: UITableView!
    
    private var searchBar: UISearchBar!
    private var tabBar: UITabBarController!
    private var detailsPage: MovieDetailsController!
    private var movies = [MovieCategory : [Movie]]()
    private var genres: [Genre] = []
    private var trendingMovies = [TrendingMovie]()
    private let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkNetworkConnection()
        
        createViews()
        addConstraints()
        styleViews()
        
        initializeNavigationView()
        initializeTabBar()

        fetchMovieData()
        fetchGenreData()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func checkNetworkConnection() {
        if (!NetworkMonitor.shared.isConnected) {
            let dialogMessage = UIAlertController(title: "Attention", message: "It appears you do not have a valid connection to the Internet.", preferredStyle: .alert)
            
            present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    private func initializeTabBar() {
        tabBar = UITabBarController()
        let search = SearchMovieController()
        let details = MovieDetailsController()
        
        tabBar.setViewControllers([search, details], animated: false)
    }
    
    private func initializeNavigationView() {
        let title = UILabel()
        
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        title.text = "TMDB"
        title.textColor = .systemGreen
        
        navigationItem.titleView = title
    }
    
    private func createViews() {
        tabBar = UITabBarController()
        
        searchBar = UISearchBar()
        searchBar.delegate = self

        view.addSubview(searchBar)
        
        tableView = UITableView()
        view.addSubview(tableView)
        
        tableView.register(MovieCategoryCell.self, forCellReuseIdentifier: MovieCategoryCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func addConstraints() {
        tableView.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: 8)
        tableView.autoPinEdge(toSuperviewEdge: .leading)
        tableView.autoPinEdge(toSuperviewEdge: .trailing)
        tableView.autoPinEdge(toSuperviewEdge: .bottom)
        
        searchBar.autoPinEdge(toSuperviewEdge: .top, withInset: 22)
        searchBar.autoPinEdge(toSuperviewEdge: .leading, withInset: 18)
        searchBar.autoPinEdge(toSuperviewEdge: .trailing, withInset: 19)
    }
    
    private func styleViews() {
        view.backgroundColor = .white
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.showsLargeContentViewer = false
        tableView.separatorStyle = .none
        
        searchBar.tintColor = .systemGray
        searchBar.placeholder = "Search"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 1)
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    func showDetailsPage() {
        navigationController?.pushViewController(detailsPage, animated: true)
    }
    
    private func getPosterUrlsForCategory(movies: [Movie]) -> [URL] {
        var urls: [URL] = []
        let base = "https://image.tmdb.org/t/p/original"
        
        for movie in movies {
            urls.append(URL(string: base + movie.posterPath)!)
        }
        return urls
    }
    
    private func getPosterUrlsForTrending(movies: [TrendingMovie]) -> [URL] {
        var urls: [URL] = []
        let base = "https://image.tmdb.org/t/p/original"
        
        for movie in movies {
            urls.append(URL(string: base + movie.posterPath)!)
        }
        return urls
    }
    
    private func findItemsForCategory(category: MovieCategory) -> [String] {
        var items: [String] = []
        
        for genre in genres {
            items.append(genre.name)
        }
        
        return items.sorted()
    }
    
    private func findIdsForCategory(movies: [Movie]) -> [Int] {
        var items: [Int] = []
        
        for movie in movies {
            items.append(movie.id)
        }
        
        return items
    }
    
    private func findIdsForTrending() -> [Int] {
        var items: [Int] = []
        
        for movie in trendingMovies {
            items.append(movie.id)
        }
        
        return items
    }
    
    private func configureCell(cell: MovieCategoryCell, category: MovieCategory, subcategories: [String], urls: [URL], ids: [Int]) {
        
        switch (category) {
        case .trending:
            cell.configure(category: "Trending", navigationBarItems: subcategories, imageURLs: urls, ids: ids)
            break
            
        case .popular:
            cell.configure(category: "Popular", navigationBarItems: subcategories, imageURLs: urls, ids: ids)
            break
            
        case .topRated:
            cell.configure(category: "Top Rated", navigationBarItems: subcategories, imageURLs: urls, ids: ids)
            break
            
        default:
            cell.configure(category: "Recommended", navigationBarItems: subcategories, imageURLs: urls, ids: ids)
            break
            
        }
    }
    
    func fetchGenreData() {
        let req = NetworkService.makeUrlRequest(category: .genres)
        networkService.executeUrlRequest(req) {
        (result: Result<Genres, RequestError>) in
            switch(result) {
            case .success(_):
                do {
                    self.genres = try result.get().genres
                    break
                    
                } catch {
                    print("Error")
                }
                
            case .failure(let failure):
                print("Fail: \(failure)")
                break
            }
        }
    }
    
    func fetchMovieData() {
        
        for movieCategory in MovieCategory.allCases {
            let request = NetworkService.makeUrlRequest(category: movieCategory)
            
            if (movieCategory != .trending) {
                networkService.executeUrlRequest(request) {
                    (result: Result<ModelMovie, RequestError>) in
                    switch result {
                    case .success(_):
                        do {
                            self.movies[movieCategory] = try result.get().results
                        }
                        catch {
                            print("Error")
                        }
                        
                    case .failure(let fail):
                        print("Fail \(fail)")
                    }
                    
                }
                
            } else {
                networkService.executeUrlRequest(request) {
                    (result: Result<TrendingModelMovie, RequestError>) in
                    switch result {
                    case .success(_):
                        do {
                            self.trendingMovies = try result.get().results
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

extension InitialMovieListController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieCategory.allCases.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCategoryCell.identifier,
                                                 for: indexPath) as? MovieCategoryCell else {
                                                        return UITableViewCell()
        }
        
        var category: MovieCategory
        
        switch(indexPath.row) {
        case 0:
            category = .recommended
            break
            
        case 1:
            category = .popular
            break
            
        case 2:
            category = .topRated
            
        default:
            category = .trending
        }
        
        
        let urls: [URL]
        let subcategories: [String]
        let ids: [Int]
        
        if (category == .trending) {
            urls = getPosterUrlsForTrending(movies: trendingMovies)
            ids = findIdsForTrending()
        } else  {
            urls = getPosterUrlsForCategory(movies: movies[category] ?? [])
            ids = findIdsForCategory(movies: movies[category] ?? [])
        }
        
        subcategories = findItemsForCategory(category: category)
        
        configureCell(cell: cell, category: category, subcategories: subcategories, urls: urls, ids: ids)
        
        return cell
    }
    
}


extension InitialMovieListController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320.0
    }
}

extension InitialMovieListController: UISearchBarDelegate {
    
    // search bar actions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let src = SearchMovieController()
        navigationController?.pushViewController(src, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        navigationController?.popViewController(animated: true)
    }
    
}
