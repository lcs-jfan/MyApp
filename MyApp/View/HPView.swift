//  HPView.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//  GitHub Copilot did not make direct changes to this file.

import SwiftUI

struct HPView: View {
    @Environment(GameState.self) private var gameState

    var body: some View {
        Label("\(gameState.hp) HP", systemImage: "heart.fill")
            .font(.title3.bold())
            .foregroundStyle(gameState.hp == 0 ? .gray : .red)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(.regularMaterial, in: Capsule())
            .overlay {
                Capsule()
                    .stroke(.red.opacity(0.25), lineWidth: 1)
            }
            .accessibilityLabel("Health points: \(gameState.hp) out of \(gameState.maximumHP)")
    }
}
