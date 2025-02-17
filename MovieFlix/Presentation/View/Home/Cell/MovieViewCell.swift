//
//  MovieCell.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 16/02/25.
//

import UIKit

class MovieViewCell: UITableViewCell {

    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    private var movie: Movie?
    private var viewModel: HomeViewModel?
    
    func configure(movie: Movie, viewModel: HomeViewModel) {
        self.movie = movie
        self.viewModel = viewModel
        
        title.text = movie.title
        releaseDate.text = movie.releaseDate()
        
        let vote = (movie.vote_average ?? 0)/2
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular)
        
        if (vote >= 0.8) {
            star1.image = UIImage(systemName: "star.fill", withConfiguration: config)
       }
        if (vote >= 1.8) {
            star2.image = UIImage(systemName: "star.fill", withConfiguration: config)
        }
        if (vote >= 2.8) {
            star3.image = UIImage(systemName: "star.fill", withConfiguration: config)
        }
        if (vote >= 3.8) {
            star4.image = UIImage(systemName: "star.fill", withConfiguration: config)
        }
        if (vote >= 4.8) {
            star5.image = UIImage(systemName: "star.fill", withConfiguration: config)
        }
        
        if (vote >= 0.3 && vote < 0.8) {
            star1.image = UIImage(systemName: "star.leadinghalf.fill", withConfiguration: config)
        }
        if (vote >= 1.3 && vote < 1.8) {
            star2.image = UIImage(systemName: "star.leadinghalf.fill", withConfiguration: config)
        }
        if (vote >= 2.3 && vote < 2.8) {
            star3.image = UIImage(systemName: "star.leadinghalf.fill", withConfiguration: config)
        }
        if (vote >= 3.3 && vote < 3.8) {
            star4.image = UIImage(systemName: "star.leadinghalf.fill", withConfiguration: config)
        }
        if (vote >= 4.3 && vote < 4.8) {
            star5.image = UIImage(systemName: "star.leadinghalf.fill", withConfiguration: config)
        }
        
        let favorite = movie.favorite ?? false
        
        if (favorite) {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        if let backdropPath = self.movie?.backdrop_path, !backdropPath.isEmpty {
            let url = "https://image.tmdb.org/t/p/w500\(backdropPath)"
            if let imageUrl = URL(string: url) {
                loadImage(from: imageUrl, imageView: backgroundImage)
            }
        }
    }
    
    private func loadImage(from url: URL, imageView: UIImageView) {
           imageView.contentMode = .scaleAspectFill
           DispatchQueue.global().async {
               if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                   DispatchQueue.main.async {
                       imageView.image = image
                   }
               }
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func setFavorite(_ sender: UIButton) {
        if ((self.movie?.favorite) != nil && self.movie?.favorite == true)  {
            self.viewModel?.setUnfavorite(movieId: self.movie?.id ?? 0)
        } else {
            self.viewModel?.setFavorite(movieId: self.movie?.id ?? 0)
        }
    }
    
    
}
