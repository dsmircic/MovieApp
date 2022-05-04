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
    private var movies = [MovieCategory : [Movie]]()
    private let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        addConstraints()
        styleViews()

        fetchMovieData()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func createViews() {
        tableView = UITableView()
        view.addSubview(tableView)
        
        tableView.register(MovieCategoryCell.self, forCellReuseIdentifier: MovieCategoryCell.identifier)
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
    
    private func getPosterUrlsForCategory(movies: [Movie]) -> [URL] {
        var urls: [URL] = []
        let base = "https://image.tmdb.org/t/p/original"
        
        for movie in movies {
            urls.append(URL(string: base + movie.posterPath)!)
        }
        return urls
    }
    
    private func findItemsForCategory(category: MovieCategory) -> [String] {
        
        var items: [String] = []
        switch (category) {
        case .popular:
            items.append("Streaming")
            items.append("On TV")
            items.append("For Rent")
            items.append("In theatres")
            break
        case .topRated:
            items.append("Movies")
            items.append("TV")
            break
        case .trending:
            items.append("Today")
            items.append("This week")
            break
        case .recommended:
            items.append("This week")
            items.append("All time")
            break
        }
       
        return items
    }
    
    private func configureCell(cell: MovieCategoryCell, category: MovieCategory, subcategories: [String], urls: [URL]) {
        
        switch (category) {
        case .trending:
            cell.configure(category: "Trending", navigationBarItems: subcategories, imageURLs: urls)
            break
            
        case .popular:
            cell.configure(category: "Popular", navigationBarItems: subcategories, imageURLs: urls)
            break
            
        case .topRated:
            cell.configure(category: "Top Rated", navigationBarItems: subcategories, imageURLs: urls)
            break
            
        case .recommended:
            cell.configure(category: "Recommended", navigationBarItems: subcategories, imageURLs: urls)
            break
            
        }
    }
    
    func fetchMovieData() {
        
        for movieCategory in MovieCategory.allCases {
            let request = NetworkService.makeUrlRequest(category: movieCategory)
            
            if (movieCategory == .trending) {
                continue
            }
            
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
            
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
}

extension InitialMovieListController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
        
        let urls: [URL] = getPosterUrlsForCategory(movies: movies[category] ?? [])
        print(urls)
        
        let subcategories: [String] = self.findItemsForCategory(category: category)
        configureCell(cell: cell, category: category, subcategories: subcategories, urls: urls)
        
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

