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
        
        addConstraints()
        styleView()
    }
    
    private func addConstraints() {
        movieDescriptionContainer.autoPinEdgesToSuperviewEdges()
    }
    
    private func styleView() {
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
        movieDescriptionContainer.configure(imageURL: posterUrl, title: movieTitle, description: description)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
}
