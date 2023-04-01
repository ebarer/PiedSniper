//
//  Status.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/30/23.
//

import Foundation
import os

let hoursInSeconds: Double = 3600
let minutesInSeconds: Double = 60

struct ScheduleStatus {
    static var logger = Logger(subsystem: "PiedSniper", category: "ScheduleStatus")

    var preview: Bool = false
    var gamesLoaded: Int = 0
    var completed: Bool = false
    var lastSyncDate: Date?

    func wantsReload(gameToday: Game?) -> Bool {
        guard let lastSyncDate = lastSyncDate else {
            ScheduleStatus.logger.log("No last sync date, reloading.")
            return true
        }

        let presentDate = Date()

        if let gameToday = gameToday {
            let timeToGame = gameToday.date.timeIntervalSince(presentDate)
            let timeSinceLastSync = presentDate.timeIntervalSince(lastSyncDate)

            // If there's a game today within the next 2 hours, refresh more frequently to grab the locker room
            if timeToGame < (2 * hoursInSeconds) && timeSinceLastSync > (5 * minutesInSeconds) {
                ScheduleStatus.logger.log("Upcoming game, reloading to ensure locker room is fetched.")
                return true
            } else {
                ScheduleStatus.logger.log("Upcoming game, but a recent sync has occurred. timeToGame: \(timeToGame), timeSinceLastSync: \(timeSinceLastSync)")
            }
        }

        // Otherwise only try to sync once/day (orderedSame | orderedAscending)
        let syncedToday = Calendar.current.compare(lastSyncDate, to: presentDate, toGranularity: .day) != .orderedDescending
        ScheduleStatus.logger.log("No upcoming game today, syncedToday? \(syncedToday)")
        return !syncedToday
    }

    var lastSyncString: String {
        guard let date = lastSyncDate else { return "N/A" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm:ss a"
        return dateFormatter.string(from: date)
    }
}
