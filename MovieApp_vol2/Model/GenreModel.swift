//
//  GenreModel.swift
//  MovieApp_vol2
//
//  Created by Dino Smirčić on 02.05.2022..
//

import Foundation
public struct Genre: Codable {
    let id: Int
    let name: String
}

public struct Genres: Codable {
    let genres: [Genre]
}
