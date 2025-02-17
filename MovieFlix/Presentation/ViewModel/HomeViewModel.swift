//
//  HomeViewModel.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 16/02/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    private let movieUseCase: MovieUseCase
    @Published var movies: [Movie] = []
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0
    var isSearchActive = false
    
    init(movieUseCase: MovieUseCase) {
        self.movieUseCase = movieUseCase
    }
    
    func refreshMovies() {
        self.isSearchActive = false
        currentPage = 0
        self.movies = []
        fetchMovies()
    }
    
    func searchMovies(title: String) {
        currentPage = 0
        self.movies = []
        if (title.isEmpty) {
            fetchMovies()
        } else {
            fetchSearchMovies(title: title)
        }
    }
    
    func fetchMovies() {
        self.isSearchActive = false
        currentPage += 1
        movieUseCase.executeMovies(page: currentPage)
               .sink(receiveCompletion: { completion in
                   switch completion {
                   case .finished:
                       break
                   case .failure(let error):
                       print("Error: \(error.localizedDescription)")
                   }
               }, receiveValue: { movies in
                   self.movies.append(contentsOf: movies)
               })
               .store(in: &cancellables)
    }
    
    func fetchSearchMovies(title: String) {
        self.isSearchActive = true
        currentPage += 1
        movieUseCase.executeMoviesSearch(title, page: currentPage)
               .sink(receiveCompletion: { completion in
                   switch completion {
                   case .finished:
                       break
                   case .failure(let error):
                       print("Error: \(error.localizedDescription)")
                   }
               }, receiveValue: { movies in
                   self.movies.append(contentsOf: movies)
               })
               .store(in: &cancellables)
    }
    
    func setFavorite(movieId: Int) {
        movieUseCase.executeFavorite("\(movieId)")
        var moviesTmp = self.movies
         if let index = moviesTmp.firstIndex(where: { $0.id == movieId }) {
             moviesTmp[index].updateFavorite(newFavorite: true)
             self.movies = moviesTmp
         }
    }
    
    func saveFavorite(movieId: Int, favorite: Bool) {
        var moviesTmp = self.movies
         if let index = moviesTmp.firstIndex(where: { $0.id == movieId }) {
             moviesTmp[index].updateFavorite(newFavorite: favorite)
             self.movies = moviesTmp
         }
    }
    
    func setUnfavorite(movieId: Int) {
        movieUseCase.executeUnfavorite("\(movieId)")
        var moviesTmp = self.movies
         if let index = moviesTmp.firstIndex(where: { $0.id == movieId }) {
             moviesTmp[index].updateFavorite(newFavorite: false)
             self.movies = moviesTmp
         }
    }
}
