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
