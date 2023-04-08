//
//  ScoringEvent.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import Foundation

struct ScoringEvent: GameEvent, Comparable {
    enum GoalType: String {
        case normal = ""
        case shorthanded = "SH"
        case powerplay = "PP"
        case emptyNet = "ENG"
    }

    var id: Int { time.timeInSeconds + team.id }
    var type: GameEventType = .scoring
    var goalType: GoalType

    var time: GameTime
    var team: Team
    var number: Int?
    var assists: [Int]?

    init?(with content: [String], team: Team) {
        // ["Per", "Time", "", "Goal", "Ass.", "Ass."]
        // ["1", "7:11", "", "24", "", ""]
        guard content.count >= 4 else { return nil }

        self.team = team

        let period = Int(content[0]) ?? 0
        self.time = GameTime(period: period, time: content[1])

        self.goalType = GoalType(rawValue: content[2]) ?? .normal

        self.number = Int(content[3])

        var assists = [Int]()
        if let assist = Int(content[4]) {
            assists.append(assist)
        }
        if let assist = Int(content[5]) {
            assists.append(assist)
        }

        self.assists = assists
    }

    var description: String {
        let playerName = team.player(number: number)?.nameString ?? Player.unknownName
        var output = "\(playerName)"
        if let assists = assists?.compactMap({ String($0) }), !assists.isEmpty {
            let assistNames = assists.map({ team.player(number: Int($0) ?? 0)?.nameString ?? Player.unknownName }).joined(separator: ", ")
            output.append(" from \(assistNames)")
        }
        return output

    }

    var eventDescription: String {
        "\(time.string) [\(team.name)] — \(description)"
    }

    static func < (lhs: ScoringEvent, rhs: ScoringEvent) -> Bool {
        lhs.time < rhs.time
    }
}
