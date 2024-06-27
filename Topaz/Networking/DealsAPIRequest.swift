//
//  DealsAPIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/20/24.
//

import Foundation

//struct DealsAPIRequest: APIRequest {
//    var storeIDs: [String]
//    var pageNumber: Int
//    var pageSize: Int
//    var sortBy: DealSortingOption
//    var desc: Bool
//    var lowerPrice: Int?
//    var upperPrice: Int?
//    var metacritic: Int?
//    var steamRating: Int?
//    var steamAppID: String?
//    var title: String?
//    var onSale: Bool
//    
//    var urlRequest: URLRequest {
//        var urlComponents = URLComponents(string: "https://www.cheapshark.com/api/1.0/deals")!
//        urlComponents.queryItems = [
//            "pageNumber": "\(pageNumber)",
//            "pageSize": "\(pageSize)",
//            "sortBy": sortBy.rawValue,
//            "desc": desc ? "1" : "0",
//            "onSale": onSale ? "1" : "0",
//        ].map { URLQueryItem(name: $0.key, value: $0.value) }
//        
//        if storeIDs.count > 0 {
//            urlComponents.queryItems?.append(URLQueryItem(name: "storeID", value: storeIDs.joined(separator: ",")))
//        }
//        
//        if let lowerPrice {
//            urlComponents.queryItems?.append(URLQueryItem(name: "lowerPrice", value: "\(lowerPrice)"))
//        }
//        
//        if let upperPrice {
//            urlComponents.queryItems?.append(URLQueryItem(name: "upperPrice", value: "\(upperPrice)"))
//        }
//        
//        if let metacritic {
//            urlComponents.queryItems?.append(URLQueryItem(name: "metacritic", value: "\(metacritic)"))
//        }
//        
//        if let steamRating {
//            urlComponents.queryItems?.append(URLQueryItem(name: "steamRating", value: "\(steamRating)"))
//        }
//        
//        if let steamAppID {
//            urlComponents.queryItems?.append(URLQueryItem(name: "steamAppID", value: "\(steamAppID)"))
//        }
//        
//        if let title {
//            urlComponents.queryItems?.append(URLQueryItem(name: "title", value: "\(title)"))
//        }
//        
//        print(urlComponents.url!)
//        let request = URLRequest(url: urlComponents.url!)
//        return request
//    }
//
//    func decodeResponse(data: Data) throws -> [Deal] {
//        let decoder = JSONDecoder()
//        let deals = try decoder.decode([Deal].self, from: data)
//        return deals
//    }
//}

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
