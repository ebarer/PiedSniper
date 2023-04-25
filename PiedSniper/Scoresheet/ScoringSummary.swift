//
//  ScoringSummary.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import SwiftUI

struct ScoringSummary: View {
    @State var game: Game

    var body: some View {
        VStack(alignment: .leading) {
            Section {
                ForEach(scoring, id: \.id) { goal in
                    ScoringCell(goal: goal, game: game)
                        .padding(.trailing)
                    Divider()
                }
            } header: {
                Text("Scoring")
                    .font(.subheadline.smallCaps().bold())
                    .foregroundColor(.secondary)
                Divider()
            }
        }
        .padding(insets)
    }
}

extension ScoringSummary {
    var scoring: [ScoringEvent] {
        guard let gameEvents = game.events else { return [] }
        guard let scoringEvents = gameEvents[.scoring] as? [ScoringEvent] else { return [] }

        var currentScore: (away: Int, home: Int) = (0, 0)
        return scoringEvents.sorted().map { goal in
            var goal = goal
            (goal.team == game.away) ? (currentScore.away += 1) : (currentScore.home += 1)
            goal.gameScore = currentScore
            return goal
        }
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
