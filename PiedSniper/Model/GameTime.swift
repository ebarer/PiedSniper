//
//  GameTime.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/22/23.
//

import Foundation

struct GameTime: Comparable {
    static let defaultPeriodLength = 15
    static let secondsInAMinute = 60

    var period: Int
    var minutes: Int
    var seconds: Int

    init(period: Int, time: String) {
        self.period = period

        let timeComponents = time.split(separator: ":")
        if timeComponents.count == 1 {
            // There are only seconds
            self.minutes = 0
            self.seconds = Int(Float(timeComponents[0]) ?? 0)
        } else {
            self.minutes = Int(timeComponents[0]) ?? 0
            self.seconds = Int(timeComponents[1]) ?? 0
        }
    }

    var timeInSeconds: Int {
        let periodMinutes = (period - 1) * GameTime.defaultPeriodLength
        let totalMinutes = periodMinutes + (GameTime.defaultPeriodLength - minutes)
        return (totalMinutes * GameTime.secondsInAMinute) + (GameTime.secondsInAMinute - seconds)
    }

    var periodString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(integerLiteral: period)) ?? ""
    }

    var string: String {
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        return "\(periodString) / \(timeString)"
    }

    static func < (lhs: GameTime, rhs: GameTime) -> Bool {
        lhs.timeInSeconds < rhs.timeInSeconds
    }
}
