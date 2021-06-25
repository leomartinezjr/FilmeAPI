//
//  Movies.swift
//  FilmeAPI
//
//  Created by Leonardo Paez on 19/05/21.
//

import Foundation



struct MovieResponse:Decodable {
    
    let results: [Movie]
    
}

struct Movie:Decodable {
    
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCout: Int
    let runtime: Int?
    
}
