//
//  DealsAPIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/20/24.
//

import Foundation

var apiKey = "0c244dbcb5293b88730b04592502fe9cbb6563ea"

struct DealsAPIRequest: APIRequest {
    var country: String
    var offset: Int
    var limit: Int
    var sort: IsThereAnyDealService.SortOption
    var nondeals: Bool
    var mature: Bool
    var shops: [Int]
    var filter: String
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://api.isthereanydeal.com/deals/v2")!
        urlComponents.queryItems = [
            "country": country,
            "offset": "\(offset)",
            "limit": "\(limit)",
            "sort": sort.rawValue,
            "nondeals": nondeals ? "1" : "0",
            "mature": mature ? "1" : "0",
            "shops": shops.map { "\($0)" }.joined(separator: ","),
            "filter": filter
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        urlComponents.queryItems?.append(URLQueryItem(name: "key", value: apiKey))

        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    func decodeResponse(data: Data) throws -> DealResponse {
        let decoder = JSONDecoder()
        let deals = try decoder.decode(DealResponse.self, from: data)
        return deals
    }
}
