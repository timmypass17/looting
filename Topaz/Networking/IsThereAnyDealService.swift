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
    
    func getMostWaitlist(offset: Int = 0, limit: Int = 20) async throws -> [Stat] {
        let request = WaitlistAPIRequest(offset: offset, limit: limit)
        let waitlist: [Stat] = try await sendRequest(request)
        return waitlist
    }
    
    func getPopular(offset: Int = 0, limit: Int = 20) async throws -> [Stat] {
        let request = PopularAPIRequest(offset: offset, limit: limit)
        let popular: [Stat] = try await sendRequest(request)
        return popular
    }
    
    func getPriceOverview(gameIDs: [String]) async throws -> PriceOverview {
        let request = PriceOverviewAPIRequest(gameIDs: gameIDs)
        let priceOverview: PriceOverview = try await sendRequest(request)
        return priceOverview
    }
    
    func getHistory(gameID: String) async throws -> [History] {
        let request = HistoryAPIRequest(gameID: gameID)
        let history = try await sendRequest(request)
        return history
    }
}

struct SteamWebService {
    func getGameDetail(gameID: String) async throws -> GameDetail {
        let request = GameDetailAPIRequest(gameID: gameID)
        let gameDetail: GameDetail = try await sendRequest(request)
        return gameDetail
    }
}

extension IsThereAnyDealService {
    enum SortOption: String {
        case trendingDesc = "-trending"
        case trendingAsc = "trending"
    }
}

struct GamerPowerService {
    func getGiveaways(platform: String? = nil, type: SearchScope = .all, sortBy: GiveawaySortOption = .popularity) async throws -> [Giveaway] {
        let request = GiveawayAPIRequest(platform: platform, type: type, sortBy: sortBy)
        let giveaways: [Giveaway] = try await sendRequest(request)
        return giveaways
    }
}
