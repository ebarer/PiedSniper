//
//  UpcomingGameCell.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/30/23.
//

import SwiftUI

struct UpcomingGameCell: View {
    @Environment(\.sizeCategory) var sizeCategory

    var game: Game

    var body: some View {
        if sizeCategory <= ContentSizeCategory.extraLarge {
            HStack {
                VStack(alignment: .leading) {
                    Text(game.date.dayString)
                        .font(.headline)
                        .multilineTextAlignment(.trailing)

                    Text(game.date.timeString)
                        .multilineTextAlignment(.trailing)

                    Text(game.rink)
                        .font(.headline)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.primaryAccent)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 5) {
                    Text(game.away.name)
                        .font(.title2)
                        .multilineTextAlignment(.leading)

                    Text("at \(game.home.name)")
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(10)
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
                        .foregroundColor(.primaryAccent)
                }
                .allowsTightening(true)
                .truncationMode(.middle)

                Spacer()
            }
            .padding(10)
        }
    }
}

struct UpcomingGameCell_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingGameCell(game: Game.previewUpcoming)
            .previewLayout(.sizeThatFits)
    }
}
