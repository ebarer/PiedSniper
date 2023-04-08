//
//  ScoringSummary.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import SwiftUI

struct ScoringSummary: View {
    @State var game: Game
    @State var scoring = [ScoringEvent]()

    var body: some View {
        VStack(alignment: .leading) {
            Section {
                ForEach(scoring, id: \.id) { goal in
                    HStack {
                        Text("\(goal.time.string) \(goal.goalType.rawValue) [\(goal.team.name)]")
                        Spacer()
                        Text(goal.description)
                    }
                    .monospacedDigit()

                    Divider()
                }
            } header: {
                Text("Scoring Summary")
                    .font(.headline)
            }
        }
        .padding(.all)
        .task { await reload() }
    }
}

extension ScoringSummary {
    func reload() async {
        guard let gameEvents = game.events else { return }
        if let scoringEvents = gameEvents[.scoring] as? [ScoringEvent] {
            scoring = scoringEvents.sorted()
        }
    }
}

struct ScoringSummary_Previews: PreviewProvider {
    static var previews: some View {
        ScoringSummary(game: Game.previewCompletedWin)
    }
}
