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
}
