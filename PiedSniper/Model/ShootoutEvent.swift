//
//  ShootoutEvent.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import Foundation

struct ShootoutEvent: Identifiable, GameEvent, Comparable {
    var id: Int { round + team.id }
    var type: GameEventType = .shootout

    var team: Team
    var round: Int
    var number: Int?
    var scored: Bool

    init?(with content: [String], team: Team) {
        // ["#", "Player", "Result"]
        // ["1", "41", "Goal"]
        // ["4", "2", "Shot"]
        guard content.count == 3 else { return nil }
        self.team = team
        number = Int(content[1])
        round = Int(content[0]) ?? 0
        scored = (content[2] == "Goal")
    }

    var description: String {
        let playerName = team.player(number: number)?.nameString ?? Player.unknownName
        return "\(playerName), \(scored ? "Scored" : "Missed")"
    }

    static func == (lhs: ShootoutEvent, rhs: ShootoutEvent) -> Bool {
        lhs.id == rhs.id &&
        lhs.team == rhs.team &&
        lhs.round == rhs.round &&
        lhs.number == rhs.number &&
        lhs.scored == rhs.scored
    }

    static func < (lhs: ShootoutEvent, rhs: ShootoutEvent) -> Bool {
        return lhs.round < rhs.round
    }
}

extension ShootoutEvent {
    var shooter: String {
        guard let player = team.player(number: number) else {
            return Player.unknownName
        }
        return player.nameString
    }

    var result: String {
        return scored ? "Goal" : "Save"
    }
}
