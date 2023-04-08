//
//  ScoresheetParser.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/15/23.
//

import Foundation
import os
import RegexBuilder

struct ScoresheetParser {
    static let shared = ScoresheetParser()
    static let cache: NSCache<NSString, CacheEntryObject<String>> = NSCache()

    /// Load the scoresheet for the provided game.
    /// - Parameters:
    ///   - game: The game for the requested scoresheet.
    ///   - preview: Indicate if preview data should be used instead of loading live results.
    ///   - forceExpire: Force the cache to be invalidated, ignored if fetching preview data.
    /// - Returns: Returns the Game updated with the results of the scoresheet.
    func loadScoresheet(for game: Game?, preview: Bool = false, forceExpire: Bool = false) async -> Game? {
        guard var game = game else {
            return game
        }

        let scrapedData = await scrapeScoresheet(for: game, preview: preview, forceExpire: forceExpire)
        guard let scoresheetData = sanitize(scoresheetData: scrapedData) else {
            return game
        }

        game = parse(scoresheetData: scoresheetData, for: game)
        return game
    }

    /// Grab the contents of the scoresheet webpage.
    /// - Parameters:
    ///   - game: The game used to build the URL query.
    ///   - preview: Indicate if preview data should be used instead of loading live results.
    ///   - forceExpire: Force the cache to be invalidated, ignored if fetching preview data.
    /// - Returns: Returns the scraped contents of the webpage as a string.
    private func scrapeScoresheet(for game: Game, preview: Bool, forceExpire: Bool) async -> String? {
        if preview {
            let scrapedData = Bundle.main.load(file: "testScoresheet")
            return scrapedData
        }

        let base = "https://stats.sharksice.timetoscore.com/oss-scoresheet"
        guard var urlComps = URLComponents(string: base) else {
            return nil
        }

        let gameIDQuery = URLQueryItem(name: "game_id", value: "\(game.id)")
        urlComps.queryItems = [gameIDQuery]

        guard let scoreSheetURL = urlComps.url else {
            return nil
        }

        return await scoreSheetURL.scrape(cache: ScoresheetParser.cache, forceExpire: forceExpire)
    }
}

extension ScoresheetParser {
    /// Process the passed scoresheet data by stripping out the HTML table tags and trimming whitespace.
    /// - Parameter scoresheetData: Scoresheet data to process.
    /// - Returns: Returns a separated set of strings from the scoresheet if successful.
    private func sanitize(scoresheetData: String?) -> [String]? {
        guard let decodedData = scoresheetData,
              let trimRangeStart = decodedData.range(of: "<table"),
              let trimRangeEnd = decodedData.range(of: "</div>", options: .backwards)
        else {
            return nil
        }

        var sanitizedData = String(decodedData[trimRangeStart.lowerBound..<trimRangeEnd.lowerBound])
        sanitizedData = sanitizedData
            .replacingOccurrences(of: "&nbsp;", with: " ")

        var separatedData = sanitizedData.components(separatedBy: "</tr>")
        separatedData = separatedData.map { data in
            data.replacingOccurrences(of: "<td bgcolor=\"#ffBBBb\">", with: "*")
                .replacingOccurrences(of: "<[^>]+>", with: "/", options: .regularExpression)
                .replacingOccurrences(of: "/+", with: "&", options: .regularExpression)
                .trimmingCharacters(in: .whitespaces)
        }

        return separatedData
    }

