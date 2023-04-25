//
//  RosterTable.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import SwiftUI

struct RosterTable: View {
    @State var game: Game

    var body: some View {
        Grid {
            TableHeader(headers: [
                HeaderCell(title: game.away.name, alignment: .leading),
                HeaderCell(title: game.home.name, alignment: .leading)
            ])

            ForEach(rosters, id:\.0.id) { p1, p2 in
                GridRow {
                    Text("\(p1.number) ").foregroundColor(.secondary).bold()
                    + Text("\(p1.fullName) \(p1.type.description)")

                    Text("\(p2.number) ").foregroundColor(.secondary).bold()
                    + Text("\(p2.fullName) \(p2.type.description)")
                }
                .font(.subheadline.monospacedDigit())
                .padding(.trailing)

                Divider()
            }
        }
        .padding(insets)
    }
}

extension RosterTable {
    var rosters: [(Player, Player)] {
        Array(zip(game.away.roster, game.home.roster))
    }

    var insets: EdgeInsets {
        EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0)
    }
}

struct RosterTable_Previews: PreviewProvider {
    static var previews: some View {
        RosterTable(game: Game.previewCompletedWin)
    }
}
