//
//  NetworkService.swift
//  MovieApp3
//
//  Created by Dino Smirčić on 02.05.2022..
//

import Foundation

/**
 Generates URL requests and executes them.
 */
class NetworkService {
    private var dataTask: URLSessionDataTask?

    /**
     Executes the url request which is passed in as a parameter and notifies the user about the outcome. _success()_ if the url request gets executed and _failure()_ if the url request fails.
     */
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping (Result<T, RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            var value: T!
                do {
                    value = try JSONDecoder().decode(T.self, from: data)
                } catch let jsonError as NSError {
                    print("JSON ERROR \(jsonError)")
                    completionHandler(.failure(.dataDecodingError))
                    return
                }

            DispatchQueue.main.async {
                completionHandler(.success(value))
            }
        }
        dataTask.resume()
    }
    
    /**
     Generates an URL request for fetching movie data in the given category.
     */
    public static func makeUrlRequest(category: MovieCategory) -> URLRequest {
        let base = "https://api.themoviedb.org/3"
        let key = "ba92a6994b75de1c153255ddb4932fdf"
        
        var url: URL? = nil
        
        
        var req: URLRequest
        switch(category) {
        case .popular:
            url = URL(string: "\(base)/movie/popular?language=en-US&page=1&api_key=\(key)")
            req = URLRequest(url: url ?? URL(string: "www.fer.hr")!)
            req.setValue("movie/popular/json", forHTTPHeaderField: "Content-Type")
            break
        case .trending:
            url = URL(string: "\(base)/trending/movie/day?&api_key=\(key)&page=1")
            req = URLRequest(url: url ?? URL(string: "www.fer.hr")!)
            req.setValue("trending/movie/day/json", forHTTPHeaderField: "Content-Type")
            break
        case .topRated:
            url = URL(string: "\(base)/movie/top_rated?language=en-US&page=1&api_key=\(key)")
            req = URLRequest(url: url ?? URL(string: "www.fer.hr")!)
            req.setValue("movie/top_rated/json", forHTTPHeaderField: "Content-Type")
            break
        case .recommended:
            url = URL(string: "\(base)/movie/103/recommendations?language=en-US&page=1&api_key=\(key)")
            req = URLRequest(url: url ?? URL(string: "www.fer.hr")!)
            req.setValue("movie/103/recommendations/json", forHTTPHeaderField: "Content-Type")
        case .genres:
            url = URL(string: "\(base)/genre/movie/list?language=en-US&api_key=\(key)")
            req = URLRequest(url: url ?? URL(string: "www.fer.hr")!)
            req.setValue("genre/movie/list/json", forHTTPHeaderField: "Content-Type")
            break
        }
        
        req.httpMethod = "GET"
        return req
    }
    
}

enum RequestError: Error {
    case clientError
    case serverError
    case noData
    case dataDecodingError
}

