//
//  Standings.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/1/23.
//

import SwiftUI

struct Standings: View {
    @Environment(\.sizeCategory) var sizeCategory

    @State private var teams = [Team]()

    let insets = EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0)

    var headers: [HeaderCell] {
        var headers = [
            HeaderCell(title: ""),
            HeaderCell(title: "Team", alignment: .leading),
            HeaderCell(title: "GP"),
            HeaderCell(title: "W")
        ]

        if sizeCategory <= ContentSizeCategory.extraExtraLarge {
            headers.append(contentsOf: [
                HeaderCell(title: "L"),
                HeaderCell(title: "OT")
            ])
        }

        headers.append(HeaderCell(title: "P"))
        return headers
    }

    var body: some View {
        NavigationStack {
            Group {
                if teams.isEmpty {
                    ProgressView()
                        .tint(.teal)
                } else {
                    ScrollView {
                        Grid(horizontalSpacing: 0, verticalSpacing: 15) {
                            TableHeader(headers: headers)

                            ForEach(teams) { team in
                                StandingsCell(team: team)
                                Divider()
                            }
                        }
                        .padding(insets)
                    }
                }
            }
            .navigationTitle("Standings")
        }
        .refreshable { await reload() }
        .task { await reload() }
    }
}

extension Standings {
    func reload() async {
        if teams.isEmpty {
            teams = await StandingsParser.shared.loadStandings()
        }
    }
}

struct Standings_Previews: PreviewProvider {
    static var previews: some View {
        Standings()
            .previewLayout(.sizeThatFits)
    }
}
