import SwiftUI

struct LevelTesterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var completedLevel: LearningLevel?
    let levels: [LearningLevel]
    let avatar: PlayerAvatar
    let onPrizeWon: (WheelPrize) -> Void
    let onRoundComplete: (LearningLevel) -> Void
    let onOpenWardrobe: () -> Void

    var body: some View {
        NavigationStack {
            List(levels) { level in
                NavigationLink {
                    LevelView(
                        level: level,
                        avatar: avatar,
                        onFinish: {
                            onRoundComplete(level)
                            completedLevel = level
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
        .overlay {
            if let completedLevel {
                CompletionOverlayView(level: completedLevel) {
                    self.completedLevel = nil
                    dismiss()
                    onOpenWardrobe()
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
