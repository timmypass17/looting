//
//  Item.swift
//  Topaz
//
//  Created by Timmy Nguyen on 6/20/24.
//

import Foundation

enum Item: Hashable {
    case game(Game, DealItem)
    case shop(Shop)
    
    var game: Game? {
        if case .game(let game, _) = self {
            return game
        } else {
            return nil
        }
    }
    
    var shop: Shop? {
        if case .shop(let shop) = self {
            return shop
        } else {
            return nil
        }
    }
    
    var dealItem: DealItem? {
        if case .game(_, let dealItem) = self {
            return dealItem
        } else {
            return nil
        }
    }
}
