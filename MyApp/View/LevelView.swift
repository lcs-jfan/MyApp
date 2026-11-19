import SwiftUI

struct LevelView: View {
    let level: LearningLevel
    let avatar: PlayerAvatar
    let onFinish: () -> Void
    let onPrizeWon: (WheelPrize) -> Void

    private var levelCover: some View {
        VStack(spacing: 12) {
            Text(level.isBoss ? "FINAL BOSS" : "Level \(level.number)")
                .font(.headline.bold())
                .foregroundStyle(level.color)
            Text(level.title)
                .font(.largeTitle.bold())

            if level.isBoss {
                Label("Match concepts with their definitions across all three topic areas.", systemImage: "flame.fill")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.red.gradient, in: RoundedRectangle(cornerRadius: 18))
            } else if level.number == 2 {
                VStack(spacing: 10) {
                    Label("Answer 3 learning questions", systemImage: "questionmark.circle.fill")
                        .font(.title3.bold())
                    Text("Each correct answer earns a spin. Win a new backpack item!")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(.pink.opacity(0.12), in: RoundedRectangle(cornerRadius: 18))
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(level.color.opacity(0.55), lineWidth: 2)
                }
            } else if level.number == 3 {
                Label("Choose one topic and complete its diagram or learning activity.", systemImage: "square.grid.2x2.fill")
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue.opacity(0.10), in: RoundedRectangle(cornerRadius: 18))
            } else if level.number == 4 {
                Label("Rest, recover HP, or find a backpack item.", systemImage: "campfire.fill")
                    .font(.title3.bold())
                    .foregroundStyle(.brown)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.orange.opacity(0.12), in: RoundedRectangle(cornerRadius: 18))
            } else {
                Label("Complete the normal battle by answering all learning questions.", systemImage: "bolt.fill")
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(level.color.opacity(0.10), in: RoundedRectangle(cornerRadius: 18))
            }
        }
    }

    var body: some View {
        ZStack {
            level.color.opacity(0.12).ignoresSafeArea()

            VStack(spacing: 24) {
                AvatarView(avatar: avatar, size: 130)

                levelCover

                if level.isBoss {
                    NavigationLink {
                        BossMatchingView(onFinish: onFinish)
                    } label: {
                        Text("Start Final Match")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(level.color.gradient, in: RoundedRectangle(cornerRadius: 18))
                    }
                    .accessibilityHint("Match four concepts with their definitions")
                } else if level.number == 1 {
                    NavigationLink {
                        NormalBattleView(
                            level: level,
                            avatar: avatar,
                            onFinish: onFinish
                        )
                    } label: {
                        Text("Start Normal Battle")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(level.color.gradient, in: RoundedRectangle(cornerRadius: 18))
                    }
                    .accessibilityHint("Starts the \(level.title) learning activity")
                } else if level.number == 2 {
                    NavigationLink {
                        PrizeWheelView(
                            level: level,
                            avatar: avatar,
                            onPrizeWon: onPrizeWon,
                            onFinish: onFinish
                        )
                    } label: {
                        Text("Start Prize Wheel")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(level.color.gradient, in: RoundedRectangle(cornerRadius: 18))
                    }
                    .accessibilityHint("Answer up to three questions to earn a prize wheel spin")
                } else if level.number == 3 {
                    NavigationLink {
                        TopicSelectionView(
                            avatar: avatar,
                            onFinish: onFinish
                        )
                    } label: {
                        Text("Choose a Topic")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(level.color.gradient, in: RoundedRectangle(cornerRadius: 18))
                    }
                    .accessibilityHint("Choose a topic for the learning activity")
                } else if level.number == 4 {
                    NavigationLink {
                        CampfireView(
                            onPrizeWon: onPrizeWon,
                            onFinish: onFinish
                        )
                    } label: {
                        Text("Visit the Campfire")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(level.color.gradient, in: RoundedRectangle(cornerRadius: 18))
                    }
                    .accessibilityHint("Choose between resting and finding a random item")
                } else {
                    NavigationLink {
                        NormalBattleView(
                            level: level,
                            avatar: avatar,
                            onFinish: onFinish
                        )
                    } label: {
                        Text("Start Normal Battle")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(level.color.gradient, in: RoundedRectangle(cornerRadius: 18))
                    }
                    .accessibilityHint("Starts the \(level.title) learning activity")
                }

                Text(level.isBoss ? "Answer the final challenge to become a Learning Land legend!" : "More puzzles and rewards are coming soon.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(28)
            .frame(maxWidth: 520)
        }
        .navigationTitle(level.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
