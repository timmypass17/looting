//
//  GamerPowerAPITests.swift
//  TopazTests
//
//  Created by Timmy Nguyen on 8/13/24.
//

import XCTest

final class GamerPowerAPITests: XCTestCase {
    
    let service = GamerPowerService()
    
    func testDecodingGiveways() {
        do {
            let decoder = JSONDecoder()
            let giveways: [Giveaway] = try decoder.decode([Giveaway].self, from: giveawaysJSON)
            XCTAssertTrue(giveways.count > 0)
        } catch {
            XCTFail("Failed to decode giveways: \(error)")
        }
    }
    

}
