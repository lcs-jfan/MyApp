import SwiftUI

struct PrizeWheelView: View {
    @State private var viewModel: PrizeWheelViewModel
    let avatar: PlayerAvatar
    let onPrizeWon: (WheelPrize) -> Void
    let onFinish: () -> Void
    @State private var wheelRotation = 0.0

    init(
        level: LearningLevel,
        avatar: PlayerAvatar,
        onPrizeWon: @escaping (WheelPrize) -> Void,
        onFinish: @escaping () -> Void
    ) {
        _viewModel = State(initialValue: PrizeWheelViewModel(level: level))
        self.avatar = avatar
        self.onPrizeWon = onPrizeWon
        self.onFinish = onFinish
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.yellow.opacity(0.25), .pink.opacity(0.15), .blue.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {
                    HStack {
                        Label("Prize Wheel", systemImage: "circle.dotted.and.circle")
                            .font(.headline.bold())
                            .foregroundStyle(.pink)
                        Spacer()
                        Text("Question \(viewModel.attemptNumber) of \(viewModel.questionCount)")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                    }

                    Text("Answer a question correctly to earn a spin!")
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)

                    wheel

                    if let wonPrize = viewModel.wonPrize {
                        prizeResult(wonPrize)
                    } else {
                        questionCard
                    }
                }
                .padding()
                .frame(maxWidth: 680)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(viewModel.level.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var wheel: some View {
        ZStack {
            Circle()
                .fill(
                    AngularGradient(
                        colors: viewModel.prizes.map(\.color),
                        center: .center
                    )
                )
                .frame(width: 250, height: 250)
                .overlay {
                    Circle()
                        .stroke(.white, lineWidth: 8)
                }
                .rotationEffect(.degrees(wheelRotation))
                .shadow(color: .pink.opacity(0.3), radius: 12, y: 6)

            ForEach(Array(viewModel.prizes.enumerated()), id: \.element.id) { index, prize in
                Image(systemName: prize.icon)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .offset(y: -88)
                    .rotationEffect(.degrees(Double(index) * 60))
                    .rotationEffect(.degrees(-wheelRotation))
            }

            Circle()
                .fill(.white)
                .frame(width: 66, height: 66)
                .overlay {
                    Text(viewModel.hasSpun ? "Won!" : "Spin")
                        .font(.headline.bold())
                        .foregroundStyle(.pink)
                }

            Image(systemName: "arrowtriangle.down.fill")
                .font(.title)
                .foregroundStyle(.red)
                .offset(y: -142)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Prize wheel")
    }

    private var questionCard: some View {
        VStack(spacing: 14) {
            Text(viewModel.question.prompt)
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(viewModel.question.answers) { answer in
                    Button {
                        viewModel.choose(answer)
                    } label: {
                        Text(answer.text)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 58)
                            .background(.white.opacity(0.85), in: RoundedRectangle(cornerRadius: 14))
                            .overlay {
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(.pink.opacity(0.5), lineWidth: 3)
                            }
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.hasAnswered || viewModel.correctAnswerFound)
                }
            }

            if viewModel.hasAnswered {
                if viewModel.answeredCorrectly {
                    Button("Spin the wheel", action: spinWheel)
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 11)
                        .background(.pink, in: Capsule())
                } else if viewModel.attemptNumber < viewModel.questionCount {
                    Button("Next question", action: viewModel.nextQuestion)
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 11)
                        .background(.orange, in: Capsule())
                } else {
                    Text("That was your last chance. Try this level again later!")
                        .font(.subheadline.bold())
                        .foregroundStyle(.orange)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
    }

    private func prizeResult(_ prize: WheelPrize) -> some View {
        VStack(spacing: 12) {
            Image(systemName: prize.icon)
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(prize.color)
            Text("You won \(prize.title)!")
                .font(.title2.bold())
            Text("Your new prize has been added to your collection.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("Return to map") {
                onPrizeWon(prize)
                onFinish()
            }
            .font(.headline.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 11)
            .background(.green, in: Capsule())
        }
        .padding()
        .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 22))
    }

    private func spinWheel() {
        withAnimation(.easeOut(duration: 2.2)) {
            wheelRotation += Double.random(in: 1080...1800)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            viewModel.spin()
        }
    }
}
