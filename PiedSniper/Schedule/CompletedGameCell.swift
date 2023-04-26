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
    var destination: Scoresheet

    var body: some View {
        NavigationLink(destination: destination) {
            if sizeCategory < ContentSizeCategory.accessibilityExtraLarge {
                HStack(spacing: 15) {
                    VStack(spacing: 5) {
                        Text(game.date.completedDayString)
                            .font(.headline)
                            .foregroundColor(dateTextColor)

                        Text(game.result.description)
                            .font(.headline)
                            .foregroundColor(dateTextColor)
                    }
                    
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
                .padding(10)
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
                .padding(10)
            }
        }
    }
}

extension CompletedGameCell {
    var dateTextColor: Color {
        switch game.result {
        case .win(overtime: _):
            return .teal
        default:
            return .secondary
        }
    }

    var piedSniperTextColor: Color {
        switch game.result {
        case .loss(overtime: _):
            return .secondary
        default:
            return .primary
        }
    }

    var opponentTextColor: Color {
        switch game.result {
        case .loss(overtime: _):
            return .primary
        case .tie:
            return .primary
        default:
            return .secondary
        }
    }
}

struct CompletedGameCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section {
                CompletedGameCell(
                    game: Game.previewCompletedWin,
                    destination: Scoresheet(game: Game.previewCompletedWin))

                CompletedGameCell(
                    game: Game.previewCompletedLoss,
                    destination: Scoresheet(game: Game.previewCompletedLoss))
            } header: {
                Text("Record")
            }
        }
        .listStyle(.plain)
    }
}
