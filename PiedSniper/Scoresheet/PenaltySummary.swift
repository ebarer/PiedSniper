//
//  PenaltySummary.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import SwiftUI

struct PenaltySummary: View {
    @State var game: Game

    var body: some View {
        VStack(alignment: .leading) {
            Section {
                ForEach(penalties, id: \.id) { penalty in
                    PenaltyCell(penalty: penalty, game: game)
                    Divider()
                }
            } header: {
                Text("Penalties")
                    .font(.subheadline.smallCaps().bold())
                    .foregroundColor(.secondary)
                Divider()
            }
        }
        .padding(.all)
    }
}

extension PenaltySummary {
    var penalties: [PenaltyEvent] {
        guard let gameEvents = game.events else {
            return []
        }

        guard let penaltyEvents = gameEvents[.penalties] as? [PenaltyEvent] else {
            return []
        }

        return penaltyEvents.sorted()
    }
}

struct PenaltySummary_Previews: PreviewProvider {
    static var previews: some View {
        PenaltySummary(game: Game.previewCompletedWin)
    }
}
