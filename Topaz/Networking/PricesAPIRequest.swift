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
            "country": "US",
            "nondeals": "1"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        urlComponents.queryItems?.append(URLQueryItem(name: "key", value: apiKey))
        
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
