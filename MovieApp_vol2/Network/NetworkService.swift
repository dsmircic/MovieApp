//
//  NetworkService.swift
//  MovieApp3
//
//  Created by Dino Smirčić on 02.05.2022..
//

import Foundation

class NetworkService {
    private var dataTask: URLSessionDataTask?
    
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
            
            guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(.failure(.dataDecodingError))
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(.success(value))
            }
        }
        
        dataTask.resume()
    }
    
    public static func makeUrlRequest(category: MovieCategory) -> URLRequest {
        let base = "https://api.themoviedb.org/3/"
        let key = "ba92a6994b75de1c153255ddb4932fdf"
        
        var url: URL? = nil
        
        switch(category) {
        case .popular:
            url = URL(string: base + "movie/popular?language=en-US&page=1&api_key=" + key)
            break
        case .trending:
            url = URL(string: base + "movie/trending/movie/day?&api_key=" + key + "&page=1")
            break
        case .topRated:
            url = URL(string: base + "movie/top_rated?language=en-US&page=1&api_key=" + key)
            break
        case .recommended:
            url = URL(string: base + "movie/103/recommendations?language=en-US&page=1&api_key=" + key)
            break
        }
        
        var req = URLRequest(url: url ?? URL(string: "www.fer.hr")!)
        
        req.httpMethod = "GET"
        req.setValue("movie/popular/json", forHTTPHeaderField: "Content-Type")
        
        return req
    }
    
}

enum RequestError: Error {
    case clientError
    case serverError
    case noData
    case dataDecodingError
}

