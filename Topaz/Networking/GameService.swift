//
//  GameService.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import Foundation

protocol GameService {
    func getStores() async throws -> [Store]
}

struct CheapSharkService: GameService {
    func getStores() async throws -> [Store] {
        let request = StoresAPIRequest()
        let stores: [Store] = try await sendRequest(request)
        return stores
    }
}
