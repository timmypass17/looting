//
//  PriceOverviewAPIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/8/24.
//

import Foundation

struct PriceOverviewAPIRequest: APIRequest {
    
    var gameIDs: [String]
    var country: String = "US"
    var shops: [Int] = []
    var vouchers: Bool = true
//    var nondeals: Bool
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://api.isthereanydeal.com/games/overview/v2")!
        urlComponents.queryItems = [
            "country": country,
            "vouchers": vouchers ? "1" : "0"    // 1 = true, 0 = false
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        if shops.count > 0 {
            urlComponents.queryItems?.append(URLQueryItem(name: "shops", value: shops.map { "\($0)"}.joined(separator: ",")))
        }
        
        urlComponents.queryItems?.append(URLQueryItem(name: "key", value: apiKey))
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST" // required
        request.httpBody = try? JSONEncoder().encode(gameIDs)
        
        return request
    }
    
    func decodeResponse(data: Data) throws -> PriceOverview {
        let decoder = JSONDecoder()
        let priceOverview = try decoder.decode(PriceOverview.self, from: data)
        return priceOverview
    }
}

