//
//  MoviesService.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 15/02/25.
//

import Foundation
import Combine

class MoviesService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchMovies(page: Int) -> AnyPublisher<[Movie], Error> {
            return networkService.request("movie/popular?page=\(page)")
            .map { (response: MovieResponse) in
                response.results
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }
    
    func fetchSearchMovies(search: String, page: Int) -> AnyPublisher<[Movie], Error> {
            return networkService.request("search/movie?query=\(search)&page=\(page)")
            .map { (response: MovieResponse) in
                response.results
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }
    
    func fetchMovieDetails(movieId: String) -> AnyPublisher<DetailMovie, Error> {
            return networkService.request("movie/\(movieId)")
                .map { (response: DetailMovie) in
                    response
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }
    
    func fetchMovieReviews(movieId: String) -> AnyPublisher<[Reviews], Error> {
            return networkService.request("movie/\(movieId)/reviews")
                .map { (response: ReviewsResponse) in
                    response.results
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }
    
    func fetchMovieSimilar(movieId: String) -> AnyPublisher<[Movie], Error> {
            return networkService.request("movie/\(movieId)/similar")
                .map { (response: MovieResponse) in
                    response.results
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }
}
