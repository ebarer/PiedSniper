//
//  Status.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/30/23.
//

import Foundation

let hoursInSeconds: Double = 3600
let minutesInSeconds: Double = 60

struct ScheduleStatus {
    var preview: Bool = false
    var gamesLoaded: Int = 0
    var completed: Bool = false
    var lastSyncDate: Date?

    func wantsReload(gameToday: Game?) -> Bool {
        guard let lastSyncDate = lastSyncDate else { return true }

        let presentDate = Date()

        if let gameToday = gameToday {
            let timeToGame = gameToday.date.timeIntervalSince(presentDate)
            let timeSinceLastSync = presentDate.timeIntervalSince(lastSyncDate)

            // If there's a game today within the next 2 hours, refresh more frequently to grab the locker room
            if timeToGame < (2 * hoursInSeconds) && timeSinceLastSync > (10 * minutesInSeconds) {
                return true
            }
        }

        // Otherwise only try to sync once/day (orderedSame | orderedAscending)
        let syncedToday = Calendar.current.compare(lastSyncDate, to: presentDate, toGranularity: .day) != .orderedDescending
        return !syncedToday
    }

    var lastSyncString: String {
        guard let date = lastSyncDate else { return "N/A" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm:ss a"
        return dateFormatter.string(from: date)
    }
}
