//
//  UpcomingGameCell.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/30/23.
//

import SwiftUI

struct UpcomingGameCell: View {
    var game: Game
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        if sizeCategory <= ContentSizeCategory.extraLarge {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 15) {
                        if let lockerRoom = game.home.lockerRoom {
                            Text(lockerRoom)
                                .font(.headline)
                                .foregroundColor(.teal)
                        }
                        Text(game.home.name)
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                    }

                    HStack(spacing: 15) {
                        if let lockerRoom = game.away.lockerRoom {
                            Text(lockerRoom)
                                .font(.headline)
                                .foregroundColor(.teal)
                        }
                        Text(game.away.name)
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                    }
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text(game.date.dayString)
                        .font(.headline)
                        .multilineTextAlignment(.trailing)
                    Text(game.date.timeString)
                        .multilineTextAlignment(.trailing)
                    Text(game.rink)
                        .font(.headline)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.teal)
                }
            }
        } else {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(game.date.dateString)
                        .font(.headline)
                    Text(game.home.nameAndLockerRoom)
                        .truncationMode(.middle)
                        .allowsTightening(true)
                    Text(game.away.nameAndLockerRoom)
                        .truncationMode(.middle)
                        .allowsTightening(true)
                    Text(game.rink)
                        .font(.headline)
                        .foregroundColor(.teal)
                }
                .allowsTightening(true)
                .truncationMode(.middle)

                Spacer()
            }
        }
    }
}

struct UpcomingGameCell_Previews: PreviewProvider {
    static var previews: some View {
//        VStack(spacing: 50) {
        List {
            UpcomingGameCell(game: Game.previewUpcoming)
            UpcomingGameCell(game: Game.previewUpcomingOneRoom)
        }
        .listStyle(.plain)
        .previewLayout(.sizeThatFits)
    }
}
