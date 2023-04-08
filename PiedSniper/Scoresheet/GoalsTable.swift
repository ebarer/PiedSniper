//
//  GoalsTable.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import SwiftUI

struct GoalsTable: View {
    @State var game: Game
    @State var headers: [HeaderCell] = []
    let insets = EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0)

    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 10) {
            TableHeader(headers: headers)

            ForEach(game.teams) { team in
                if let result = team.result {
                    GridRow {
                        Text(team.name)
                            .fontWeight(.semibold)

                        Text("\(result.goals.first)")
                        Text("\(result.goals.second)")
                        Text("\(result.goals.third)")

                        if result.otl, let shootout = result.goals.shootoutDescription(otl: result.otl) {
                            Text(shootout)
                        }

                        Text("\(result.goals.final)")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(foregroundColor(for: team))
                    .monospacedDigit()
                    .padding(.vertical, 5)
                    .padding(.trailing)

                    Divider()
                }
            }
        }
        .padding(insets)
        .task {
            headers = [
                HeaderCell(title: "Final", alignment: .leading),
                HeaderCell(title: "1st"),
                HeaderCell(title: "2nd"),
                HeaderCell(title: "3rd"),
                HeaderCell(title: "T")
            ]

            if game.wentToOT {
                headers.insert(HeaderCell(title: "SO"), at: 4)
            }
        }
    }
}

extension GoalsTable {
    func foregroundColor(for team: Team) -> Color {
        game.loser == team ? .secondary : .primary
    }
}

struct GoalsTable_Previews: PreviewProvider {
    static var previews: some View {
        GoalsTable(game: Game.previewCompletedWin)
    }
}
