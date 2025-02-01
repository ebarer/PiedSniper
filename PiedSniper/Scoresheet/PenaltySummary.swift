//
//  PenaltySummary.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import SwiftUI

struct PenaltySummary: View {
    @State var game: Game
    @State var maxStatWidth: CGFloat = .zero

    var body: some View {
        VStack(alignment: .leading) {
            Section {
                if penalties.isEmpty {
                    Text("None")
                        .font(.footnote)
                        .fontWeight(.semibold)
                } else {
                    ForEach(penalties, id: \.id) { penalty in
                        PenaltyCell(penalty: penalty, game: game, maxStatWidth: $maxStatWidth)
                            .padding(.trailing)
                        Divider()
                    }
                }
            } header: {
                Text("Penalties")
                    .font(.subheadline.smallCaps().bold())
                    .foregroundColor(.secondary)
                Divider()
                    .frame(height: 2)
                    .overlay(.secondary)
            }
        }
        .padding(insets)
        .onPreferenceChange(PenaltyTimeMaxWidthPreferenceKey.self) {
            maxStatWidth = $0
        }
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

    var insets: EdgeInsets {
        EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0)
    }
}

struct PenaltySummary_Previews: PreviewProvider {
    static var previews: some View {
        PenaltySummary(game: Game.previewCompletedWin)
    }
}
