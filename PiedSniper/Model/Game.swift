//
//  Game.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/30/23.
//

import Foundation

struct Game {
    enum GameType {
        case undefined
        case preseason
        case regularSeason
    }

    enum GameResult {
        case upcoming
        case win
        case tie
        case loss
        case overtimeLoss
    }

    let id: Int
    let date: Date
    var type: GameType? = .undefined
    let rink: String
    var away: Team
    var home: Team
    var lockerRoom: String?

    var isHome: Bool {
        home.name == Team.piedSniper
    }

    var opponent: Team {
        home.name != Team.piedSniper ? home : away
    }

    var winner: Team? {
        guard
            let homeScore = Int(home.score.trimmingCharacters(in: .decimalDigits.inverted)),
            let awayScore = Int(away.score.trimmingCharacters(in: .decimalDigits.inverted))
        else {
            return nil
        }

        // If the score is the same, there's no winner
        guard homeScore != awayScore else { return nil }

        return homeScore > awayScore ? home : away
    }

    var result: GameResult {
        let gameCompleted = date.compare(Date()) == .orderedAscending
        guard gameCompleted else { return .upcoming }

        // If the game is complete and there's no winner, it's a tie
        guard let winner = winner else { return .tie }

        let result: GameResult = (winner.name == Team.piedSniper) ? .win : .loss

        if result == .loss {
            // TODO: If it's a loss, check if it was an OTL
        }

        return result
    }

    var debug: String {
        return "\(id) : \(type ?? .undefined)(\(date)) = \(result) -> \(home.name) \(home.score) - \(away.name) \(away.score)"
    }
}

// MARK: Helpers for Previews

extension Game {
    static let previewToday = Game(
        id: 365624,
        date: Calendar.current.date(byAdding: .minute, value: 10, to: Date()) ?? Date(),
        rink: "Black (E)",
        away: Team(name: "Double Secret Probation"),
        home: Team(name: Team.piedSniper),
        lockerRoom: "B2"
    )

    static let previewUpcoming = Game(
        id: 12456,
        date: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
        rink: "Black (E)",
        away: Team(name: "Double Secret Probation"),
        home: Team(name: Team.piedSniper)
    )

    static let previewCompletedWin = Game(
        id: 12456,
        date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
        rink: "Black (E)",
        away: Team(name: "Double Secret Probation", score: "1"),
        home: Team(name: Team.piedSniper, score: "10")
    )

    static let previewCompletedLoss = Game(
        id: 12456,
        date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
        rink: "Black (E)",
        away: Team(name: "Double Secret Probation", score: "3"),
        home: Team(name: Team.piedSniper, score: "2")
    )
}
