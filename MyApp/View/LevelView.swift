import SwiftUI

struct LevelView: View {
    let level: LearningLevel
    let avatar: PlayerAvatar
    let onFinish: () -> Void

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
                    Text("A fun \(level.subject.lowercased()) adventure is ready!")
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
