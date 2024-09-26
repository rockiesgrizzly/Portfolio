//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by joshmac on 9/1/24.
//

import SwiftUI
import SwiftData

@main
struct PortfolioApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                GenAiView()
                    .tabItem {
                        Label("GenAi SwiftUI", systemImage: "house")
                    }
                GenAiUiViewRepresentable()
                    .tabItem {
                        Label("GenAi UIKit", systemImage: "circle")
                    }
            }
        }
    }
}
