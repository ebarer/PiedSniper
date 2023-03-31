//
//  Schedule.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/29/23.
//

import SwiftUI

struct Schedule: View {
    @State var status = ScheduleStatus(preview: false)
    @State var teamRecord = TeamRecord()
    @State private var gameToday: Game?
    @State private var upcomingGames = [Game]()
    @State private var completedGames = [Game]()

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
                        Section {
                            GameCell(game: gameToday)
                        } header: {
                            HStack {
                                Text("Game Today, \(todayString)")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Spacer()
                            }
                        }
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
                    }

                    Text("The Toronto Maple Leafs are trash. They're definitely going to lose in the first round of the playoffs. No need to specify a year, for it's a universal constant.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .padding([.top, .bottom], 20)
                }
                .listStyle(.plain)
                .navigationTitle(Team.piedSniper)
            }
        }
        .task {
            let result = await SharksIceParser.shared.loadSchedule(status: &status, record: &teamRecord)
            gameToday = result.today
            upcomingGames = result.upcoming
            completedGames = result.completed
        }
    }
}

extension Schedule {
    var todayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: Date())
    }
}

struct Schedule_Previews: PreviewProvider {
    static var previews: some View {
        Schedule(status: ScheduleStatus(preview: true))
    }
}
