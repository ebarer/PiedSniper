//
//  TableHeader.swift
//  PiedSniper
//
//  Created by Elliot Barer on 4/23/23.
//

import SwiftUI

struct HeaderCell {
    var title: String
    var alignment: HorizontalAlignment = .center
}

struct TableHeader: View {
    var headers: [HeaderCell]
    var wantsTrailingPadding: Bool = true

    var body: some View {
        GridRow {
            ForEach(headers, id:\.title) { header in
                Text(header.title)
                    .gridColumnAlignment(header.alignment)
            }
        }
        .font(.subheadline.smallCaps().bold())
        .foregroundColor(.secondary)
        .padding(.trailing, wantsTrailingPadding ? nil : 0)

        Divider()
    }
}

struct TableHeader_Previews: PreviewProvider {
    static var previews: some View {
        TableHeader(headers: [
            HeaderCell(title: "Final", alignment: .leading),
            HeaderCell(title: "1st"),
            HeaderCell(title: "2nd"),
            HeaderCell(title: "3rd"),
            HeaderCell(title: "OT"),
            HeaderCell(title: "SO"),
            HeaderCell(title: "T")
        ])
    }
}
