//
//  MovieDetailReviews.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 15/02/25.
//

struct AuthorDetails: Codable {
    let name: String
    let username: String
    let avatar_path: String
    let rating: Int
}

struct Reviews: Identifiable, Codable {
    let author: String
    let content: String
    let created_at: String
    let id: String
    let updated_at: String
    let url: String
    let author_details: AuthorDetails
}

struct ReviewsResponse: Codable {
    let id: Int
    let page: Int
    let total_pages: Int
    let total_results: Int
    let results: [Reviews]
}
