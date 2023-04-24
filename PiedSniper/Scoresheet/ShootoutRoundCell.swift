//
//  ShootoutRoundCell.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/25/23.
//

import SwiftUI

struct ShootoutRoundCell: View {
    var round: Int
    var shots: [ShootoutEvent]?

    var body: some View {
        if let shots = shots, !shots.isEmpty {
            GridRow {
                Text(shots[0].shooter)
                    .gridColumnAlignment(.center)

                ShootoutResultBadge(shot: shots[0], alignment: .center)

                Text("\(round)")
                    .font(.title2.bold())

                if shots.count > 1 {
                    ShootoutResultBadge(shot: shots[1], alignment: .center)

                    Text(shots[1].shooter)
                        .gridColumnAlignment(.center)
                }
            }
            .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

struct ShootoutResultBadge: View {
    var shot: ShootoutEvent
    var alignment: HorizontalAlignment

    var body: some View {
        Text(shot.result)
            .font(.caption.smallCaps())
            .fontWeight(shot.scored ? .bold : .regular)
            .foregroundColor(foregroundColor)
            .gridColumnAlignment(alignment)
            .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
            .background {
                if shot.scored {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(fillColor)
                } else {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .inset(by: 1)
                        .stroke(strokeColor, lineWidth: 1)
                }
            }
    }

    var teamColor: Color {
        shot.team.isPiedSniper ? .teal : .darkTeal
    }

    var fillColor: Color {
        shot.scored ? teamColor : .clear
    }

    var strokeColor: Color {
        shot.scored ? .clear : teamColor
    }

    var foregroundColor: Color {
        shot.scored ? .white : teamColor
    }
}

struct ShootoutRoundCell_Previews: PreviewProvider {
    static var previews: some View {
        let shots: [ShootoutEvent] = [
            ShootoutEvent(
                with: ["4", "2", "Shot"],
                team: Team.doubleSecretProbation()
            )!,
            ShootoutEvent(
                with: ["1", "41", "Goal"],
                team: Team.piedSniper()
            )!
        ]

        Grid {
            ShootoutRoundCell(round: 1, shots: shots)
        }
    }
}
