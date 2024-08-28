//
//  SearchScope.swift
//  Topaz
//
//  Created by Timmy Nguyen on 8/26/24.
//

import Foundation

enum SearchScope: CaseIterable {
    case all, game, dlc, earlyAccess
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case .game:
            return "Game"
        case .dlc:
            return "DLC & Loot"
        case .earlyAccess:
            return "Early Access"
        }
    }
    
    var giveawayType: String {
        switch self {
        case .all:
            return "all"
        case .game:
            return "game"
        case .dlc:
            return "loot"
        case .earlyAccess:
            return "beta"
        }
    }

    var type: GiveawayType {
        switch self {
        case .all:
            return .other
        case .game:
            return .game
        case .dlc:
            return .dlc
        case .earlyAccess:
            return .earlyAccess
        }
    }
}

