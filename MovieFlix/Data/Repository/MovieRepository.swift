//
//  MovieRepository.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 15/02/25.
//

import Combine

protocol MovieRepository {
    func getMovies(page: Int) -> AnyPublisher<[Movie], Error>
    func getMoviesSearch(_ search: String, page: Int) -> AnyPublisher<[Movie], Error>
    func getDetailMovie(_ movieId: String) -> AnyPublisher<DetailMovie, Error>
    func getReviewsMovie(_ movieId: String) -> AnyPublisher<[Reviews], Error>
    func getSimilarMovie(_ movieId: String) -> AnyPublisher<[Movie], Error>
    func setFavorite(_ movieId: String) 
    func setUnfavorite(_ movieId: String)
}
