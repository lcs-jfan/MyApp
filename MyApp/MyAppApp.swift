//
//  MyAppApp.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//  GitHub Copilot did not make direct changes to this file.
//

import SwiftUI

@main
struct MyAppApp: App {
    @State private var gameState = GameState()

    var body: some Scene {
        WindowGroup {
            // Share one health state across battles, the campfire, and other activities.
            ContentView()
                .environment(gameState)
        }
    }
}
