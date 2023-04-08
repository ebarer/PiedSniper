//
//  CompletedGameCell.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/30/23.
//

import SwiftUI

struct CompletedGameCell: View {
    @Environment(\.sizeCategory) var sizeCategory

    var game: Game

    var body: some View {
        if sizeCategory < ContentSizeCategory.accessibilityExtraLarge {
            HStack(spacing: 15) {
                Text(game.date.verticalDayString)
                    .font(.headline)
                    .foregroundColor(dateTextColor)
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(game.away.name)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(game.away.result!.goals.final)")
                            .monospacedDigit()
                    }
                    .font(.title2)
                    .foregroundColor(game.away.isPiedSniper ? piedSniperTextColor : opponentTextColor)

                    HStack {
                        Text(game.home.name)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(game.home.result!.goals.final)")
                            .monospacedDigit()
                    }
                    .font(.title2)
                    .foregroundColor(game.home.isPiedSniper ? piedSniperTextColor : opponentTextColor)
                }
            }
        } else {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(game.date.dayString)
                        .font(.headline)

                    Text("\(game.away.name) \(game.away.result!.goals.final)")
                        .font(.title2)
                        .foregroundColor(game.away.isPiedSniper ? piedSniperTextColor : opponentTextColor)

                    Text("\(game.home.name) \(game.home.result!.goals.final)")
                        .font(.title2)
                        .foregroundColor(game.home.isPiedSniper ? piedSniperTextColor : opponentTextColor)

                }
                .multilineTextAlignment(.leading)
                .allowsTightening(true)
                .truncationMode(.middle)

                Spacer()
            }
        }
    }

    var dateTextColor: Color {
        game.result == .win() ? .teal : .secondary
    }

    var piedSniperTextColor: Color {
        game.result == .loss() ? .secondary : .primary
    }

    var opponentTextColor: Color {
        (game.result == .loss() || game.result == .tie) ? .primary : .secondary
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
