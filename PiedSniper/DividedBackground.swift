//
//  DividedBackground.swift
//  Sample
//
//  Created by Elliot Barer on 4/22/23.
//

import SwiftUI

struct DividedBackground: View {
    var startColor: Color
    var endColor: Color
    var slantPercent: CGFloat

    var body: some View {
        ZStack {
            startColor
            endColor
                .mask(Parallelogram(slantPercent: slantPercent))
        }
    }
}

struct Parallelogram: Shape {
    @Clamp(0.0...1.0) var slantPercent: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let mid = rect.width * 0.5
        let offset = rect.width * slantPercent * 0.5

        return Path { p in
            p.move(to: CGPoint(x: mid + offset, y: 0))
            p.addLine(to: CGPoint(x: rect.width, y: 0))
            p.addLine(to: CGPoint(x: rect.width, y: rect.height))
            p.addLine(to: CGPoint(x: mid - offset, y: rect.height))
            p.closeSubpath()
        }
    }
}

struct DividedBackground_Previews: PreviewProvider {
    static var previews: some View {
        DividedBackground(
            startColor: .red,
            endColor: .blue,
            slantPercent: 0.5
        )
            .previewLayout(.fixed(width: 500, height: 200))
    }
}
