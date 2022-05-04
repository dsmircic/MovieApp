//
//  MovieDetailsController.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 04.05.2022..
//

import Foundation
import UIKit

class MovieDetailsController : UIViewController {
    private var scrollView: UIScrollView!
    private var vStack: UIStackView!
    
    private var movieTitle: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        return titleLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createView()
        addConstraints()
        styleView()
    }
    
    private func createView() {
        view.addSubview(movieTitle)
    }
    
    private func addConstraints() {
        movieTitle.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        movieTitle.autoPinEdge(toSuperviewEdge: .leading, withInset: 50)
    }
    
    private func styleView() {
        
    }
    
    public func configure(title: String) {
        movieTitle.text = title
    }
    
}
