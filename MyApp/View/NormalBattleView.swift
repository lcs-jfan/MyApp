import SwiftUI

struct NormalBattleView: View {
    @State private var viewModel: NormalBattleViewModel
    @Environment(\.dismiss) private var dismiss
    let avatar: PlayerAvatar
    let nextLevel: LearningLevel?

    init(level: LearningLevel, avatar: PlayerAvatar, nextLevel: LearningLevel?) {
        _viewModel = State(initialValue: NormalBattleViewModel(level: level))
        self.avatar = avatar
        self.nextLevel = nextLevel
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [viewModel.level.color.opacity(0.18), .white, .yellow.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Label(viewModel.level.isBoss ? "Final Battle" : "Normal Battle", systemImage: "bolt.fill")
                        .font(.headline.bold())
                        .foregroundStyle(viewModel.level.color)
                    Spacer()
                    Text(viewModel.level.subject)
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: viewModel.level.icon)
                        .font(.system(size: 44, weight: .bold))
                        .foregroundStyle(viewModel.level.color)

                    Text(viewModel.question.prompt)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.7)
                        .frame(maxWidth: 620)
                        .accessibilityAddTraits(.isHeader)
                }

                Spacer()

                answerGrid

                if viewModel.hasAnswered {
                    feedback
                }
            }
            .padding()
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(viewModel.level.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var answerGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            ForEach(viewModel.question.answers) { answer in
                Button {
                    viewModel.choose(answer)
                } label: {
                    Text(answer.text)
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 76)
                        .padding(.horizontal, 10)
                        .background(answerBackground(for: answer), in: RoundedRectangle(cornerRadius: 18))
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(answerBorder(for: answer), lineWidth: 4)
                        }
                }
                .buttonStyle(.plain)
                .disabled(viewModel.hasAnswered)
                .accessibilityLabel("Answer: \(answer.text)")
            }
        }
    }

    private var feedback: some View {
        VStack(spacing: 10) {
            Label(
                viewModel.answeredCorrectly ? "Correct! Great thinking!" : "Not quite. Try again!",
                systemImage: viewModel.answeredCorrectly ? "checkmark.circle.fill" : "arrow.clockwise.circle.fill"
            )
            .font(.headline.bold())
            .foregroundStyle(viewModel.answeredCorrectly ? .green : .orange)

            if !viewModel.answeredCorrectly {
                Button("Try again", action: viewModel.tryAgain)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(.orange, in: Capsule())
            } else if !viewModel.isLastQuestion {
                Button("Next question", action: viewModel.advanceToNextQuestion)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(viewModel.level.color, in: Capsule())
            } else if let nextLevel {
                NavigationLink {
                    NormalBattleView(
                        level: nextLevel,
                        avatar: avatar,
                        nextLevel: GameMapViewModel().nextLevel(after: nextLevel)
                    )
                } label: {
                    Label("Continue to \(nextLevel.title)", systemImage: "arrow.right.circle.fill")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(viewModel.level.color, in: Capsule())
                }
            } else {
                Button("Finish battle") {
                    dismiss()
                }
                .font(.subheadline.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(viewModel.level.color, in: Capsule())
            }
        }
        .accessibilityElement(children: .combine)
    }

    private func answerBackground(for answer: AnswerChoice) -> Color {
        guard viewModel.hasAnswered, answer.id == viewModel.selectedAnswerID else {
            return .white.opacity(0.82)
        }
        return viewModel.answeredCorrectly ? .green.opacity(0.22) : .orange.opacity(0.22)
    }

    private func answerBorder(for answer: AnswerChoice) -> Color {
        guard viewModel.hasAnswered, answer.id == viewModel.selectedAnswerID else {
            return .indigo.opacity(0.45)
        }
        return viewModel.answeredCorrectly ? .green : .orange
    }
}
