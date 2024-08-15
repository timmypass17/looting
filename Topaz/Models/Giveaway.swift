//
//  Giveaway.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/13/24.
//

import Foundation

struct Giveaway: Decodable, Hashable {
    var title: String
    var description: String
    var worth: String // "$9.99"
    var instructions: String?   // key may not exist
    var thumbnail: String
    var type: GiveawayType
    var platforms: String
    var publishedDate: String
    var endDate: String
    var users: Int
    var giveawayUrl: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case worth
        case instructions
        case thumbnail
        case type
        case platforms
        case publishedDate = "published_date"
        case endDate = "end_date"
        case users
        case giveawayUrl = "open_giveaway"
    }
}

enum GiveawayType: String, Decodable, CaseIterable {
    case game = "Game"
    case dlc = "DLC"
    case earlyAccess = "Early Access"
    case other = "Other"
}
