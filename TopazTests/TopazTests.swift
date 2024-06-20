//
//  TopazTests.swift
//  TopazTests
//
//  Created by Timmy Nguyen on 6/19/24.
//

import XCTest

final class TopazTests: XCTestCase {
    
    let service = CheapSharkService()
    
    func testFetchStores() async throws {
        let stores: [Store] = try await service.getStores()
        let steamStore = stores.first { $0.name == "Steam" }
        XCTAssertEqual(steamStore?.name, "Steam")
    }

    func testDecodingStores() throws {
        let decoder = JSONDecoder()
        let stores: [Store] = try decoder.decode([Store].self, from: storesJson)
        let steamStore = stores.first { $0.name == "Steam" }
        XCTAssertEqual(steamStore?.name, "Steam")
    }

}
