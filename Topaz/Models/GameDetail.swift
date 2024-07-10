//
//  GameDetail.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/4/24.
//

import Foundation

struct GameResponse: Decodable {
    var data: GameDetail
    var success: Bool
}

struct GameDetail: Decodable {
    var name: String
    var background: String  // steam version
    var background_raw: String
    var short_description: String
}
