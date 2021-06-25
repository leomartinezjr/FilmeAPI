//
//  MovieStore.swift
//  FilmeAPI
//
//  Created by Leonardo Paez on 19/05/21.
//

import Foundation

class MovieStore: MovieService {

    static let shared = MovieStore()
    private init() {}
    
    private let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    
    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)")  else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    func fethMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)")  else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "append_to_response":"videos,credits"
        
        ], completion: completion)
    }
    
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/search/movie")  else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: [
            "language":"en-US",
            "include_adult":"false",
            "region":"US",
            "query":query
        
        ], completion: completion)

    }
    
    private func loadURLAndDecode <D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) -> ()){
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "a07e22bc18f5cb106bfe4cc1f83ad8ed", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map{(URLQueryItem(name: $0.key, value: $0.value))})
            
        }
        
        urlComponents.queryItems = queryItems
        guard let finalURL = urlComponents.url else{
            completion(.failure(.invalidEndpoint))
            return
        }
        
        
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else {return}
            if error != nil {
                self.executeCompletionHandleInMainThread(whith: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandleInMainThread(whith: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandleInMainThread(whith: .failure(.noData), completion: completion)
                return
            }
            do{
                let decodeResponse = try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandleInMainThread(whith: .success(decodeResponse), completion: completion)
            }catch{
                self.executeCompletionHandleInMainThread(whith: .failure(.serializationError), completion: completion)
            }
            
        }.resume()
    }
    
    private func executeCompletionHandleInMainThread<D: Decodable>(whith result: Result<D,MovieError>, completion: @escaping (Result<D,MovieError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
}
