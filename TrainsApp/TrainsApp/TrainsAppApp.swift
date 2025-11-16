//
//  TrainsAppApp.swift
//  TrainsApp
//
//  Created by Stepan Chuiko on 26.10.2025.
//

import SwiftUI

@main
struct TrainsAppApp: App {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(resource: .ypWhiteDay)
        appearance.shadowColor = UIColor.systemGray4
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            TabBar()
        }
    }
}
