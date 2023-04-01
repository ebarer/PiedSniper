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
                    Text(game.home.name)
                        .font(.title2)
                        .multilineTextAlignment(.leading)

                    Text(game.away.name)
                        .font(.title2)
                        .multilineTextAlignment(.leading)
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

                    Text(game.home.name)
                        .truncationMode(.middle)
                        .allowsTightening(true)

                    Text(game.away.name)
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
        UpcomingGameCell(game: Game.previewUpcoming)
            .previewLayout(.sizeThatFits)
    }
}
