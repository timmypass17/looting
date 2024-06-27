//
//  Deal.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/20/24.
//

import Foundation

//struct Deal {
//    var title: String
//    var dealID: String
//    var storeID: String
//    var salePrice: String
//    var normalPrice: String
//    var savings: String // "85.042521" -> 85% discount
//    var metacriticScore: String
//    var steamRatingText: String?
//    var steamRatingPercent: String?
//    var steamRatingCount: String?
//    var steamAppID: String?
//    var releaseDate: Int // 1382400000 unix
//    var lastChange: Int // unix
//    var dealRating: String
//    var thumb: String
//}
//
//extension Deal {
//    var store: Store? {
//        return Settings.shared.stores.first { $0.id == storeID }
//    }
//}
//
//extension Deal: Decodable { }
//
//extension Deal: Hashable { }
//
//enum DealSortingOption: String {
//    case dealRating = "DealRating"
//    case title = "Title"
//    case savings = "Savings"
//    case metacritic = "Metacritic"
//    case reviews = "Reviews"
//    case release = "Release"
//    case store = "Store"
//    case recent = "Recent"
//}
//
//extension Deal {
//    static let samples: [Deal] = [
//        Deal(
//            title: "KINGDOM HEARTS III and Re Mind",
//            dealID: "bKP09dZy0tg1VQDeQDqCURj9C753Y1zFaikYCGUOMmM%3D",
//            storeID: "1",
//            salePrice: "41.39",
//            normalPrice: "59.99",
//            savings: "31.005168",
//            metacriticScore: "83",
//            steamRatingText: "Very Positive",
//            steamRatingPercent: "92",
//            steamRatingCount: "269",
//            steamAppID: "2552450",
//            releaseDate: 1617062400,
//            lastChange: 1718301092,
//            dealRating: "2.5",
//            thumb: "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552450/capsule_sm_120.jpg?t=1718708379"
//        ),
//        Deal(
//            title: "KINGDOM HEARTS HD 1.5 + 2.5 ReMIX",
//            dealID: "sZdljfg3gPJhMgbymQgFxJsD9748c5aPB2rV5zA5jGs%3D",
//            storeID: "1",
//            salePrice: "34.49",
//            normalPrice: "49.99",
//            savings: "31.006201",
//            metacriticScore: "0",
//            steamRatingText: "Mostly Positive",
//            steamRatingPercent: "70",
//            steamRatingCount: "2160",
//            steamAppID: "2552430",
//            releaseDate: 0,
//            lastChange: 1718301044,
//            dealRating: "0.6",
//            thumb: "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552430/capsule_sm_120.jpg?t=1718708278"
//        ),
//        Deal(
//            title: "KINGDOM HEARTS HD 2.8 Final Chapter Prologue",
//            dealID: "6iUHYPG3AST2fafQibL8ss1b2ji77Rtu%2Fq4mGnhtQ6k%3D",
//            storeID: "1",
//            salePrice: "41.39",
//            normalPrice: "59.99",
//            savings: "31.005168",
//            metacriticScore: "0",
//            steamRatingText: "Mostly Positive",
//            steamRatingPercent: "78",
//            steamRatingCount: "80",
//            steamAppID: "2552440",
//            releaseDate: 1617062400,
//            lastChange: 1718301103,
//            dealRating: "0.0",
//            thumb: "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/2552440/capsule_sm_120.jpg?t=1718708375"
//        )
//    ]
//}

struct DealResponse {
    var nextOffset: Int
    var hasMore: Bool
    var list: [DealItem]
}

extension DealResponse: Decodable { }

struct DealItem: Decodable, Hashable {
    var id: String
    var slug: String
    var title: String
    var type: String?
    var deal: Deal?
}

struct Deal: Decodable, Hashable {
    var shop: ShopAbridged
    var price: Price
    var regular: Price
    var cut: Int    // 22 -> 22% discount
    // var vouncher: nil
    var storeLow: Price
    var historyLow: Price
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

struct Price: Decodable, Hashable {
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
