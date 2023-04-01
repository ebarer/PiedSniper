//
//  PiedSniperApp.swift
//  PiedSniper
//
//  Created by Elliot Barer on 3/26/23.
//

import SwiftUI

@main
struct PiedSniperApp: App {
    init() {
        // Style title when displaying with large font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemTeal]

        // Style title when displaying inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
    }

    @State private var selection = 0

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                Schedule()
                    .tabItem { Label("Schedule", systemImage: "calendar") }
                    .tag(0)
                Standings()
                    .tabItem { Label("Standings", systemImage: "list.number") }
                    .tag(1)
            }
            .tint(.teal)
        }
    }
}
