//
//  ShootoutSummary.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/24/23.
//

import SwiftUI

struct ShootoutSummary: View {
    @State var game: Game

    var body: some View {
        VStack(alignment: .leading) {
            Section {
                Grid {
                    ForEach(rounds, id: \.self) { round in
                        ShootoutRoundCell(round: round, shots: shootout[round])
                        Divider()
                    }
                }
            } header: {
                Text("Shootout")
                    .font(.subheadline.smallCaps().bold())
                    .foregroundColor(.secondary)
                Divider()
            }
        }
        .padding(.all)
    }
}

extension ShootoutSummary {
    var shootout: [Int : [ShootoutEvent]] {
        guard let gameEvents = game.events,
              let events = gameEvents[.shootout] as? [ShootoutEvent]
        else { return [:] }

        return events.sorted().reduce(into: [Int: [ShootoutEvent]](), { partialResult, shot in
            if partialResult[shot.round] == nil {
                partialResult[shot.round] = []
            }
            partialResult[shot.round]?.append(shot)
        })
    }

    var rounds: [Int] {
        Array(shootout.keys.sorted())
    }
}

struct ShootoutSummary_Previews: PreviewProvider {
    static var previews: some View {
        ShootoutSummary(game: Game.previewCompletedWin)
    }
}
