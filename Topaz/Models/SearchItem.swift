//
//  GameSearchResponse.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/25/24.
//

import Foundation

struct SearchItem {
    var id: String
    var title: String
    var type: String? // game, dlc
    var mature: Bool
}

extension SearchItem: Decodable { }
