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
        ForEach(rosters, id:\.0.id) { p1, p2 in
            HStack {
                Text(p1.nameString)
                Spacer()
                Text(p2.nameString)
            }
            //                VStack(alignment: .leading) {
            //                    ForEach(team.roster) { player in
            //                        Text("\(player.number) \(player.fullName) \(player.type.description)")
            //                            .font(.subheadline)
            //                        Divider()
            //                    }
            //                }
        }
    }
}

extension RosterTable {
    var rosters: [(Player, Player)] {
        Array(zip(game.away.roster, game.home.roster))
    }
}

struct RosterTable_Previews: PreviewProvider {
    static var previews: some View {
        RosterTable(game: Game.previewCompletedWin)
    }
}
