import SwiftUI

struct GameMapView: View {
    @Bindable var viewModel: GameMapViewModel
    @State private var navigationPath: [LearningLevel] = []
    @State private var showsLevelTester = false
    @State private var completedLevel: LearningLevel?
    @State private var showsBackpack = false
    @State private var completedWithNewItem = false
    @State private var showsRouteSelection = false
    let avatar: PlayerAvatar
    let backpackItems: [WheelPrize]
    let roundNumber: Int
    let onOpenWardrobe: () -> Void
    let onStartNewRound: () -> Void
    let onPrizeWon: (WheelPrize) -> Void

    var body: some View {
        NavigationStack(path: $navigationPath) {
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
                            let isCompleted = viewModel.completedLevelIDs.contains(level.id)
                            if viewModel.isUnlocked(level) && !isCompleted {
                                NavigationLink(value: level) {
                                    LevelNode(level: level)
                                }
                                .buttonStyle(.plain)
                                .simultaneousGesture(TapGesture().onEnded {
                                    completedWithNewItem = false
                                })
                                .position(level.position)
                            } else {
                                LevelNode(
                                    level: level,
                                    isLocked: !isCompleted && !viewModel.isUnlocked(level),
                                    isPreview: false,
                                    isCompleted: isCompleted,
                                    selectedRoute: viewModel.selectedRoute,
                                    lockMessage: viewModel.lockMessage(for: level)
                                )
                                .position(level.position)
                            }
                        }

                        let isBossCompleted = viewModel.completedLevelIDs.contains(viewModel.boss.id)
                        if viewModel.isUnlocked(viewModel.boss) && !isBossCompleted {
                            NavigationLink(value: viewModel.boss) {
                                LevelNode(level: viewModel.boss)
                            }
                            .buttonStyle(.plain)
                            .simultaneousGesture(TapGesture().onEnded {
                                completedWithNewItem = false
                            })
                            .position(viewModel.boss.position)
                        } else {
                            LevelNode(
                                level: viewModel.boss,
                                isLocked: !isBossCompleted,
                                isCompleted: isBossCompleted,
                                selectedRoute: viewModel.selectedRoute,
                                lockMessage: viewModel.lockMessage(for: viewModel.boss)
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
                            Text("Round \(roundNumber) • Drag the map and pick a path!")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button("Test levels", systemImage: "hammer.fill") {
                            showsLevelTester = true
                        }
                        .labelStyle(.iconOnly)
                        .font(.title2)
                        .foregroundStyle(.orange)
                        .padding(12)
                        .background(.ultraThinMaterial, in: Circle())
                        .accessibilityLabel("Test levels directly")
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
                LevelView(
                    level: level,
                    avatar: avatar,
                    onFinish: {
                        viewModel.markCompleted(level)
                        navigationPath.removeAll()
                        completedLevel = level
                    },
                    onPrizeWon: { prize in
                        let isNewItem = !backpackItems.contains(where: { $0.title == prize.title })
                        onPrizeWon(prize)
                        completedWithNewItem = isNewItem
                    }
                )
            }
        }
        .sheet(isPresented: $showsLevelTester) {
            LevelTesterView(
                levels: viewModel.allLevels + [viewModel.boss],
                avatar: avatar,
                backpackItems: backpackItems,
                onPrizeWon: onPrizeWon,
                onRoundComplete: { level in
                    viewModel.markCompleted(level)
                    showsLevelTester = false
                    completedLevel = level
                },
                onOpenWardrobe: onStartNewRound
            )
        }
        .overlay {
            if let completedLevel {
                CompletionOverlayView(
                    level: completedLevel,
                    hasNewItem: completedWithNewItem,
                    onReturnToWardrobe: {
                        self.completedLevel = nil
                        onStartNewRound()
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
        .overlay {
            if showsRouteSelection {
                routeSelectionOverlay
            }
        }
        .onAppear {
            if !viewModel.isRouteConfirmed {
                showsRouteSelection = true
            }
        }
    }

    private var routeSelectionOverlay: some View {
        ZStack {
            Color.black.opacity(0.58)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("Choose Your Route")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)

                Text("Select one trail for this round.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                VStack(spacing: 12) {
                    ForEach(AdventureRoute.allCases) { route in
                        Button {
                            viewModel.selectedRoute = route
                            viewModel.confirmRoute()
                            showsRouteSelection = false
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: route.icon)
                                    .font(.title2.bold())
                                    .frame(width: 48, height: 48)
                                    .foregroundStyle(.white)
                                    .background(route.color.gradient, in: Circle())

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(route.name)
                                        .font(.title3.bold())
                                        .foregroundStyle(.primary)
                                    Text(routeDescription(for: route))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(route.color)
                            }
                            .padding()
                            .background(.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 18))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(22)
            .frame(maxWidth: 520)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28))
            .shadow(radius: 28)
            .padding(20)
        }
    }

    private func routeDescription(for route: AdventureRoute) -> String {
        switch route {
        case .sunny:
            "Discovery, mixed topics, and the Sky Castle"
        case .forest:
            "Nature, writing, science, and logic"
        case .rainbow:
            "Art, music, space, and puzzles"
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
    var isPreview = false
    var isCompleted = false
    var selectedRoute: AdventureRoute?
    var lockMessage: String?

    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : (isLocked ? "lock.fill" : level.icon))
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .frame(width: 68, height: 68)
                    .background((isCompleted ? .green : (isLocked ? .gray : level.color)).gradient, in: Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 5))
                    .shadow(
                        color: isLocked ? .clear : level.color.opacity(0.35),
                        radius: 8,
                        y: 4
                    )

                if isPreview {
                    Image(systemName: "lock.fill")
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                        .padding(5)
                        .background(.black.opacity(0.55), in: Circle())
                        .offset(x: 25, y: -25)
                }
            }
            Text(isCompleted ? "Passed" : (level.isBoss ? "BOSS" : "Level \(level.number)"))
                .font(.caption.bold())
                .foregroundStyle(isCompleted ? .green : (isLocked ? .secondary : (level.isBoss ? level.color : .primary)))
        }
        .frame(width: 115)
        .opacity(isLocked && !isPreview && !isCompleted ? 0.62 : 1)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            isCompleted
                ? "\(level.title), passed"
                : (isLocked
                ? "\(level.title), locked"
                : (isPreview
                    ? "\(level.title), route preview"
                    : (level.isBoss ? "Final boss, \(level.title)" : "Level \(level.number), \(level.title)")))
        )
        .accessibilityHint(
            isCompleted
                ? "This level has already been passed"
                : (isLocked || isPreview
                ? (lockMessage ?? "Choose the \(selectedRoute?.name ?? "selected") to unlock this level")
                : "Opens \(level.subject)")
        )
    }
}
