//
//  MaxWidthPreferenceKey.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/30/23.
//

import SwiftUI

/// Implement PreferenceKey to retain the max value
class MaxWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        let nextValue = nextValue()
        guard nextValue > value else { return }
        value = nextValue
    }
}

/// For the view this is applied to, identify the widest instance in a list, store that value
/// in the provided PreferenceKey, and use that preference to set all other instance to the same width.
/// Assign this view to the instance as a background. Used in conjunction with `.onPreferenceChange:`
struct MaxWidthGeometry<K: PreferenceKey>: View {
    var key: K.Type

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: key, value: geometry.size.width as! K.Value)
        }
        .scaledToFill()
    }
}
