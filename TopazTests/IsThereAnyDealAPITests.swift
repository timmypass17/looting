//
//  IsThereAnyDealAPITests.swift
//  TopazTests
//
//  Created by Timmy Nguyen on 6/25/24.
//

import XCTest

final class IsThereAnyDealAPITests: XCTestCase {

    let service = IsThereAnyDealService()
    let kingdomHeartsID = "018d937f-4adb-73a6-a9e5-94ff5f2b847b"
    
    func testFetchingDeals() async {
        do {
            let dealResponse: DealResponse = try await service.getDeals()
            XCTAssertTrue(dealResponse.list.count > 0)
        } catch {
            XCTFail("Failed to fetch deals: \(error)")
        }
    }

    func testDecodingDeals() {
        do {
            let decoder = JSONDecoder()
            let dealResponse: DealResponse = try decoder.decode(DealResponse.self, from: dealsJSON)
            XCTAssertTrue(dealResponse.list.count > 0)
        } catch {
            XCTFail("Failed to decode deals: \(error)")
        }
    }
    
    func testFetchingSearchItems() async {
        do {
            let searchItems: [SearchItem] = try await service.getSearchItems(title: "kingdom hearts")
            XCTAssertTrue(searchItems.count > 0)
        } catch {
            XCTFail("Failed to fetch games by title: \(error)")
        }
    }

    func testDecodingGameSearchItems() {
        do {
            let decoder = JSONDecoder()
            let searchItems: [SearchItem] = try decoder.decode([SearchItem].self, from: gameSearchJSON)
            XCTAssertTrue(searchItems.count > 0)
        } catch {
            XCTFail("Failed to decode deals: \(error)")
        }
    }
    
    func testFetchingGame() async {
        do {
            let game: Game = try await service.getGame(id: kingdomHeartsID)
            XCTAssertTrue(game.title == "KINGDOM HEARTS - HD 1 5+2 5 ReMIX")
        } catch {
            XCTFail("Failed to fetch games by title: \(error)")
        }
    }
    
    func testDecodingGame() {
        do {
            let decoder = JSONDecoder()
            let game: Game = try decoder.decode(Game.self, from: gameJSON)
            XCTAssertTrue(game.title == "KINGDOM HEARTS - HD 1 5+2 5 ReMIX")
        } catch {
            XCTFail("Failed to decode deals: \(error)")
        }
    }
    
    func testFetchingShops() async {
        do {
            let shops: [Shop] = try await service.getShops()
            XCTAssertTrue(shops.count > 0)
        } catch {
            XCTFail("Failed to fetch games by title: \(error)")
        }
    }
    
    func testDecodingShops() {
        do {
            let decoder = JSONDecoder()
            let shops: [Shop] = try decoder.decode([Shop].self, from: shopsJSON)
            XCTAssertTrue(shops.count > 0)
        } catch {
            XCTFail("Failed to decode deals: \(error)")
        }
    }
    
    func testFetchingPrices() async {
        do {
            let prices: [Price] = try await service.getPrices(gameIDs: [kingdomHeartsID])
            XCTAssertTrue(prices.count > 0)
        } catch {
            XCTFail("Failed to fetch games by title: \(error)")
        }
    }
    
    func testDecodingPrices() {
        do {
            let decoder = JSONDecoder()
            let prices: [Price] = try decoder.decode([Price].self, from: pricesJSON)
            XCTAssertTrue(prices.count > 0)
        } catch {
            XCTFail("Failed to decode prices: \(error)")
        }
    }
    
    func testFetchingPriceOverview() async {
        do {
            let priceOverview: PriceOverview = try await service.getPriceOverview(gameIDs: [kingdomHeartsID])
            XCTAssertTrue(priceOverview.prices.count > 0)
        } catch {
            XCTFail("Failed to fetch games by title: \(error)")
        }
    }
    
    func testDecodingPriceOverview() {
        do {
            let decoder = JSONDecoder()
            let priceOverview: PriceOverview = try decoder.decode(PriceOverview.self, from: priceOverviewJSON)
            XCTAssertTrue(priceOverview.prices.count > 0)
        } catch {
            XCTFail("Failed to decode price overview: \(error)")
        }
    }
    
    
    
}
