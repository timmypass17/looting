//
//  GameSearchAPIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/25/24.
//

import Foundation

struct SearchAPIRequest: APIRequest {
    
    var title: String
    var results: Int
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://api.isthereanydeal.com/games/search/v1")!
        urlComponents.queryItems = [
            "title": title,
            "results": "\(results)"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        urlComponents.queryItems?.append(URLQueryItem(name: "key", value: apiKey))

        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    func decodeResponse(data: Data) throws -> [SearchItem] {
        let decoder = JSONDecoder()
        let games = try decoder.decode([SearchItem].self, from: data)
        return games
    }
}
