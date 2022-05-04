//
//  MovieViewModel.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 02.05.2022..
//

//import Foundation
//class MovieViewModel {
//    
//    private var networkService = NetworkService()
//    private var moviesInCategory = [Movie]()
//    
//    func fetchPopularMovies(completion: @escaping () -> ()) {
//        
//        networkService.getPopularMoviesData { [weak self] (result) in
//            
//            switch result {
//            case .success(let list):
//                self?.moviesInCategory = list.results
//                completion()
//            case .failure(_):
//                print("Error processing json data")
//            }
//        }
//    }
//    
//    func numberOfRowsInSection(section: Int) -> Int {
//        if moviesInCategory.count != 0 {
//            return moviesInCategory.count
//        }
//        return 0
//    }
//    
//    func cellForRowAt(indexPath: IndexPath) -> Movie {
//        return moviesInCategory[indexPath.row]
//    }
//    
//}
