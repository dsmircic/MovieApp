//
//  MovieCategoryCell.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 07.04.2022..
//

import PureLayout
import UIKit
import MovieAppData

class MovieCategoryCell: UITableViewCell {
    static let identifier = "MovieCategoryCell"
    
    private var moviePosterUrls: [URL]!
    private var detailsPage: MovieDetailsController!
    private var searchController: SearchMovieController!
    
    private var ids: [Int]!
    
    private var navBar: UISegmentedControl = UISegmentedControl()
    private var scrollView: UIScrollView!
    
    private var categoryName: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textColor = UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 1)
        
        return label
    }()
    var movieList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        let movieList = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return movieList
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        scrollView = UIScrollView()
        
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        
        movieList.register(MoviePosterCell.self, forCellWithReuseIdentifier: MoviePosterCell.identifier)
        movieList.dataSource = self
        movieList.delegate = self
        
        contentView.addSubview(categoryName)
        contentView.addSubview(movieList)
        contentView.addSubview(scrollView)
        
        scrollView.addSubview(navBar)
        
        addConstraints()
        styleView()
        
        detailsPage = MovieDetailsController()
        searchController = SearchMovieController()
        
        DispatchQueue.main.async {
            self.movieList.reloadData()
        }
    }
    
    private func addConstraints() {
        categoryName.autoPinEdge(toSuperviewEdge: .leading, withInset: 15)
        categoryName.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
        
        scrollView.autoPinEdge(.top, to: .bottom, of: categoryName, withOffset: 10)
        scrollView.autoPinEdge(toSuperviewEdge: .leading, withInset: 15)
        scrollView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 15)
        scrollView.autoPinEdge(.bottom, to: .top, of: movieList, withOffset: 5)
        
        navBar.autoPinEdgesToSuperviewEdges()
        
        movieList.autoPinEdge(.top, to: .bottom, of: navBar, withOffset: 10)
        movieList.autoPinEdge(toSuperviewEdge: .leading, withInset: 15)
        movieList.autoPinEdge(toSuperviewEdge: .trailing, withInset: 15)
        movieList.autoPinEdge(toSuperviewEdge: .bottom, withInset: 15)
    }
    
    private func styleView() {
        movieList.showsVerticalScrollIndicator = false
        movieList.showsHorizontalScrollIndicator = false
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(category: String, navigationBarItems: [String], imageURLs: [URL], ids: [Int]) {
        categoryName.text = category
        
        if (navigationBarItems.count > 0) {
            for index in 0...navigationBarItems.count - 1 {
                navBar.insertSegment(withTitle: navigationBarItems[index], at: index, animated: false)
            }
        }
        
        navBar.selectedSegmentIndex = 0
        navBar.tintColor = UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 1)
        
        moviePosterUrls = imageURLs
        self.ids = ids
    }
    
    func showDetailsPage(detailsPage: MovieDetailsController) {
        searchController.showDetailsPage(detailsPage: detailsPage)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryName.text = nil
    
        navBar.removeAllSegments()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}


extension MovieCategoryCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviePosterUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = movieList.dequeueReusableCell(
            withReuseIdentifier: MoviePosterCell.identifier,
            for: indexPath) as? MoviePosterCell else { return UICollectionViewCell() }
        
        cell.configure(imageUrl: moviePosterUrls[indexPath.row], id: ids[indexPath.row])
        
        return cell
    }
}


extension MovieCategoryCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.masksToBounds = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        detailsPage.configure(id: ids[indexPath.row])
        showDetailsPage(detailsPage: detailsPage)
    }
    
}


extension MovieCategoryCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 122, height: 179)
    }
}
