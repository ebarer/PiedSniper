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

    var gameScore: (away: Int, home: Int)

    init?(with content: [String], team: Team, gameScore: (away: Int, home: Int) = (0, 0)) {
        // ["Per", "Time", "", "Goal", "Ass.", "Ass."]
        // ["1", "7:11", "", "24", "", ""]
        guard content.count >= 4 else { return nil }

        self.team = team

        let period = Int(content[0]) ?? 0
        time = GameTime(period: period, time: content[1])

        goalType = GoalType(rawValue: content[2]) ?? .normal

        number = Int(content[3])

        assists = [Int]()
        if let assist = Int(content[4]) {
            assists?.append(assist)
        }
        if let assist = Int(content[5]) {
            assists?.append(assist)
        }

        self.gameScore = gameScore
    }

    var description: String {
        let playerName = team.player(number: number)?.nameString ?? Player.unknownName
        var output = "\(playerName)"
        if let assists = assists?.compactMap({ $0 }), !assists.isEmpty {
            let assistNames = assists.map({ team.player(number: $0)?.nameString ?? Player.unknownName }).joined(separator: ", ")
            output.append(" from \(assistNames)")
        }
        return output

    }

    var eventDescription: String {
        "\(time.string) [\(team.name)] — \(description)"
    }

    static func == (lhs: ScoringEvent, rhs: ScoringEvent) -> Bool {
        lhs.id == rhs.id &&
        lhs.goalType == rhs.goalType &&
        lhs.time == rhs.time &&
        lhs.team == rhs.team &&
        lhs.number == rhs.number &&
        lhs.assists == rhs.assists
    }

    static func < (lhs: ScoringEvent, rhs: ScoringEvent) -> Bool {
        lhs.time < rhs.time
    }
}

extension ScoringEvent {
    var scorerString: String {
        guard let number = number, let player = team.player(number: number) else {
            return Player.unknownName
        }

        return "\(player.nameString) (\(number))"
    }

    var assistsString: String? {
        guard let assists = assists else { return nil }
        let assistsString: [String] = assists.compactMap { number in
            guard let player = team.player(number: number) else { return nil }
            return "\(player.nameString) (\(number))"
        }

        guard !assistsString.isEmpty else { return nil }
        return assistsString.joined(separator: ", ")
    }

    func gameScoreString(with game: Game) -> AttributedString {
        let awayScore = "\(game.away.abbreviation) \(gameScore.away)"
        let homeScore = "\(game.home.abbreviation) \(gameScore.home)"
        let gameScoreString = "\(awayScore) - \(homeScore)"

        var string = AttributedString(stringLiteral: gameScoreString)
        string.font = .caption

        let scoreToBold = (team == game.home) ? homeScore : awayScore
        if let range = string.range(of: scoreToBold) {
            string[range].font = .caption.weight(.heavy)
        }

        return string
    }
}
