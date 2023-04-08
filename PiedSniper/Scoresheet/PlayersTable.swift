//
//  PlayersTable.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import SwiftUI

struct PlayersTable: View {
    @State var game: Game

    var body: some View {
        ForEach(game.teams) { team in
            let players = Array(team.players.values) as [Player]
            ForEach(players) { player in
                Text("\(player.number) \(player.fullName) \(player.typeString)")
            }
        }
    }
}

struct PlayersTable_Previews: PreviewProvider {
    static var previews: some View {
        PlayersTable(game: Game.previewCompletedWin)
    }
}
