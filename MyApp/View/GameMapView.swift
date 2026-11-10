import SwiftUI

struct GameMapView: View {
    @State private var viewModel = GameMapViewModel()
    let avatar: PlayerAvatar
    let onOpenWardrobe: () -> Void

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    ZStack {
                        LinearGradient(
                            colors: [.cyan.opacity(0.32), .green.opacity(0.3), .yellow.opacity(0.28)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )

                        MapDecorations()

                        ForEach(AdventureRoute.allCases) { route in
                            RoutePath(
                                route: route,
                                levels: viewModel.levels,
                                boss: viewModel.boss,
                                isSelected: route == viewModel.selectedRoute
                            )
                        }

                        ForEach(viewModel.levels) { level in
                            NavigationLink(value: level) {
                                LevelNode(level: level)
                            }
                            .buttonStyle(.plain)
                            .position(level.position)
                        }

                        NavigationLink(value: viewModel.boss) {
                            LevelNode(level: viewModel.boss)
                        }
                        .buttonStyle(.plain)
                        .position(viewModel.boss.position)
                    }
                    .frame(width: 1120, height: 760)
                }
                .ignoresSafeArea(edges: .bottom)

                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        AvatarView(avatar: avatar, size: 62)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Learning Land")
                                .font(.title2.bold())
                            Text("Drag the map and pick a path!")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button("Wardrobe", systemImage: "tshirt.fill", action: onOpenWardrobe)
                            .labelStyle(.iconOnly)
                            .font(.title2)
                            .foregroundStyle(.indigo)
                            .padding(12)
                            .background(.ultraThinMaterial, in: Circle())
                            .accessibilityLabel("Open wardrobe")
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(AdventureRoute.allCases) { route in
                                Button {
                                    viewModel.selectedRoute = route
                                } label: {
                                    Label(route.name, systemImage: route.icon)
                                        .font(.subheadline.bold())
                                        .foregroundStyle(route == viewModel.selectedRoute ? .white : route.color)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            route == viewModel.selectedRoute ? route.color : .white.opacity(0.78),
                                            in: Capsule()
                                        )
                                }
                                .buttonStyle(.plain)
                                .accessibilityAddTraits(route == viewModel.selectedRoute ? .isSelected : [])
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.regularMaterial)
            }
            .navigationDestination(for: LearningLevel.self) { level in
                LevelView(level: level, avatar: avatar)
            }
        }
    }
}

private struct RoutePath: View {
    let route: AdventureRoute
    let levels: [LearningLevel]
    let boss: LearningLevel
    let isSelected: Bool

    var body: some View {
        routeShape
            .stroke(
                isSelected ? route.color : .white.opacity(0.48),
                style: StrokeStyle(
                    lineWidth: isSelected ? 15 : 7,
                    lineCap: .round,
                    lineJoin: .round,
                    dash: route == .rainbow ? [18, 12] : []
                )
            )
            .shadow(color: isSelected ? route.color.opacity(0.3) : .clear, radius: 8, y: 3)
            .opacity(isSelected ? 1 : 0.55)
    }

    private var routeShape: Path {
        Path { path in
            path.move(to: levels[0].position)
            switch route {
            case .sunny:
                path.addCurve(to: levels[1].position, control1: CGPoint(x: 210, y: 390), control2: CGPoint(x: 300, y: 410))
                path.addCurve(to: levels[2].position, control1: CGPoint(x: 450, y: 260), control2: CGPoint(x: 550, y: 620))
                path.addCurve(to: levels[3].position, control1: CGPoint(x: 680, y: 400), control2: CGPoint(x: 720, y: 260))
            case .forest:
                path.addCurve(to: levels[1].position, control1: CGPoint(x: 185, y: 650), control2: CGPoint(x: 300, y: 540))
                path.addCurve(to: levels[2].position, control1: CGPoint(x: 450, y: 180), control2: CGPoint(x: 530, y: 320))
                path.addCurve(to: levels[3].position, control1: CGPoint(x: 690, y: 610), control2: CGPoint(x: 720, y: 390))
            case .rainbow:
                path.addCurve(to: levels[1].position, control1: CGPoint(x: 280, y: 500), control2: CGPoint(x: 280, y: 180))
                path.addCurve(to: levels[2].position, control1: CGPoint(x: 430, y: 350), control2: CGPoint(x: 520, y: 700))
                path.addCurve(to: levels[3].position, control1: CGPoint(x: 680, y: 200), control2: CGPoint(x: 690, y: 100))
            }
            path.addCurve(to: boss.position, control1: CGPoint(x: 850, y: 160), control2: CGPoint(x: 900, y: 125))
        }
    }
}

private struct MapDecorations: View {
    var body: some View {
        ZStack {
            ForEach(0..<14, id: \.self) { index in
                Image(systemName: index.isMultiple(of: 2) ? "cloud.fill" : "tree.fill")
                    .font(.system(size: index.isMultiple(of: 2) ? 34 : 42))
                    .foregroundStyle(index.isMultiple(of: 2) ? .white.opacity(0.65) : .green.opacity(0.55))
                    .position(
                        x: CGFloat((index * 137) % 900) + 35,
                        y: CGFloat((index * 83) % 650) + 35
                    )
            }
        }
    }
}

private struct LevelNode: View {
    let level: LearningLevel

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: level.icon)
                .font(.title.bold())
                .foregroundStyle(.white)
                .frame(width: 68, height: 68)
                .background(level.color.gradient, in: Circle())
                .overlay(Circle().stroke(.white, lineWidth: 5))
                .shadow(color: level.color.opacity(0.35), radius: 8, y: 4)
            Text(level.isBoss ? "BOSS" : "Level \(level.number)")
                .font(.caption.bold())
                .foregroundStyle(level.isBoss ? level.color : .primary)
        }
        .frame(width: 115)
        .accessibilityLabel("Level \(level.number), \(level.title)")
        .accessibilityHint("Opens \(level.subject)")
    }
}
