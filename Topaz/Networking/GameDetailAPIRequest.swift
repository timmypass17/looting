//
//  DetailAPIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/4/24.
//

import Foundation

struct GameDetailAPIRequest: APIRequest {
    var gameID: String   // accepts multible id's
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://store.steampowered.com/api/appdetails")!
        urlComponents.queryItems = [
            "appids": gameID
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
                
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    enum ResponseError: Error {
        case invalidGameData
    }
    
    func decodeResponse(data: Data) throws -> GameDetail {
        let decoder = JSONDecoder()
        let response = try decoder.decode([String: GameResponse].self, from: data)
        guard let gameResponse = response.first,
              gameResponse.value.success == true
        else {
            throw ResponseError.invalidGameData
        }
        
        return gameResponse.value.data
    }
}
