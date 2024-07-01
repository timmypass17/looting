//
//  Deal.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/20/24.
//

import Foundation

struct DealResponse {
    var nextOffset: Int
    var hasMore: Bool
    var list: [DealItem]
}

extension DealResponse: Decodable { }

struct DealItem: Decodable, Hashable {
    var id: String
    var title: String
    var type: String?
    var deal: Deal?
}

struct Deal: Decodable, Hashable {
    var shop: ShopAbridged
    var price: Cost
    var regular: Cost
    var cut: Int    // 22 -> 22% discount
    // var vouncher: nil
    var storeLow: Cost
    var historyLow: Cost
    // var flag: nil
    var drm: [DRM] // Digital Rights Management (e.g. Steam)
    var platforms: [Platform]
    var timestamp: String
    var expiry: String?
    var url: String // IsThereAnyDeal site
}

struct ShopAbridged: Decodable, Hashable {
    var id: Int
    var name: String
}

struct Cost: Decodable, Hashable {
    var amount: Double
    var amountInt: Int
    var currency: String
}

struct DRM: Decodable, Hashable {
    var id: Int
    var name: String
}

struct Platform: Decodable, Hashable {
    var id: Int
    var name: String
}
