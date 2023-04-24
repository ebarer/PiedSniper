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
    var offset: CGFloat = 0.0

    var body: some View {
        ZStack {
            startColor
            endColor
                .mask(Parallelogram(slantPercent: slantPercent, offset: offset))
        }
    }
}

struct Parallelogram: Shape {
    @Clamp(0.0...1.0) var slantPercent: CGFloat = 0
    var offset: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        let halfWidth = rect.width * 0.5
        let slantAdjustment = halfWidth * slantPercent
        let mid = halfWidth + offset

        return Path { p in
            p.move(to: CGPoint(x: mid + slantAdjustment, y: 0))
            p.addLine(to: CGPoint(x: rect.width, y: 0))
            p.addLine(to: CGPoint(x: rect.width, y: rect.height))
            p.addLine(to: CGPoint(x: mid - slantAdjustment, y: rect.height))
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
