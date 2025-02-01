//
//  PenaltyCell.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/25/23.
//

import SwiftUI

class PenaltyTimeMaxWidthPreferenceKey: MaxWidthPreferenceKey {}

struct PenaltyCell: View {
    @State var penalty: PenaltyEvent
    @State var game: Game
    @Binding var maxStatWidth: CGFloat

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
            .background(MaxWidthGeometry(key: PenaltyTimeMaxWidthPreferenceKey.self))
            .frame(width: maxStatWidth)

            VStack(alignment: .leading) {
                Text(penalty.delinquentString)
                    .font(.headline)

                Text("\(penalty.infraction), \(penalty.duration)m")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

extension PenaltyCell {
    var pillColor: Color {
        penalty.team.isPiedSniper ? .primaryAccent : .secondaryAccent
    }
}

struct PenaltyCell_Previews: PreviewProvider {
    static var previews: some View {
        let penalty = PenaltyEvent(
            time: GameTime(period: 2, time: "7:57"),
            team: Team.piedSniper(),
            number: 18,
            infraction: "Body Check",
            duration: 2
        )

        VStack(alignment: .leading) {
            Section {
                PenaltyCell(
                    penalty: penalty,
                    game: Game.previewCompletedWin,
                    maxStatWidth: .constant(100)
                )

                Divider()

                PenaltyCell(
                    penalty: penalty,
                    game: Game.previewCompletedWin,
                    maxStatWidth: .constant(100)
                )

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
