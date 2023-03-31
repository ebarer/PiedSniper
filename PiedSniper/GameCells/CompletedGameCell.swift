//
//  CompletedGameCell.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/30/23.
//

import SwiftUI

struct CompletedGameCell: View {
    var game: Game
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        if sizeCategory < ContentSizeCategory.accessibilityExtraLarge {
            HStack(spacing: 15) {
                Text(game.date.verticalDayString)
                    .font(.headline)
                    .foregroundColor(game.result == .win ? .teal : .primary)
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(game.home.name)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(game.home.score)
                    }
                    .font(.title2)
                    .fontWeight((game.winner == game.home) ? .bold : .regular)
                    .foregroundColor((game.winner == game.home && game.result == .win) ? .teal : .primary)

                    HStack {
                        Text(game.away.name)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(game.away.score)
                    }
                    .font(.title2)
                    .fontWeight((game.winner == game.away) ? .bold : .regular)
                    .foregroundColor((game.winner == game.away && game.result == .win) ? .teal : .primary)
                }
            }
        } else {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(game.date.dayString)
                        .font(.headline)

                    Text("\(game.home.name) \(game.home.score)")
                        .font(.title2)
                        .fontWeight((game.winner == game.home) ? .bold : .regular)
                        .foregroundColor((game.winner == game.home && game.result == .win) ? .teal : .primary)

                    Text("\(game.away.name) \(game.away.score)")
                        .font(.title2)
                        .fontWeight((game.winner == game.away) ? .bold : .regular)
                        .foregroundColor((game.winner == game.away && game.result == .win) ? .teal : .primary)

                }
                .multilineTextAlignment(.center)
                .allowsTightening(true)
                .truncationMode(.middle)

                Spacer()
            }
        }
    }
}

struct CompletedGameCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            CompletedGameCell(game: Game.previewCompletedWin)
            CompletedGameCell(game: Game.previewCompletedLoss)
        }
        .previewLayout(.sizeThatFits)
    }
}
