//
//  ScheduleParser.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/26/23.
//

import Foundation

struct ScheduleParser {
    static let shared = ScheduleParser()

    /// Load the schedule for Pied Snipers.
    /// - Parameters:
    ///   - status: Inout object for keep track of the view status.
    ///   - record: Inout object to keep track of the team record.
    /// - Returns: Returns a tuple containing today's game, if one exists, upcoming games, and completed games.
    func loadSchedule(status: inout ScheduleStatus, record: inout TeamRecord) async -> (today: Game?, upcoming: [Game], completed: [Game]) {
        var result: (today: Game?, upcoming: [Game], completed: [Game]) = (nil, [], [])

        let scrapedData = await scrapeSchedule(preview: status.preview)
        guard let data = sanitize(gamesData: scrapedData) else {
            status.gamesLoaded = 0
            status.lastSyncDate = Date()
            status.completed = true
            return result
        }

        let games = parse(gamesData: data)
        games.forEach { game in
            if game.date.isToday {
                result.today = game
            } else if game.result == .upcoming {
                result.upcoming.append(game)
            } else {
                record.update(for: game)
                result.completed.insert(game, at: 0)
            }
        }        

        if status.preview {
            result.today = Game.previewToday
        }

        if result.today != nil {
            let lockerRoom = await fetchLockerRoom(for: result.today, preview: status.preview)
            result.today?.lockerRoom = lockerRoom
        }

        status.gamesLoaded = games.count
        status.lastSyncDate = Date()
        status.completed = true
        return result
    }

    /// Scrape schedule data from specified source.
    /// - Parameter preview: Indicate if preview data should be used instead of loading live results.
    /// - Returns: Return the scraped schedule data.
    private func scrapeSchedule(preview: Bool) async -> String? {
        if preview {
            let scrapedData = Bundle.main.load(file: "testSchedule")
            return scrapedData
        }

        let piedSniperURL = URL(string: "https://stats.sharksice.timetoscore.com/display-schedule?team=4638")
        let scrapedData = await piedSniperURL?.scrape()
        return scrapedData
    }
}

// MARK: - Game Parser

extension ScheduleParser {
    /// Process the passed schedule data by stripping out the HTML table tags and trimming whitespace.
    /// - Parameter gamesData: Game schedule data to process.
    /// - Returns: Returns a separated set of strings from the specific URL if successful.
    private func sanitize(gamesData: String?) -> [String]? {
        guard let decodedData = gamesData,
              let trimRangeStart = decodedData.range(of: "</th></tr>"),
              let trimRangeEnd = decodedData.range(of: "</table>")
        else {
            return nil
        }

        var sanitizedData = String(decodedData[trimRangeStart.upperBound..<trimRangeEnd.lowerBound])
        sanitizedData = sanitizedData
            .replacingOccurrences(of: "&nbsp;", with: "")
            .replacingOccurrences(of: "Double Secret Probation", with: "DSP")

        var separatedData = sanitizedData.components(separatedBy: "</tr>")
        separatedData = separatedData.map { data in
            data.replacingOccurrences(of: "<[^>]+>", with: "/", options: .regularExpression)
                .replacingOccurrences(of: "/+", with: "&", options: .regularExpression)
                .trimmingCharacters(in: .whitespaces)
        }

        return separatedData
    }

