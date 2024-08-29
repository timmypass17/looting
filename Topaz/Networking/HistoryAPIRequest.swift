//
//  HistoryAPIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/29/24.
//

import Foundation
struct HistoryAPIRequest: APIRequest {
    var gameID: String
        
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://api.isthereanydeal.com/games/history/v2")!
        let steamID = "61"
        urlComponents.queryItems = [
            "id": gameID,
            "shops": steamID,
            "since": "0000-01-01T14:30:00Z"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
                
        urlComponents.queryItems?.append(URLQueryItem(name: "key", value: apiKey))
        
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    func decodeResponse(data: Data) throws -> [History] {
        let decoder = JSONDecoder()
        let history = try decoder.decode([History].self, from: data)
        return history
    }
}
