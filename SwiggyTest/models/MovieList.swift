//
//  MovieList.swift
//  SwiggyTest
//
//  Created by Manas1 Mishra on 28/10/20.
//

import Foundation


struct MovieListResponse : Codable {
    let search : [MovieSearch]?
    let totalResults : String?
    let response : String?
    
    var totalPages: Int {
        if let requests = totalResults, let count = Int(requests) {
            if count % 10 == 0 {
                return count/10
            }
            return (count/10) + 1
        }
        return 0
        
    }

    enum CodingKeys: String, CodingKey {

        case search = "Search"
        case totalResults = "totalResults"
        case response = "Response"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        search = try? values.decodeIfPresent([MovieSearch].self, forKey: .search)
        totalResults = try? values.decodeIfPresent(String.self, forKey: .totalResults)
        response = try? values.decodeIfPresent(String.self, forKey: .response)
    }

}

struct MovieSearch : Codable {
    let title : String?
    let year : String?
    let imdbID : String?
    let type : String?
    let poster : String?

    enum CodingKeys: String, CodingKey {

        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try? values.decodeIfPresent(String.self, forKey: .title)
        year = try? values.decodeIfPresent(String.self, forKey: .year)
        imdbID = try? values.decodeIfPresent(String.self, forKey: .imdbID)
        type = try? values.decodeIfPresent(String.self, forKey: .type)
        poster = try? values.decodeIfPresent(String.self, forKey: .poster)
    }

}

