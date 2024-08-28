//
//  GameInfo.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/25/24.
//

import Foundation

struct Game: Decodable, Hashable  {
    var uuid = UUID() // Can't have same item in multiple sections in diffable collection view (needs to have uniqueness via hash)
    var id: String
    var title: String
    var type: String?
    var mature: Bool
    var assets: Assets?
    var earlyAccess: Bool
    var achievements: Bool
    var tradingCards: Bool
    var steamID: Int? // steam id
    var tags: [String]
    var releaseDate: String? // "2013-08-13"
    var developers: [Developer]
    var publishers: [Publisher]
    var reviews: [Review]
    var stats: Stats
    var players: PlayerStats?
    var isThereAnyDealURL: IsThereAnyDealURL
    
    var rating: Double? {
        if let steamReview = reviews.first(where: { $0.source == "Steam" }),
           let steamScore = steamReview.score {
            return Double(steamScore) / 20
        } else if let otherScore = reviews.first?.score {
            return Double(otherScore) / 20
        }
        
        return nil
    }
    
    var steamReview: Review? {
        return reviews.first { $0.source == "Steam" }
    }
    
    var steamReviewText: String? {
        guard let steamReview,
              let score = steamReview.score
        else { return nil }
        
        if score < 20 {
            if steamReview.count < 50 {
                return "Negative"
            } else if steamReview.count < 500 {
                return "Very Negative"
            } else {
                return "Overwhelmingly Negative"
            }
        } else if score < 40 {
            return "Mostly Negative"
        } else if score < 70 {
            return "Mixed"
        } else if score < 80 {
            return "Mostly Postive"
        } else if score < 95 {
            if steamReview.count < 50 {
                return "Postive"
            } else  {
                return "Very Postive"
            }
        } else {
            if steamReview.count < 50 {
                return "Postive"
            } else if score < 500 {
                return "Very Postive"
            } else {
                return "Overwhelmingly Positive"
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.mature = try container.decode(Bool.self, forKey: .mature)
        self.assets = try? container.decode(Assets.self, forKey: .assets) // value could be array type for some reason..
        self.earlyAccess = try container.decode(Bool.self, forKey: .earlyAccess)
        self.achievements = try container.decode(Bool.self, forKey: .achievements)
        self.tradingCards = try container.decode(Bool.self, forKey: .tradingCards)
        self.steamID = try container.decodeIfPresent(Int.self, forKey: .steamID)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) // handles missing key or nil values
        self.developers = try container.decode([Developer].self, forKey: .developers)
        self.publishers = try container.decode([Publisher].self, forKey: .publishers)
        self.reviews = try container.decode([Review].self, forKey: .reviews)
        self.stats = try container.decode(Stats.self, forKey: .stats)
        self.players = try container.decodeIfPresent(PlayerStats.self, forKey: .players)
        self.isThereAnyDealURL = try container.decode(IsThereAnyDealURL.self, forKey: .isThereAnyDealURL)
    }
}

extension Game {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case type
        case mature
        case assets
        case earlyAccess
        case achievements
        case tradingCards
        case steamID = "appid"
        case tags
        case releaseDate
        case developers
        case publishers
        case reviews
        case stats
        case players
        case isThereAnyDealURL = "urls"
    }
}

struct Assets: Decodable, Hashable {
    var boxart: String
    var banner145: String
    var banner300: String
    var banner400: String
    var banner600: String
}

struct Developer: Decodable, Hashable {
    var id: Int
    var name: String
}

struct Publisher: Decodable, Hashable {
    var id: Int
    var name: String
}

struct Review: Decodable, Hashable {
    var score: Int?
    var source: String
    var count: Int
    var url: String
}

struct Stats: Decodable, Hashable {
    var rank: Int
    var waitlisted: Int
    var collected: Int
}

struct PlayerStats: Decodable, Hashable {
    var recent: Int
    var day: Int
    var week: Int
    var peak: Int
}

struct IsThereAnyDealURL: Decodable, Hashable {
    var game: String
}
