//
//  ScoringSummary.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import SwiftUI

struct ScoringSummary: View {
    @State var game: Game
    @State var maxStatWidth: CGFloat = .zero

    var body: some View {
        VStack(alignment: .leading) {
            Section {
                if scoring.isEmpty {
                    Text("None")
                        .font(.footnote)
                        .fontWeight(.semibold)
                } else {
                    ForEach(scoring, id: \.id) { goal in
                        ScoringCell(goal: goal, game: game, maxStatWidth: $maxStatWidth)
                            .padding(.trailing)
                        Divider()
                    }
                }
            } header: {
                Text("Scoring")
                    .font(.subheadline.smallCaps().bold())
                    .foregroundColor(.secondary)
                Divider()
                    .frame(height: 2)
                    .overlay(.secondary)
            }
        }
        .padding(insets)
        .onPreferenceChange(ScoringStatMaxWidthPreferenceKey.self) {
            maxStatWidth = $0
        }
    }
}

extension ScoringSummary {
    var scoring: [ScoringEvent] {
        guard let gameEvents = game.events else { return [] }
        guard let scoringEvents = gameEvents[.scoring] as? [ScoringEvent] else { return [] }
        return scoringEvents.sorted()
    }

    var insets: EdgeInsets {
        EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0)
    }
}

struct ScoringSummary_Previews: PreviewProvider {
    static var previews: some View {
        ScoringSummary(game: Game.previewCompletedWin)
    }
}
