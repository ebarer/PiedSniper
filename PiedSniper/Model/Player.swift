//
//  Player.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/22/23.
//

import Foundation

enum PlayerType: String {
    case player = ""
    case goalie = "G"
    case captain = "C"
    case assistantCaptain = "A"
    case spare = "S"
}

struct Player: Identifiable, CustomStringConvertible {
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
            self.type = PlayerType(rawValue: content[1]) ?? .player
            nameIndex = 2
        }

        self.names = content[nameIndex].split(separator: " ").map { String($0) }
    }

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

    var typeString: String {
        type != .player ? " (\(type.rawValue))" : ""
    }

    var description: String {
        "\(number) \(nameString) \(typeString)"
    }
}
