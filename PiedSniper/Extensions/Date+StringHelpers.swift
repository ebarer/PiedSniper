//
//  Date+StringHelpers.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/30/23.
//

import Foundation

extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    static var todayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: Date())
    }

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, h:mm a"
        return formatter.string(from: self)
    }

    var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter.string(from: self)
    }

    var verticalDayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM\nd"
        return formatter.string(from: self)
    }

    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
}
