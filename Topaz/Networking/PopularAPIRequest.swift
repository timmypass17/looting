//
//  PopularAPIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/4/24.
//

import Foundation

struct PopularAPIRequest: APIRequest {
    var offset: Int
    var limit: Int
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://api.isthereanydeal.com/stats/most-popular/v1")!
        urlComponents.queryItems = [
            "offset": "\(offset)",
            "limit": "\(limit)"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        urlComponents.queryItems?.append(URLQueryItem(name: "key", value: apiKey))
        
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    func decodeResponse(data: Data) throws -> [Stat] {
        let decoder = JSONDecoder()
        let waitlist = try decoder.decode([Stat].self, from: data)
        return waitlist
    }
}
