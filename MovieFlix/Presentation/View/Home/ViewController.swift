//
//  ViewController.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 15/02/25.
//

import UIKit
import SwiftUI
import Combine
 

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DetailViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel: HomeViewModel = HomeViewModel(movieUseCase: MovieUseCaseImpl(movieRepository: MovieRepositoryImpl(moviesService: MoviesService(networkService: NetworkService()), movieDataStorage: MovieDataStorage.shared)))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            tableView.refreshControl = refreshControl
        
        viewModel.fetchMovies()
        bindViewModel()
    }
    
    @objc func refreshData() {
        viewModel.refreshMovies()
    }
    
    private func bindViewModel() {
          viewModel.$movies
              .receive(on: DispatchQueue.main)
              .sink { [weak self] _ in
                  self?.tableView.reloadData()
              }
              .store(in: &cancellables)
      }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hostingController = UIHostingController(
            rootView: DetailView(
                viewModel: DetailViewModel(
                    movieUseCase: MovieUseCaseImpl(
                        movieRepository: MovieRepositoryImpl(
                            moviesService: MoviesService(networkService: NetworkService()),
                            movieDataStorage: MovieDataStorage.shared
                        )
                    ),
                    movieId: viewModel.movies[indexPath.row].id
                ),
                delegate: self
            )
        )

        hostingController.modalPresentationStyle = .fullScreen

        present(hostingController, animated: true, completion: nil)
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = viewModel.movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell")! as! MovieViewCell
         
        cell.configure(movie: movie, viewModel: self.viewModel)
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchMovies(title: searchText)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

         if offsetY > contentHeight - frameHeight * 1.5 {
             let search = searchBar.text ?? ""
             if viewModel.isSearchActive && !search.isEmpty {
                 viewModel.fetchSearchMovies(title: search)
             } else {
                 viewModel.fetchMovies()
             }
        }
    }
    
    func didDismissDetailView(with movie: DetailMovie?) {
         viewModel.saveFavorite(movieId: movie?.id ?? 0, favorite: movie?.favorite ?? false)
    }

}

