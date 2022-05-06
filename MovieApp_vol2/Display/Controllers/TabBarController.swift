//
//  TabBarController.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 05.05.2022..
//

import Foundation
import UIKit
/**
 Tab controller for the bottom of every view. It is set as the root navigation view controller and it contains the initial view controller which is displayed when the app starts.
 */
class TabBarController: UITabBarController {
    private var initial: InitialMovieListController!
    private var favorites: FavoritesViewController!
    
    override func viewDidLoad() {
        createViews()
        styleView()
    }
    
    /**
     Initializes view components, adds view controllers to the tab bar controller.
     */
    private func createViews() {
        initial = InitialMovieListController()
        favorites = FavoritesViewController()
        
        self.viewControllers = [
            initializeTabBar(title: "Home", image: UIImage(systemName: "house") ?? .add, viewController: initial),
            initializeTabBar(title: "Favorites", image: UIImage(systemName: "star") ?? .add, viewController: favorites)
        ]
    }
    
    /**
     Creates tab bar items, returns a navigation controller for the tab controller.
     */
    private func initializeTabBar(title: String, image: UIImage, viewController: UIViewController) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image)
        
        return navigationController
    }
    
    /**
     Styles view components.
     */
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
    
    /**
     Adds a _TMDB_ title to the navigation controller.
     */
    private func initializeNavigationView() {
        let title = UILabel()
        
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        title.text = "TMDB"
        title.textColor = .systemGreen
        
        navigationItem.titleView = title
    }
    
}
