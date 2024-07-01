//
//  Price.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/30/24.
//

import Foundation

struct Price: Decodable {
    var id: String
    var deals: [Deal]
    
    enum CodingKeys: CodingKey {
        case id
        case deals
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.deals = (try? container.decode([Deal].self, forKey: .deals)) ?? [] // possible int val for some reason
    }
}
