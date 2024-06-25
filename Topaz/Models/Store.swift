//
//  Store.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/19/24.
//

import Foundation

struct Store {
    var id: String
    var name: String
    var images: StoreImages
}

extension Store: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "storeID"
        case name = "storeName"
        case images
    }
}

extension Store: Hashable {} // for Item enum

struct StoreImages: Codable {
    var banner: String
    var logo: String
    var icon: String
}

extension StoreImages: Hashable {}


extension Store {
    static let sampleStores = [
        Store(id: "1", name: "Steam", images: StoreImages(banner: "/img/stores/banners/0.png", logo: "/img/logos/banners/0.png", icon: "/img/stores/icons/0.png")),
        Store (id: "25", name: "Epic Games Store", images: StoreImages(banner: "/img/stores/banners/24.png", logo: "/img/stores/logos/24.png", icon: "/img/stores/icons/24.png"))
    ]
}

enum StoreID: String {
    case steam = "1"
    case greenMan = "3"
    case humble = "11"
}
