//
//  GameCell.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/29/23.
//

import SwiftUI

struct GameCell: View {
    var game: Game

    var body: some View {
        Group {
            if game.date.isToday {
                TodayGameCell(game: game)
            } else if game.result == .upcoming {
                UpcomingGameCell(game: game)
            } else {
                CompletedGameCell(game: game)
            }
        }
        .padding(10)
    }
}

struct GameCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            GameCell(game: Game.previewCompletedWin)
            GameCell(game: Game.previewUpcoming)
        }
        .previewLayout(.sizeThatFits)
    }
}
