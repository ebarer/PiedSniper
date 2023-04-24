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
    case spare = 5

    init(symbol: String) {
        switch symbol {
        case "G":
            self = .goalie
        case "C":
            self = .captain
        case "A":
            self = .assistantCaptain
        case "S":
            self = .spare
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

struct Player: Identifiable, Comparable, CustomStringConvertible {
    static let unknownName = "Unknown"

    var id: String { "\(number)-\(fullName)" }

    let number: Int
    let names: [String]
    var type: PlayerType = .player

    init?(for content: [String]) {
        guard content.count >= 2 else { return nil }
//        ["1", "G", "Elliot Barer"]
//        ["15", "C", "JEFF MOCK"]
//        ["18", "Matthew B Lagarto"]

        self.number = Int(content[0]) ?? 0

        var nameIndex = 1
        if content.count == 3 {
            self.type = PlayerType(symbol: content[1])
            nameIndex = 2
        }

        self.names = content[nameIndex].split(separator: " ").map { String($0) }
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
