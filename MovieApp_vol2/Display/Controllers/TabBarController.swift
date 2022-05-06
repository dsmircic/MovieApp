//
//  TabBarController.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 05.05.2022..
//

import Foundation
import UIKit
class TabBarController: UITabBarController {
    private var initial: InitialMovieListController!
    private var favorites: FavoritesViewController!
    
    override func viewDidLoad() {
        createViews()
        styleView()
    }
    
    private func createViews() {
        initial = InitialMovieListController()
        favorites = FavoritesViewController()
        
        self.viewControllers = [
            initializeTabBar(title: "Home", image: UIImage(systemName: "house") ?? .add, viewController: initial),
            initializeTabBar(title: "Favorites", image: UIImage(systemName: "star") ?? .add, viewController: favorites)
        ]
    }
    
    private func initializeTabBar(title: String, image: UIImage, viewController: UIViewController) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
        
        return navigationController
    }
    
    private func styleView() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 1)
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    private func initializeNavigationView() {
        let title = UILabel()
        
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        title.text = "TMDB"
        title.textColor = .systemGreen
        
        navigationItem.titleView = title
    }
    
}
