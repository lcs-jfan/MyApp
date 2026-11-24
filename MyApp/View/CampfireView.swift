//  CampfireView.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//  GitHub Copilot did not make direct changes to this file.

import SwiftUI

struct CampfireView: View {
    @Environment(GameState.self) private var gameState
    @State private var reward: CampfireReward?
    let onPrizeWon: (WheelPrize) -> Void
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.orange.opacity(0.24), .brown.opacity(0.12), .black.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "campfire.fill")
                    .font(.system(size: 96))
                    .foregroundStyle(.orange, .red)
                    .symbolEffect(.bounce, value: reward == nil)
                    .accessibilityLabel("Campfire")

                Text("Rest at the Campfire")
                    .font(.largeTitle.bold())

                Text("Choose one reward before returning to the map.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                if let reward {
                    rewardCard(reward)
                } else {
                    // The player chooses exactly one reward: restore health or collect an item.
                    HStack(spacing: 14) {
                        Button {
                            gameState.restoreHP(by: 3)
                            reward = .restored
                        } label: {
                            Label("Rest +3 HP", systemImage: "bed.double.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(CampfireButtonStyle(color: .teal))

                        Button {
                            guard let prize = WheelPrize.available.randomElement() else {
                                return
                            }
                            onPrizeWon(prize)
                            reward = .item(prize)
                        } label: {
                            Label("Find an item", systemImage: "gift.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(CampfireButtonStyle(color: .orange))
                    }
                }
            }
            .padding(28)
            .frame(maxWidth: 620)
        }
        .navigationTitle("Campfire")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func rewardCard(_ reward: CampfireReward) -> some View {
        VStack(spacing: 14) {
            switch reward {
            case .restored:
                Label("You rested and recovered 3 HP!", systemImage: "heart.fill")
                    .foregroundStyle(.teal)
            case .item(let prize):
                Label("You found \(prize.title)!", systemImage: prize.icon)
                    .foregroundStyle(prize.color)
            }

            Text("Current HP: \(gameState.hp)/\(gameState.maximumHP)")
                .font(.headline)

            Button("Return to map", action: onFinish)
                .font(.headline.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 11)
                .background(.green, in: Capsule())
        }
        .font(.title3.bold())
        .multilineTextAlignment(.center)
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 22))
    }
}

private enum CampfireReward {
    case restored
    case item(WheelPrize)
}

private struct CampfireButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(color.gradient, in: RoundedRectangle(cornerRadius: 16))
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}
