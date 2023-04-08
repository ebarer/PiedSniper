//
//  EventsList.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import SwiftUI

struct EventsList: View {
    @State var game: Game
    @State var scoring = [ScoringEvent]()
    @State var penalties = [PenaltyEvent]()
    @State var shootouts = [ShootoutEvent]()

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(scoring, id: \.id) { goal in
                HStack {
                    Text("\(goal.time.string) \(goal.goalType.rawValue) [\(goal.team.name)]")
                    Spacer()
                    Text(goal.description)
                }
                .monospacedDigit()

                Divider()
            }

            ForEach(penalties, id: \.id) { penalty in
                HStack {
                    Text("\(penalty.time.string) [\(penalty.team.name)]")
                    Spacer()
                    Text(penalty.description)
                }
                .monospacedDigit()

                Divider()
            }

            ForEach(shootouts, id: \.id) { shootout in
                HStack {
                    Text("[\(shootout.team.name)] \(shootout.attempt.round)")
                    Spacer()
                    Text(shootout.description)
                }
                .monospacedDigit()

                Divider()
            }
        }
        .padding(.all)
        .task {
            guard let gameEvents = game.events else { return }
            if let scoringEvents = gameEvents[.scoring] as? [ScoringEvent] {
                scoring = scoringEvents.sorted()
            }
            if let penaltyEvents = gameEvents[.penalties] as? [PenaltyEvent] {
                penalties = penaltyEvents.sorted()
            }
            if let shootoutEvents = gameEvents[.shootout] as? [ShootoutEvent] {
                shootouts = shootoutEvents.sorted()
            }
        }
    }
}

struct EventsList_Previews: PreviewProvider {
    static var previews: some View {
        EventsList(game: Game.previewCompletedWin)
    }
}
