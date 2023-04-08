//
//  CacheEntry.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import Foundation

final class CacheEntryObject<Value> {
    let entry: CacheEntry<Value>
    init(entry: CacheEntry<Value>) { self.entry = entry }
}

enum CacheEntry<Value> {
    case inProgress(Task<Value, Error>)
    case ready(Value)
}
