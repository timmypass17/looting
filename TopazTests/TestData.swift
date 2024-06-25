//
//  TestData.swift
//  TopazTests
//
//  Created by Timmy Nguyen on 6/19/24.
//

import Foundation

let storesJson: Data = """
[
    {
        "storeID": "1",
        "storeName": "Steam",
        "isActive": 1,
        "images": {
            "banner": "/img/stores/banners/0.png",
            "logo": "/img/stores/logos/0.png",
            "icon": "/img/stores/icons/0.png"
        }
    },
    {
        "storeID": "2",
        "storeName": "GamersGate",
        "isActive": 1,
        "images": {
            "banner": "/img/stores/banners/1.png",
            "logo": "/img/stores/logos/1.png",
            "icon": "/img/stores/icons/1.png"
        }
    }
]
""".data(using: .utf8)!

let dealsJson: Data = """
[
  {
    "internalName": "DEUSEXHUMANREVOLUTIONDIRECTORSCUT",
    "title": "Deus Ex: Human Revolution - Director's Cut",
    "metacriticLink": "/game/pc/deus-ex-human-revolution---directors-cut",
    "dealID": "HhzMJAgQYGZ%2B%2BFPpBG%2BRFcuUQZJO3KXvlnyYYGwGUfU%3D",
    "storeID": "1",
    "gameID": "102249",
    "salePrice": "2.99",
    "normalPrice": "19.99",
    "isOnSale": "1",
    "savings": "85.042521",
    "metacriticScore": "91",
    "steamRatingText": "Very Positive",
    "steamRatingPercent": "92",
    "steamRatingCount": "17993",
    "steamAppID": "238010",
    "releaseDate": 1382400000,
    "lastChange": 1621536418,
    "dealRating": "9.6",
    "thumb": "https://cdn.cloudflare.steamstatic.com/steam/apps/238010/capsule_sm_120.jpg?t=1619788192"
  },
  {
    "internalName": "THIEFDEADLYSHADOWS",
    "title": "Thief: Deadly Shadows",
    "metacriticLink": "/game/pc/thief-deadly-shadows",
    "dealID": "EX0oH20b7A1H2YiVjvVx5A0HH%2F4etw3x%2F6YMGVPpKbA%3D",
    "storeID": "1",
    "gameID": "396",
    "salePrice": "0.98",
    "normalPrice": "8.99",
    "isOnSale": "1",
    "savings": "89.098999",
    "metacriticScore": "85",
    "steamRatingText": "Very Positive",
    "steamRatingPercent": "81",
    "steamRatingCount": "1670",
    "steamAppID": "6980",
    "releaseDate": 1085443200,
    "lastChange": 1621540561,
    "dealRating": "9.4",
    "thumb": "https://cdn.cloudflare.steamstatic.com/steam/apps/6980/capsule_sm_120.jpg?t=1592493801"
  }
]
""".data(using: .utf8)!
