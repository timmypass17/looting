//
//  WishlistItem.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/29/24.
//

import Foundation
import FirebaseFirestore

struct WishlistItem: Codable, Hashable {
    var userID: String
    var gameID: String
    var title: String
    var regularPrice: Double?
    var posterURL: String?
//    var createdAt: Date
    var createdAt = FirebaseFirestore.Timestamp()
    var deal: Deal? // fetch price using api
}
