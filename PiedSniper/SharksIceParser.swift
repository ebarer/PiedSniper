//
//  SharksIceParser.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/26/23.
//

import Foundation

struct SharksIceParser {
    // URLs
    let piedSniperURL = URL(string: "https://stats.sharksice.timetoscore.com/display-schedule?team=4638&season=56&league=1&stat_class=1")
    let todaysGamesURL = URL(string: "https://stats.sharksice.timetoscore.com/display-lr-assignments.php")

    // Singleton
    static let shared = SharksIceParser()

    /// Load the schedule for Pied Snipers.
    /// - Parameters:
    ///   - status: Inout object for keep track of the view status.
    ///   - record: Inout object to keep track of the team record.
    /// - Returns: Returns a tuple containing today's game, if one exists, upcoming games, and completed games.
    func loadSchedule(status: inout ScheduleStatus, record: inout TeamRecord) async -> (today: Game?, upcoming: [Game], completed: [Game]) {
        var result: (today: Game?, upcoming: [Game], completed: [Game]) = (nil, [], [])

        let scrapedData = status.preview ? load(file: "testSchedule") : await scrape(url: piedSniperURL)
        guard let data = sanitize(data: scrapedData) else { return result }

        let games = parseGames(in: data)
        status.gamesLoaded = games.count

        games.forEach { game in
            // print(game.debug)

            if game.date.isToday {
                result.today = game
            } else if game.result == .upcoming {
                result.upcoming.append(game)
            } else {
                record.update(for: game)
                result.completed.append(game)
            }
        }        

        if status.preview {
            result.today = Game.previewToday
        }

        if result.today != nil {
            let rooms = await fetchLockerRooms(for: result.today, preview: status.preview)
            result.today?.home.lockerRoom = rooms.home
            result.today?.away.lockerRoom = rooms.away
        }

        status.completed = true
        return result
    }

    /// Attempt to fetch the locker rooms for the specified game.
    /// - Parameters:
    ///   - game: Provide a game to try to find the designated locker rooms. The game must be today or this fetch will fail.
    ///   - preview: Indicate if preview data should be used instead of loading live results.
    /// - Returns: Returns a tuple containing the home and away dressing rooms.
    func fetchLockerRooms(for game: Game?, preview: Bool) async -> (home: String?, away: String?) {
        var rooms: (home: String?, away: String?) = (nil, nil)

        let scrapedData = preview ? load(file: "testLockerRooms") : await scrape(url: todaysGamesURL)
        guard let data = sanitize(data: scrapedData), let gameID = game?.id else { return rooms }

        // This could probably be more efficient by just filtering for the row with the matching ID at the top, instead of iterating each game.
        // However, given the data set is minimal (< 10 games) that's likely a premature optimization.
        for gameData in data {
            let sanitizedGameData = gameData.components(separatedBy: "&").map { $0.trimmingCharacters(in: .whitespaces) }

            // There are 9 fields that are used from the upcoming games page
            guard sanitizedGameData.count >= 9 else { continue }

            let id = Int(sanitizedGameData[1].replacingOccurrences(of: "*", with: "")) ?? 0
            if gameID == id {
                rooms.home = sanitizedGameData[7]
                rooms.away = sanitizedGameData[9]
                return rooms
            }
        }

        return rooms
    }
}

// MARK: - Source Helpers

extension SharksIceParser {
    /// Load the URL, scrape the HTML, then sanitize and separate the results.
    /// - Parameters:
    ///   - url: URL to scrape.
    /// - Returns: Returns unsanitized output for the specified URL.
    private func scrape(url: URL?) async -> String? {
        guard let url = url else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }

    /// Load the contents of the specified file.
    /// - Parameter file: File to load.
    /// - Returns: Returns unsanitized output for the specified file.
    private func load(file: String?) -> String? {
        guard
            let fileName = file,
            let path = Bundle.main.path(forResource: fileName, ofType: "txt")
        else { return nil }

        return try? String(contentsOfFile: path, encoding: .utf8)
    }
}

// MARK: - Data Parsers

extension SharksIceParser {
    /// Process the passed data by stripping out the HTML table tags and trimming whitespace.
    /// - Parameter data: Data to process.
    /// - Returns: Returns a separated set of strings from the specific URL if successful.
    private func sanitize(data: String?) -> [String]? {
        guard
            let decodedData = data,
            let trimRangeStart = decodedData.range(of: "</th></tr>"),
            let trimRangeEnd = decodedData.range(of: "</table>")
        else {
            return nil
        }

        var sanitizedData = String(decodedData[trimRangeStart.upperBound..<trimRangeEnd.lowerBound])
        sanitizedData = sanitizedData.replacingOccurrences(of: "&nbsp;", with: "")

        var separatedData = sanitizedData.components(separatedBy: "</tr>")
        separatedData = separatedData.map { data in
            data
                .replacingOccurrences(of: "<[^>]+>", with: "/", options: .regularExpression)
                .replacingOccurrences(of: "/+", with: "&", options: .regularExpression)
                .trimmingCharacters(in: .whitespaces)
        }

        return separatedData
    }

    private func parseGames(in data: [String]) -> [Game] {
        var games = [Game]()

        for gameData in data {
            let sanitizedGameData = gameData.components(separatedBy: "&").map { $0.trimmingCharacters(in: .whitespaces) }
            // print(sanitizedGameData)

            // There are 11 fields that are used from the schedule page
            guard sanitizedGameData.count >= 11 else { continue }

            let gameID = Int(sanitizedGameData[1].replacingOccurrences(of: "*", with: "")) ?? 0

            let year = Calendar.current.component(.year, from: Date())
            let dateString = "\(sanitizedGameData[2]) \(year) \(sanitizedGameData[3])"

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E MMM d yyyy h:m a"
            dateFormatter.timeZone = .current
            guard let date = dateFormatter.date(from: dateString) else { continue }

            let completed = date.compare(Date()) == .orderedAscending

            var rink = sanitizedGameData[4]
            if let upperBound = rink.range(of: "San Jose ")?.upperBound {
                rink = String(rink[upperBound...])
            }

            var type: Game.GameType
            let gameTypeIndex = completed ? 11 : 9
            switch sanitizedGameData[gameTypeIndex] {
            case "Preseason":
                type = .preseason
            case let s where s.isRegularSeason:
                type = .regularSeason
            default:
                type = .undefined
            }

            let game = Game(
                id: gameID,
                date: date,
                type: type,
                rink: rink,
                home: Team(name: sanitizedGameData[7], score: completed ? sanitizedGameData[8] : "0"),
                away: Team(name: completed ? sanitizedGameData[9] : sanitizedGameData[8], score: completed ? sanitizedGameData[10] : "0")
            )

            games.append(game)
        }

        return games
    }
}

// MARK: - String Extension

extension String {
    var isRegularSeason: Bool {
        (try? Regex("Regular [0-9]+").firstMatch(in: self)) != nil
    }
}
