//
//  MovieRepositoryImpl.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 15/02/25.
//

import Combine

class MovieRepositoryImpl: MovieRepository {
    
    private let moviesService: MoviesService
    private let movieDataStorage: MovieDataStorage

    init(moviesService: MoviesService, movieDataStorage: MovieDataStorage) {
        self.moviesService = moviesService
        self.movieDataStorage = movieDataStorage
    }
    
    func getMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        return moviesService.fetchMovies(page: page)
                .map { movies in
                    movies.map { movie in
                        var modifiedMovie = movie
                        if self.movieDataStorage.exists(value: "\(movie.id)")  {
                            modifiedMovie.favorite = true
                        }
                        return modifiedMovie
                    }
                }
                .eraseToAnyPublisher()
    }
    
    func getMoviesSearch(_ search: String, page: Int) -> AnyPublisher<[Movie], Error> {
        return moviesService.fetchSearchMovies(search: search, page: page)
                .map { movies in
                    movies.map { movie in
                        var modifiedMovie = movie
                        if self.movieDataStorage.exists(value: "\(movie.id)")  {
                            modifiedMovie.favorite = true
                        }
                        return modifiedMovie
                    }
                }
                .eraseToAnyPublisher()
    }
    
    func getDetailMovie(_ movieId: String) -> AnyPublisher<DetailMovie, Error> {
        return moviesService.fetchMovieDetails(movieId: movieId)
                .map { movie in
                        var modifiedMovie = movie
                        if self.movieDataStorage.exists(value: "\(movie.id)")  {
                            modifiedMovie.favorite = true
                        }
                        return modifiedMovie
                }
                .eraseToAnyPublisher()
    }
    
    func getReviewsMovie(_ movieId: String) -> AnyPublisher<[Reviews], Error> {
        return moviesService.fetchMovieReviews(movieId: movieId)
    }
    
    func getSimilarMovie(_ movieId: String) -> AnyPublisher<[Movie], Error> {
        return moviesService.fetchMovieSimilar(movieId: movieId)
    }
    
    func setFavorite(_ movieId: String) {
        movieDataStorage.insert(value: movieId)
    }
    
    func setUnfavorite(_ movieId: String) {
        movieDataStorage.delete(value: movieId)
    }
}