    /// Extract scoresheet information from the sanitized data.
    /// - Parameter scoresheetData: Sanitized data processed from the scoresheet.
    /// - Returns: Return the game updated with all the information from the scoresheet.
    private func parse(scoresheetData: [String], for game: Game) -> Game {
        var game = game

        var homeResult = game.home.result ?? TeamResult()
        var awayResult = game.away.result ?? TeamResult()
        var gameEvents = [any GameEvent]()

        // Keep track of which part of the scoresheet is being processed
        var scoresheetSection: ScoresheetSection = .undefined

        for data in scoresheetData {
            let sanitizedData = Array(data.components(separatedBy: "&").map { $0.trimmingCharacters(in: .whitespaces) }.dropFirst().dropLast())
            guard !sanitizedData.isEmpty, let header = sanitizedData.first else { continue }

            switch header {

                // Process the goals for both teams
            case "Visitor":
                awayResult.goals = goals(in: sanitizedData, category: game.category)
            case "Home":
                homeResult.goals = goals(in: sanitizedData, category: game.category)

                // Process the saves for both teams
            case let v where v.visitorSavesHeader:
                homeResult.shots = shots(in: sanitizedData, goalsScored: homeResult.goals)
            case let v where v.homeSavesHeader:
                awayResult.shots = shots(in: sanitizedData, goalsScored: awayResult.goals)

                // Add the players for each team
            case let v where v.rosterHeader:
                scoresheetSection.update(for: header)

                // If the row header matches a game event type, update the section being processed
                // Identifying which section is being processed ensures events are properly parsed
            case let v where GameEventType.values.contains(v):
                scoresheetSection.update(for: header)

                // If the row header is a number (period), it's a game event
            case let v where v.isNumber:
                switch scoresheetSection {
                case .visitorRoster:
                    for player in players(in: sanitizedData) {
                        game.away.players[player.number] = player
                    }
                case .homeRoster:
                    for player in players(in: sanitizedData) {
                        game.home.players[player.number] = player
                    }
                default:
                    let eventType = scoresheetSection.eventType
                    let team = scoresheetSection.team(for: game)
                    if let event = event(type: eventType, in: sanitizedData, team: team, game: &game) {
                        gameEvents.append(event)
                    }
                }
            default:
                break
            }
        }

        game.home.result = homeResult
        game.away.result = awayResult
        game.events = Dictionary(grouping: gameEvents, by: \.type)

        return game
    }
}

// MARK: - Scoresheet Data

extension ScoresheetParser {
    /// Extract the players from the roster table.
    /// - Parameter content: A row in the roster table, broken into an array of strings.
    /// - Returns: The players extracted from the roster table row.
    func players(in content: [String]) -> [Player] {
        var players = [Player]()

        var numberIndices = content.enumerated().compactMap { $1.isNumber ? $0 : nil }
        let startIndex = numberIndices.removeFirst()
        let midIndex = !numberIndices.isEmpty ? numberIndices.removeFirst() : nil
        let endIndex = content.count

        if let midIndex = midIndex {
            if let playerOne = Player(for: Array(content[startIndex..<midIndex])) {
                players.append(playerOne)
            }
            
            if let playerTwo = Player(for: Array(content[midIndex..<endIndex])) {
                players.append(playerTwo)
            }
        } else {
            if let player = Player(for: Array(content[startIndex..<endIndex-1])) {
                players.append(player)
            }
        }

        return players
    }

    /// Extract the goals from the scoresheet.
    /// - Parameter content: The goals table rows in the scoresheet.
    /// - Returns: Returns the numebr of goals scored by the team in each period.

    /// - Parameters:
    ///   - content: The goals table rows in the scoresheet.
    ///   - category: What phase of the season/category the game falls into
    /// - Returns: Returns the numebr of goals scored by the team in each period.
    func goals(in content: [String], category: Game.Category?) -> TeamResult.Goals {
        guard content.count >= 8 else { return TeamResult.Goals() }
        let first = Int(content[2]) ?? 0
        let second = Int(content[3]) ?? 0
        let third = Int(content[4]) ?? 0

        var overtimeIndex: Int?
        var shootoutIndex: Int = 5
        var finalIndex: Int = 6

        if let category = category, category == .playoffs {
            overtimeIndex = 5
            shootoutIndex = 6
            finalIndex = 7
        }

        var overtime: String?
        if let overtimeIndex = overtimeIndex {
            overtime = !content[overtimeIndex].isEmpty ? content[overtimeIndex] : nil
        }

        let shootout = !content[shootoutIndex].isEmpty ? content[shootoutIndex] : nil
        let final = Int(content[finalIndex]) ?? 0

        let results = TeamResult.Goals(
            first: first,
            second: second,
            third: third,
            overtime: overtime,
            shootout: shootout,
            final: final
        )

        return results
    }

