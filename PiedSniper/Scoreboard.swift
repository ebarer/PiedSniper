//
//  Scoreboard.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/22/23.
//

import SwiftUI

struct Scoreboard: View {
    @State var game: Game

    var body: some View {
        if let awayResult = game.away.result, let homeResult = game.home.result {
            HStack {
                VStack {
                    Text(game.away.name)
                        .font(.callout.smallCaps())
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text("\(awayResult.goals.final)")
                        .font(.system(size: 70)).monospacedDigit().bold()
                        .foregroundColor(foregroundColor(for: game.away))
                }
                .frame(maxWidth: .infinity)

                VStack {
                    Text(game.home.name)
                        .font(.callout.smallCaps())
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text("\(homeResult.goals.final)")
                        .font(.system(size: 70)).monospacedDigit().bold()
                        .foregroundColor(foregroundColor(for: game.home))
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background {
                DividedBackground(
                    startColor: awayBackgroundColor,
                    endColor: homeBackgroundColor,
                    slantPercent: 0.2,
                    offset: 20
                )
                .edgesIgnoringSafeArea([.top, .horizontal])
            }
        }
    }
}

// MARK: - Colors

extension Scoreboard {
    func foregroundColor(for team: Team) -> Color {
        game.loser == team ? .white.opacity(0.5) : .white
    }

    var awayBackgroundColor: Color {
        game.away.isPiedSniper ? .teal : .darkTeal
    }

    var homeBackgroundColor: Color {
        game.home.isPiedSniper ? .teal : .darkTeal
    }
}

struct Scoreboard_Previews: PreviewProvider {
    static var previews: some View {
        Scoreboard(game: Game.previewToday)
    }
}
