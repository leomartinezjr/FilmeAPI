//
//  Utils.swift
//  FilmeAPI
//
//  Created by Leonardo Paez on 19/05/21.
//

import Foundation



class Utils {
    
    static let jsonDecoder: JSONDecoder = {
       
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase // converte em padráo camelo ou cobra
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter) // coloca a data no fomato certp 
        return jsonDecoder
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
        
    }()
    
}
