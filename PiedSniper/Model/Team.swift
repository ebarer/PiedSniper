//
//  Defines.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/29/23.
//

import Foundation

struct TeamRecord {
    var wins: Int = 0
    var losses: Int = 0
    var overtime: Int = 0

    var rank: Int = 0

    var gamesPlayed: Int {
        wins + losses + overtime
    }

    var points: Int {
        return (2 * wins) + overtime
    }

    mutating func update(for game: Game) {
        // Don't include preseason games in record and standings
        guard game.type != .preseason else {
            return
        }

        switch game.result {
        case .win:
            wins += 1
        case .loss:
            losses += 1
        case .tie:
            fallthrough
        case .overtime:
            overtime += 1
        case .upcoming:
            break
        }
    }

    var summary: String {
        "\(wins)-\(losses)-\(overtime)"
    }

    var description: String {
        "\(summary), \(points) points in \(gamesPlayed) games"
    }
}

struct Team: Identifiable, Equatable {
    static let piedSniper = "Pied Sniper"

    let id: Int = Int.random(in: 1..<500)
    let name: String
    var score: String = "0"
    var record: TeamRecord?

    static func == (lhs: Team, rhs: Team) -> Bool {
        return true &&
        lhs.name == rhs.name &&
        lhs.score == rhs.score
    }
}

// MARK: - Teams

extension Team {
    static let piedSniperTeam = Team(
        name: "Pied Sniper",
        record: TeamRecord(wins: 4, losses: 6, overtime: 2, rank: 4)
    )

    static let doubleSecretProbation = Team(
        name: "Double Secret Probation",
        record: TeamRecord(wins: 8, losses: 3, overtime: 1, rank: 1)
    )
}
