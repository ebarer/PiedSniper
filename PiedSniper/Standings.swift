//
//  Standings.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/1/23.
//

import SwiftUI

struct Standings: View {
    @State private var teams = [Team]()

    var body: some View {
        NavigationStack {
            ScrollView {
                if !teams.isEmpty {
                    Grid(horizontalSpacing: 0, verticalSpacing: 15) {
                        StandingsHeader()

                        ForEach(teams) { team in
                            StandingsCell(team: team)
                                .padding(.trailing)

                            Divider()
                        }
                    }
                    .padding(
                        EdgeInsets(
                            top: 20,
                            leading: 20,
                            bottom: 0,
                            trailing: 0
                        )
                    )
                }
            }
            .navigationTitle("Standings")
        }
        .task {
            if teams.isEmpty {
                teams = await StandingsParser.shared.loadStandings()
            }
        }
    }
}

struct StandingsHeader: View {
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        GridRow {
            Text("")
            Text("Team")
                .gridColumnAlignment(.leading)
            Text("G")
            Text("W")

            if sizeCategory <= ContentSizeCategory.extraExtraLarge {
                Text("L")
                Text("OT")
            }

            Text("P")
        }
        .font(.subheadline.smallCaps().bold())
        .foregroundColor(.secondary)
        .padding(.trailing)

        Divider()
    }
}

struct Standings_Previews: PreviewProvider {
    static var previews: some View {
        Standings()
            .previewLayout(.sizeThatFits)
    }
}
