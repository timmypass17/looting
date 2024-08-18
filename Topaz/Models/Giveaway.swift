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
    var endDate: Date?
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
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.worth = try container.decode(String.self, forKey: .worth)
        self.instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
        self.type = try container.decode(GiveawayType.self, forKey: .type)
        self.platforms = try container.decode(String.self, forKey: .platforms)
        self.publishedDate = try container.decode(String.self, forKey: .publishedDate)
        let endDateString = try container.decode(String.self, forKey: .endDate)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        // Convert the string to a Date object
        if let date = dateFormatter.date(from: endDateString) {
            self.endDate = date
        }
        
        self.users = try container.decode(Int.self, forKey: .users)
        self.giveawayUrl = try container.decode(String.self, forKey: .giveawayUrl)
    }
}

enum GiveawayType: String, Decodable, CaseIterable {
    case game = "Game"
    case dlc = "DLC"
    case earlyAccess = "Early Access"
    case other = "Other"
}
