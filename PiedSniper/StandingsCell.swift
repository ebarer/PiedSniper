//
//  StandingsCell.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/2/23.
//

import SwiftUI

struct StandingsCell: View {
    @Environment(\.sizeCategory) var sizeCategory
    
    var team: Team

    var body: some View {
        if let record = team.record {
            GridRow {
                Text("\(record.rank)")
                    .font(.headline)
                    .foregroundColor(team.isPiedSniper ? .primaryAccent : .secondary)

                Text(team.name)
                    .font(.headline)
                    .foregroundColor(team.isPiedSniper ? .primaryAccent : .primary)

                Group {
                    Text("\(record.gamesPlayed)")
                    Text("\(record.wins)")

                    if sizeCategory <= ContentSizeCategory.extraExtraLarge {
                        Text("\(record.losses)")
                        Text("\(record.ties)")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Text("\(record.points)")
                    .font(.subheadline.bold())
                    .foregroundColor(team.isPiedSniper ? .primaryAccent : .primary)
            }
            .padding(.trailing)
        }
    }
}

struct StandingsCell_Previews: PreviewProvider {
    static var previews: some View {
        Grid {
            StandingsCell(team: Team.piedSniper())
        }
        .previewLayout(.sizeThatFits)
    }
}
