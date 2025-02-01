//
//  ScoringEvent.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import Foundation

struct GameScore {
    var home: Int
    var away: Int

    static func += (lhs: inout GameScore, rhs: GameScore) {
        lhs.home += rhs.home
        lhs.away += rhs.away
    }
}

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

    var gameScore = GameScore(home: 0, away: 0)

    init(goalType: GoalType, time: GameTime, team: Team, number: Int?, assists: [Int]?) {
        self.goalType = goalType
        self.time = time
        self.team = team
        self.number = number
        self.assists = assists
    }

    init?(from event: LiveEvent, team: Team, gameScore: GameScore) {
        guard let goalTypeName = event.goalTypeName,
              let eventTime = event.time,
              let number = event.goalPlayerJersey
        else {
            return nil
        }

        self.goalType = ScoringEvent.GoalType(rawValue: goalTypeName) ?? .normal
        self.time = GameTime(period: event.period, time: eventTime)
        self.team = team
        self.number = Int(number)
        self.gameScore = gameScore

        // Determine if there are assists
        var assists = [Int]()
        if let firstAssistNumber = event.ass1PlayerJersey {
            assists.append(Int(firstAssistNumber)!)
        }
        if let secondAssistNumber = event.ass2PlayerJersey {
            assists.append(Int(secondAssistNumber)!)
        }
        self.assists = assists
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
        guard let number = number else {
            return Player.unknownName
        }

        guard let player = team.player(number: number) else {
            return "\(Player.unknownName) (\(number))"
        }

        return "\(player.nameString) (\(number))"
    }

    var assistsString: String? {
        guard let assists = assists else { return nil }

        let fallbackString = assists.map { "\(Player.unknownName) (\($0))" } .joined(separator: ", ")

        let assistsString: [String] = assists.compactMap { number in
            guard let player = team.player(number: number) else { return nil }
            return "\(player.nameString) (\(number))"
        }

        guard !assistsString.isEmpty else {
            return fallbackString
        }

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
