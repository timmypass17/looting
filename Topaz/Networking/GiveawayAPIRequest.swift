//
//  GiveawayAPIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/13/24.
//

import Foundation

struct GiveawayAPIRequest: APIRequest {
    
    var platform: String? = nil // no value means "All"
    var type: SearchScope = .all
    var sortBy: GiveawaySortOption = .popularity
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://gamerpower.com/api/giveaways")!
        urlComponents.queryItems = [
            "sort-by": sortBy.rawValue
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        
        if let platform {
            urlComponents.queryItems?.append(URLQueryItem(name: "platform", value: platform))
        }
        
        if type.giveawayType != "all" {
            urlComponents.queryItems?.append(URLQueryItem(name: "type", value: type.giveawayType))
        }

        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    func decodeResponse(data: Data) throws -> [Giveaway] {
        let decoder = JSONDecoder()
        let giveaways = try decoder.decode([Giveaway].self, from: data)
        return giveaways
    }
}

enum GiveawaySortOption: String {
    case date, value, popularity
}


