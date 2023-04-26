//
//  GameSummary.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/25/23.
//

import SwiftUI

struct GameSummary: View {
    @State var game: Game

    var body: some View {
        Group {
            Text("\(game.category.rawValue)").fontWeight(.medium)
            + Text(" • \(game.date.dateString)")
        }
        .font(.subheadline.smallCaps())
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
        .foregroundColor(.secondary)
        .padding(.top)
    }
}

struct GameSummary_Previews: PreviewProvider {
    static var previews: some View {
        GameSummary(game: Game.previewCompletedWin)
    }
}
