//
//  Clamp.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/22/23.
//

import Foundation

@propertyWrapper
struct Clamp<Value: Comparable> {
    var value: Value
    var range: ClosedRange<Value>

    init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.value = wrappedValue
        self.range = range
        self.wrappedValue = wrappedValue
    }

    var wrappedValue: Value {
        get { value }
        set { value = min(range.upperBound, max(range.lowerBound, newValue))
        }
    }
}
