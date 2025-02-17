//
//  Movie.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 15/02/25.
//

import Foundation

struct Movie: Identifiable, Codable {
    let backdrop_path: String?
    let id: Int
    let overview: String?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let vote_average: Double?
    var favorite: Bool? = false
    
    mutating func updateFavorite(newFavorite: Bool) {
        self.favorite = newFavorite
    }
    
    func releaseDate() -> String {
        return formatDate(input: release_date ?? "")
    }
}

struct MovieResponse: Codable {
    let page: Int
    let total_pages: Int
    let total_results: Int
    let results: [Movie]
}
