//
//  InitialMovieListController.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 07.04.2022..
//

import PureLayout
import Foundation
/**
 Displays tableview cells with the movie category data including movie posters, subcategories and category name.
 */
class InitialMovieListController : UIViewController {
    private var tableView: UITableView!
    
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
    
    /**
     Checks the network connection periodically. Returns _false_ if the connection isn't valid and displays an alert.
     */
    private func checkNetworkConnection() {
        if (!NetworkMonitor.shared.isConnected) {
            let dialogMessage = UIAlertController(title: "Attention", message: "It appears you do not have a valid connection to the Internet.", preferredStyle: .alert)
            
            present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    /**
     Creates a tab bar control with links to other pages.
     */
    private func initializeTabBar() {
        tabBar = UITabBarController()
        let search = SearchMovieController()
        let details = MovieDetailsController()
        
        tabBar.setViewControllers([search, details], animated: false)
    }
    
    /**
     Initializes the navigaiton control view.
     */
    private func initializeNavigationView() {
        let title = UILabel()
        
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        title.text = "TMDB"
        title.textColor = .systemGreen
        
        navigationItem.titleView = title
    }
    
    /**
     Initializes view components.
     */
    private func createViews() {
        tabBar = UITabBarController()
        
        searchBar = UISearchBar()
        searchBar.delegate = self

        view.addSubview(searchBar)
        
        tableView = UITableView()
        tableView.allowsSelection = false
        
        view.addSubview(tableView)
        
        tableView.register(MovieCategoryCell.self, forCellReuseIdentifier: MovieCategoryCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    /**
     Configures view' layout.
     */
    private func addConstraints() {
        tableView.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: 8)
        tableView.autoPinEdge(toSuperviewEdge: .leading)
        tableView.autoPinEdge(toSuperviewEdge: .trailing)
        tableView.autoPinEdge(toSuperviewEdge: .bottom)
        
        searchBar.autoPinEdge(toSuperviewEdge: .top, withInset: 22)
        searchBar.autoPinEdge(toSuperviewEdge: .leading, withInset: 18)
        searchBar.autoPinEdge(toSuperviewEdge: .trailing, withInset: 19)
    }
    
    /**
     Styles the view.
     */
    private func styleViews() {
        view.backgroundColor = .white
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.showsLargeContentViewer = false
        tableView.separatorStyle = .none
        
        searchBar.tintColor = .systemGray
        searchBar.placeholder = "Search"
        searchBar.backgroundImage = UIImage()
        
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
    
    /**
     Opens a view containing movie details.
     */
    func showDetailsPage() {
        navigationController?.pushViewController(detailsPage, animated: true)
    }
    
    /**
     Gets a list of movie URLs for the given category and returns it.
     */
    private func getPosterUrlsForCategory(movies: [Movie]) -> [URL] {
        var urls: [URL] = []
        let base = "https://image.tmdb.org/t/p/original"
        
        for movie in movies {
            urls.append(URL(string: base + movie.posterPath)!)
        }
        return urls
    }
    
    /**
     Gets a list of URLs for movies in the _trending_ category. (Trending movies have a different JSON file)
     */
    private func getPosterUrlsForTrending(movies: [TrendingMovie]) -> [URL] {
        var urls: [URL] = []
        let base = "https://image.tmdb.org/t/p/original"
        
        for movie in movies {
            urls.append(URL(string: base + movie.posterPath)!)
        }
        return urls
    }
    
    /**
     Gets a list of subcategories or genres for the given category.
     */
    private func findItemsForCategory(category: MovieCategory) -> [String] {
        var items: [String] = []
        
        for genre in genres {
            items.append(genre.name)
        }
        
        return items.sorted()
    }
    
    /**
     Gets a list of movie IDs for the given movie category.
     */
    private func findIdsForCategory(movies: [Movie]) -> [Int] {
        var items: [Int] = []
        
        for movie in movies {
            items.append(movie.id)
        }
        
        return items
    }
    
    /**
     Gets a list of movie IDs for trending movies.
     */
    private func findIdsForTrending() -> [Int] {
        var items: [Int] = []
        
        for movie in trendingMovies {
            items.append(movie.id)
        }
        
        return items
    }
    
    /**
     Configures a tableView cell with the given parameters.
     */
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
    
    /**
     Fetches genre data and stores it into a class variable _genres_.
     */
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
    
    /**
     Fetches movie data for all movie categories and stores into a class dictionary variable _movies_.
     */
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
    
    /**
     Dequeue's a custom table view cell _MovieCategoryCell_ and configures it depending on the row which the table view is in.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCategoryCell.identifier,
                                                 for: indexPath) as? MovieCategoryCell else {
                                                        return UITableViewCell()
        }
        
        cell.setNavigationController(controller: self)
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
