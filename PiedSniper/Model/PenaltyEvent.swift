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
    var duration: Int

    init(time: GameTime, team: Team, number: Int?, infraction: String, duration: Int) {
        self.time = time
        self.team = team
        self.number = number
        self.infraction = infraction
        self.duration = duration
    }

    init?(from event: LiveEvent, team: Team) {
        guard let eventTime = event.time,
              let number = event.penaltyPlayerJersey,
              let duration = event.duration
        else {
            return nil
        }

        self.time = GameTime(period: event.period, time: eventTime)
        self.team = team
        self.number = Int(number)
        self.infraction = event.penaltyName ?? "Unknown"
        self.duration = Int(duration) ?? 0
    }

    var description: String {
        let playerName = team.player(number: number)?.nameString ?? Player.unknownName
        return "\(playerName), \(duration) min for \(infraction)"
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
