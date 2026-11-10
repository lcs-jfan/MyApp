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
                        ForEach(SkinTone.allCases) { tone in
                            ChoiceButton(
                                title: tone.rawValue,
                                color: tone.color,
                                isSelected: viewModel.avatar.skinTone == tone
                            ) {
                                viewModel.avatar.skinTone = tone
                            }
                        }
                    }

                    WardrobeSection(title: "Hair") {
                        ForEach(HairStyle.allCases) { style in
                            ChoiceButton(
                                title: style.rawValue,
                                systemImage: style.symbol,
                                color: style.color,
                                isSelected: viewModel.avatar.hair == style
                            ) {
                                viewModel.avatar.hair = style
                            }
                        }
                    }

                    WardrobeSection(title: "Outfit") {
                        ForEach(Outfit.allCases) { outfit in
                            ChoiceButton(
                                title: outfit.rawValue,
                                systemImage: outfit.symbol,
                                color: outfit.color,
                                isSelected: viewModel.avatar.outfit == outfit
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
}

private struct WardrobeSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.indigo)

            HStack(spacing: 10, content: { content })
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ChoiceButton: View {
    let title: String
    var systemImage: String?
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 7) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.title2)
                        .foregroundStyle(color)
                } else {
                    Circle()
                        .fill(color)
                        .frame(width: 28, height: 28)
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
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
