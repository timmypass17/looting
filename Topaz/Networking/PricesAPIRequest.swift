//
//  PricesAPIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/30/24.
//

import Foundation

struct PricesAPIRequest: APIRequest {
    
    var gameIDs: [String]
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://api.isthereanydeal.com/games/prices/v2")!
        urlComponents.queryItems = [
            "key": apiKey
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(gameIDs)
        
        return request
    }
    
    func decodeResponse(data: Data) throws -> [Price] {
        let decoder = JSONDecoder()
        let prices = try decoder.decode([Price].self, from: data)
        return prices
    }
}