    /// Extract game information from the sanitized data.
    /// - Parameter gamesData: Sanitized data processed from the schedule page.
    /// - Returns: Return a list of scheduled games.
    private func parse(gamesData: [String]) -> [Game] {
        var games = [Game]()

        for gameData in gamesData {
            let sanitizedGameData = gameData.components(separatedBy: "&").map { $0.trimmingCharacters(in: .whitespaces) }

            // There are 11 fields that are used from the schedule page
            guard sanitizedGameData.count >= 11 else { continue }

            let gameID = Int(sanitizedGameData[1].replacingOccurrences(of: "*", with: "")) ?? -1

            let year = Calendar.current.component(.year, from: Date())
            let dateString = "\(sanitizedGameData[2]) \(year) \(sanitizedGameData[3])"

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E MMM d yyyy h:m a"
            dateFormatter.timeZone = .current
            guard let date = dateFormatter.date(from: dateString) else { continue }

            let completed = date.compare(Date()) == .orderedAscending && sanitizedGameData.count > 11

            var rink = sanitizedGameData[4]
            if let upperBound = rink.range(of: "San Jose ")?.upperBound {
                rink = String(rink[upperBound...])
            }

            var category: Game.Category?
            let gameTypeIndex = completed ? 11 : 9
            switch sanitizedGameData[gameTypeIndex] {
            case "Preseason":
                category = .preseason
            case let typeString where typeString.isRegularSeason:
                category = .regularSeason
            case "Playoff":
                category = .playoffs
            default:
                category = nil
            }

            var awayTeam = Team(name: sanitizedGameData[7])
            var homeTeam = Team(name: completed ? sanitizedGameData[9] : sanitizedGameData[8])

            var awayScore = 0
            var homeScore = 0
            var wentToOT = false

            var result: Game.Result = .upcoming

            // If the game is completed, parse the home and away team results
            if completed {
                var awayScoreString = sanitizedGameData[8]
                // Overtime losses have "S" appended to the end, look for it and remove it
                if awayScoreString.last == "S" {
                    wentToOT = true
                    awayScoreString = String(awayScoreString.dropLast(2))
                }
                awayScore = Int(awayScoreString) ?? -1

                var homeScoreString = sanitizedGameData[10]
                if homeScoreString.last == "S" {
                    wentToOT = true
                    homeScoreString = String(homeScoreString.dropLast(2))
                }
                homeScore = Int(homeScoreString) ?? -1

                awayTeam.result = TeamResult(id: gameID, goals: TeamResult.Goals(final: awayScore))
                homeTeam.result = TeamResult(id: gameID, goals: TeamResult.Goals(final: homeScore))

                if awayScore == homeScore {
                    result = .tie
                } else if homeTeam.isPiedSniper {
                    result = homeScore > awayScore ? .win(overtime: wentToOT) : .loss(overtime: wentToOT)
                } else {
                    result = awayScore > homeScore ? .win(overtime: wentToOT) : .loss(overtime: wentToOT)
                }
            }

            let game = Game(
                id: gameID,
                date: date,
                category: category,
                rink: rink,
                away: awayTeam,
                home: homeTeam,
                result: result
            )

            games.append(game)
        }

        return games
    }

    /// Attempt to fetch the Pied Sniper locker room for the specified game.
    /// - Parameters:
    ///   - game: Provide a game to try to find the designated locker rooms. The game must be today or this fetch will fail.
    ///   - preview: Indicate if preview data should be used instead of loading live results.
    /// - Returns: Returns the Pied Sniper locker room.
    private func fetchLockerRoom(for game: Game?, preview: Bool) async -> String? {
        if preview {
            let scrapedData = Bundle.main.load(file: "testLockerRooms")
            return scrapedData
        }

        let todaysGamesURL = URL(string: "https://stats.sharksice.timetoscore.com/display-lr-assignments")
        let scrapedData = await todaysGamesURL?.scrape()
        guard let data = sanitize(gamesData: scrapedData), let game = game else { return nil }

        // This could probably be more efficient by just filtering for the row with the matching ID at the top, instead of iterating each game.
        // However, given the data set is minimal (< 10 games) that's likely a premature optimization.
        for gameData in data {
            let sanitizedGameData = gameData.components(separatedBy: "&").map { $0.trimmingCharacters(in: .whitespaces) }

            // There are 9 fields that are used from the upcoming games page
            guard sanitizedGameData.count >= 9 else { continue }

            let id = Int(sanitizedGameData[1].replacingOccurrences(of: "*", with: "")) ?? -1
            if game.id == id {
                let lockerRoom = game.isHome ? sanitizedGameData[7] : sanitizedGameData[9]
                return lockerRoom
            }
        }

        return nil
    }
}

// MARK: - String Extension

extension String {
    var isRegularSeason: Bool {
        (try? Regex("Regular [0-9]+").firstMatch(in: self)) != nil
    }
}
