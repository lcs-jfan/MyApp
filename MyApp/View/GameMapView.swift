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
                                levels: viewModel.levelsByRoute[route] ?? [],
                                boss: viewModel.boss,
                                isSelected: route == viewModel.selectedRoute
                            )
                        }

                        ForEach(viewModel.allLevels) { level in
                            if level.trail == viewModel.selectedRoute && viewModel.isRouteConfirmed {
                                NavigationLink(value: level) {
                                    LevelNode(level: level)
                                }
                                .buttonStyle(.plain)
                                .position(level.position)
                            } else {
                                LevelNode(
                                    level: level,
                                    isLocked: true,
                                    selectedRoute: viewModel.selectedRoute,
                                    lockMessage: level.trail == viewModel.selectedRoute
                                        ? "Confirm your trail to unlock this level"
                                        : "Choose the \(viewModel.selectedRoute.name) to unlock this level"
                                )
                                .position(level.position)
                            }
                        }

                        if viewModel.isRouteConfirmed {
                            NavigationLink(value: viewModel.boss) {
                                LevelNode(level: viewModel.boss)
                            }
                            .buttonStyle(.plain)
                            .position(viewModel.boss.position)
                        } else {
                            LevelNode(
                                level: viewModel.boss,
                                isLocked: true,
                                lockMessage: "Confirm your trail to unlock the boss"
                            )
                            .position(viewModel.boss.position)
                        }
                    }
                    .frame(width: 1160, height: 900)
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
                                .disabled(viewModel.isRouteConfirmed)
                                .accessibilityAddTraits(route == viewModel.selectedRoute ? .isSelected : [])
                            }
                        }
                        .padding(.horizontal, 4)
                    }

                    if viewModel.isRouteConfirmed {
                        Label("\(viewModel.selectedRoute.name) confirmed", systemImage: "checkmark.seal.fill")
                            .font(.subheadline.bold())
                            .foregroundStyle(.green)
                    } else {
                        Button("Confirm \(viewModel.selectedRoute.name)") {
                            viewModel.confirmRoute()
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 9)
                        .background(viewModel.selectedRoute.color, in: Capsule())
                        .accessibilityHint("Locks this trail and unlocks its learning levels")
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
            guard let firstLevel = levels.first, let lastLevel = levels.last else {
                return
            }

            path.move(to: firstLevel.position)

            for index in 1..<levels.count {
                let previous = levels[index - 1].position
                let current = levels[index].position
                let curveOffset: CGFloat = route == .forest ? 70 : (route == .rainbow ? -55 : 45)
                path.addCurve(
                    to: current,
                    control1: CGPoint(x: previous.x + 70, y: previous.y + curveOffset),
                    control2: CGPoint(x: current.x - 70, y: current.y - curveOffset)
                )
            }

            path.addCurve(
                to: boss.position,
                control1: CGPoint(x: lastLevel.position.x + 90, y: lastLevel.position.y),
                control2: CGPoint(x: boss.position.x - 110, y: boss.position.y)
            )
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
    var isLocked = false
    var selectedRoute: AdventureRoute?
    var lockMessage: String?

    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Image(systemName: isLocked ? "lock.fill" : level.icon)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .frame(width: 68, height: 68)
                    .background((isLocked ? .gray : level.color).gradient, in: Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 5))
                    .shadow(
                        color: isLocked ? .clear : level.color.opacity(0.35),
                        radius: 8,
                        y: 4
                    )
            }
            Text(level.isBoss ? "BOSS" : "Level \(level.number)")
                .font(.caption.bold())
                .foregroundStyle(isLocked ? .secondary : (level.isBoss ? level.color : .primary))
        }
        .frame(width: 115)
        .opacity(isLocked ? 0.62 : 1)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            isLocked
                ? "\(level.title), locked"
                : (level.isBoss ? "Final boss, \(level.title)" : "Level \(level.number), \(level.title)")
        )
        .accessibilityHint(
            isLocked
                ? (lockMessage ?? "Choose the \(selectedRoute?.name ?? "selected") to unlock this level")
                : "Opens \(level.subject)"
        )
    }
}
