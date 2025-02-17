//
//  DetailView.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 16/02/25.
//

import SwiftUI

protocol DetailViewDelegate: AnyObject {
    func didDismissDetailView(with movie: DetailMovie?)
}

struct DetailView: View {
    
    @ObservedObject var viewModel: DetailViewModel
    @State private var isLoading = true
    @Environment(\.presentationMode) var presentationMode
    weak var delegate: DetailViewDelegate?
    @State private var isShareSheetPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        if let detailMovie = viewModel.detailMovie {
                            if let backdropPath = detailMovie.backdrop_path, !backdropPath.isEmpty {
                                let url = "https://image.tmdb.org/t/p/w500\(backdropPath)"
                                if let imageUrl = URL(string: url) {
                                    AsyncImage(url: imageUrl) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .frame(width: .infinity, height: 250)
                                                .padding(.bottom, 8)
                                        case .failure(let error):
                                            Text("Failed to load image: \(error.localizedDescription)")
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }
                            }
                    
                            Text(detailMovie.title ?? "")
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 8)
                            
                            HStack(spacing: 0) {
                                Text("\(detailMovie.getGenders())")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 8)
                                Spacer()
                                Button(action: {
                                    if (detailMovie.favorite != nil && detailMovie.favorite == true)  {
                                        self.viewModel.setUnfavorite(movieId: detailMovie.id)
                                    } else {
                                        self.viewModel.setFavorite(movieId: detailMovie.id)
                                    }
                                }) {
                                    let favorite = detailMovie.favorite ?? false
                                    if (favorite) {
                                        Image(systemName: "heart.fill")
                                            .frame(width: 45, height: 45)
                                            .foregroundColor(.red)
                                    } else {
                                        Image(systemName: "heart")
                                            .frame(width: 45, height: 45)
                                            .foregroundColor(.red)
                                    }
                                }
                                
                            }.padding(0)
                            
                            Text(detailMovie.releaseDate())
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                                .foregroundColor(.brown)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 5) {
                                let vote = (detailMovie.vote_average ?? 0)/2
                                if (vote >= 0.8) {
                                    Image(systemName: "star.fill")
                                } else if (vote >= 0.3 && vote < 0.8) {
                                    Image(systemName: "star.leadinghalf.fill")
                                } else {
                                    Image(systemName: "star")
                                }
                                
                                if (vote >= 1.8) {
                                    Image(systemName: "star.fill")
                                } else if (vote >= 1.3 && vote < 1.8) {
                                    Image(systemName: "star.leadinghalf.fill")
                                } else {
                                    Image(systemName: "star")
                                }
                                
                                if (vote >= 2.8) {
                                    Image(systemName: "star.fill")
                                } else if (vote >= 2.3 && vote < 2.8) {
                                    Image(systemName: "star.leadinghalf.fill")
                                } else {
                                    Image(systemName: "star")
                                }
                                
                                if (vote >= 3.8) {
                                    Image(systemName: "star.fill")
                                } else if (vote >= 3.3 && vote < 3.8) {
                                    Image(systemName: "star.leadinghalf.fill")
                                } else {
                                    Image(systemName: "star")
                                }
                                
                                if (vote >= 4.8) {
                                    Image(systemName: "star.fill")
                                } else if (vote >= 4.3 && vote < 4.8) {
                                    Image(systemName: "star.leadinghalf.fill")
                                } else {
                                    Image(systemName: "star")
                                }
                            }.font(.body)
                                .foregroundColor(.yellow)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 8)
                                .padding(.bottom, 8)
                            
                            Text("Runtime")
                                .font(.body)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                                .padding(.horizontal, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(detailMovie.formatMinutesToHoursAndMinutes())")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                                .foregroundColor(.brown)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Description")
                                .font(.body)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                                .padding(.horizontal, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(detailMovie.overview ?? "")
                                .font(.body)
                                .padding(.horizontal, 8)
                                .padding(.bottom, 8)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("Reviews")
                                .font(.body)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.bottom, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ForEach(viewModel.reviews) { review in
                                Text("\(review.author_details.username)")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 8)
                                    .foregroundColor(.orange)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                          
                                Text(review.content)
                                    .font(.caption2)
                                    .padding(.horizontal, 8)
                                    .padding(.bottom, 8)
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)
                             }
                            
                            Text("Similar Movies")
                                .font(.body)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.bottom, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.movies) { movie in
                                        if let posterPath = movie.poster_path, !posterPath.isEmpty {
                                            let url = "https://image.tmdb.org/t/p/w500\(posterPath)"
                                            if let imageUrl = URL(string: url) {
                                                AsyncImage(url: imageUrl) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .frame(width: 150, height: 200)
                                                            .background(Color.blue)
                                                            .cornerRadius(10)
                                                    case .failure(let error):
                                                        Text("Failed to load image: \(error.localizedDescription)")
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding()
                            }

                            
                        } else {
                            SkeletonPlaceholder()
                                .onAppear {
                                    viewModel.fetchDetailMovie()
                                    viewModel.fetchReviewsMovie()
                                    viewModel.fetchSimilarMovie()
                                }
                        }
                    }
                }
            }.toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            delegate?.didDismissDetailView(with: viewModel.detailMovie)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                        }
                    }
                   ToolbarItem(placement: .navigationBarTrailing) {
                       Button(action: {
                           isShareSheetPresented.toggle()
                         print("Compartir película")
                       }) {
                         Image(systemName: "square.and.arrow.up")
                       }
                   }
                }
               .sheet(isPresented: $isShareSheetPresented) {
                   ShareSheet(items: [viewModel.detailMovie?.title])
                }
            }
        }
}

struct SkeletonPlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
               ShimmerRectangle(height: 200)
               ShimmerRectangle(height: 50)
               ShimmerRectangle(height: 50)
               ShimmerRectangle(height: 50)
               ShimmerRectangle(height: 50)
               ShimmerRectangle(height: 100)
               ShimmerRectangle(height: 100)
               ShimmerRectangle(height: 100)
           }
    }
}

struct ShimmerRectangle: View {
    var height: CGFloat
    @State private var moveShimmer = false

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.2), Color.gray.opacity(0.4)]),
                    startPoint: moveShimmer ? .leading : .trailing,
                    endPoint: moveShimmer ? .trailing : .leading
                )
            )
            .frame(height: height)
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    moveShimmer.toggle()
                }
            }
    }
}

