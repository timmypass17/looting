//
//  GameService.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import Foundation

struct IsThereAnyDealService {
    func getDeals(country: String = "US", offset: Int = 0, limit: Int = 20, sort: SortOption = .trendingDesc, nondeals: Bool = false, mature: Bool = false, shops: [Int] = [], filter: String = "") async throws -> DealResponse {
        let request = DealsAPIRequest(country: country, offset: offset, limit: limit, sort: sort, nondeals: nondeals, mature: mature, shops: shops, filter: filter)
        let dealReponse: DealResponse = try await sendRequest(request)
        return dealReponse
    }
    
    func getSearchItems(title: String, results: Int = 20) async throws -> [SearchItem] {
        let request = SearchAPIRequest(title: title, results: results)
        let gameSearchItems: [SearchItem] = try await sendRequest(request)
        return gameSearchItems
    }
    
    func getGame(id: String) async throws -> Game {
        let request = GameAPIRequest(id: id)
        let game: Game = try await sendRequest(request)
        return game
    }
    
    func getShops(country: String = "US") async throws -> [Shop] {
        let request = ShopsAPIRequest(country: country)
        let shops: [Shop] = try await sendRequest(request)
        return shops
    }
    
    func getPrices(gameIDs: [String]) async throws -> [Price] {
        let request = PricesAPIRequest(gameIDs: gameIDs)
        let prices: [Price] = try await sendRequest(request)
        return prices
    }
    
    func getMostWaitlist(offset: Int = 0, limit: Int = 20) async throws -> [Waitlist] {
        let request = WaitlistAPIRequest(offset: offset, limit: limit)
        let waitlist: [Waitlist] = try await sendRequest(request)
        return waitlist
    }
}

extension IsThereAnyDealService {
    enum SortOption: String {
        case trendingDesc = "-trending"
        case trendingAsc = "trending"
    }
}
