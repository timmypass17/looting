//
//  APIRequest.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import Foundation

protocol APIRequest {
    associatedtype Response
    
    var urlRequest: URLRequest { get }
    func decodeResponse(data: Data) throws -> Response
}

enum APIRequestError: Error {
    case itemNotFound
}

func sendRequest<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
    let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
    
    data.prettyPrintedJSONString()
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw APIRequestError.itemNotFound
    }
    
    let decodedResponse = try request.decodeResponse(data: data)
    return decodedResponse
}

extension Data {
    func prettyPrintedJSONString() {
        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
            let prettyJSONString = String(data: jsonData, encoding: .utf8) else {
                print("Failed to read JSON Object.")
                return
        }
        
        print(prettyJSONString)
    }
}
