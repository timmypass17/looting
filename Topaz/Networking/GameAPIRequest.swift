//
//  GameAPIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/25/24.
//

import Foundation

struct GameAPIRequest: APIRequest {
    var id: String
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://api.isthereanydeal.com/games/info/v2")!
        urlComponents.queryItems = [
            "id": id
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        urlComponents.queryItems?.append(URLQueryItem(name: "key", value: apiKey))

        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    func decodeResponse(data: Data) throws -> Game {
        let decoder = JSONDecoder()
        let game = try decoder.decode(Game.self, from: data)
        return game
    }
    
}