    /// Extract the saves from the scoresheet and combine with the goals scored to calculate the number of shots taken.
    /// - Parameters:
    ///   - content: The saves table from the scoresheet.
    ///   - goalsScored: The goals scored by the team.
    /// - Returns: Returns the number of shots taken by the team in each period.
    func shots(in content: [String], goalsScored: TeamResult.Goals) -> TeamResult.Shots {
        var saves = content.filter({ $0.contains("*") }).map { result in
            (Int(result.dropFirst()) ?? 1) - 1
        }

        let totalShots = (content.first?.saves ?? 0) + goalsScored.final

        // Account for the unlikely scenario that there were no shots in a period
        if saves.count == 1 {
            // If there were no goals in the 3rd, assume there were no shots,
            // Otherwise assume there were no shots in the first period.
            // TODO: Find the last cell with #BBBBBB
            if goalsScored.third == 0 {
                saves.append(totalShots - goalsScored.first - goalsScored.second)
            } else {
                saves.insert(0, at: 0)
            }
        }

        var shots = TeamResult.Shots()
        shots.total = (content.first?.saves ?? 0) + goalsScored.final
        shots.first = saves[0] + goalsScored.first
        shots.second = saves[1] + goalsScored.second - saves[0]
        shots.third = shots.total - shots.second - shots.first
        return shots
    }

    /// <#Description#>
    /// - Parameters:
    ///   - type: <#type description#>
    ///   - content: <#content description#>
    ///   - team: <#team description#>
    /// - Returns: <#description#>
    func event(type: GameEventType, in content: [String], team: Team, game: inout Game) -> (any GameEvent)? {
        switch type {
        case .scoring:
            return ScoringEvent(with: content, team: team)
        case .shootout:
            return ShootoutEvent(with: content, team: team, game: &game)
        case .penalties:
            return PenaltyEvent(with: content, team: team)
        default:
            break
        }

        return nil
    }
}

// MARK: - ScoresheetSection

enum ScoresheetSection: Int, Comparable {
    case undefined

    case date
    case location
    case referees

    case visitorGoals
    case homeGoals

    case homeSaves
    case visitorSaves

    case visitorRoster
    case homeRoster

    case visitorScoring
    case visitorShootout
    case visitorPenalties

    case homeScoring
    case homeShootout
    case homePenalties

    mutating func update(for str: String) {
        guard !str.rosterHeader else {
            self = (self >= .visitorRoster) ? .homeRoster : .visitorRoster
            return
        }

        let eventType = GameEventType(rawValue: str) ?? .undefined
        switch eventType {
        case .scoring:
            self = (self > .visitorScoring) ? .homeScoring : .visitorScoring
        case .shootout:
            self = (self > .visitorShootout) ? .homeShootout : .visitorShootout
        case .penalties:
            self = (self > .visitorPenalties) ? .homePenalties : .visitorPenalties
        default:
            break
        }
    }

    var eventType: GameEventType {
        switch self {
        case .visitorScoring, .homeScoring:
            return .scoring
        case .visitorShootout, .homeShootout:
            return .shootout
        case .visitorPenalties, .homePenalties:
            return .penalties
        default:
            return .undefined
        }
    }

    func team(for game: Game) -> Team {
        switch self {
        case .homeGoals, .homeSaves, .homeRoster, .homeScoring, .homeShootout, .homePenalties:
            return game.home
        default:
            return game.away
        }
    }

    static func < (lhs: ScoresheetSection, rhs: ScoresheetSection) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
