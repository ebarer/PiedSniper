//
//  ShootoutEvent.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import Foundation

struct ShootoutEvent: GameEvent, Comparable {
    var id: Int { attempt.round + team.id }
    var type: GameEventType = .shootout

    var team: Team
    var attempt: (round: Int, home: Bool)
    var number: Int?
    var scored: Bool

    init?(with content: [String], team: Team, game: inout Game) {
        // ["#", "Player", "Result"]
        // ["1", "41", "Goal"]
        // ["4", "2", "Shot"]
        guard content.count == 3 else { return nil }

        self.team = team
        self.number = Int(content[1])

        let attempt = Int(content[0]) ?? 0
        self.attempt = (attempt, game.home == team)

        self.scored = (content[2] == "Goal")
    }

    var description: String {
        let playerName = team.player(number: number)?.nameString ?? Player.unknownName
        return "\(playerName), \(scored ? "Scored" : "Missed")"
    }

    static func == (lhs: ShootoutEvent, rhs: ShootoutEvent) -> Bool {
        lhs.id == rhs.id &&
        lhs.team == rhs.team &&
        lhs.attempt.round == rhs.attempt.round &&
        lhs.attempt.home == rhs.attempt.home &&
        lhs.number == rhs.number &&
        lhs.scored == rhs.scored
    }

    static func < (lhs: ShootoutEvent, rhs: ShootoutEvent) -> Bool {
        // Away team goes first, sort their attempts first for each round
        if lhs.attempt.round == rhs.attempt.round {
            return rhs.attempt.home
        }

        return lhs.attempt.round < rhs.attempt.round
    }
}
