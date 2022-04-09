//
//  SearchTableCell.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 08.04.2022..
//

import Foundation
import PureLayout
import UIKit

class SearchTableCell : UITableViewCell {
    public static let identifier: String = "SearchTableCellID"
    
    private var movieDescriptionContainer: SearchView = SearchView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(movieDescriptionContainer)
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.24
        layer.shadowRadius = 8
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieDescriptionContainer.deleteContent()
    }
    
    public func configure(posterUrl: URL, movieTitle: String, description: String) {
        let posterImage = UIImageView()
        
        if let imageData = try? Data(contentsOf: posterUrl) {
            if UIImage(data: imageData) != nil {
                posterImage.image = UIImage(data: imageData)
            }
        }
        
        let movieTitleLabel = UILabel()
        let movieDescriptionLabel = UILabel()
        
        movieTitleLabel.text = movieTitle
        movieDescriptionLabel.text = description
        
        movieDescriptionContainer.configure(image: posterImage, title: movieTitleLabel, description: movieDescriptionLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieDescriptionContainer.autoPinEdgesToSuperviewEdges()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
}
