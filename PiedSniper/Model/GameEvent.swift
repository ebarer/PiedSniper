//
//  GameEvent.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/16/23.
//

import Foundation

enum GameEventType: String, CaseIterable {
    typealias RawValue = String

    case undefined = "Undefined"
    case scoring = "Scoring"
    case shootout = "Shootout"
    case penalties = "Penalties"

    static var values: [String] {
        self.allCases.map { $0.rawValue }
    }
}

protocol GameEvent: CustomStringConvertible {
    var id: Int { get }
    var type: GameEventType { get }

    var team: Team { get set }
    var number: Int? { get set }
}
