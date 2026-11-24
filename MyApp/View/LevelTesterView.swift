//  LevelTesterView.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//  GitHub Copilot added completion feedback and backpack access to the level tester.

import SwiftUI

struct LevelTesterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var completedLevel: LearningLevel?
    @State private var showsBackpack = false
    @State private var completedWithNewItem = false
    let levels: [LearningLevel]
    let avatar: PlayerAvatar
    let backpackItems: [WheelPrize]
    let onPrizeWon: (WheelPrize) -> Void
    let onRoundComplete: (LearningLevel) -> Void
    let onOpenWardrobe: () -> Void

    var body: some View {
        NavigationStack {
            List(levels) { level in
                // Reuse the production level flow while exposing every level for manual testing.
                NavigationLink {
                    LevelView(
                        level: level,
                        avatar: avatar,
                        onFinish: {
                            onRoundComplete(level)
                            completedLevel = level
                        },
                        onPrizeWon: { prize in
                            let isNewItem = !backpackItems.contains(where: { $0.title == prize.title })
                            onPrizeWon(prize)
                            completedWithNewItem = isNewItem
                        }
                    )
                } label: {
                    Label("Level \(level.number): \(level.title)", systemImage: level.icon)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    completedWithNewItem = false
                })
            }
            .navigationTitle("Level Tester")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done", action: dismiss.callAsFunction)
                }
            }
        }
        .overlay {
            if let completedLevel {
                CompletionOverlayView(
                    level: completedLevel,
                    hasNewItem: completedWithNewItem,
                    onReturnToWardrobe: {
                        self.completedLevel = nil
                        dismiss()
                        onOpenWardrobe()
                    },
                    onCheckBackpack: {
                        self.completedLevel = nil
                        completedWithNewItem = false
                        showsBackpack = true
                    },
                    onContinue: {
                        self.completedLevel = nil
                        completedWithNewItem = false
                    }
                )
            }
        }
        .sheet(isPresented: $showsBackpack) {
            BackpackContentsView(items: backpackItems)
                .presentationDetents([.medium, .large])
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            HStack {
                Spacer()
                HPView()
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(.thinMaterial)
        }
    }
}
