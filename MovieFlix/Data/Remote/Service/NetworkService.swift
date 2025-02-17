//
//  NetworkService.swift
//  MovieFlix
//
//  Created by Isolina Ripolles on 15/02/25.
//

import Foundation
import Combine

enum NetworkError: Error {
  case decodingError(DecodingError.Context)
  case urlError(URLError)
}

class NetworkService {
    private let baseURL = "https://api.themoviedb.org/3/"
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwYjhiZTkzNWU0ODZiOWEwNTAxY2I2YjU4ZDMzYWQ0MiIsIm5iZiI6MTczOTY0ODI0OS40OTgsInN1YiI6IjY3YjBlY2Y5MjAxZDliZjY0ZTZjNWViNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NH5RJkukx2PjB1B1mT3PmdYYpSkhUvaPlGAIsqOFPCw"
    
    func request<T: Decodable>(
        _ path: String,
        method: String = "GET",
        body: Data? = nil
    ) -> AnyPublisher<T, Error> {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
               request.httpMethod = method
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")
               request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        if let body = body {
            request.httpBody = body
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .receive(on: DispatchQueue.main)
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
    }
}
