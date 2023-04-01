//
//  Schedule.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/29/23.
//

import SwiftUI

struct Schedule: View {
    @State private var status = ScheduleStatus(preview: true)

    @State var gameToday: Game?
    @State var upcomingGames = [Game]()
    @State var completedGames = [Game]()
    @State var teamRecord = TeamRecord()

    init(status: ScheduleStatus? = nil) {
        // Style title when displaying with large font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemTeal]

        // Style title when displaying inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.systemTeal]

        if let status = status {
            self.status = status
        }
    }

    var body: some View {
        NavigationStack {
            if !status.completed {
                Text(Team.piedSniper)
                    .font(.title2)
                    .foregroundColor(.teal)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .teal))
            } else if status.gamesLoaded == 0 {
                Text("No Games")
                    .font(.title2)
                    .foregroundColor(.teal)
            } else {
                List{
                    if let gameToday = gameToday {
                        Section("Game Today, \(Date.todayString)") {
                            GameCell(game: gameToday)
                        }
                        .headerProminence(.increased)
                    }

                    Section("Upcoming") {
                        ForEach(upcomingGames, id: \.id) { game in
                            GameCell(game: game)
                        }
                    }

                    Section {
                        ForEach(completedGames, id: \.id) { game in
                            GameCell(game: game)
                        }
                    } header: {
                        HStack {
                            Text("Record")
                            Spacer()
                            Text(teamRecord.description)
                        }
                    } footer: {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Last Sync: \(status.lastSyncString)")
                                .font(.footnote)
                                .foregroundColor(.secondary)

                            Text("The Toronto Maple Leafs are definitely going to lose in the first round of the playoffs. No need to specify a year, it'll always be true.")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle(Team.piedSniper)
            }
        }
        .refreshable {
            await reload(force: true)
        }
        .task {
            await reload()
        }
    }
}

extension Schedule {
    func reload(force: Bool = false) async {
        guard force || status.wantsReload(gameToday: gameToday) else {
            return
        }

        let result = await SharksIceParser.shared.loadSchedule(status: &status, record: &teamRecord)
        gameToday = result.today
        upcomingGames = result.upcoming
        completedGames = result.completed
    }
}

struct Schedule_Previews: PreviewProvider {
    static var previews: some View {
        Schedule(status: ScheduleStatus(preview: true))
    }
}
