//
//  Player.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/22/23.
//

import Foundation

enum PlayerType: Int, Comparable, CustomStringConvertible {
    case goalie = 1
    case captain = 2
    case assistantCaptain = 3
    case player = 4

    init(symbol: String) {
        switch symbol {
        case "G":
            self = .goalie
        case "C":
            self = .captain
        case "A":
            self = .assistantCaptain
        default:
            self = .player
        }
    }

    static func < (lhs: PlayerType, rhs: PlayerType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var description: String {
        switch self {
        case .goalie:
            return "(G)"
        case .captain:
            return "(C)"
        case .assistantCaptain:
            return "(A)"
        default:
            return ""
        }
    }
}

struct Player: Identifiable, Comparable, Hashable, CustomStringConvertible {
    static let unknownName = "Unknown"

    let id: String
    let number: Int
    let names: [String]
    var type: PlayerType = .player

    init?(for skater: Skater) {
        self.id = skater.id ?? UUID().uuidString
        self.number = skater.jersey != nil ? Int(skater.jersey!) ?? 0 : 0
        
        if let name = skater.name {
            self.names = name.split(separator: " ").map { String($0) }
        } else {
            self.names = [Player.unknownName]
        }
    }

    var description: String {
        "\(number) \(nameString) \(type.description)"
    }

    static func < (lhs: Player, rhs: Player) -> Bool {
        guard lhs.type == rhs.type else {
            return lhs.type < rhs.type
        }

        return lhs.number < rhs.number
    }
}

extension Player {
    var firstName: String {
        names.first?.localizedCapitalized ?? Player.unknownName
    }

    var lastInitial: String {
        guard let lastInitial = names.last?.first else { return "" }
        return "\(lastInitial)."
    }

    var lastName: String {
        names.last?.localizedCapitalized ?? Player.unknownName
    }

    var nameString: String {
        return "\(firstName) \(lastInitial)"
    }

    var fullName: String {
        names.joined(separator: " ").localizedCapitalized
    }
}
