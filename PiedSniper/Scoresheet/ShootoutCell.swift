//
//  ShootoutCell.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/25/23.
//

import SwiftUI

struct ShootoutCell: View {
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
                    .foregroundColor(.secondary)

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
    @Environment(\.colorScheme) var colorScheme

    var shot: ShootoutEvent
    var alignment: HorizontalAlignment

    var body: some View {
        Text(shot.result)
            .font(.caption.smallCaps())
            .fontWeight(shot.scored ? .bold : .regular)
            .foregroundColor(textColor(for: colorScheme))
            .gridColumnAlignment(alignment)
            .padding(EdgeInsets(top: 2, leading: 5, bottom: 3, trailing: 5))
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
        shot.team.isPiedSniper ? .primaryAccent : .secondaryAccent
    }

    var fillColor: Color {
        shot.scored ? teamColor : .clear
    }

    var strokeColor: Color {
        shot.scored ? .clear : teamColor
    }

    func textColor(for colorScheme: ColorScheme) -> Color {
        return shot.scored ? (colorScheme == .dark ? .black : .white) : teamColor
    }
}

struct ShootoutCell_Previews: PreviewProvider {
    static var previews: some View {
        let shots: [ShootoutEvent] = [
            ShootoutEvent(team: Team.doubleSecretProbation(), round: 4, number: 2, scored: false),
            ShootoutEvent(team: Team.piedSniper(), round: 1, number: 41, scored: true),
        ]

        Grid {
            ShootoutCell(round: 1, shots: shots)
        }
    }
}
