//
//  MovieUseCaseImpl.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 15/02/25.
//

import Combine

class MovieUseCaseImpl: MovieUseCase {
    
    private let movieRepository: MovieRepository

    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func executeMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        return movieRepository.getMovies(page: page)
    }
    
    func executeMoviesSearch(_ search: String, page: Int) -> AnyPublisher<[Movie], Error> {
        return movieRepository.getMoviesSearch(search, page: page)
    }
    
    func executeDetailMovie(_ movieId: String) -> AnyPublisher<DetailMovie, Error> {
        return movieRepository.getDetailMovie(movieId)
    }
    
    func executeReviewsMovie(_ movieId: String) -> AnyPublisher<[Reviews], Error> {
        return movieRepository.getReviewsMovie(movieId)
    }
    
    func executeSimilarMovie(_ movieId: String) -> AnyPublisher<[Movie], Error> {
        return movieRepository.getSimilarMovie(movieId)
    }
    
    func executeFavorite(_ movieId: String) {
        movieRepository.setFavorite(movieId)
    }
    
    func executeUnfavorite(_ movieId: String) {
        movieRepository.setUnfavorite(movieId)
    }
}
