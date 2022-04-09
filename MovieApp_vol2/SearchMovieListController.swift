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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        addConstraints()
        styleViews()
    }
    
    private func createViews() {
        tableView = UITableView()
        
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
    
}


extension SearchMovieController : UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Movies.all().count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchTableCell.identifier,
                for: indexPath) as? SearchTableCell else { return UITableViewCell() }
        
        let movieInfo = Movies.all()[indexPath.row]
        
        let movieImageUrl = URL(string: movieInfo.imageUrl)!
        let movieTitle = movieInfo.title
        let movieDescription = movieInfo.description
        
        cell.configure(posterUrl: movieImageUrl, movieTitle: movieTitle, description: movieDescription)
                
        return cell
    }
    
}

extension SearchMovieController : UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let radius = cell.contentView.layer.cornerRadius
        cell.contentView.layer.masksToBounds = true
//        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
//        cell.layer.shouldRasterize = true
//        cell.layer.rasterizationScale = UIScreen.main.scale
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142.0
    }
}
