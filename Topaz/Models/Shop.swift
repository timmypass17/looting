//
//  Store.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import Foundation

struct Shop: Codable, Hashable { // Hashable for diffable Item
    var id: Int
    var title: String
    var deals: Int
//    var games: Int
    var update: String // "2024-06-26T04:17:59+02:00"
}
