//
//  Defines.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/29/23.
//

import Foundation

struct TeamRecord {
    var totalGames: Int = 0
    var wins: Int = 0
    var ties: Int = 0
    var losses: Int = 0
    var overtimeLosses: Int = 0

    mutating func update(for game: Game) {
        guard game.type != .preseason else { return }
        totalGames += 1

        switch game.result {
        case .win:
            wins += 1
        case .tie:
            ties += 1
        case .loss:
            losses += 1
        case .overtimeLoss:
            overtimeLosses += 1
        case .upcoming:
            break
        }
    }

    var description: String {
        "\(wins)-\(ties)-\(losses)-\(overtimeLosses) in \(totalGames) games"
    }
}

struct Team: Equatable {
    static let piedSniper = "Pied Sniper"

    let name: String
    var score: String = "0"
    var record: TeamRecord?

    static func == (lhs: Team, rhs: Team) -> Bool {
        return true &&
        lhs.name == rhs.name &&
        lhs.score == rhs.score
    }
}
