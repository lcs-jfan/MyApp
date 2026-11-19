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

                    topicDiagramStrip

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

    private var topicDiagramStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                topicDiagram(title: "Dose-Response", color: .teal) {
                    Canvas { context, size in
                        var axes = Path()
                        axes.move(to: CGPoint(x: 20, y: size.height - 20))
                        axes.addLine(to: CGPoint(x: size.width - 12, y: size.height - 20))
                        axes.move(to: CGPoint(x: 20, y: size.height - 20))
                        axes.addLine(to: CGPoint(x: 20, y: 18))
                        context.stroke(axes, with: .color(.teal), lineWidth: 2)

                        var curve = Path()
                        curve.move(to: CGPoint(x: 24, y: size.height - 24))
                        curve.addCurve(
                            to: CGPoint(x: size.width - 18, y: 26),
                            control1: CGPoint(x: size.width * 0.42, y: size.height - 22),
                            control2: CGPoint(x: size.width * 0.68, y: 46)
                        )
                        context.stroke(curve, with: .color(.orange), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    }
                }

                topicDiagram(title: "Whale Anatomy", color: .blue) {
                    Canvas { context, size in
                        var whale = Path()
                        whale.move(to: CGPoint(x: 18, y: size.height * 0.50))
                        whale.addCurve(
                            to: CGPoint(x: size.width - 20, y: size.height * 0.45),
                            control1: CGPoint(x: size.width * 0.28, y: 16),
                            control2: CGPoint(x: size.width * 0.72, y: 16)
                        )
                        whale.addCurve(
                            to: CGPoint(x: 18, y: size.height * 0.50),
                            control1: CGPoint(x: size.width * 0.78, y: size.height - 12),
                            control2: CGPoint(x: size.width * 0.28, y: size.height - 12)
                        )
                        context.fill(whale, with: .color(.blue.opacity(0.65)))
                    }
                }

                topicDiagram(title: "Music Staff", color: .purple) {
                    Canvas { context, size in
                        for index in 0..<5 {
                            var line = Path()
                            let y = 30 + CGFloat(index) * 16
                            line.move(to: CGPoint(x: 18, y: y))
                            line.addLine(to: CGPoint(x: size.width - 18, y: y))
                            context.stroke(line, with: .color(.purple.opacity(0.72)), lineWidth: 2)
                        }
                        for (index, x) in [size.width * 0.34, size.width * 0.58, size.width * 0.82].enumerated() {
                            let note = CGRect(x: x - 8, y: 44 + CGFloat(index % 2) * 28, width: 16, height: 11)
                            context.fill(Ellipse().path(in: note), with: .color(.purple))
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }

    @ViewBuilder
    private func topicDiagram<Diagram: View>(
        title: String,
        color: Color,
        @ViewBuilder diagram: () -> Diagram
    ) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(color)
            diagram()
                .frame(width: 150, height: 110)
                .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 16))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.35), lineWidth: 2)
                }
        }
        .frame(width: 150)
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
