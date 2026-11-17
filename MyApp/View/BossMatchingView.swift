import SwiftUI

struct BossMatchingView: View {
    @Environment(GameState.self) private var gameState
    @State private var pairs: [MatchingPair]
    @State private var definitions: [MatchingPair]
    @State private var selectedTermID: String?
    @State private var matchedIDs: Set<String> = []
    @State private var feedback: String?
    let onFinish: () -> Void

    init(onFinish: @escaping () -> Void) {
        let shuffledPairs = MatchingPair.bossPairs.shuffled()
        _pairs = State(initialValue: shuffledPairs)
        _definitions = State(initialValue: shuffledPairs.shuffled())
        self.onFinish = onFinish
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.red.opacity(0.2), .white, .purple.opacity(0.16)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {
                    Label("Final Matching Challenge", systemImage: "flame.fill")
                        .font(.headline.bold())
                        .foregroundStyle(.red)

                    Text("Match every concept with its definition.")
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)

                    Text("\(matchedIDs.count) of \(pairs.count) matched")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)

                    HStack(alignment: .top, spacing: 14) {
                        choiceColumn(
                            title: "Concepts",
                            choices: pairs.map { ($0.id, $0.term) }
                        )

                        choiceColumn(
                            title: "Definitions",
                            choices: definitions.map { ($0.id, $0.definition) }
                        )
                    }

                    if let feedback {
                        Text(feedback)
                            .font(.headline)
                            .foregroundStyle(feedback.hasPrefix("Correct") ? .green : .orange)
                            .multilineTextAlignment(.center)
                    }

                    if matchedIDs.count == pairs.count {
                        Button("Complete Final Challenge", action: onFinish)
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(.red, in: Capsule())
                    } else {
                        Text("Tap a concept, then tap its matching definition.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(20)
                .frame(maxWidth: 820)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Quiz Dragon")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func choiceColumn(
        title: String,
        choices: [(String, String)]
    ) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.headline.bold())

            ForEach(choices, id: \.0) { choice in
                Button {
                    choose(choiceID: choice.0)
                } label: {
                    Text(choice.1)
                        .font(.subheadline.bold())
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, minHeight: 72)
                        .padding(.horizontal, 8)
                        .background(choiceBackground(for: choice.0), in: RoundedRectangle(cornerRadius: 14))
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(choiceBorder(for: choice.0), lineWidth: 3)
                        }
                }
                .buttonStyle(.plain)
                .disabled(matchedIDs.contains(choice.0))
                .accessibilityLabel("\(title.dropLast()): \(choice.1)")
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func choose(choiceID: String) {
        guard !matchedIDs.contains(choiceID) else {
            return
        }

        if let selectedTermID {
            if selectedTermID == choiceID {
                matchedIDs.insert(choiceID)
                feedback = "Correct! Keep matching."
            } else {
                gameState.loseHP()
                feedback = "Not quite. Try another definition."
            }
            self.selectedTermID = nil
        } else {
            selectedTermID = choiceID
            feedback = nil
        }
    }

    private func choiceBackground(for choiceID: String) -> Color {
        if matchedIDs.contains(choiceID) {
            return .green.opacity(0.2)
        }
        if selectedTermID == choiceID {
            return .yellow.opacity(0.3)
        }
        return .white.opacity(0.82)
    }

    private func choiceBorder(for choiceID: String) -> Color {
        if matchedIDs.contains(choiceID) {
            return .green
        }
        if selectedTermID == choiceID {
            return .orange
        }
        return .red.opacity(0.35)
    }
}
