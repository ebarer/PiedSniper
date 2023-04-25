//
//  PenaltyCell.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/25/23.
//

import SwiftUI

struct PenaltyCell: View {
    @State var penalty: PenaltyEvent
    @State var game: Game

    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            VStack(alignment: .center, spacing: 0) {
                Text(penalty.time.string)
                    .font(.caption)
                    .foregroundColor(.primary).colorInvert()
                    .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                    .background {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(pillColor)
                    }
            }

            VStack(alignment: .leading) {
                Text(penalty.delinquentString)
                    .font(.headline)

                Text("\(penalty.infraction)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

extension PenaltyCell {
    var pillColor: Color {
        penalty.team.isPiedSniper ? .teal : .darkTeal
    }
}

struct PenaltyCell_Previews: PreviewProvider {
    static var previews: some View {
        let penaltyContent = ["2", "18", "Body Check", "2", "7:57", "7:57", "5:57", "5:01 W"]
        if let penalty = PenaltyEvent(with: penaltyContent, team: Team.piedSniper()) {
            VStack(alignment: .leading) {
                Section {
                    PenaltyCell(penalty: penalty, game: Game.previewCompletedWin)
                    Divider()
                    PenaltyCell(penalty: penalty, game: Game.previewCompletedWin)
                    Divider()
                } header: {
                    Text("Penalties")
                        .font(.subheadline.smallCaps().bold())
                        .foregroundColor(.secondary)
                    Divider()
                }
            }
        }
    }
}
