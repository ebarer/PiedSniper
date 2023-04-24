//
//  Scoresheet.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/7/23.
//

import SwiftUI

struct Scoresheet: View {
    @State var game: Game
    @State var finishedLoading = false

    var body: some View {
        NavigationStack {
            ScrollView {
                if finishedLoading {
                    GoalsTable(game: game)
                    ShotsTable(game: game)
                    ScoringSummary(game: game)

                    if let shootout = game.events?[.shootout], !shootout.isEmpty {
                        ShootoutSummary(game: game)
                    }

                    if let penalties = game.events?[.penalties], !penalties.isEmpty {
                        PenaltySummary(game: game)
                    }

                    RosterTable(game: game)
                } else {
                    ProgressView()
                        .padding(.top, 50)
                        .tint(.teal)
                }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                Scoreboard(game: game)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .refreshable { await reload(force: true) }
        .task { await reload() }
    }
}

extension Scoresheet {
    func reload(force: Bool = false) async {
        if let updatedGame = await ScoresheetParser.shared.loadScoresheet(for: game, forceExpire: force) {
            game = updatedGame
        }
        finishedLoading = true
    }
}

// MARK: - Previews

struct Scoresheet_Previews: PreviewProvider {
    static var previews: some View {
        Scoresheet(game: Game.previewCompletedWin)
    }
}
