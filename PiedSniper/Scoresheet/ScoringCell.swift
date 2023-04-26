//
//  ScoringCell.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/24/23.
//

import SwiftUI

struct ScoringCell: View {
    @State var goal: ScoringEvent
    @State var game: Game

    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            VStack(alignment: .center, spacing: 0) {
                Group {
                    Text(goal.time.string) +
                    Text(goal.goalType != .normal ? " • \(goal.goalType.rawValue)" : "")
                }
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                .font(.caption)
                .foregroundColor(.secondary)

                Text(goal.gameScoreString(with: game))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.primary).colorInvert()
                    .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                    .background {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(pillColor)
                    }
            }
            .fixedSize(horizontal: true, vertical: false)

            VStack(alignment: .leading) {
                Text(goal.scorerString)
                    .font(.headline)

                if let assistsString = goal.assistsString {
                    Text(assistsString)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

extension ScoringCell {
    var pillColor: Color {
        goal.team.isPiedSniper ? .teal : .darkTeal
    }
}

struct ScoringCell_Previews: PreviewProvider {
    static var previews: some View {
        let firstGoalContent = ["2", "14:47", "PP", "76", "6", "57"]
        let secondGoalContent = ["3", "00:17", "", "6", "", ""]

        VStack(alignment: .leading) {
            Section {
                if let goal = ScoringEvent(with: firstGoalContent, team: Team.piedSniper(), gameScore: (1,0)) {
                    ScoringCell(goal: goal, game: Game.previewCompletedWin)
                    Divider()
                }


                if let goal = ScoringEvent(with: secondGoalContent, team: Team.piedSniper(), gameScore: (1,1)) {
                    ScoringCell(goal: goal, game: Game.previewCompletedWin)
                    Divider()
                }
            } header: {
                Text("Scoring Summary")
                    .font(.subheadline.smallCaps().bold())
                    .foregroundColor(.secondary)
                Divider()
            }
        }
    }
}
