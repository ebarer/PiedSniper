//
//  TodayGameCell.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/30/23.
//

import SwiftUI

struct TodayGameCell: View {
    var game: Game
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(isHome ? "vs." : "@") \(game.opponent.name)")
                .font(.headline)

            Text(summaryString)

            if let lockerRoomString = lockerRoomString {
                Text(lockerRoomString)
            }
        }
    }
}

extension TodayGameCell {
    var summaryString: AttributedString {
        var string = AttributedString("\(game.date.timeString) on \(game.rink)")
        string.font = .title2
        string.foregroundColor = .label

        if let range = string.range(of: game.date.timeString) {
            string[range].font = .title2.bold()
            string[range].foregroundColor = .teal
        }

        if let range = string.range(of: game.rink) {
            string[range].font = .title2.bold()
            string[range].foregroundColor = .teal
        }

        return string
    }

    var lockerRoomString: AttributedString? {
        guard let lockerRoom = game.piedSniper.lockerRoom else {
            return nil
        }

        var string = AttributedString("Locker: \(lockerRoom)")
        string.font = .headline
        string.foregroundColor = .label

        if let range = string.range(of: lockerRoom) {
            string[range].font = .headline.bold()
            string[range].foregroundColor = .teal
        }

        return string
    }

    var isHome: Bool {
        game.home.name == Team.piedSniper
    }
}

struct TodayGameCell_Previews: PreviewProvider {
    static var previews: some View {
        TodayGameCell(game: Game.previewUpcoming)

        VStack(spacing: 50) {
            TodayGameCell(game: Game.previewUpcoming)
            TodayGameCell(game: Game.previewUpcomingOneRoom)
        }
        .previewLayout(.sizeThatFits)
    }
}
