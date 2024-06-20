//
//  StoresAPIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import Foundation

struct StoresAPIRequest: APIRequest {
    var urlRequest: URLRequest {
        let url = URL(string: "https://www.cheapshark.com/api/1.0/stores")!
        var request = URLRequest(url: url)
        return request
    }
    
    func decodeResponse(data: Data) throws -> [Store] {
        let decoder = JSONDecoder()
        let stores = try decoder.decode([Store].self, from: data)
        return stores
    }
}
