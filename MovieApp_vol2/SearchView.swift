//
//  SearchView.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 08.04.2022..
//
import UIKit

class SearchView : UIView {
    private var image: UIImageView = {
        let image = UIImageView()
        
        image.autoSetDimension(.width, toSize: 97)
        image.autoSetDimension(.height, toSize: 142)
        
        return image
    }()
    private var movieTitle: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        return titleLabel
    }()
    private var movieDescription: UILabel = {
        let descriptionLabel = UILabel()
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textColor = .systemGray2
        
        return descriptionLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    // prepares for reuse
    public func deleteContent() {
        image.image = nil
        movieDescription.text = nil
        movieTitle.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(image: UIImageView, title: UILabel, description: UILabel) {
        self.image = image
        self.movieTitle = title
        self.movieDescription = description
        
        addSubview(self.image)
        addSubview(self.movieTitle)
        addSubview(self.movieDescription)
        
        addConstraints()
        styleViews()
    }
    
    private func styleViews() {
        self.image.clipsToBounds = true
        self.image.contentMode = .scaleAspectFill
        
        self.movieDescription.lineBreakMode = .byWordWrapping
        self.movieDescription.numberOfLines = 0
        
        self.movieTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        self.movieDescription.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 0.8)
    }

    private func addConstraints() {
        image.autoPinEdge(toSuperviewEdge: .top)
        image.autoPinEdge(toSuperviewEdge: .leading)
        
        image.autoSetDimension(.width, toSize: 97)
        image.autoSetDimension(.height, toSize: 142)
        
        movieTitle.autoPinEdge(toSuperviewEdge: .top, withInset: 13)
        movieTitle.autoPinEdge(toSuperviewEdge: .trailing, withInset: 12)
        movieTitle.autoPinEdge(.leading, to: .trailing, of: image, withOffset: 15)
        
        movieDescription.autoPinEdge(.top, to: .bottom, of: movieTitle, withOffset: 5)
        movieDescription.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        movieDescription.autoPinEdge(.leading, to: .trailing, of: image, withOffset: 15)
        movieDescription.autoPinEdge(toSuperviewEdge: .bottom, withInset: 19)
    }
    
}
