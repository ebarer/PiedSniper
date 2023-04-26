//
//  RosterTable.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import SwiftUI

struct RosterTable: View {
    @State var game: Game

    var body: some View {
        Grid {
            TableHeader(headers: [
                HeaderCell(title: game.away.name, alignment: .leading),
                HeaderCell(title: game.home.name, alignment: .leading)
            ])

            ForEach(rosters, id:\.0) { index, players in
                GridRow {
                    if let p1 = players.0 {
                        HStack(alignment: .top, spacing: 4) {
                            Text("\(p1.number)").foregroundColor(.secondary).bold()
                            Text("\(p1.fullName) \(p1.type.description)")
                        }
                    } else {
                        Spacer()
                    }

                    if let p2 = players.1 {
                        HStack(alignment: .top, spacing: 4) {
                            Text("\(p2.number)").foregroundColor(.secondary).bold()
                            Text("\(p2.fullName) \(p2.type.description)")
                        }
                    } else {
                        Spacer()
                    }
                }
                .font(.subheadline.monospacedDigit())
                .padding(.trailing)

                Divider()
            }
        }
        .padding(insets)
    }
}

extension RosterTable {
    var rosters: [(Range<Array<Player>.Index>.Element, (Player?, Player?))] {
        let indices = game.away.roster.count > game.home.roster.count ? game.away.roster.indices : game.home.roster.indices
        let roster = zipLongest(game.away.roster, game.home.roster)
        return Array(zip(indices, roster))
    }

    // Replacement for zip function that pads shorted sequence with nil elements,
    // instead of truncating zipped result to length of shortest provided sequence.
    /// - Parameters:
    ///   - sequence1: First sequence to be zipped.
    ///   - sequence2: Second sequence to be zipped.
    /// - Returns: Return sequence1 and sequence2 zippered where the shortest of the two sequences is nil padded.
    func zipLongest <Sequence1: Sequence, Sequence2: Sequence> (_ sequence1: Sequence1, _ sequence2: Sequence2) -> [(Sequence1.Element?, Sequence2.Element?)] {
        var (iterator1, iterator2) = (sequence1.makeIterator(), sequence2.makeIterator())
        var result = [(Sequence1.Element?, Sequence2.Element?)]()
        result.reserveCapacity(Swift.max(sequence1.underestimatedCount, sequence2.underestimatedCount))
        while true {
            let (element1, element2) = (iterator1.next(), iterator2.next())
            if element1 == nil && element2 == nil {
                break
            } else {
                result.append((element1, element2))
            }
        }
        return result
    }

    var insets: EdgeInsets {
        EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0)
    }
}

struct RosterTable_Previews: PreviewProvider {
    static var previews: some View {
        RosterTable(game: Game.previewCompletedWin)
    }
}
