//  WardrobeView.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//  GitHub Copilot did not make direct changes to this file.

import SwiftUI

struct WardrobeView: View {
    @Bindable var viewModel: AppViewModel
    let onReady: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.yellow.opacity(0.35), .mint.opacity(0.45), .blue.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    VStack(spacing: 6) {
                        Text("Adventure Outfit")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.indigo)
                        Text("Choose your look before exploring!")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }

                    AvatarView(avatar: viewModel.avatar, size: 190)

                    WardrobeSection(title: "Skin tone") {
                        ForEach(orderedSkinTones) { tone in
                            ChoiceButton(
                                title: tone.rawValue,
                                color: tone.color,
                                isSelected: viewModel.avatar.skinTone == tone,
                                isUnlocked: viewModel.isUnlocked(tone)
                            ) {
                                viewModel.avatar.skinTone = tone
                            }
                        }
                    }

                    WardrobeSection(title: "Hair") {
                        ForEach(orderedHairStyles) { style in
                            ChoiceButton(
                                title: style.rawValue,
                                systemImage: style.symbol,
                                color: style.color,
                                isSelected: viewModel.avatar.hair == style,
                                isUnlocked: viewModel.isUnlocked(style)
                            ) {
                                viewModel.avatar.hair = style
                            }
                        }
                    }

                    WardrobeSection(title: "Outfit") {
                        ForEach(orderedOutfits) { outfit in
                            ChoiceButton(
                                title: outfit.rawValue,
                                systemImage: outfit.symbol,
                                color: outfit.color,
                                isSelected: viewModel.avatar.outfit == outfit,
                                isUnlocked: viewModel.isUnlocked(outfit)
                            ) {
                                viewModel.avatar.outfit = outfit
                            }
                        }

                    }

                    Button("Ready to explore!", action: onReady)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.indigo, in: RoundedRectangle(cornerRadius: 18))
                        .accessibilityHint("Opens the learning adventure map")
                }
                .padding()
                .frame(maxWidth: 620)
                .frame(maxWidth: .infinity)
            }
        }
    }

    // Group unlocked choices first so earned items are easy to find.
    private var orderedSkinTones: [SkinTone] {
        SkinTone.allCases.filter(viewModel.isUnlocked) + SkinTone.allCases.filter { !viewModel.isUnlocked($0) }
    }

    private var orderedHairStyles: [HairStyle] {
        HairStyle.allCases.filter(viewModel.isUnlocked) + HairStyle.allCases.filter { !viewModel.isUnlocked($0) }
    }

    private var orderedOutfits: [Outfit] {
        Outfit.allCases.filter(viewModel.isUnlocked) + Outfit.allCases.filter { !viewModel.isUnlocked($0) }
    }
}

private struct WardrobeSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.indigo)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ],
                spacing: 10,
                content: { content }
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ChoiceButton: View {
    let title: String
    var systemImage: String?
    let color: Color
    let isSelected: Bool
    let isUnlocked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 7) {
                if isUnlocked, let systemImage {
                    Image(systemName: systemImage)
                        .font(.title2)
                        .foregroundStyle(color)
                } else if isUnlocked {
                    Circle()
                        .fill(color)
                        .frame(width: 28, height: 28)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .frame(height: 28)
                }

                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? .indigo : .clear, lineWidth: 3)
            }
        }
        .buttonStyle(.plain)
        .disabled(!isUnlocked)
        .opacity(isUnlocked ? 1 : 0.55)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityHint(isUnlocked ? "Wear this item" : "Unlock this item by earning it")
    }
}
