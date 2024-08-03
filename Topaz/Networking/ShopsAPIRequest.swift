//
//  StoresAPIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import Foundation

struct ShopsAPIRequest: APIRequest {
    var country: String
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://api.isthereanydeal.com/service/shops/v1")!
        urlComponents.queryItems = [
            "country": country
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    func decodeResponse(data: Data) throws -> [Shop] {
        let decoder = JSONDecoder()
        let shops = try decoder.decode([Shop].self, from: data)
        return shops
    }
    
}
