import SwiftUI

struct AnatomyActivityView: View {
    let onFinish: () -> Void
    @State private var partIndex = 0
    @State private var completedPartIDs: Set<String> = []
    @State private var feedback: String?
    @State private var highlightPulse = false

    private let parts = AnatomyPart.all

    private var currentPart: AnatomyPart {
        parts[partIndex]
    }

    private var isComplete: Bool {
        completedPartIDs.count == parts.count
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.22), .white, .cyan.opacity(0.18)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {
                    Label("Marine Biology", systemImage: "water.waves")
                        .font(.headline.bold())
                        .foregroundStyle(.blue)

                    Text("Whale Anatomy")
                        .font(.largeTitle.bold())

                    Text("Tap the correct part of the whale to fill in the diagram.")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)

                    whaleDiagram

                    VStack(spacing: 8) {
                        Text("Find the \(currentPart.name)")
                            .font(.title2.bold())
                        Text("Part \(partIndex + 1) of \(parts.count)")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                    }

                    if let feedback {
                        Text(feedback)
                            .font(.headline)
                            .foregroundStyle(feedback.hasPrefix("Correct") ? .green : .orange)
                            .multilineTextAlignment(.center)
                    }

                    if isComplete {
                        Button("Complete Marine Biology Activity", action: onFinish)
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(.blue, in: Capsule())
                    } else if completedPartIDs.contains(currentPart.id) {
                        Button("Next body part") {
                            partIndex += 1
                            feedback = nil
                        }
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.teal, in: Capsule())
                    }
                }
                .padding(24)
                .frame(maxWidth: 680)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Whale Anatomy")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var whaleDiagram: some View {
        GeometryReader { geometry in
            ZStack {
                whaleIllustration

                Circle()
                    .fill(.yellow.opacity(highlightPulse ? 0.12 : 0.24))
                    .frame(width: 62, height: 62)
                    .overlay {
                        Circle()
                            .stroke(.yellow, style: StrokeStyle(lineWidth: 4, dash: [7, 5]))
                    }
                    .shadow(color: .yellow.opacity(0.7), radius: highlightPulse ? 14 : 6)
                    .scaleEffect(highlightPulse ? 1.12 : 0.94)
                    .position(
                        x: geometry.size.width * currentPart.x,
                        y: geometry.size.height * currentPart.y
                    )

                ForEach(parts) { part in
                    Button {
                        select(part)
                    } label: {
                        Color.clear
                            .frame(width: 58, height: 58)
                            .contentShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(part.number), \(part.name)")
                    .position(
                        x: geometry.size.width * part.x,
                        y: geometry.size.height * part.y
                    )
                }
            }
        }
        .frame(height: 300)
        .padding(.horizontal, 8)
        .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 26))
        .onAppear {
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                highlightPulse = true
            }
        }
    }

    private var whaleIllustration: some View {
        Canvas { context, size in
            let body = Path { path in
                path.move(to: CGPoint(x: size.width * 0.14, y: size.height * 0.54))
                path.addCurve(
                    to: CGPoint(x: size.width * 0.82, y: size.height * 0.43),
                    control1: CGPoint(x: size.width * 0.28, y: size.height * 0.17),
                    control2: CGPoint(x: size.width * 0.68, y: size.height * 0.20)
                )
                path.addCurve(
                    to: CGPoint(x: size.width * 0.84, y: size.height * 0.64),
                    control1: CGPoint(x: size.width * 0.94, y: size.height * 0.48),
                    control2: CGPoint(x: size.width * 0.91, y: size.height * 0.62)
                )
                path.addCurve(
                    to: CGPoint(x: size.width * 0.23, y: size.height * 0.74),
                    control1: CGPoint(x: size.width * 0.65, y: size.height * 0.82),
                    control2: CGPoint(x: size.width * 0.34, y: size.height * 0.84)
                )
                path.addCurve(
                    to: CGPoint(x: size.width * 0.14, y: size.height * 0.54),
                    control1: CGPoint(x: size.width * 0.14, y: size.height * 0.69),
                    control2: CGPoint(x: size.width * 0.10, y: size.height * 0.60)
                )
                path.closeSubpath()
            }

            let underside = Path { path in
                path.move(to: CGPoint(x: size.width * 0.19, y: size.height * 0.65))
                path.addCurve(
                    to: CGPoint(x: size.width * 0.82, y: size.height * 0.63),
                    control1: CGPoint(x: size.width * 0.40, y: size.height * 0.86),
                    control2: CGPoint(x: size.width * 0.65, y: size.height * 0.78)
                )
                path.addCurve(
                    to: CGPoint(x: size.width * 0.19, y: size.height * 0.65),
                    control1: CGPoint(x: size.width * 0.63, y: size.height * 0.72),
                    control2: CGPoint(x: size.width * 0.29, y: size.height * 0.76)
                )
                path.closeSubpath()
            }

            let tailTop = Path { path in
                path.move(to: CGPoint(x: size.width * 0.17, y: size.height * 0.55))
                path.addCurve(
                    to: CGPoint(x: size.width * 0.03, y: size.height * 0.39),
                    control1: CGPoint(x: size.width * 0.11, y: size.height * 0.50),
                    control2: CGPoint(x: size.width * 0.06, y: size.height * 0.41)
                )
                path.addCurve(
                    to: CGPoint(x: size.width * 0.24, y: size.height * 0.51),
                    control1: CGPoint(x: size.width * 0.11, y: size.height * 0.44),
                    control2: CGPoint(x: size.width * 0.19, y: size.height * 0.50)
                )
                path.closeSubpath()
            }

            let tailBottom = Path { path in
                path.move(to: CGPoint(x: size.width * 0.17, y: size.height * 0.58))
                path.addCurve(
                    to: CGPoint(x: size.width * 0.05, y: size.height * 0.74),
                    control1: CGPoint(x: size.width * 0.10, y: size.height * 0.62),
                    control2: CGPoint(x: size.width * 0.06, y: size.height * 0.70)
                )
                path.addCurve(
                    to: CGPoint(x: size.width * 0.24, y: size.height * 0.62),
                    control1: CGPoint(x: size.width * 0.11, y: size.height * 0.70),
                    control2: CGPoint(x: size.width * 0.19, y: size.height * 0.63)
                )
                path.closeSubpath()
            }

            let pectoralFin = Path { path in
                path.move(to: CGPoint(x: size.width * 0.52, y: size.height * 0.68))
                path.addCurve(
                    to: CGPoint(x: size.width * 0.43, y: size.height * 0.96),
                    control1: CGPoint(x: size.width * 0.51, y: size.height * 0.78),
                    control2: CGPoint(x: size.width * 0.43, y: size.height * 0.91)
                )
                path.addCurve(
                    to: CGPoint(x: size.width * 0.61, y: size.height * 0.69),
                    control1: CGPoint(x: size.width * 0.51, y: size.height * 0.88),
                    control2: CGPoint(x: size.width * 0.59, y: size.height * 0.75)
                )
                path.closeSubpath()
            }

            let dorsalFin = Path { path in
                path.move(to: CGPoint(x: size.width * 0.65, y: size.height * 0.31))
                path.addCurve(
                    to: CGPoint(x: size.width * 0.72, y: size.height * 0.10),
                    control1: CGPoint(x: size.width * 0.69, y: size.height * 0.24),
                    control2: CGPoint(x: size.width * 0.72, y: size.height * 0.15)
                )
                path.addCurve(
                    to: CGPoint(x: size.width * 0.77, y: size.height * 0.34),
                    control1: CGPoint(x: size.width * 0.75, y: size.height * 0.16),
                    control2: CGPoint(x: size.width * 0.77, y: size.height * 0.27)
                )
                path.closeSubpath()
            }

            context.fill(tailTop, with: .linearGradient(.init(colors: [.blue.opacity(0.88), .indigo]), startPoint: .zero, endPoint: CGPoint(x: size.width, y: size.height)))
            context.fill(tailBottom, with: .linearGradient(.init(colors: [.blue.opacity(0.88), .indigo]), startPoint: .zero, endPoint: CGPoint(x: size.width, y: size.height)))
            context.fill(body, with: .linearGradient(.init(colors: [.blue.opacity(0.95), .indigo.opacity(0.92)]), startPoint: .zero, endPoint: CGPoint(x: size.width, y: size.height)))
            context.fill(underside, with: .linearGradient(.init(colors: [.gray.opacity(0.30), .white.opacity(0.72)]), startPoint: .zero, endPoint: CGPoint(x: 0, y: size.height)))
            context.fill(pectoralFin, with: .linearGradient(.init(colors: [.blue.opacity(0.82), .indigo]), startPoint: .zero, endPoint: CGPoint(x: size.width, y: size.height)))
            context.fill(dorsalFin, with: .linearGradient(.init(colors: [.blue.opacity(0.86), .indigo]), startPoint: .zero, endPoint: CGPoint(x: size.width, y: size.height)))

            context.fill(
                Path(ellipseIn: CGRect(x: size.width * 0.76, y: size.height * 0.39, width: 12, height: 12)),
                with: .color(.white)
            )
            context.fill(
                Path(ellipseIn: CGRect(x: size.width * 0.765, y: size.height * 0.395, width: 7, height: 7)),
                with: .color(.black)
            )
            context.stroke(
                Path { path in
                    path.move(to: CGPoint(x: size.width * 0.80, y: size.height * 0.59))
                    path.addCurve(
                        to: CGPoint(x: size.width * 0.87, y: size.height * 0.57),
                        control1: CGPoint(x: size.width * 0.83, y: size.height * 0.61),
                        control2: CGPoint(x: size.width * 0.85, y: size.height * 0.60)
                    )
                },
                with: .color(.white.opacity(0.72)),
                lineWidth: 3
            )
            context.stroke(
                Path(roundedRect: CGRect(x: size.width * 0.605, y: size.height * 0.21, width: 18, height: 9), cornerRadius: 4),
                with: .color(.white.opacity(0.75)),
                lineWidth: 3
            )
        }
    }

    private func select(_ part: AnatomyPart) {
        guard !completedPartIDs.contains(part.id) else {
            return
        }

        if part == currentPart {
            completedPartIDs.insert(part.id)
            feedback = "Correct! You found the \(part.name)."
        } else {
            feedback = "Not quite. Look for the \(currentPart.name)."
        }
    }
}

private struct AnatomyPart: Identifiable, Equatable {
    let id: String
    let number: Int
    let name: String
    let x: CGFloat
    let y: CGFloat

    static let all = [
        AnatomyPart(id: "blowhole", number: 1, name: "blowhole", x: 0.60, y: 0.22),
        AnatomyPart(id: "eye", number: 2, name: "eye", x: 0.72, y: 0.39),
        AnatomyPart(id: "fin", number: 3, name: "pectoral fin", x: 0.42, y: 0.78),
        AnatomyPart(id: "tail", number: 4, name: "tail fluke", x: 0.16, y: 0.48)
    ]
}
