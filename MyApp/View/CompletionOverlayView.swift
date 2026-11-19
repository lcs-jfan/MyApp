import SwiftUI

struct CompletionOverlayView: View {
    let level: LearningLevel
    let hasNewItem: Bool
    let onReturnToWardrobe: () -> Void
    let onCheckBackpack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Image(systemName: "party.popper.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(.yellow)

                Text("Congratulations!")
                    .font(.largeTitle.bold())

                Text("You completed \(level.title).")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                if level.isBoss {
                    Button("Return to Wardrobe", action: onReturnToWardrobe)
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 13)
                        .background(.indigo, in: Capsule())
                } else if hasNewItem {
                    Button("Check Backpack", action: onCheckBackpack)
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 13)
                        .background(.indigo, in: Capsule())
                } else {
                    Button("Continue", action: onContinue)
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 13)
                        .background(.indigo, in: Capsule())
                }
            }
            .padding(28)
            .frame(maxWidth: 420)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28))
            .shadow(radius: 24)
            .padding(24)
        }
        .accessibilityAddTraits(.isModal)
    }
}
