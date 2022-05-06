//
//  MoviePosterCell.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 08.04.2022..
//

import PureLayout
import MovieAppData
import UIKit

/**
 Stores movie poster images and a favorite button.
 */
class MoviePosterCell : UICollectionViewCell {
    
    private let poster: UIImageView = {
        return UIImageView()
    }()
    private let favoriteButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "heart.circle.fill"))
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    public static let identifier: String = "MoviePosterID"
    private var id: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(poster)
        contentView.addSubview(favoriteButton)
        
        addConstraints()
        styleView()
    }
    
    private func addConstraints() {
        poster.autoPinEdgesToSuperviewEdges()
        
        favoriteButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 9)
        favoriteButton.autoPinEdge(toSuperviewEdge: .top, withInset: 9)
        favoriteButton.autoSetDimensions(to: CGSize(width: 32, height: 32))
    }
    
    private func styleView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        poster.image = nil
    }
    
    public func configure(imageUrl: URL, id: Int) {
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
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
        
        self.id = id
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            
    }
    
}
