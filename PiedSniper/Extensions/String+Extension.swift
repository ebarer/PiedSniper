//
//  String+Extension.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import Foundation

extension String {
    var homeSavesHeader: Bool {
        guard !self.isEmpty else { return false }
        return (try? Regex("Home Saves:[0-9]{1,2}").firstMatch(in: self)) != nil
    }

    var visitorSavesHeader: Bool {
        guard !self.isEmpty else { return false }
        return (try? Regex("Visitor Saves:[0-9]{1,2}").firstMatch(in: self)) != nil
    }

    var rosterHeader: Bool {
        guard !self.isEmpty else { return false }
        return (try? Regex("Players in [gG]ame").firstMatch(in: self)) != nil
    }

    var isNumber: Bool {
        guard !self.isEmpty else { return false }
        return self.range(of: "^[0-9]*$", options: .regularExpression) != nil
    }

    var saves: Int {
        guard let match = try? Regex("[0-9]{1,2}").firstMatch(in: self) else { return 0 }
        let result = self[match.range]
        return Int(result) ?? 0
    }
}
