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
    var voucher: String?    // coupon code
    var storeLow: Cost?
    var historyLow: Cost?   // history
    // var flag: nil
    var drm: [DRM] // Digital Rights Management (e.g. Steam)
    var platforms: [Platform]
    var timestamp: String
    var expiry: String?
    var url: String? // url to shop
    
    enum CodingKeys: CodingKey {
        case shop
        case price
        case regular
        case cut
        case voucher
        case storeLow
        case historyLow
        case drm
        case platforms
        case timestamp
        case expiry
        case url
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.shop = try container.decode(ShopAbridged.self, forKey: .shop)
        self.price = try container.decode(Cost.self, forKey: .price)
        self.regular = try container.decode(Cost.self, forKey: .regular)
        self.cut = try container.decode(Int.self, forKey: .cut)
        self.voucher = try container.decodeIfPresent(String.self, forKey: .voucher)
        self.storeLow = try container.decodeIfPresent(Cost.self, forKey: .storeLow)
        self.historyLow = try container.decodeIfPresent(Cost.self, forKey: .historyLow)
        self.drm = (try? container.decodeIfPresent([DRM].self, forKey: .drm)) ?? []
        self.platforms = (try? container.decodeIfPresent([Platform].self, forKey: .platforms)) ?? []
        self.timestamp = try container.decode(String.self, forKey: .timestamp)
        self.expiry = try container.decodeIfPresent(String.self, forKey: .expiry)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
    }
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
