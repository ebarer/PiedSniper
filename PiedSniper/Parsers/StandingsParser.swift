//
//  StandingsParser.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/9/23.
//

import Foundation

struct StandingsParser {
    static let shared = StandingsParser()
    static let cache: NSCache<NSString, CacheEntryObject<String>> = NSCache()

    /// Load the standings for Adult Division 4A.
    /// - Parameter preview: Indicate if preview data should be used instead of loading live results.
    /// - Returns: Returns the Adult Division 4A standings.
    func loadStandings(preview: Bool = false) async -> [Team] {
        let scrapedData = await scrapeStandings(preview: preview)
        guard let data = sanitize(standingsData: scrapedData) else { return [] }
        let teams = parse(standingsData: data)
        return teams
    }

    /// Scrape standings data from specified source.
    /// - Parameter preview: Indicate if preview data should be used instead of loading live results.
    /// - Returns: Return the scraped standings data.
    private func scrapeStandings(preview: Bool) async -> String? {
        if preview {
            let scrapedData = Bundle.main.load(file: "testStandings")
            return scrapedData
        }

        let standingsURL = URL(string: "https://stats.sharksice.timetoscore.com/display-stats.php?league=1")
        let scrapedData = await standingsURL?.scrape(cache: StandingsParser.cache)
        return scrapedData
    }
}

extension StandingsParser {
    /// Process the passed standings data by stripping out the HTML table tags and trimming whitespace.
    /// - Parameter standingsData: Standings data to process.
    /// - Returns: Returns a separated set of strings from the specific URL if successful.
    private func sanitize(standingsData: String?) -> [String]? {
        guard let decodedData = standingsData,
              let trimRangeStart = decodedData.range(of: "Adult Division 4A"),
              let trimRangeEnd = decodedData.range(of: "Adult Division 4B")
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

    /// Extract team and record information from the sanitized data.
    /// - Parameter standingsData: Sanitized data processed from the standings page.
    /// - Returns: Returns a list of teams with their repective records.
    private func parse(standingsData: [String]) -> [Team] {
        var standings = [Team]()

        var rank: Int = 1
        for data in standingsData {
            let sanitizedData = data.components(separatedBy: "&").map { $0.trimmingCharacters(in: .whitespaces) }
            //            print(sanitizedData)

            // There are 11 fields that are used from the standings page
            guard sanitizedData.count >= 11,
                  sanitizedData[1] != "Team" // Ignore header
            else { continue }

            let overtime = Int(sanitizedData[5])! + Int(sanitizedData[6])!
            let team = Team(
                name: sanitizedData[1],
                record: TeamRecord(
                    wins: Int(sanitizedData[3])!,
                    losses: Int(sanitizedData[4])!,
                    overtime: overtime,
                    rank: rank
                )
            )

            standings.append(team)
            rank += 1
        }

        return standings
    }
}
