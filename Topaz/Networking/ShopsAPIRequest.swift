//
//  StoresAPIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import Foundation

//struct StoresAPIRequest: APIRequest {
//    var urlRequest: URLRequest {
//        let url = URL(string: "https://www.cheapshark.com/api/1.0/stores")!
//        let request = URLRequest(url: url)
//        return request
//    }
//    
//    func decodeResponse(data: Data) throws -> [Store] {
//        let decoder = JSONDecoder()
//        let stores = try decoder.decode([Store].self, from: data)
//        return stores
//    }
//}


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
