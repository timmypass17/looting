//
//  GameService.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import Foundation

protocol GameService {
    func getStores() async throws -> [Store]
    func getDeals(storeIDs: [String], pageNumber: Int, pageSize: Int, sortBy: DealSortingOption, desc: Bool, lowerPrice: Int?, upperPrice: Int?, metacritic: Int?, steamRating: Int?, steamAppID: String?, title: String?, onSale: Bool) async throws -> [Deal]
}

struct CheapSharkService: GameService {
    func getStores() async throws -> [Store] {
        let request = StoresAPIRequest()
        let stores: [Store] = try await sendRequest(request)
        return stores
    }
    
    func getDeals(storeIDs: [String] = [], pageNumber: Int = 0, pageSize: Int = 60, sortBy: DealSortingOption = .dealRating, desc: Bool = false, lowerPrice: Int? = nil, upperPrice: Int? = nil, metacritic: Int? = nil, steamRating: Int? = nil, steamAppID: String? = nil, title: String? = nil, onSale: Bool = true) async throws -> [Deal] {
        let request = DealsAPIRequest(storeIDs: storeIDs, pageNumber: pageNumber, pageSize: pageSize, sortBy: sortBy, desc: desc, lowerPrice: lowerPrice, upperPrice: upperPrice, metacritic: metacritic, steamRating: steamRating, steamAppID: steamAppID, title: title, onSale: onSale)
        let deals: [Deal] = try await sendRequest(request)
        return deals
    }

}
