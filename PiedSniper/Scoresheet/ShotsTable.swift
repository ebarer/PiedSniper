//
//  ShotsTable.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import SwiftUI

struct ShotsTable: View {
    @State var game: Game
    @State var headers: [HeaderCell] = []

    let insets = EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0)

    var body: some View {
        if let awayResult = game.away.result, let homeResult = game.home.result {
            Grid(horizontalSpacing: 0, verticalSpacing: 10) {
                TableHeader(headers: headers, wantsTrailingPadding: false)

                GridRow {
                    Text("1st")
                    Text("\(awayResult.shots.first)")
                    Text("\(homeResult.shots.first)")
                }

                Divider()

                GridRow {
                    Text("2nd")
                    Text("\(awayResult.shots.second)")
                    Text("\(homeResult.shots.second)")
                }

                Divider()

                GridRow {
                    Text("3rd")
                    Text("\(awayResult.shots.third)")
                    Text("\(homeResult.shots.third)")
                }

                Divider()

                GridRow {
                    Text("Total")
                    Text("\(awayResult.shots.total)")
                    Text("\(homeResult.shots.total)")
                }
                .fontWeight(.semibold)

                Divider()
            }
            .font(.footnote)
            .padding(insets)
            .task {
                headers = [
                    HeaderCell(title: "Shots", alignment: .leading),
                    HeaderCell(title: game.away.abbreviation),
                    HeaderCell(title: game.home.abbreviation)
                ]
            }
        }
    }
}

extension ShotsTable {
    func foregroundColor(for team: Team) -> Color {
        game.loser == team ? .secondary : .primary
    }
}

struct ShotsTable_Previews: PreviewProvider {
    static var previews: some View {
        ShotsTable(game: Game.previewCompletedWin)
    }
}
