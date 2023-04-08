//
//  Game.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/30/23.
//

import Foundation

struct Game: Identifiable, CustomStringConvertible {
    enum Category: String {
        case preseason = "Preseason"
        case regularSeason = "Regular Season"
        case playoffs = "Playoffs"
    }

    enum Result: Equatable {
        case upcoming
        case win(overtime: Bool = false)
        case tie
        case loss(overtime: Bool = false)
    }

    let id: Int
    let date: Date
    var category: Category? = .regularSeason
    let rink: String
    var lockerRoom: String?

    var away: Team
    var home: Team

    var events: [GameEventType: [any GameEvent]]? = nil

    var result: Game.Result {
        let gameCompleted = date.compare(Date()) == .orderedAscending
        guard gameCompleted else {
            return .upcoming
        }

        // If the game is complete and there's no winner, it's a tie
        guard let winner = winner else {
            return .tie
        }

        return winner.isPiedSniper ? .win(overtime: wentToOT) : .loss(overtime: wentToOT)
    }

    var wentToOT: Bool {
        if let homeOTL = home.result?.otl, homeOTL {
            return true
        }

        if let awayOTL = away.result?.otl, awayOTL {
            return true
        }

        return false
    }

    var description: String {
        return "\(id) : \(category?.rawValue ?? "")(\(date.dateString)) = \(result) -> \(home.name) \(home.result?.goals.final ?? 0) - \(away.name) \(away.result?.goals.final ?? 0)"
    }
}

// MARK: - Team Identifiers

extension Game {
    // Collection of both team results in the match
    var teams: [Team] {
        [away, home]
    }

    /// The opposition team (not Pied Sniper)
    var opponent: Team {
        home.isPiedSniper ? home : away
    }

    /// The team that won the game.
    var winner: Team? {
        // If the score is the same, there's no winner
        guard let homeScore = home.result?.goals.final,
              let awayScore = away.result?.goals.final,
              homeScore != awayScore
        else { return nil }
        return homeScore > awayScore ? home : away
    }

    /// The team that lost the game.
    var loser: Team? {
        // If the score is the same, there's no loser
        guard let homeScore = home.result?.goals.final,
              let awayScore = away.result?.goals.final,
              homeScore != awayScore
        else { return nil }
        return homeScore < awayScore ? home : away
    }

    /// Indicates if Pied Sniper was the home team.
    var isHome: Bool {
        home.isPiedSniper
    }
}


// MARK: - Game Helpers for Previews

extension Game {
    static let previewToday = Game(
        id: 380624,
        date: Calendar.current.date(byAdding: .minute, value: 10, to: Date()) ?? Date(),
        rink: "Black (E)",
        lockerRoom: "B2",
        away: Team.doubleSecretProbation(),
        home: Team.piedSniper()
    )

    static let previewUpcoming = Game(
        id: 12456,
        date: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
        rink: "Black (E)",
        away: Team.piedSniper(),
        home: Team.doubleSecretProbation()
    )

    static let previewCompletedWin = Game(
        id: 12456,
        date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
        rink: "Black (E)",
        away: Team.doubleSecretProbation(result: TeamResult(goals: TeamResult.Goals(final: 1))),
        home: Team.piedSniper(result: TeamResult(goals: TeamResult.Goals(final: 10)))
    )

    static let previewCompletedLoss = Game(
        id: 12456,
        date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
        rink: "Black (E)",
        away: Team.doubleSecretProbation(result: TeamResult(goals: TeamResult.Goals(final: 3))),
        home: Team.piedSniper(result: TeamResult(goals: TeamResult.Goals(final: 2)))
    )
}
