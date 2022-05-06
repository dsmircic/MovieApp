//
//  FilterView.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 05.05.2022..
//

import Foundation
import UIKit
class FilterView: UIView {
    private var selected: Int = 0
    private var elements: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews() {
        for button in elements {
            addSubview(button)
        }
    }
    
    private func setSelected() {
        
    }
    
    func addElements(titles: [String]) {
        var button: UIButton
        
        for i in 0...titles.count - 1 {
            button = UIButton()
            button.setTitle(titles[i], for: .normal)
            elements.append(button)
        }
        
        elements[selected].setTitleColor(UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 1), for: .normal)
    }
    
}
