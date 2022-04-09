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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        addConstraints()
        styleViews()
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
    
    private func getPosterUrlsForCategory(category: MovieGroup) -> [URL] {
        var urls: [URL] = []
        
        for movie in Movies.all() {
            if (movie.group.contains(category)) {
                urls.append(URL(string: movie.imageUrl)!)
            }
        }
            return urls
    }
    
    private func findItemsForCategory(category: MovieGroup) -> [String] {
        
        var items: [String] = []
        switch (category) {
        case .popular:
            items.append("Streaming")
            items.append("On TV")
            items.append("For Rent")
            items.append("In theatres")
            break
        case .freeToWatch:
            items.append("Movies")
            items.append("TV")
            break
        case .trending:
            items.append("Today")
            items.append("This week")
            break
        case .topRated:
            items.append("This week")
            items.append("All time")
            break
        case .upcoming:
            items.append("Action")
            items.append("Horror")
            items.append("Comedy")
            break
        }
       
        return items
    }
    
    private func configureCell(cell: MovieCategoryCell, category: MovieGroup, subcategories: [String], urls: [URL]) {
        
        switch (category) {
        case .freeToWatch:
            cell.configure(category: "Free to Watch", navigationBarItems: subcategories, imageURLs: urls)
            break
            
        case .popular:
            cell.configure(category: "Popular", navigationBarItems: subcategories, imageURLs: urls)
            break
            
        case .topRated:
            cell.configure(category: "Top Rated", navigationBarItems: subcategories, imageURLs: urls)
            break
            
        case .upcoming:
            cell.configure(category: "Upcoming", navigationBarItems: subcategories, imageURLs: urls)
            break
            
        case .trending:
            cell.configure(category: "Trending", navigationBarItems: subcategories, imageURLs: urls)
            break
        }
        
    }
    
}

extension InitialMovieListController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieGroup.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCategoryCell.identifier,
                                                 for: indexPath) as? MovieCategoryCell else {
                                                        return UITableViewCell()
        }
        
        let categoryName = MovieGroup.allCases[indexPath.row]
        let subcategories: [String] = findItemsForCategory(category: categoryName)
        let urls = getPosterUrlsForCategory(category: categoryName)
        
        configureCell(cell: cell, category: categoryName, subcategories: subcategories, urls: urls)
    
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

