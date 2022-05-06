//
//  MovieModel.swift
//  MovieApp3
//
//  Created by Dino Smirčić on 02.05.2022..
//
import Foundation

struct ModelMovie: Codable {
    let page: Int?
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    private enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct TrendingModelMovie: Codable {
    let page: Int
    let results: [TrendingMovie]
    let totalPages: Int
    let totalResults: Int
    
    private enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String?
    let overview: String
    let popularity: Float
    let posterPath: String
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Float
    let voteCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
}

struct TrendingMovie: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIds: [Int]
    let originalLanguage: String
    let originalTitle: String?
    let posterPath: String
    let voteCount: Int
    let video: Bool
    let voteAverage: Float
    let title: String
    let overview: String
    let releaseDate: String
    let id: Int
    let popularity: Float
    let mediaType: String
    
    private enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case posterPath = "poster_path"
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
        case title
        case overview
        case releaseDate = "release_date"
        case id
        case popularity
        case mediaType = "media_type"
    }
    
}

struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name: String?
    let originCountry: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
}

struct Country: Codable {
    let iso: String?
    let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case iso = "iso_3166_1"
        case name
    }
    
}

struct Language: Codable {
    let englishName: String?
    let iso: String?
    let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso = "iso_639_1"
        case name
    }
    
}

struct MovieCollection: Codable {
    let id: Int?
    let name: String?
    let posterPath: String?
    let backdropPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }

}

struct Genre: Codable {
    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

struct Genres: Codable {
    let genres: [Genre]
    
    private enum CodingKeys: String, CodingKey {
        case genres
    }
}


struct MovieDetails: Codable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: MovieCollection?
    let budget: Int?
    let genres: [Genre]
    let homePage: String?
    let id: Int?
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [Country]?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [Language]?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Float?
    let voteCount: Int?
    
    private enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homePage = "home_page"
        case id
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum MovieCategory: CaseIterable {
    case popular
    case recommended
    case trending
    case topRated
    case genres
}
