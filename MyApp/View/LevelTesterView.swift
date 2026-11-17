import SwiftUI

struct LevelTesterView: View {
    @Environment(\.dismiss) private var dismiss
    let levels: [LearningLevel]
    let avatar: PlayerAvatar
    let onPrizeWon: (WheelPrize) -> Void
    let onRoundComplete: (LearningLevel) -> Void

    var body: some View {
        NavigationStack {
            List(levels) { level in
                NavigationLink {
                    LevelView(
                        level: level,
                        avatar: avatar,
                        onFinish: {
                            onRoundComplete(level)
                        },
                        onPrizeWon: onPrizeWon
                    )
                } label: {
                    Label("Level \(level.number): \(level.title)", systemImage: level.icon)
                }
            }
            .navigationTitle("Level Tester")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done", action: dismiss.callAsFunction)
                }
            }
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            HStack {
                Spacer()
                HPView()
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(.thinMaterial)
        }
    }
}
