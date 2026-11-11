import SwiftUI

struct TopicSelectionView: View {
    let avatar: PlayerAvatar
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.18), .white, .teal.opacity(0.16)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    AvatarView(avatar: avatar, size: 110)

                    VStack(spacing: 8) {
                        Text("Choose a Topic")
                            .font(.largeTitle.bold())
                        Text("Pick a learning adventure to begin.")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    topicCard(
                        title: "Marine Biology",
                        subtitle: "Explore a whale's anatomy",
                        icon: "water.waves",
                        color: .blue
                    ) {
                        AnatomyActivityView(onFinish: onFinish)
                    }

                    topicCard(
                        title: "Biomedical Toxicity",
                        subtitle: "Coming soon",
                        icon: "cross.case.fill",
                        color: .teal,
                        isAvailable: false
                    )

                    topicCard(
                        title: "Music",
                        subtitle: "Coming soon",
                        icon: "music.note",
                        color: .purple,
                        isAvailable: false
                    )
                }
                .padding(24)
                .frame(maxWidth: 620)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Topic Quest")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func topicCard<Destination: View>(
        title: String,
        subtitle: String,
        icon: String,
        color: Color,
        isAvailable: Bool = true,
        @ViewBuilder destination: () -> Destination = { EmptyView() }
    ) -> some View {
        if isAvailable {
            NavigationLink {
                destination()
            } label: {
                cardLabel(title: title, subtitle: subtitle, icon: icon, color: color)
            }
            .buttonStyle(.plain)
        } else {
            cardLabel(title: title, subtitle: subtitle, icon: icon, color: color)
                .opacity(0.62)
        }
    }

    private func cardLabel(title: String, subtitle: String, icon: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title.bold())
                .foregroundStyle(.white)
                .frame(width: 58, height: 58)
                .background(color.gradient, in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: subtitle == "Coming soon" ? "lock.fill" : "arrow.right")
                .foregroundStyle(color)
        }
        .padding()
        .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(color.opacity(0.35), lineWidth: 2)
        }
    }
}
