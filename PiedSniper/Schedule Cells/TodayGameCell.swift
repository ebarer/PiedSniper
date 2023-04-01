//
//  TodayGameCell.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/30/23.
//

import SwiftUI

struct TodayGameCell: View {
    var game: Game

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(game.isHome ? "vs." : "at") \(game.opponent.name)")
                .font(.headline)

            Text(summaryString)

            Text(game.isHome ? "Light Jersey" : "Dark Jersey")
        }
    }
}

extension TodayGameCell {
    var summaryString: AttributedString {
        var rinkString = "\(game.rink)"
        if let lockerRoom = game.lockerRoom {
            rinkString.append(" \(lockerRoom)")
        }

        let summaryString = "\(game.date.timeString) on \(rinkString)"
        var string = AttributedString(summaryString)
        string.font = .title2
        string.foregroundColor = .label

        if let range = string.range(of: game.date.timeString) {
            string[range].font = .title2.bold()
            string[range].foregroundColor = .teal
        }

        if let range = string.range(of: rinkString) {
            string[range].font = .title2.bold()
            string[range].foregroundColor = .teal
        }

        return string
    }
}

struct TodayGameCell_Previews: PreviewProvider {
    static var previews: some View {
        TodayGameCell(game: Game.previewToday)
            .previewLayout(.sizeThatFits)
    }
}
