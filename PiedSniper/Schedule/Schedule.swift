//
//  Schedule.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/29/23.
//

import SwiftUI

struct Schedule: View {
    @Environment(\.sizeCategory) var sizeCategory

    @State var status = ScheduleStatus(preview: false)

    @State var gameToday: Game?
    @State var upcomingGames = [Game]()
    @State var completedGames = [Game]()
    @State var teamRecord = TeamRecord()

    var body: some View {
        NavigationStack {
            Group {
                if !status.completed {
                    ProgressView()
                        .tint(.teal)
                } else if status.gamesLoaded == 0 {
                    Button {
                        Task { await reload(force: true) }
                    } label: {
                        Text("No Games")
                            .font(.title2)
                        Image(systemName: "arrow.clockwise")
                    }
                    .foregroundColor(.teal)
                } else {
                    List {
                        if let gameToday = gameToday {
                            Section("Game Today • \(Date.todayString)") {
                                TodayGameCell(game: gameToday)
                            }
                            .headerProminence(.increased)
                        }

                        Section {
                            ForEach(upcomingGames, id: \.id) { game in
                                UpcomingGameCell(game: game)
                            }
                        } header: {
                            Text(upcomingGames.isEmpty ? "No upcoming games" : "Upcoming")
                        }

                        if !completedGames.isEmpty {
                            Section {
                                ForEach(completedGames, id: \.id) { game in
                                    CompletedGameCell(game: game, destination: Scoresheet(game: game))
                                }
                            } header: {
                                Text("Record (\(teamRecord.summary))")
                            } footer: {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Last Sync: \(status.lastSyncString)")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(Team.piedSniperName)
        }
        .tint(.primary)
        .refreshable { await reload(force: true) }
        .task { await reload() }
    }
}

extension Schedule {
    func reload(force: Bool = false) async {
        guard force || status.wantsReload(gameToday: gameToday) else {
            return
        }

        let result = await ScheduleParser.shared.loadSchedule(status: &status, record: &teamRecord)
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
