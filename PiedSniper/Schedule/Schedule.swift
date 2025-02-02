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

    @State var maxDateWidth: CGFloat = .zero

    var body: some View {
        NavigationStack {
            Group {
                if !status.completed {
                    ProgressView()
                        .tint(.primaryAccent)
                } else if status.gamesLoaded == 0 {
                    Button {
                        Task { await reload(force: true) }
                    } label: {
                        Text("No Games")
                            .font(.title2)
                        Image(systemName: "arrow.clockwise")
                    }
                    .foregroundColor(.primaryAccent)
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
                                    CompletedGameCell(
                                        game: game,
                                        destination: Scoresheet(game: game),
// TODO:                                        isActive: game.result != .forfeit,
                                        maxDateWidth: $maxDateWidth
                                    )
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
        .onPreferenceChange(CompletedGameDateMaxWidthPreferenceKey.self) { 
            maxDateWidth = $0
        }
    }
}

extension Schedule {
    func reload(force: Bool = false) async {
        guard force || status.wantsReload(gameToday: gameToday) else {
            return
        }

        teamRecord.reset()

        let result = await ScheduleParser.shared.loadSchedule(status: status, record: teamRecord)
        status = result.status
        teamRecord = result.record
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
