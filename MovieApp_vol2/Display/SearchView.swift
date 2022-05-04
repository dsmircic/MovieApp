//
//  SearchView.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 08.04.2022..
//
import UIKit

class SearchView : UIView {
    private var poster: UIImageView = {
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
        
        addSubview(poster)
        addSubview(movieTitle)
        addSubview(movieDescription)
        
        addConstraints()
        styleViews()
    }
    
    // prepares for reuse
    public func deleteContent() {
        poster.image = nil
        movieDescription.text = nil
        movieTitle.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(imageURL: URL, title: String, description: String) {
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            
            if let error = error {
                print("DataTask error \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Empty data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.poster.image = image
                }
                
            }
            
        }.resume()
        
        movieTitle.text = title
        movieDescription.text = description
    }
    
    private func styleViews() {
        poster.clipsToBounds = true
        poster.contentMode = .scaleAspectFill
        
        movieDescription.lineBreakMode = .byWordWrapping
        movieDescription.numberOfLines = 0
        
        movieTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        movieDescription.textColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 0.8)
    }

    private func addConstraints() {
        poster.autoPinEdge(toSuperviewEdge: .top)
        poster.autoPinEdge(toSuperviewEdge: .leading)
        
        poster.autoSetDimension(.width, toSize: 97)
        poster.autoSetDimension(.height, toSize: 142)
        
        movieTitle.autoPinEdge(toSuperviewEdge: .top, withInset: 13)
        movieTitle.autoPinEdge(toSuperviewEdge: .trailing, withInset: 12)
        movieTitle.autoPinEdge(.leading, to: .trailing, of: poster, withOffset: 15)
        
        movieDescription.autoPinEdge(.top, to: .bottom, of: movieTitle, withOffset: 5)
        movieDescription.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        movieDescription.autoPinEdge(.leading, to: .trailing, of: poster, withOffset: 15)
        movieDescription.autoPinEdge(toSuperviewEdge: .bottom, withInset: 19)
    }
    
}
