//
//  PenaltyEvent.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import Foundation

struct PenaltyEvent: GameEvent, Comparable {
    var id: Int { time.timeInSeconds + team.id }
    var type: GameEventType = .penalties

    var time: GameTime
    var team: Team
    var number: Int?
    var infraction: String
    var minutes: Int

    init?(with content: [String], team: Team) {
        // ["Per", "#", "Infraction", "Min", "Off Ice", "Start", "End", "On Ice"]
        // [ 0 ,  1  ,       2     ,  3 ,    4  ,    5  ,   6   ,    7    ]
        // ["2", "18", "Body Check", "2", "7:57", "7:57", "5:57", "5:01 W"]
        guard content.count >= 5 else { return nil }

        self.team = team

        let period = Int(content[0]) ?? 0
        self.time = GameTime(period: period, time: content[5])

        self.number = Int(content[1])
        self.minutes = Int(content[3]) ?? 0
        self.infraction = content[2]
    }

    var description: String {
        let playerName = team.player(number: number)?.nameString ?? Player.unknownName
        return "\(playerName), \(minutes) minutes for \(infraction)"
    }

    var eventDescription: String {
        "\(time.string) [\(team.name)] — \(description)"
    }

    static func < (lhs: PenaltyEvent, rhs: PenaltyEvent) -> Bool {
        lhs.time < rhs.time
    }
}

extension PenaltyEvent {
    var delinquentString: String {
        guard let number = number, let player = team.player(number: number) else {
            return Player.unknownName
        }

        return "\(player.nameString) (\(number))"
    }
}
