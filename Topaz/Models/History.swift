//
//  History.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/29/24.
//

import Foundation

struct History: Decodable {
    var timestamp: Date
    var deal: HistoryDeal
    
    enum CodingKeys: CodingKey {
        case timestamp
        case deal
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timestampString = try container.decode(String.self, forKey: .timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        if let date = dateFormatter.date(from: timestampString) {
            self.timestamp = date
        } else {
            throw HistoryAPIRequestError.invalidTimestamp
        }
        self.deal = try container.decode(HistoryDeal.self, forKey: .deal)
    }
}

struct HistoryDeal: Decodable {
    var price: Cost
    var regular: Cost
    var cut: Int
}

enum HistoryAPIRequestError: Error {
    case invalidTimestamp
}
