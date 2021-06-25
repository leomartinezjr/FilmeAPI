//
//  MovieService.swift
//  FilmeAPI
//
//  Created by Leonardo Paez on 19/05/21.
//

import Foundation

protocol MovieService {
    
    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse,MovieError>) -> ())
    func fethMovie(id: Int, completion: @escaping (Result<Movie,MovieError>) -> ())
    func searchMovie (query: String, completion: @escaping (Result<MovieResponse,MovieError>)-> ())
}


enum MovieListEndpoint: String, CaseIterable {
    case nowPlaying = "now_playing"
    case upcomig
    case topRated = "top_rated"
    case popular
    
    var description: String{
        switch self {
        case .nowPlaying: return "Now Playing"
        case .upcomig: return "Upcomig"
        case .topRated: return "Top Rated"
        case .popular: return "Popular"
        }
    }
}

enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String{
        switch self {
        case .apiError: return "Falha na fetch data"
        case .invalidEndpoint: return "invalid endpoint"
        case .invalidResponse: return "invalid response"
        case .noData: return "no Data"
        case .serializationError: return "Falha no decode data"
        }
    }
    var errorUserInfo: [String : Any] {
    [NSLocalizedDescriptionKey: localizedDescription ]
    }
}
