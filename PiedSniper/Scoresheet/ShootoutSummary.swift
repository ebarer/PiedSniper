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
                        ShootoutCell(round: round, shots: shootout[round])
                            .padding(.trailing)
                        Divider()
                    }
                }
            } header: {
                Text("Shootout")
                    .font(.subheadline.smallCaps().bold())
                    .foregroundColor(.secondary)
                Divider()
                    .frame(height: 2)
                    .overlay(.secondary)
            }
        }
        .padding(insets)
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

    var insets: EdgeInsets {
        EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0)
    }
}

struct ShootoutSummary_Previews: PreviewProvider {
    static var previews: some View {
        ShootoutSummary(game: Game.previewCompletedWin)
    }
}
