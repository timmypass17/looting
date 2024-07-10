//
//  SteamWebAPITests.swift
//  TopazTests
//
//  Created by Timmy Nguyen on 7/4/24.
//

import XCTest

final class SteamWebAPITests: XCTestCase {
    
    let service = SteamWebService()
    
    func testFetchingGameDetail() async {
        do {
            let kingdomHeartsID = "2552430"
            let gameDetail: GameDetail = try await service.getGameDetail(gameID: kingdomHeartsID)
            XCTAssertEqual(gameDetail.name, "KINGDOM HEARTS -HD 1.5+2.5 ReMIX-")
        } catch {
            XCTFail("Failed to fetch deals: \(error)")
        }
    }

}
