//
//  TrainsAppApp.swift
//  TrainsApp
//
//  Created by Stepan Chuiko on 26.10.2025.
//

import SwiftUI

@main
struct TrainsAppApp: App {
    @AppStorage("isDarkThemeEnabled") private var isDarkThemeEnabled = false

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(resource: .ypWhiteDay)
        appearance.shadowColor = UIColor(resource: .ypSeparator)
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            TabBar()
                .preferredColorScheme(isDarkThemeEnabled ? .dark : .light)
        }
    }
}
