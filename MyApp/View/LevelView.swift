import SwiftUI

struct LevelView: View {
    let level: LearningLevel
    let avatar: PlayerAvatar
    let onFinish: () -> Void
    let onPrizeWon: (WheelPrize) -> Void

    var body: some View {
        ZStack {
            level.color.opacity(0.12).ignoresSafeArea()

            VStack(spacing: 24) {
                AvatarView(avatar: avatar, size: 130)

                VStack(spacing: 8) {
                    Text(level.isBoss ? "FINAL BOSS" : "Level \(level.number)")
                        .font(.headline)
                        .foregroundStyle(level.color)
                    Text(level.title)
                        .font(.largeTitle.bold())
                    Text(level.number == 2
                         ? "Answer marine biology, music, and biomedical toxicity questions to earn a spin!"
                         : level.number == 3
                         ? "Choose a topic and complete its learning activity."
                         : "A fun \(level.subject.lowercased()) adventure is ready!")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }

                if level.number == 1 || level.isBoss {
                    NavigationLink {
                        NormalBattleView(
                            level: level,
                            avatar: avatar,
                            onFinish: onFinish
                        )
                    } label: {
                        Text(level.isBoss ? "Face the Quiz Dragon" : "Start Normal Battle")
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
                } else {
                    Text("This learning activity is coming soon.")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 18))
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
