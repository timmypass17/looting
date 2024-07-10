//
//  PriceOverview.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/8/24.
//

import Foundation

struct PriceOverview: Decodable {
    var prices: [PriceOverviewItem]
//    var bundles: []
}

struct PriceOverviewItem: Decodable {
    var id: String
    var current: Deal
    var lowest: Deal
}
