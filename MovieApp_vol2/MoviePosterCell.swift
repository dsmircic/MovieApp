//
//  MoviePosterCell.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 08.04.2022..
//

import PureLayout
import MovieAppData
import UIKit

class MoviePosterCell : UICollectionViewCell {
    
    public let poster: UIImageView = {
        return UIImageView()
    }()
    public let favoriteButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "heart.circle.fill"))
        imageView.tintColor = UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 0.65)
        return imageView
    }()
    
    public static let identifier: String = "MoviePosterID"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(poster)
        contentView.addSubview(favoriteButton)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        poster.image = nil
    }
    
    public func configure(imageUrl: URL) {
        if let imageData = try? Data(contentsOf: imageUrl) {
            if UIImage(data: imageData) != nil {
                poster.image = UIImage(data: imageData)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        poster.autoPinEdgesToSuperviewEdges()
        poster.layer.cornerRadius = 10
        
        favoriteButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 9)
        favoriteButton.autoPinEdge(toSuperviewEdge: .top, withInset: 9)
        favoriteButton.autoSetDimensions(to: CGSize(width: 32, height: 32))
    }
    
}
