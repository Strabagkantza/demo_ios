//
//  DetailViewModel.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 16/02/25.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    private let movieUseCase: MovieUseCase
    private let movieId: Int
    @Published var detailMovie: DetailMovie?
    @Published var reviews: [Reviews] = []
    @Published var movies: [Movie] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(movieUseCase: MovieUseCase, movieId: Int) {
        self.movieUseCase = movieUseCase
        self.movieId = movieId
    }
    
    func fetchDetailMovie() {
        movieUseCase.executeDetailMovie("\(self.movieId)")
               .sink(receiveCompletion: { completion in
                   switch completion {
                   case .finished:
                       break
                   case .failure(let error):
                       print("Error: \(error.localizedDescription)")
                   }
               }, receiveValue: { detailMovie in
                   self.detailMovie = detailMovie
               })
               .store(in: &cancellables)
    }

    func fetchReviewsMovie() {
        movieUseCase.executeReviewsMovie("\(self.movieId)")
               .sink(receiveCompletion: { completion in
                   switch completion {
                   case .finished:
                       break
                   case .failure(let error):
                       print("Error: \(error.localizedDescription)")
                   }
               }, receiveValue: { reviews in
                   self.reviews = reviews
               })
               .store(in: &cancellables)
    }
    
    func fetchSimilarMovie() {
        movieUseCase.executeSimilarMovie("\(self.movieId)")
               .sink(receiveCompletion: { completion in
                   switch completion {
                   case .finished:
                       break
                   case .failure(let error):
                       print("Error: \(error.localizedDescription)")
                   }
               }, receiveValue: { movies in
                   self.movies = movies
               })
               .store(in: &cancellables)
    }
    
    func setFavorite(movieId: Int) {
        movieUseCase.executeFavorite("\(movieId)")
        detailMovie?.updateFavorite(newFavorite: true)
    }
    
    func setUnfavorite(movieId: Int) {
        movieUseCase.executeUnfavorite("\(movieId)")
        detailMovie?.updateFavorite(newFavorite: false)
    }
}
