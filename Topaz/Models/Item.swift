//
//  Item.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/20/24.
//

import Foundation

enum Item: Hashable {
    case deal(Deal)
//    case storeDeals(StoreDeals)
    case store(Store)
    
    var deal: Deal? {
        if case .deal(let deal) = self {
            return deal
        } else {
            return nil
        }
    }
    
//    var storeDeals: StoreDeals? {
//        if case .storeDeals(let storeDeals) = self {
//            return storeDeals
//        } else {
//            return nil
//        }
//    }
    
    var store: Store? {
        if case .store(let store) = self {
            return store
        } else {
            return nil
        }
    }
}
