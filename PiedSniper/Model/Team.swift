//
//  Defines.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/29/23.
//

import Foundation

struct Team: Identifiable, Equatable {
    let id: Int = Int.random(in: 1..<500)
    let name: String
    var record: TeamRecord?
    var result: TeamResult?
    var players = [Int : Player]()

    static func == (lhs: Team, rhs: Team) -> Bool {
        let sameName = lhs.name == rhs.name
        let sameRecord = lhs.record == rhs.record
        let sameResult = lhs.result?.id == rhs.result?.id
        return sameName && sameRecord && sameResult
    }
}

// MARK: - Name Helpers

extension Team {
    static let piedSniperName = "Pied Sniper"

    var isPiedSniper: Bool {
        name == Team.piedSniperName
    }

    var abbreviation: String {
        String(name.uppercased().prefix(3))
    }
}

// MARK: - Roster Helpers

extension Team {
    func player(number: Int?) -> Player? {
        guard let number = number else { return nil }
        return players[number]
    }

    var roster: [Player] {
        var roster = Array(players.values) as [Player]
        roster.sort(by: <)
        return roster
    }
}

struct TeamResult: Identifiable, Equatable {
    struct Goals: Equatable {
        var first: Int = 0
        var second: Int = 0
        var third: Int = 0
        var overtime: String? = nil
        var shootout: String? = nil
        var final: Int = 0

        func shootoutDescription(winner: Bool) -> AttributedString? {
            guard let shootout = shootout else {
                return AttributedString(stringLiteral: winner ? "1" : "0")
            }

            let shootoutStr = "(\(shootout))"
            var attrStr = AttributedString(stringLiteral: "\(winner ? 1 : 0) \(shootoutStr)")

            if let range = attrStr.range(of: shootoutStr) {
                attrStr[range].foregroundColor = .secondary
                attrStr[range].font = .caption2
            }

            return attrStr
        }
    }

    struct Shots: Equatable {
        var first: Int = 0
        var second: Int = 0
        var third: Int = 0
        var total: Int = 0

        var all: [Int] {
            return [first, second, third, total]
        }
    }

    var id: Int = 0
    var goals = Goals()
    var shots = Shots()
}

struct TeamRecord: Equatable {
    var wins: Int = 0
    var losses: Int = 0
    var ties: Int = 0

    var rank: Int = 0

    var gamesPlayed: Int {
        wins + losses + ties
    }

    var points: Int {
        return (2 * wins) + ties
    }

    mutating func update(for game: Game) {
        // Don't include preseason and playoff games in record and standings
        guard game.category != .preseason,
              game.category != .playoffs
        else {
            return
        }

        switch game.result {
        case .win(_):
            wins += 1
        case .loss(overtime: let overtime):
            overtime ? (ties += 1) : (losses += 1)
        case .tie:
            ties += 1
        case .upcoming:
            break
        }
    }

    var summary: String {
        "\(wins)-\(losses)-\(ties)"
    }

    var description: String {
        "\(summary), \(points) points in \(gamesPlayed) games"
    }
}

// MARK: - Team Helpers for Previews

extension Team {
    static func piedSniper(result: TeamResult? = nil) -> Team {
        return Team(
            name: Team.piedSniperName,
            record: TeamRecord(wins: 4, losses: 6, ties: 2, rank: 4),
            result: result
        )
    }

    static func doubleSecretProbation(result: TeamResult? = nil) -> Team {
        return Team(
            name: "Double Secret Probation",
            record: TeamRecord(wins: 8, losses: 3, ties: 1, rank: 1),
            result: result
        )
    }
}
