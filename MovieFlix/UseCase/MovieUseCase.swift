//
//  MovieUseCase.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 15/02/25.
//

import Combine

protocol MovieUseCase {
    func executeMovies(page: Int) -> AnyPublisher<[Movie], Error>
    func executeMoviesSearch(_ search: String, page: Int) -> AnyPublisher<[Movie], Error>
    func executeDetailMovie(_ movieId: String) -> AnyPublisher<DetailMovie, Error>
    func executeReviewsMovie(_ movieId: String) -> AnyPublisher<[Reviews], Error>
    func executeSimilarMovie(_ movieId: String) -> AnyPublisher<[Movie], Error>
    func executeFavorite(_ movieId: String)
    func executeUnfavorite(_ movieId: String)
}
