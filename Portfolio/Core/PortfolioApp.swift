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
    static let oauthCallbackUrl = "portfolio://oauth-callback"
    
    var body: some Scene {
        WindowGroup {
            TabView {
                GenAiView()
                    .tabItem {
                        Label("SwiftUI GenAi", systemImage: "square")
                    }
                GenAiUiViewRepresentable()
                    .tabItem {
                        Label("UIKit GenAi", systemImage: "circle")
                    }
                DiscogsView()
                    .tabItem {
                        Label("SwiftUI DiscogsView", systemImage: "triangle")
                    }
                    .onOpenURL { url in
                        if url.host == PortfolioApp.oauthCallbackUrl {
                            assertionFailure("implement discogs view")
                        } else {
                            assertionFailure("deeplink not supported")
                        }
                    }
            }
        }
    }
}
