//
//  MovieDetail.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 15/02/25.
//

import Foundation

struct Genres: Identifiable, Codable {
    let id: Int
    let name: String
}

struct DetailMovie: Codable {
    let adult: Bool?
    let backdrop_path: String?
    let budget: Int?
    let genres: [Genres]
    let homepage: String?
    let id: Int
    let imdb_id: String?
    let origin_country: [String]
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let release_date: String?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
    var favorite: Bool? = false
    
    mutating func updateFavorite(newFavorite: Bool) {
        self.favorite = newFavorite
    }
    
    func getGenders() -> String {
        return genres.map { $0.name }.joined(separator: ", ")
    }
    
    func formatMinutesToHoursAndMinutes() -> String {
        guard let runtime = runtime else { return "0h 0m" }
        
        let hours = runtime / 60
        let remainingMinutes = runtime % 60
        
        return "\(hours)h \(remainingMinutes)m"
    }
    
    func releaseDate() -> String {
        return formatDate(input: release_date ?? "")
    }
}
