 
 
 
 
 
 
 
 
 

import SwiftUI

@main
struct MyAppApp: App {
    @State private var gameState = GameState()

    var body: some Scene {
        WindowGroup {

            ContentView()
                .environment(gameState)
        }
    }
}

 
 
 
 
 
 
 

struct BattleQuestion {
    let prompt: String
    let answers: [AnswerChoice]
    let correctAnswerID: Int


    func isCorrect(_ answer: AnswerChoice) -> Bool {
        answer.id == correctAnswerID
    }
}

struct AnswerChoice: Identifiable {
    let id: Int
    let text: String
}

 
 
 
 
 
 
 

import Observation

@Observable
final class GameState {
    let maximumHP = 10
    private(set) var hp = 10


    func loseHP() {
        hp = max(0, hp - 1)
    }

    func restoreHP(by amount: Int) {
        hp = min(maximumHP, hp + max(0, amount))
    }
}

 
 
 
 
 
 
 

import SwiftUI

struct LearningLevel: Hashable, Identifiable {
    let number: Int
    let title: String
    let subject: String
    let icon: String
    let color: Color
    let position: CGPoint
    let isBoss: Bool
    let trail: AdventureRoute?


    var id: String {
        "\(trail?.rawValue ?? "boss")-\(number)"
    }

    static func == (lhs: LearningLevel, rhs: LearningLevel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

 
 
 
 
 
 
 

import SwiftUI

enum AdventureRoute: String, CaseIterable, Identifiable {
    case sunny
    case forest
    case rainbow

    var id: String { rawValue }

    var name: String {
        switch self {
        case .sunny: "Sunny Trail"
        case .forest: "Forest Trail"
        case .rainbow: "Rainbow Trail"
        }
    }

    var icon: String {
        switch self {
        case .sunny: "sun.max.fill"
        case .forest: "tree.fill"
        case .rainbow: "rainbow"
        }
    }

    var color: Color {
        switch self {
        case .sunny: .orange
        case .forest: .green
        case .rainbow: .pink
        }
    }
}

 
 
 
 
 
 
 

struct MatchingPair: Identifiable, Hashable {
    let id: String
    let term: String
    let definition: String


    static let bossPairs = [
        MatchingPair(
            id: "dose",
            term: "Dose",
            definition: "The amount of a substance that enters the body"
        ),
        MatchingPair(
            id: "tempo",
            term: "Tempo",
            definition: "How fast or slow a piece of music is performed"
        ),
        MatchingPair(
            id: "blubber",
            term: "Blubber",
            definition: "A whale's thick layer of fat that helps it stay warm"
        ),
        MatchingPair(
            id: "toxicity",
            term: "Toxicity",
            definition: "How harmful a substance can be to a living thing"
        )
    ]
}

 
 
 
 
 
 
 

import SwiftUI

struct PlayerAvatar {

    var skinTone: SkinTone = .sunny
    var hair: HairStyle = .curly
    var outfit: Outfit = .explorer

    var skinColor: Color {
        skinTone.color
    }

    var hairColor: Color {
        hair.color
    }

    var outfitColor: Color {
        outfit.color
    }
}

enum SkinTone: String, CaseIterable, Identifiable {
    case sunny = "Sunny"
    case peach = "Peach"
    case cocoa = "Cocoa"
    case moon = "Moon"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .sunny: Color(red: 0.96, green: 0.72, blue: 0.48)
        case .peach: Color(red: 0.98, green: 0.57, blue: 0.43)
        case .cocoa: Color(red: 0.48, green: 0.26, blue: 0.16)
        case .moon: Color(red: 0.75, green: 0.54, blue: 0.40)
        }
    }
}

enum HairStyle: String, CaseIterable, Identifiable {
    case curly = "Curly"
    case bob = "Bob"
    case spikes = "Spikes"
    case cap = "Cap"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .curly: "person.crop.circle.fill"
        case .bob: "person.crop.circle"
        case .spikes: "sparkles"
        case .cap: "graduationcap.fill"
        }
    }

    var color: Color {
        switch self {
        case .curly: .brown
        case .bob: .black
        case .spikes: .orange
        case .cap: .indigo
        }
    }
}

enum Outfit: String, CaseIterable, Identifiable {
    case explorer = "Explorer"
    case scientist = "Scientist"
    case artist = "Artist"
    case athlete = "Athlete"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .explorer: "binoculars.fill"
        case .scientist: "flask.fill"
        case .artist: "paintpalette.fill"
        case .athlete: "figure.run"
        }
    }

    var color: Color {
        switch self {
        case .explorer: .green
        case .scientist: .blue
        case .artist: .pink
        case .athlete: .orange
        }
    }
}

 
 
 
 
 
 
 

import SwiftUI

enum PrizeKind {
    case outfit(Outfit)
    case hair(HairStyle)
    case skinTone(SkinTone)
}

struct WheelPrize: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let kind: PrizeKind


    static let available = [
        WheelPrize(title: "Science Coat", icon: "cross.case.fill", color: .blue, kind: .outfit(.scientist)),
        WheelPrize(title: "Spiky Hair", icon: "sparkles", color: .orange, kind: .hair(.spikes)),
        WheelPrize(title: "Cocoa Skin Tone", icon: "circle.fill", color: .brown, kind: .skinTone(.cocoa)),
        WheelPrize(title: "Peach Skin Tone", icon: "circle.fill", color: .orange, kind: .skinTone(.peach)),
        WheelPrize(title: "Moon Skin Tone", icon: "circle.fill", color: .gray, kind: .skinTone(.moon)),
        WheelPrize(title: "Bob Hair", icon: "person.crop.circle", color: .black, kind: .hair(.bob)),
        WheelPrize(title: "Cap Hair", icon: "graduationcap.fill", color: .indigo, kind: .hair(.cap)),
        WheelPrize(title: "Artist Outfit", icon: "paintpalette.fill", color: .pink, kind: .outfit(.artist)),
        WheelPrize(title: "Explorer Outfit", icon: "binoculars.fill", color: .green, kind: .outfit(.explorer)),
        WheelPrize(title: "Athlete Outfit", icon: "figure.run", color: .orange, kind: .outfit(.athlete)),
        WheelPrize(title: "Curly Hair", icon: "person.crop.circle.fill", color: .purple, kind: .hair(.curly)),
        WheelPrize(title: "Sunny Skin Tone", icon: "circle.fill", color: .yellow, kind: .skinTone(.sunny))
    ]
}

 
 
 
 
 
 
 

import SwiftUI

struct AnatomyActivityView: View {
    @Environment(GameState.self) private var gameState
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
            gameState.loseHP()
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

 
 
 
 
 
 
 

import SwiftUI

struct AvatarView: View {
    let avatar: PlayerAvatar
    var size: CGFloat = 150

    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.35))
                .frame(width: size, height: size)

            VStack(spacing: -size * 0.04) {
                ZStack {
                    Circle()
                        .fill(avatar.skinColor)
                        .frame(width: size * 0.42, height: size * 0.42)

                    Image(systemName: avatar.hair.symbol)
                        .font(.system(size: size * 0.22, weight: .bold))
                        .foregroundStyle(avatar.hairColor)
                        .offset(y: -size * 0.16)
                }

                RoundedRectangle(cornerRadius: size * 0.12)
                    .fill(avatar.outfitColor)
                    .frame(width: size * 0.42, height: size * 0.38)
                    .overlay {
                        Image(systemName: avatar.outfit.symbol)
                            .font(.system(size: size * 0.16, weight: .bold))
                            .foregroundStyle(.white)
                    }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(avatar.outfit.rawValue) outfit with \(avatar.hair.rawValue.lowercased()) hair")
    }
}

 
 
 
 
 
 
 

import SwiftUI

struct BackpackView: View {
    @State private var showsContents = false
    let items: [WheelPrize]

    var body: some View {
        Button {
            showsContents = true
        } label: {
            Label("\(items.count)", systemImage: "bag.fill")
                .font(.title3.bold())
                .foregroundStyle(.brown)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(.regularMaterial, in: Capsule())
                .overlay {
                    Capsule()
                        .stroke(.brown.opacity(0.25), lineWidth: 1)
                }
        }
        .accessibilityLabel("Backpack: \(items.count) item\(items.count == 1 ? "" : "s")")

        .sheet(isPresented: $showsContents) {
            BackpackContentsView(items: items)
        }
    }
}

struct BackpackContentsView: View {
    @Environment(\.dismiss) private var dismiss
    let items: [WheelPrize]

    var body: some View {
        NavigationStack {
            Group {

                if items.isEmpty {
                    ContentUnavailableView(
                        "Backpack is empty",
                        systemImage: "bag",
                        description: Text("Earn items from learning activities to add them here.")
                    )
                } else {
                    List(items) { item in
                        Label(item.title, systemImage: item.icon)
                            .foregroundStyle(item.color)
                    }
                }
            }
            .navigationTitle("Backpack")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done", action: dismiss.callAsFunction)
                }
            }
        }
    }
}

 
 
 
 
 
 
 

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
                    .background(choiceBackground(for: choice.0, inColumn: title), in: RoundedRectangle(cornerRadius: 14))
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                            .stroke(choiceBorder(for: choice.0, inColumn: title), lineWidth: 3)
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

    private func choiceBackground(for choiceID: String, inColumn title: String) -> Color {
        if matchedIDs.contains(choiceID) {
            return .green.opacity(0.2)
        }
        if title == "Concepts", selectedTermID == choiceID {
            return .yellow.opacity(0.75)
        }
        return .white.opacity(0.82)
    }

    private func choiceBorder(for choiceID: String, inColumn title: String) -> Color {
        if matchedIDs.contains(choiceID) {
            return .green
        }
        if title == "Concepts", selectedTermID == choiceID {
            return .orange
        }
        return .red.opacity(0.35)
    }
}

 
 
 
 
 
 
 

import SwiftUI

struct CampfireView: View {
    @Environment(GameState.self) private var gameState
    @State private var reward: CampfireReward?
    let onPrizeWon: (WheelPrize) -> Void
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.orange.opacity(0.24), .brown.opacity(0.12), .black.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "campfire.fill")
                    .font(.system(size: 96))
                    .foregroundStyle(.orange, .red)
                    .symbolEffect(.bounce, value: reward == nil)
                    .accessibilityLabel("Campfire")

                Text("Rest at the Campfire")
                    .font(.largeTitle.bold())

                Text("Choose one reward before returning to the map.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                if let reward {
                    rewardCard(reward)
                } else {

                    HStack(spacing: 14) {
                        Button {
                            gameState.restoreHP(by: 3)
                            reward = .restored
                        } label: {
                            Label("Rest +3 HP", systemImage: "bed.double.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(CampfireButtonStyle(color: .teal))

                        Button {
                            guard let prize = WheelPrize.available.randomElement() else {
                                return
                            }
                            onPrizeWon(prize)
                            reward = .item(prize)
                        } label: {
                            Label("Find an item", systemImage: "gift.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(CampfireButtonStyle(color: .orange))
                    }
                }
            }
            .padding(28)
            .frame(maxWidth: 620)
        }
        .navigationTitle("Campfire")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func rewardCard(_ reward: CampfireReward) -> some View {
        VStack(spacing: 14) {
            switch reward {
            case .restored:
                Label("You rested and recovered 3 HP!", systemImage: "heart.fill")
                    .foregroundStyle(.teal)
            case .item(let prize):
                Label("You found \(prize.title)!", systemImage: prize.icon)
                    .foregroundStyle(prize.color)
            }

            Text("Current HP: \(gameState.hp)/\(gameState.maximumHP)")
                .font(.headline)

            Button("Return to map", action: onFinish)
                .font(.headline.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 11)
                .background(.green, in: Capsule())
        }
        .font(.title3.bold())
        .multilineTextAlignment(.center)
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 22))
    }
}

private enum CampfireReward {
    case restored
    case item(WheelPrize)
}

private struct CampfireButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(color.gradient, in: RoundedRectangle(cornerRadius: 16))
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}

 
 
 
 
 
 
 

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

 
 
 
 
 
 
 
 
 

import SwiftUI

struct ContentView: View {

    @State private var viewModel = AppViewModel()
    @State private var mapViewModel = GameMapViewModel()

    var body: some View {
        Group {
            if viewModel.showsMap {
                GameMapView(
                    viewModel: mapViewModel,
                    avatar: viewModel.avatar,
                    backpackItems: viewModel.collectedPrizes,
                    roundNumber: viewModel.roundNumber,
                    onOpenWardrobe: viewModel.openWardrobe,
                    onStartNewRound: {
                        mapViewModel = GameMapViewModel()
                        viewModel.startNewRound()
                    },
                    onPrizeWon: viewModel.collect
                )
            } else {
                WardrobeView(viewModel: viewModel, onReady: viewModel.enterMap)
            }
        }
        .animation(.easeInOut, value: viewModel.showsMap)
        .safeAreaInset(edge: .top, spacing: 0) {

            HStack {
                BackpackView(items: viewModel.collectedPrizes)
                Spacer()
                HPView()
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(.thinMaterial)
        }
    }
}

#Preview {
    ContentView()
        .environment(GameState())
}

 
 
 
 
 
 
 

import SwiftUI

struct GameMapView: View {
    @Bindable var viewModel: GameMapViewModel
    @State private var navigationPath: [LearningLevel] = []
    @State private var showsLevelTester = false
    @State private var completedLevel: LearningLevel?
    @State private var showsBackpack = false
    @State private var completedWithNewItem = false
    @State private var showsRouteSelection = false
    let avatar: PlayerAvatar
    let backpackItems: [WheelPrize]
    let roundNumber: Int
    let onOpenWardrobe: () -> Void
    let onStartNewRound: () -> Void
    let onPrizeWon: (WheelPrize) -> Void

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack(alignment: .top) {
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    ZStack {
                        LinearGradient(
                            colors: [.cyan.opacity(0.32), .green.opacity(0.3), .yellow.opacity(0.28)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )

                        MapDecorations()

                        ForEach(AdventureRoute.allCases) { route in
                            RoutePath(
                                route: route,
                                levels: viewModel.levelsByRoute[route] ?? [],
                                boss: viewModel.boss,
                                isSelected: route == viewModel.selectedRoute
                            )
                        }

                        ForEach(viewModel.allLevels) { level in
                            let isCompleted = viewModel.completedLevelIDs.contains(level.id)

                            if viewModel.isUnlocked(level) && !isCompleted {
                                NavigationLink(value: level) {
                                    LevelNode(level: level)
                                }
                                .buttonStyle(.plain)
                                .simultaneousGesture(TapGesture().onEnded {
                                    completedWithNewItem = false
                                })
                                .position(level.position)
                            } else {
                                LevelNode(
                                    level: level,
                                    isLocked: !isCompleted && !viewModel.isUnlocked(level),
                                    isPreview: false,
                                    isCompleted: isCompleted,
                                    selectedRoute: viewModel.selectedRoute,
                                    lockMessage: viewModel.lockMessage(for: level)
                                )
                                .position(level.position)
                            }
                        }

                        let isBossCompleted = viewModel.completedLevelIDs.contains(viewModel.boss.id)
                        if viewModel.isUnlocked(viewModel.boss) && !isBossCompleted {
                            NavigationLink(value: viewModel.boss) {
                                LevelNode(level: viewModel.boss)
                            }
                            .buttonStyle(.plain)
                            .simultaneousGesture(TapGesture().onEnded {
                                completedWithNewItem = false
                            })
                            .position(viewModel.boss.position)
                        } else {
                            LevelNode(
                                level: viewModel.boss,
                                isLocked: !isBossCompleted,
                                isCompleted: isBossCompleted,
                                selectedRoute: viewModel.selectedRoute,
                                lockMessage: viewModel.lockMessage(for: viewModel.boss)
                            )
                            .position(viewModel.boss.position)
                        }
                    }
                    .frame(width: 1160, height: 900)
                }
                .ignoresSafeArea(edges: .bottom)

                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        AvatarView(avatar: avatar, size: 62)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Learning Land")
                                .font(.title2.bold())
                            Text("Round \(roundNumber) • Drag the map and pick a path!")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button("Test levels", systemImage: "hammer.fill") {
                            showsLevelTester = true
                        }
                        .labelStyle(.iconOnly)
                        .font(.title2)
                        .foregroundStyle(.orange)
                        .padding(12)
                        .background(.ultraThinMaterial, in: Circle())
                        .accessibilityLabel("Test levels directly")
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(AdventureRoute.allCases) { route in
                                Button {
                                    viewModel.selectedRoute = route
                                } label: {
                                    Label(route.name, systemImage: route.icon)
                                        .font(.subheadline.bold())
                                        .foregroundStyle(route == viewModel.selectedRoute ? .white : route.color)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            route == viewModel.selectedRoute ? route.color : .white.opacity(0.78),
                                            in: Capsule()
                                        )
                                }
                                .buttonStyle(.plain)
                                .disabled(viewModel.isRouteConfirmed)
                                .accessibilityAddTraits(route == viewModel.selectedRoute ? .isSelected : [])
                            }
                        }
                        .padding(.horizontal, 4)
                    }

                    if viewModel.isRouteConfirmed {
                        Label("\(viewModel.selectedRoute.name) confirmed", systemImage: "checkmark.seal.fill")
                            .font(.subheadline.bold())
                            .foregroundStyle(.green)
                    } else {
                        Button("Confirm \(viewModel.selectedRoute.name)") {
                            viewModel.confirmRoute()
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 9)
                        .background(viewModel.selectedRoute.color, in: Capsule())
                        .accessibilityHint("Locks this trail and unlocks its learning levels")
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.regularMaterial)
            }
            .navigationDestination(for: LearningLevel.self) { level in

                LevelView(
                    level: level,
                    avatar: avatar,
                    onFinish: {
                        viewModel.markCompleted(level)
                        navigationPath.removeAll()
                        completedLevel = level
                    },
                    onPrizeWon: { prize in
                        let isNewItem = !backpackItems.contains(where: { $0.title == prize.title })
                        onPrizeWon(prize)
                        completedWithNewItem = isNewItem
                    }
                )
            }
        }
        .sheet(isPresented: $showsLevelTester) {
            LevelTesterView(
                levels: viewModel.allLevels + [viewModel.boss],
                avatar: avatar,
                backpackItems: backpackItems,
                onPrizeWon: onPrizeWon,
                onRoundComplete: { level in
                    viewModel.markCompleted(level)
                    showsLevelTester = false
                    completedLevel = level
                },
                onOpenWardrobe: onStartNewRound
            )
        }
        .overlay {
            if let completedLevel {
                CompletionOverlayView(
                    level: completedLevel,
                    hasNewItem: completedWithNewItem,
                    onReturnToWardrobe: {
                        self.completedLevel = nil
                        onStartNewRound()
                    },
                    onCheckBackpack: {
                        self.completedLevel = nil
                        completedWithNewItem = false
                        showsBackpack = true
                    },
                    onContinue: {
                        self.completedLevel = nil
                        completedWithNewItem = false
                    }
                )
            }
        }
        .sheet(isPresented: $showsBackpack) {
            BackpackContentsView(items: backpackItems)
                .presentationDetents([.medium, .large])
        }
        .overlay {
            if showsRouteSelection {
                routeSelectionOverlay
            }
        }
        .onAppear {
            if !viewModel.isRouteConfirmed {
                showsRouteSelection = true
            }
        }
    }

    private var routeSelectionOverlay: some View {

        ZStack {
            Color.black.opacity(0.58)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("Choose Your Route")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)

                Text("Select one trail for this round.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                VStack(spacing: 12) {
                    ForEach(AdventureRoute.allCases) { route in
                        Button {
                            viewModel.selectedRoute = route
                            viewModel.confirmRoute()
                            showsRouteSelection = false
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: route.icon)
                                    .font(.title2.bold())
                                    .frame(width: 48, height: 48)
                                    .foregroundStyle(.white)
                                    .background(route.color.gradient, in: Circle())

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(route.name)
                                        .font(.title3.bold())
                                        .foregroundStyle(.primary)
                                    Text(routeDescription(for: route))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(route.color)
                            }
                            .padding()
                            .background(.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 18))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(22)
            .frame(maxWidth: 520)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28))
            .shadow(radius: 28)
            .padding(20)
        }
    }

    private func routeDescription(for route: AdventureRoute) -> String {
        switch route {
        case .sunny:
            "Discovery, mixed topics, and the Sky Castle"
        case .forest:
            "Nature, writing, science, and logic"
        case .rainbow:
            "Art, music, space, and puzzles"
        }
    }
}

private struct RoutePath: View {
    let route: AdventureRoute
    let levels: [LearningLevel]
    let boss: LearningLevel
    let isSelected: Bool

    var body: some View {
        routeShape
            .stroke(
                isSelected ? route.color : .white.opacity(0.48),
                style: StrokeStyle(
                    lineWidth: isSelected ? 15 : 7,
                    lineCap: .round,
                    lineJoin: .round,
                    dash: route == .rainbow ? [18, 12] : []
                )
            )
            .shadow(color: isSelected ? route.color.opacity(0.3) : .clear, radius: 8, y: 3)
            .opacity(isSelected ? 1 : 0.55)
    }

    private var routeShape: Path {
        Path { path in
            guard let firstLevel = levels.first, let lastLevel = levels.last else {
                return
            }

            path.move(to: firstLevel.position)

            for index in 1..<levels.count {
                let previous = levels[index - 1].position
                let current = levels[index].position
                let curveOffset: CGFloat = route == .forest ? 70 : (route == .rainbow ? -55 : 45)
                path.addCurve(
                    to: current,
                    control1: CGPoint(x: previous.x + 70, y: previous.y + curveOffset),
                    control2: CGPoint(x: current.x - 70, y: current.y - curveOffset)
                )
            }

            path.addCurve(
                to: boss.position,
                control1: CGPoint(x: lastLevel.position.x + 90, y: lastLevel.position.y),
                control2: CGPoint(x: boss.position.x - 110, y: boss.position.y)
            )
        }
    }
}

private struct MapDecorations: View {
    var body: some View {
        ZStack {
            ForEach(0..<14, id: \.self) { index in
                Image(systemName: index.isMultiple(of: 2) ? "cloud.fill" : "tree.fill")
                    .font(.system(size: index.isMultiple(of: 2) ? 34 : 42))
                    .foregroundStyle(index.isMultiple(of: 2) ? .white.opacity(0.65) : .green.opacity(0.55))
                    .position(
                        x: CGFloat((index * 137) % 900) + 35,
                        y: CGFloat((index * 83) % 650) + 35
                    )
            }
        }
    }
}

private struct LevelNode: View {
    let level: LearningLevel
    var isLocked = false
    var isPreview = false
    var isCompleted = false
    var selectedRoute: AdventureRoute?
    var lockMessage: String?

    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : (isLocked ? "lock.fill" : level.icon))
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .frame(width: 68, height: 68)
                    .background((isCompleted ? .green : (isLocked ? .gray : level.color)).gradient, in: Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 5))
                    .shadow(
                        color: isLocked ? .clear : level.color.opacity(0.35),
                        radius: 8,
                        y: 4
                    )

                if isPreview {
                    Image(systemName: "lock.fill")
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                        .padding(5)
                        .background(.black.opacity(0.55), in: Circle())
                        .offset(x: 25, y: -25)
                }
            }
            Text(isCompleted ? "Passed" : (level.isBoss ? "BOSS" : "Level \(level.number)"))
                .font(.caption.bold())
                .foregroundStyle(isCompleted ? .green : (isLocked ? .secondary : (level.isBoss ? level.color : .primary)))
        }
        .frame(width: 115)
        .opacity(isLocked && !isPreview && !isCompleted ? 0.62 : 1)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            isCompleted
                ? "\(level.title), passed"
                : (isLocked
                ? "\(level.title), locked"
                : (isPreview
                    ? "\(level.title), route preview"
                    : (level.isBoss ? "Final boss, \(level.title)" : "Level \(level.number), \(level.title)")))
        )
        .accessibilityHint(
            isCompleted
                ? "This level has already been passed"
                : (isLocked || isPreview
                ? (lockMessage ?? "Choose the \(selectedRoute?.name ?? "selected") to unlock this level")
                : "Opens \(level.subject)")
        )
    }
}

 
 
 
 
 
 
 

import SwiftUI

struct HPView: View {
    @Environment(GameState.self) private var gameState

    var body: some View {
        Label("\(gameState.hp) HP", systemImage: "heart.fill")
            .font(.title3.bold())
            .foregroundStyle(gameState.hp == 0 ? .gray : .red)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(.regularMaterial, in: Capsule())
            .overlay {
                Capsule()
                    .stroke(.red.opacity(0.25), lineWidth: 1)
            }
            .accessibilityLabel("Health points: \(gameState.hp) out of \(gameState.maximumHP)")
    }
}

 
 
 
 
 
 
 

import SwiftUI

struct LevelTesterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var completedLevel: LearningLevel?
    @State private var showsBackpack = false
    @State private var completedWithNewItem = false
    let levels: [LearningLevel]
    let avatar: PlayerAvatar
    let backpackItems: [WheelPrize]
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
                        onPrizeWon: { prize in
                            let isNewItem = !backpackItems.contains(where: { $0.title == prize.title })
                            onPrizeWon(prize)
                            completedWithNewItem = isNewItem
                        }
                    )
                } label: {
                    Label("Level \(level.number): \(level.title)", systemImage: level.icon)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    completedWithNewItem = false
                })
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
                CompletionOverlayView(
                    level: completedLevel,
                    hasNewItem: completedWithNewItem,
                    onReturnToWardrobe: {
                        self.completedLevel = nil
                        dismiss()
                        onOpenWardrobe()
                    },
                    onCheckBackpack: {
                        self.completedLevel = nil
                        completedWithNewItem = false
                        showsBackpack = true
                    },
                    onContinue: {
                        self.completedLevel = nil
                        completedWithNewItem = false
                    }
                )
            }
        }
        .sheet(isPresented: $showsBackpack) {
            BackpackContentsView(items: backpackItems)
                .presentationDetents([.medium, .large])
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

 
 
 
 
 
 
 

import SwiftUI

struct NormalBattleView: View {
    @State private var viewModel: NormalBattleViewModel
    @Environment(GameState.self) private var gameState
    let avatar: PlayerAvatar
    let onFinish: () -> Void

    init(level: LearningLevel, avatar: PlayerAvatar, onFinish: @escaping () -> Void) {
        _viewModel = State(initialValue: NormalBattleViewModel(level: level))
        self.avatar = avatar
        self.onFinish = onFinish
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
                    VStack(alignment: .leading, spacing: 3) {
                        Label(viewModel.level.isBoss ? "Final Battle" : "Normal Battle", systemImage: "bolt.fill")
                            .font(.headline.bold())
                            .foregroundStyle(viewModel.level.color)
                        Text("Answered \(viewModel.answeredQuestionCount) of \(viewModel.questionCount)")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                    }
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
                    if !viewModel.answeredCorrectly {
                        gameState.loseHP()
                    }
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
            } else {
                Button("Return to map", action: onFinish)
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

 
 
 
 
 
 
 

import SwiftUI

struct PrizeWheelView: View {
    @State private var viewModel: PrizeWheelViewModel
    @Environment(GameState.self) private var gameState
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
                colors: [
                    viewModel.level.color.opacity(0.25),
                    .white,
                    viewModel.level.color.opacity(0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {
                    HStack {
                        Label("Topic Mix", systemImage: "sparkles")
                            .font(.headline.bold())
                            .foregroundStyle(viewModel.level.color)
                        Spacer()
                        Text("Question \(viewModel.attemptNumber) of \(viewModel.questionCount)")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                    }

                    Text("Answer a marine biology, music, or biomedical toxicity question to earn a spin!")
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(viewModel.level.color.gradient, in: RoundedRectangle(cornerRadius: 18))


                    if let wonPrize = viewModel.wonPrize {
                        prizeResult(wonPrize)
                        wheel
                    } else {
                        questionCard
                        wheel
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
                .shadow(color: viewModel.level.color.opacity(0.3), radius: 12, y: 6)

            ForEach(Array(viewModel.prizes.enumerated()), id: \.element.id) { index, prize in
                Image(systemName: prize.icon)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .offset(y: -88)
                    .rotationEffect(.degrees(Double(index) * 360 / Double(viewModel.prizes.count)))
                    .rotationEffect(.degrees(-wheelRotation))
            }

            Circle()
                .fill(.white)
                .frame(width: 66, height: 66)
                .overlay {
                    Text(viewModel.hasSpun ? "Won!" : "Spin")
                        .font(.headline.bold())
                        .foregroundStyle(viewModel.level.color)
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
                        if !viewModel.answeredCorrectly {
                            gameState.loseHP()
                        }
                    } label: {
                        Text(answer.text)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 58)
                            .background(.white.opacity(0.85), in: RoundedRectangle(cornerRadius: 14))
                            .overlay {
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(viewModel.level.color.opacity(0.5), lineWidth: 3)
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
                        .background(viewModel.level.color, in: Capsule())
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

 
 
 
 
 
 
 

import SwiftUI

struct TopicSelectionView: View {
    let avatar: PlayerAvatar
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.18), .white, .teal.opacity(0.16)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    AvatarView(avatar: avatar, size: 110)

                    VStack(spacing: 8) {
                        Text("Choose a Topic")
                            .font(.largeTitle.bold())
                        Text("Pick a learning adventure to begin.")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    topicDiagramStrip

                    topicCard(
                        title: "Marine Biology",
                        subtitle: "Explore a whale's anatomy",
                        icon: "water.waves",
                        color: .blue
                    ) {
                        AnatomyActivityView(onFinish: onFinish)
                    }

                    topicCard(
                        title: "Biomedical Toxicity",
                        subtitle: "Coming soon",
                        icon: "cross.case.fill",
                        color: .teal,
                        isAvailable: false
                    )

                    topicCard(
                        title: "Music",
                        subtitle: "Coming soon",
                        icon: "music.note",
                        color: .purple,
                        isAvailable: false
                    )
                }
                .padding(24)
                .frame(maxWidth: 620)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Topic Quest")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var topicDiagramStrip: some View {

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                topicDiagram(title: "Dose-Response", color: .teal) {
                    Canvas { context, size in
                        var axes = Path()
                        axes.move(to: CGPoint(x: 20, y: size.height - 20))
                        axes.addLine(to: CGPoint(x: size.width - 12, y: size.height - 20))
                        axes.move(to: CGPoint(x: 20, y: size.height - 20))
                        axes.addLine(to: CGPoint(x: 20, y: 18))
                        context.stroke(axes, with: .color(.teal), lineWidth: 2)

                        var curve = Path()
                        curve.move(to: CGPoint(x: 24, y: size.height - 24))
                        curve.addCurve(
                            to: CGPoint(x: size.width - 18, y: 26),
                            control1: CGPoint(x: size.width * 0.42, y: size.height - 22),
                            control2: CGPoint(x: size.width * 0.68, y: 46)
                        )
                        context.stroke(curve, with: .color(.orange), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    }
                }

                topicDiagram(title: "Whale Anatomy", color: .blue) {
                    Canvas { context, size in
                        var whale = Path()
                        whale.move(to: CGPoint(x: 18, y: size.height * 0.50))
                        whale.addCurve(
                            to: CGPoint(x: size.width - 20, y: size.height * 0.45),
                            control1: CGPoint(x: size.width * 0.28, y: 16),
                            control2: CGPoint(x: size.width * 0.72, y: 16)
                        )
                        whale.addCurve(
                            to: CGPoint(x: 18, y: size.height * 0.50),
                            control1: CGPoint(x: size.width * 0.78, y: size.height - 12),
                            control2: CGPoint(x: size.width * 0.28, y: size.height - 12)
                        )
                        context.fill(whale, with: .color(.blue.opacity(0.65)))
                    }
                }

                topicDiagram(title: "Music Staff", color: .purple) {
                    Canvas { context, size in
                        for index in 0..<5 {
                            var line = Path()
                            let y = 30 + CGFloat(index) * 16
                            line.move(to: CGPoint(x: 18, y: y))
                            line.addLine(to: CGPoint(x: size.width - 18, y: y))
                            context.stroke(line, with: .color(.purple.opacity(0.72)), lineWidth: 2)
                        }
                        for (index, x) in [size.width * 0.34, size.width * 0.58, size.width * 0.82].enumerated() {
                            let note = CGRect(x: x - 8, y: 44 + CGFloat(index % 2) * 28, width: 16, height: 11)
                            context.fill(Ellipse().path(in: note), with: .color(.purple))
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }

    @ViewBuilder
    private func topicDiagram<Diagram: View>(
        title: String,
        color: Color,
        @ViewBuilder diagram: () -> Diagram
    ) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(color)
            diagram()
                .frame(width: 150, height: 110)
                .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 16))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.35), lineWidth: 2)
                }
        }
        .frame(width: 150)
    }

    @ViewBuilder
    private func topicCard<Destination: View>(
        title: String,
        subtitle: String,
        icon: String,
        color: Color,
        isAvailable: Bool = true,
        @ViewBuilder destination: () -> Destination = { EmptyView() }
    ) -> some View {

        if isAvailable {
            NavigationLink {
                destination()
            } label: {
                cardLabel(title: title, subtitle: subtitle, icon: icon, color: color)
            }
            .buttonStyle(.plain)
        } else {
            cardLabel(title: title, subtitle: subtitle, icon: icon, color: color)
                .opacity(0.62)
        }
    }

    private func cardLabel(title: String, subtitle: String, icon: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title.bold())
                .foregroundStyle(.white)
                .frame(width: 58, height: 58)
                .background(color.gradient, in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: subtitle == "Coming soon" ? "lock.fill" : "arrow.right")
                .foregroundStyle(color)
        }
        .padding()
        .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(color.opacity(0.35), lineWidth: 2)
        }
    }
}

 
 
 
 
 
 
 

import SwiftUI

struct WardrobeView: View {
    @Bindable var viewModel: AppViewModel
    let onReady: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.yellow.opacity(0.35), .mint.opacity(0.45), .blue.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    VStack(spacing: 6) {
                        Text("Adventure Outfit")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.indigo)
                        Text("Choose your look before exploring!")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }

                    AvatarView(avatar: viewModel.avatar, size: 190)

                    WardrobeSection(title: "Skin tone") {
                        ForEach(orderedSkinTones) { tone in
                            ChoiceButton(
                                title: tone.rawValue,
                                color: tone.color,
                                isSelected: viewModel.avatar.skinTone == tone,
                                isUnlocked: viewModel.isUnlocked(tone)
                            ) {
                                viewModel.avatar.skinTone = tone
                            }
                        }
                    }

                    WardrobeSection(title: "Hair") {
                        ForEach(orderedHairStyles) { style in
                            ChoiceButton(
                                title: style.rawValue,
                                systemImage: style.symbol,
                                color: style.color,
                                isSelected: viewModel.avatar.hair == style,
                                isUnlocked: viewModel.isUnlocked(style)
                            ) {
                                viewModel.avatar.hair = style
                            }
                        }
                    }

                    WardrobeSection(title: "Outfit") {
                        ForEach(orderedOutfits) { outfit in
                            ChoiceButton(
                                title: outfit.rawValue,
                                systemImage: outfit.symbol,
                                color: outfit.color,
                                isSelected: viewModel.avatar.outfit == outfit,
                                isUnlocked: viewModel.isUnlocked(outfit)
                            ) {
                                viewModel.avatar.outfit = outfit
                            }
                        }

                    }

                    Button("Ready to explore!", action: onReady)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.indigo, in: RoundedRectangle(cornerRadius: 18))
                        .accessibilityHint("Opens the learning adventure map")
                }
                .padding()
                .frame(maxWidth: 620)
                .frame(maxWidth: .infinity)
            }
        }
    }


    private var orderedSkinTones: [SkinTone] {
        SkinTone.allCases.filter(viewModel.isUnlocked) + SkinTone.allCases.filter { !viewModel.isUnlocked($0) }
    }

    private var orderedHairStyles: [HairStyle] {
        HairStyle.allCases.filter(viewModel.isUnlocked) + HairStyle.allCases.filter { !viewModel.isUnlocked($0) }
    }

    private var orderedOutfits: [Outfit] {
        Outfit.allCases.filter(viewModel.isUnlocked) + Outfit.allCases.filter { !viewModel.isUnlocked($0) }
    }
}

private struct WardrobeSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.indigo)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ],
                spacing: 10,
                content: { content }
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ChoiceButton: View {
    let title: String
    var systemImage: String?
    let color: Color
    let isSelected: Bool
    let isUnlocked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 7) {
                if isUnlocked, let systemImage {
                    Image(systemName: systemImage)
                        .font(.title2)
                        .foregroundStyle(color)
                } else if isUnlocked {
                    Circle()
                        .fill(color)
                        .frame(width: 28, height: 28)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .frame(height: 28)
                }

                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? .indigo : .clear, lineWidth: 3)
            }
        }
        .buttonStyle(.plain)
        .disabled(!isUnlocked)
        .opacity(isUnlocked ? 1 : 0.55)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityHint(isUnlocked ? "Wear this item" : "Unlock this item by earning it")
    }
}

 
 
 
 
 
 
 

import Foundation
import Observation

@Observable
final class AppViewModel {
    private enum StorageKey {
        static let collectedPrizeTitles = "collectedPrizeTitles"
        static let avatarSkinTone = "avatarSkinTone"
        static let avatarHair = "avatarHair"
        static let avatarOutfit = "avatarOutfit"
        static let roundNumber = "roundNumber"
    }

    var avatar = PlayerAvatar()
    var showsMap = false
    var collectedPrizes: [WheelPrize] = []
    private(set) var roundNumber = 1


    init() {
        let defaults = UserDefaults.standard

        if let rawValue = defaults.string(forKey: StorageKey.avatarSkinTone),
           let skinTone = SkinTone(rawValue: rawValue) {
            avatar.skinTone = skinTone
        }
        if let rawValue = defaults.string(forKey: StorageKey.avatarHair),
           let hair = HairStyle(rawValue: rawValue) {
            avatar.hair = hair
        }
        if let rawValue = defaults.string(forKey: StorageKey.avatarOutfit),
           let outfit = Outfit(rawValue: rawValue) {
            avatar.outfit = outfit
        }

        let savedTitles = Set(defaults.stringArray(forKey: StorageKey.collectedPrizeTitles) ?? [])
        collectedPrizes = WheelPrize.available.filter { savedTitles.contains($0.title) }
        roundNumber = max(1, defaults.integer(forKey: StorageKey.roundNumber))
    }

    func enterMap() {
        showsMap = true
    }

    func openWardrobe() {
        showsMap = false
    }

    func startNewRound() {
        roundNumber += 1
        showsMap = false
        UserDefaults.standard.set(roundNumber, forKey: StorageKey.roundNumber)
    }


    func collect(prize: WheelPrize) {
        if !collectedPrizes.contains(where: { $0.title == prize.title }) {
            collectedPrizes.append(prize)
        }

        switch prize.kind {
        case .outfit(let outfit):
            avatar.outfit = outfit
        case .hair(let hair):
            avatar.hair = hair
        case .skinTone(let skinTone):
            avatar.skinTone = skinTone
        }

        let defaults = UserDefaults.standard
        defaults.set(collectedPrizes.map(\.title), forKey: StorageKey.collectedPrizeTitles)
        defaults.set(avatar.skinTone.rawValue, forKey: StorageKey.avatarSkinTone)
        defaults.set(avatar.hair.rawValue, forKey: StorageKey.avatarHair)
        defaults.set(avatar.outfit.rawValue, forKey: StorageKey.avatarOutfit)
    }


    func isUnlocked(_ outfit: Outfit) -> Bool {
        outfit == .explorer || collectedPrizes.contains {
            guard case .outfit(let unlockedOutfit) = $0.kind else {
                return false
            }
            return unlockedOutfit == outfit
        }
    }

    func isUnlocked(_ hair: HairStyle) -> Bool {
        hair == .curly || collectedPrizes.contains {
            guard case .hair(let unlockedHair) = $0.kind else {
                return false
            }
            return unlockedHair == hair
        }
    }

    func isUnlocked(_ skinTone: SkinTone) -> Bool {
        skinTone == .sunny || collectedPrizes.contains {
            guard case .skinTone(let unlockedSkinTone) = $0.kind else {
                return false
            }
            return unlockedSkinTone == skinTone
        }
    }
}

 
 
 
 
 
 
 

import SwiftUI
import Observation

@Observable
final class GameMapViewModel {
    var selectedRoute: AdventureRoute = .sunny
    var isRouteConfirmed = false
    var completedLevelIDs: Set<String> = []

    func confirmRoute() {
        isRouteConfirmed = true
    }

    func markCompleted(_ level: LearningLevel) {
        completedLevelIDs.insert(level.id)
    }


    func isUnlocked(_ level: LearningLevel) -> Bool {
        guard isRouteConfirmed else {
            return false
        }

        if level.isBoss {
            guard let routeLevels = levelsByRoute[selectedRoute],
                  let finalLevel = routeLevels.last else {
                return false
            }
            return completedLevelIDs.contains(finalLevel.id)
        }

        guard level.trail == selectedRoute,
              let routeLevels = levelsByRoute[selectedRoute],
              let levelIndex = routeLevels.firstIndex(of: level) else {
            return false
        }

        guard levelIndex > 0 else {
            return true
        }
        return completedLevelIDs.contains(routeLevels[levelIndex - 1].id)
    }

    func lockMessage(for level: LearningLevel) -> String {
        guard isRouteConfirmed else {
            return "Confirm your trail to unlock this level"
        }
        if level.isBoss {
            return "Complete the final level on your trail to unlock the Quiz Dragon"
        }
        guard let routeLevels = levelsByRoute[selectedRoute],
              let levelIndex = routeLevels.firstIndex(of: level),
              levelIndex > 0 else {
            return "Choose the \(selectedRoute.name) to unlock this level"
        }
        return "Complete Level \(routeLevels[levelIndex - 1].number) first"
    }


    let levelsByRoute: [AdventureRoute: [LearningLevel]] = [
        .sunny: [
            LearningLevel(number: 1, title: "Discovery Lab", subject: "Biomedical Toxicity", icon: "cross.case.fill", color: .teal, position: CGPoint(x: 150, y: 210), isBoss: false, trail: .sunny),
            LearningLevel(number: 2, title: "Prize Wheel", subject: "Topic Mix", icon: "circle.dotted.and.circle", color: .pink, position: CGPoint(x: 370, y: 300), isBoss: false, trail: .sunny),
            LearningLevel(number: 3, title: "Topic Quest", subject: "Choose a Topic", icon: "square.grid.2x2.fill", color: .blue, position: CGPoint(x: 590, y: 180), isBoss: false, trail: .sunny),
            LearningLevel(number: 4, title: "Campfire", subject: "Reward", icon: "star.fill", color: .purple, position: CGPoint(x: 810, y: 260), isBoss: false, trail: .sunny)
        ],
        .forest: [
            LearningLevel(number: 1, title: "Discovery Lab", subject: "Biomedical Toxicity", icon: "cross.case.fill", color: .teal, position: CGPoint(x: 150, y: 450), isBoss: false, trail: .forest),
            LearningLevel(number: 2, title: "Prize Wheel", subject: "Topic Mix", icon: "circle.dotted.and.circle", color: .pink, position: CGPoint(x: 370, y: 540), isBoss: false, trail: .forest),
            LearningLevel(number: 3, title: "Topic Quest", subject: "Choose a Topic", icon: "square.grid.2x2.fill", color: .blue, position: CGPoint(x: 590, y: 420), isBoss: false, trail: .forest),
            LearningLevel(number: 4, title: "Campfire", subject: "Reward", icon: "star.fill", color: .purple, position: CGPoint(x: 810, y: 500), isBoss: false, trail: .forest)
        ],
        .rainbow: [
            LearningLevel(number: 1, title: "Discovery Lab", subject: "Biomedical Toxicity", icon: "cross.case.fill", color: .teal, position: CGPoint(x: 150, y: 690), isBoss: false, trail: .rainbow),
            LearningLevel(number: 2, title: "Prize Wheel", subject: "Topic Mix", icon: "circle.dotted.and.circle", color: .pink, position: CGPoint(x: 370, y: 780), isBoss: false, trail: .rainbow),
            LearningLevel(number: 3, title: "Topic Quest", subject: "Choose a Topic", icon: "square.grid.2x2.fill", color: .blue, position: CGPoint(x: 590, y: 660), isBoss: false, trail: .rainbow),
            LearningLevel(number: 4, title: "Campfire", subject: "Reward", icon: "star.fill", color: .purple, position: CGPoint(x: 810, y: 740), isBoss: false, trail: .rainbow)
        ]
    ]

    let boss = LearningLevel(
        number: 5,
        title: "Quiz Dragon",
        subject: "Final Challenge",
        icon: "flame.fill",
        color: .red,
        position: CGPoint(x: 1030, y: 475),
        isBoss: true,
        trail: nil
    )

    var allLevels: [LearningLevel] {
        AdventureRoute.allCases.flatMap { levelsByRoute[$0] ?? [] }
    }

}

 
 
 
 
 
 
 

import Foundation
import Observation

@Observable
final class NormalBattleViewModel {
    let level: LearningLevel
    private let questions: [BattleQuestion]
    var questionIndex = 0
    var selectedAnswerID: Int?
    var hasAnswered = false
    private(set) var answeredQuestionCount = 0

    init(level: LearningLevel) {
        self.level = level
        self.questions = Array(Self.freshQuestionBatch(for: level, count: 5))
    }

    var question: BattleQuestion {
        questions[questionIndex]
    }

    var isLastQuestion: Bool {
        questionIndex == questions.count - 1
    }

    var questionCount: Int {
        questions.count
    }

    var selectedAnswer: AnswerChoice? {
        guard let selectedAnswerID else {
            return nil
        }
        return question.answers.first { $0.id == selectedAnswerID }
    }

    var answeredCorrectly: Bool {
        guard let selectedAnswer else {
            return false
        }
        return question.isCorrect(selectedAnswer)
    }


    func choose(_ answer: AnswerChoice) {
        guard !hasAnswered else {
            return
        }
        selectedAnswerID = answer.id
        hasAnswered = true
        if answeredCorrectly {
            answeredQuestionCount += 1
        }
    }

    func tryAgain() {
        selectedAnswerID = nil
        hasAnswered = false
    }

    func advanceToNextQuestion() {
        guard !isLastQuestion else {
            return
        }
        questionIndex += 1
        tryAgain()
    }

    static func questionBank(for level: LearningLevel) -> [BattleQuestion] {
        questionBank(forLevelNumber: level.number, subject: level.subject)
    }


    static func questionBank(forLevelNumber levelNumber: Int, subject: String = "") -> [BattleQuestion] {
        if levelNumber == 1 {
            return [
                BattleQuestion(
                    prompt: "Which statement about a toxic substance is most accurate?",
                    answers: [
                        AnswerChoice(id: 1, text: "It can harm the body at some dose"),
                        AnswerChoice(id: 2, text: "It is always dangerous to touch"),
                        AnswerChoice(id: 3, text: "It only affects grown-ups"),
                        AnswerChoice(id: 4, text: "It is safe if it has no smell")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which evidence shows that a whale is a mammal?",
                    answers: [
                        AnswerChoice(id: 1, text: "It breathes air and feeds milk to its young"),
                        AnswerChoice(id: 2, text: "It lives in salt water"),
                        AnswerChoice(id: 3, text: "It has fins and a tail"),
                        AnswerChoice(id: 4, text: "It swims faster than many fish")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which musical feature tells how high or low a note sounds?",
                    answers: [
                        AnswerChoice(id: 1, text: "Pitch"),
                        AnswerChoice(id: 2, text: "Tempo"),
                        AnswerChoice(id: 3, text: "Dynamics"),
                        AnswerChoice(id: 4, text: "Rhythm")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What can change how harmful a substance is?",
                    answers: [
                        AnswerChoice(id: 1, text: "The amount that enters the body"),
                        AnswerChoice(id: 2, text: "The color of its container"),
                        AnswerChoice(id: 3, text: "Whether it has a strong smell"),
                        AnswerChoice(id: 4, text: "How expensive it is")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is the safest response to an unlabeled bottle?",
                    answers: [
                        AnswerChoice(id: 1, text: "Do not touch it and tell a trusted adult"),
                        AnswerChoice(id: 2, text: "Smell it from very close"),
                        AnswerChoice(id: 3, text: "Mix a tiny amount with water"),
                        AnswerChoice(id: 4, text: "Taste a drop to identify it")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Why are algae important in many ocean food webs?",
                    answers: [
                        AnswerChoice(id: 1, text: "They make food using sunlight"),
                        AnswerChoice(id: 2, text: "They keep every ocean animal warm"),
                        AnswerChoice(id: 3, text: "They turn salt water into fresh water"),
                        AnswerChoice(id: 4, text: "They are the largest ocean predators")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does tempo tell us about a piece of music?",
                    answers: [
                        AnswerChoice(id: 1, text: "How fast or slow it should be"),
                        AnswerChoice(id: 2, text: "How loud or soft it should be"),
                        AnswerChoice(id: 3, text: "Which instruments are playing"),
                        AnswerChoice(id: 4, text: "How many notes are in the song")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Why can warm ocean water be harmful to coral reefs?",
                    answers: [
                        AnswerChoice(id: 1, text: "Coral can lose the algae that help feed it"),
                        AnswerChoice(id: 2, text: "Coral instantly turns into a fish"),
                        AnswerChoice(id: 3, text: "Warm water contains no oxygen at all"),
                        AnswerChoice(id: 4, text: "Coral can only live in freshwater")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which feature helps a seal stay warm in cold water?",
                    answers: [
                        AnswerChoice(id: 1, text: "A thick layer of blubber"),
                        AnswerChoice(id: 2, text: "Bright scales that reflect sunlight"),
                        AnswerChoice(id: 3, text: "Long roots under the seafloor"),
                        AnswerChoice(id: 4, text: "A shell that opens and closes")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does dynamics describe in music?",
                    answers: [
                        AnswerChoice(id: 1, text: "Changes in loudness and softness"),
                        AnswerChoice(id: 2, text: "The speed of the beat"),
                        AnswerChoice(id: 3, text: "The distance between instruments"),
                        AnswerChoice(id: 4, text: "The number of verses")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is the safest way to handle an unknown powder?",
                    answers: [
                        AnswerChoice(id: 1, text: "Do not touch it and alert a trusted adult"),
                        AnswerChoice(id: 2, text: "Taste a small amount"),
                        AnswerChoice(id: 3, text: "Pour it into a drink"),
                        AnswerChoice(id: 4, text: "Rub it on your skin")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does dose mean in toxicology?",
                    answers: [
                        AnswerChoice(id: 1, text: "The amount of a substance exposed to the body"),
                        AnswerChoice(id: 2, text: "The color of a substance"),
                        AnswerChoice(id: 3, text: "The shape of a container"),
                        AnswerChoice(id: 4, text: "The temperature outside")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Why should chemicals stay in their labeled containers?",
                    answers: [
                        AnswerChoice(id: 1, text: "Labels help people know the hazards and safe use"),
                        AnswerChoice(id: 2, text: "Labels make the chemical taste better"),
                        AnswerChoice(id: 3, text: "Labels stop the container from melting"),
                        AnswerChoice(id: 4, text: "Labels remove the chemical")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is the correct first action after breathing harmful fumes?",
                    answers: [
                        AnswerChoice(id: 1, text: "Move to fresh air and get adult help"),
                        AnswerChoice(id: 2, text: "Breathe more deeply"),
                        AnswerChoice(id: 3, text: "Continue working"),
                        AnswerChoice(id: 4, text: "Hide the fumes")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which item gives the clearest warning about a chemical?",
                    answers: [
                        AnswerChoice(id: 1, text: "Its hazard label"),
                        AnswerChoice(id: 2, text: "Its smell"),
                        AnswerChoice(id: 3, text: "Its price"),
                        AnswerChoice(id: 4, text: "Its container size")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Why should chemical splash goggles be worn?",
                    answers: [
                        AnswerChoice(id: 1, text: "They protect the eyes"),
                        AnswerChoice(id: 2, text: "They make liquids disappear"),
                        AnswerChoice(id: 3, text: "They remove bad odors"),
                        AnswerChoice(id: 4, text: "They keep glasses warm")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What role does a whale's tail fluke play?",
                    answers: [
                        AnswerChoice(id: 1, text: "It helps propel the whale through water"),
                        AnswerChoice(id: 2, text: "It filters sunlight"),
                        AnswerChoice(id: 3, text: "It makes the whale breathe underwater"),
                        AnswerChoice(id: 4, text: "It digests fish")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a whale's blowhole used for?",
                    answers: [
                        AnswerChoice(id: 1, text: "Breathing at the water surface"),
                        AnswerChoice(id: 2, text: "Filtering sand"),
                        AnswerChoice(id: 3, text: "Seeing underwater"),
                        AnswerChoice(id: 4, text: "Holding eggs")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "How does a whale breathe?",
                    answers: [
                        AnswerChoice(id: 1, text: "It comes to the surface and uses lungs"),
                        AnswerChoice(id: 2, text: "It extracts air with gills"),
                        AnswerChoice(id: 3, text: "It absorbs air through its fins"),
                        AnswerChoice(id: 4, text: "It never needs oxygen")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What do whales use echolocation to help with?",
                    answers: [
                        AnswerChoice(id: 1, text: "Finding objects and prey"),
                        AnswerChoice(id: 2, text: "Growing a shell"),
                        AnswerChoice(id: 3, text: "Making fresh water"),
                        AnswerChoice(id: 4, text: "Changing colors")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What keeps many marine mammals warm?",
                    answers: [
                        AnswerChoice(id: 1, text: "Blubber"),
                        AnswerChoice(id: 2, text: "Leaf scales"),
                        AnswerChoice(id: 3, text: "Dry sand"),
                        AnswerChoice(id: 4, text: "Seaweed shells")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which organism begins many marine food chains?",
                    answers: [
                        AnswerChoice(id: 1, text: "Photosynthetic plankton"),
                        AnswerChoice(id: 2, text: "A blue whale"),
                        AnswerChoice(id: 3, text: "A shark"),
                        AnswerChoice(id: 4, text: "An octopus")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is rhythm in music?",
                    answers: [
                        AnswerChoice(id: 1, text: "A pattern of long and short sounds"),
                        AnswerChoice(id: 2, text: "The brightness of a tone"),
                        AnswerChoice(id: 3, text: "The number of instruments"),
                        AnswerChoice(id: 4, text: "The size of the stage")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does a musical clef help show?",
                    answers: [
                        AnswerChoice(id: 1, text: "The pitch range of notes on a staff"),
                        AnswerChoice(id: 2, text: "The speed of a performance"),
                        AnswerChoice(id: 3, text: "The name of the audience"),
                        AnswerChoice(id: 4, text: "How much a song costs")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What happens when a musical beat is played faster?",
                    answers: [
                        AnswerChoice(id: 1, text: "The tempo increases"),
                        AnswerChoice(id: 2, text: "The pitch always drops"),
                        AnswerChoice(id: 3, text: "The melody disappears"),
                        AnswerChoice(id: 4, text: "The dynamics become silence")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which symbol commonly indicates silence in music?",
                    answers: [
                        AnswerChoice(id: 1, text: "A rest"),
                        AnswerChoice(id: 2, text: "A treble clef"),
                        AnswerChoice(id: 3, text: "A time signature"),
                        AnswerChoice(id: 4, text: "A measure line")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a melody?",
                    answers: [
                        AnswerChoice(id: 1, text: "A sequence of notes that is heard as a tune"),
                        AnswerChoice(id: 2, text: "Only the rhythm of a drum"),
                        AnswerChoice(id: 3, text: "A silent pause"),
                        AnswerChoice(id: 4, text: "A written list of instruments")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which term describes several notes played together?",
                    answers: [
                        AnswerChoice(id: 1, text: "Chord"),
                        AnswerChoice(id: 2, text: "Rest"),
                        AnswerChoice(id: 3, text: "Tempo"),
                        AnswerChoice(id: 4, text: "Coda")
                    ],
                    correctAnswerID: 1
                )
            ]
        }

        if levelNumber == 2 {
            return [
                BattleQuestion(
                    prompt: "How many sides does a triangle have?",
                    answers: [
                        AnswerChoice(id: 1, text: "Three"),
                        AnswerChoice(id: 2, text: "Four"),
                        AnswerChoice(id: 3, text: "Five"),
                        AnswerChoice(id: 4, text: "Six")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which shape has four equal sides?",
                    answers: [
                        AnswerChoice(id: 1, text: "Square"),
                        AnswerChoice(id: 2, text: "Triangle"),
                        AnswerChoice(id: 3, text: "Circle"),
                        AnswerChoice(id: 4, text: "Oval")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is the perimeter of a square with 3 cm sides?",
                    answers: [
                        AnswerChoice(id: 1, text: "12 cm"),
                        AnswerChoice(id: 2, text: "9 cm"),
                        AnswerChoice(id: 3, text: "6 cm"),
                        AnswerChoice(id: 4, text: "15 cm")
                    ],
                    correctAnswerID: 1
                )
            ]
        }

        switch subject {
        case "Nature":
            return [
                BattleQuestion(
                    prompt: "What do plants need to make food?",
                    answers: [
                        AnswerChoice(id: 1, text: "Sunlight"),
                        AnswerChoice(id: 2, text: "Plastic"),
                        AnswerChoice(id: 3, text: "Metal"),
                        AnswerChoice(id: 4, text: "Sound")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which animal is an herbivore?",
                    answers: [
                        AnswerChoice(id: 1, text: "Deer"),
                        AnswerChoice(id: 2, text: "Tiger"),
                        AnswerChoice(id: 3, text: "Hawk"),
                        AnswerChoice(id: 4, text: "Shark")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a habitat?",
                    answers: [
                        AnswerChoice(id: 1, text: "A place where an organism lives"),
                        AnswerChoice(id: 2, text: "A type of weather"),
                        AnswerChoice(id: 3, text: "A kind of rock"),
                        AnswerChoice(id: 4, text: "A food chain only")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What do bees help many flowering plants do?",
                    answers: [
                        AnswerChoice(id: 1, text: "Reproduce through pollination"),
                        AnswerChoice(id: 2, text: "Freeze their roots"),
                        AnswerChoice(id: 3, text: "Change into trees"),
                        AnswerChoice(id: 4, text: "Make sunlight")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which resource can be renewed naturally?",
                    answers: [
                        AnswerChoice(id: 1, text: "Wind"),
                        AnswerChoice(id: 2, text: "Coal"),
                        AnswerChoice(id: 3, text: "Plastic"),
                        AnswerChoice(id: 4, text: "Gasoline")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Writing":
            return [
                BattleQuestion(
                    prompt: "What does a verb show?",
                    answers: [
                        AnswerChoice(id: 1, text: "An action or state"),
                        AnswerChoice(id: 2, text: "A color"),
                        AnswerChoice(id: 3, text: "A number only"),
                        AnswerChoice(id: 4, text: "A paragraph's length")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which sentence uses a capital letter correctly?",
                    answers: [
                        AnswerChoice(id: 1, text: "Monday is my favorite day."),
                        AnswerChoice(id: 2, text: "monday is my favorite day."),
                        AnswerChoice(id: 3, text: "MONday is my favorite day."),
                        AnswerChoice(id: 4, text: "monday Is my favorite day.")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is the main idea?",
                    answers: [
                        AnswerChoice(id: 1, text: "The most important point"),
                        AnswerChoice(id: 2, text: "The last word"),
                        AnswerChoice(id: 3, text: "A character's name"),
                        AnswerChoice(id: 4, text: "The page number")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which word is an adjective?",
                    answers: [
                        AnswerChoice(id: 1, text: "Bright"),
                        AnswerChoice(id: 2, text: "Run"),
                        AnswerChoice(id: 3, text: "Quickly"),
                        AnswerChoice(id: 4, text: "And")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What should a conclusion do?",
                    answers: [
                        AnswerChoice(id: 1, text: "Wrap up the main ideas"),
                        AnswerChoice(id: 2, text: "Introduce a random topic"),
                        AnswerChoice(id: 3, text: "Delete the evidence"),
                        AnswerChoice(id: 4, text: "Start a new title")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Science":
            return [
                BattleQuestion(
                    prompt: "What force pulls objects toward Earth?",
                    answers: [
                        AnswerChoice(id: 1, text: "Gravity"),
                        AnswerChoice(id: 2, text: "Magnetism only"),
                        AnswerChoice(id: 3, text: "Sound"),
                        AnswerChoice(id: 4, text: "Light")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What gas do humans need to breathe?",
                    answers: [
                        AnswerChoice(id: 1, text: "Oxygen"),
                        AnswerChoice(id: 2, text: "Helium"),
                        AnswerChoice(id: 3, text: "Smoke"),
                        AnswerChoice(id: 4, text: "Steam")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is matter made of?",
                    answers: [
                        AnswerChoice(id: 1, text: "Particles"),
                        AnswerChoice(id: 2, text: "Only light"),
                        AnswerChoice(id: 3, text: "Ideas"),
                        AnswerChoice(id: 4, text: "Weather")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which state of matter keeps its own shape?",
                    answers: [
                        AnswerChoice(id: 1, text: "Solid"),
                        AnswerChoice(id: 2, text: "Liquid"),
                        AnswerChoice(id: 3, text: "Gas"),
                        AnswerChoice(id: 4, text: "Vapor only")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What tool measures temperature?",
                    answers: [
                        AnswerChoice(id: 1, text: "Thermometer"),
                        AnswerChoice(id: 2, text: "Compass"),
                        AnswerChoice(id: 3, text: "Ruler"),
                        AnswerChoice(id: 4, text: "Scale")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Logic":
            return [
                BattleQuestion(
                    prompt: "What should you do first when solving a puzzle?",
                    answers: [
                        AnswerChoice(id: 1, text: "Identify the clues"),
                        AnswerChoice(id: 2, text: "Ignore the rules"),
                        AnswerChoice(id: 3, text: "Guess every answer"),
                        AnswerChoice(id: 4, text: "Hide the puzzle")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a pattern?",
                    answers: [
                        AnswerChoice(id: 1, text: "A repeated or predictable arrangement"),
                        AnswerChoice(id: 2, text: "A random mistake"),
                        AnswerChoice(id: 3, text: "A single dot"),
                        AnswerChoice(id: 4, text: "An unrelated fact")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "If all blue keys open doors and this key is blue, what follows?",
                    answers: [
                        AnswerChoice(id: 1, text: "This key opens a door"),
                        AnswerChoice(id: 2, text: "The key is broken"),
                        AnswerChoice(id: 3, text: "No doors exist"),
                        AnswerChoice(id: 4, text: "The key is red")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which strategy helps test an idea?",
                    answers: [
                        AnswerChoice(id: 1, text: "Check it against the evidence"),
                        AnswerChoice(id: 2, text: "Change the evidence"),
                        AnswerChoice(id: 3, text: "Avoid all clues"),
                        AnswerChoice(id: 4, text: "Choose without thinking")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a sequence?",
                    answers: [
                        AnswerChoice(id: 1, text: "Items arranged in an order"),
                        AnswerChoice(id: 2, text: "A shape with no sides"),
                        AnswerChoice(id: 3, text: "A color blend"),
                        AnswerChoice(id: 4, text: "A sound level")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Art":
            return [
                BattleQuestion(
                    prompt: "Which colors are primary colors?",
                    answers: [
                        AnswerChoice(id: 1, text: "Red, yellow, and blue"),
                        AnswerChoice(id: 2, text: "Green, purple, and orange"),
                        AnswerChoice(id: 3, text: "Black, white, and gray"),
                        AnswerChoice(id: 4, text: "Pink, brown, and teal")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does texture describe?",
                    answers: [
                        AnswerChoice(id: 1, text: "How something feels or looks like it feels"),
                        AnswerChoice(id: 2, text: "How fast music is"),
                        AnswerChoice(id: 3, text: "How long a story is"),
                        AnswerChoice(id: 4, text: "How heavy a color is")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a sculpture?",
                    answers: [
                        AnswerChoice(id: 1, text: "Three-dimensional artwork"),
                        AnswerChoice(id: 2, text: "A musical beat"),
                        AnswerChoice(id: 3, text: "A written paragraph"),
                        AnswerChoice(id: 4, text: "A weather pattern")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does symmetry mean?",
                    answers: [
                        AnswerChoice(id: 1, text: "Parts balance or mirror each other"),
                        AnswerChoice(id: 2, text: "A picture has no colors"),
                        AnswerChoice(id: 3, text: "A drawing is unfinished"),
                        AnswerChoice(id: 4, text: "A shape has no pattern")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which tool is commonly used to paint?",
                    answers: [
                        AnswerChoice(id: 1, text: "Brush"),
                        AnswerChoice(id: 2, text: "Compass"),
                        AnswerChoice(id: 3, text: "Thermometer"),
                        AnswerChoice(id: 4, text: "Whistle")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Music":
            return [
                BattleQuestion(
                    prompt: "What is rhythm?",
                    answers: [
                        AnswerChoice(id: 1, text: "A pattern of beats"),
                        AnswerChoice(id: 2, text: "A type of paint"),
                        AnswerChoice(id: 3, text: "A story setting"),
                        AnswerChoice(id: 4, text: "A kind of instrument case")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does melody describe?",
                    answers: [
                        AnswerChoice(id: 1, text: "A sequence of musical notes"),
                        AnswerChoice(id: 2, text: "The volume knob"),
                        AnswerChoice(id: 3, text: "The stage lights"),
                        AnswerChoice(id: 4, text: "The audience size")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which instrument has keys and strings?",
                    answers: [
                        AnswerChoice(id: 1, text: "Piano"),
                        AnswerChoice(id: 2, text: "Trumpet"),
                        AnswerChoice(id: 3, text: "Drum"),
                        AnswerChoice(id: 4, text: "Flute")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does a rest mean in music?",
                    answers: [
                        AnswerChoice(id: 1, text: "A period of silence"),
                        AnswerChoice(id: 2, text: "A faster beat"),
                        AnswerChoice(id: 3, text: "A louder note"),
                        AnswerChoice(id: 4, text: "A new instrument")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which family does the violin belong to?",
                    answers: [
                        AnswerChoice(id: 1, text: "Strings"),
                        AnswerChoice(id: 2, text: "Brass"),
                        AnswerChoice(id: 3, text: "Percussion"),
                        AnswerChoice(id: 4, text: "Woodwind")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Space":
            return [
                BattleQuestion(
                    prompt: "What is Earth?",
                    answers: [
                        AnswerChoice(id: 1, text: "A planet"),
                        AnswerChoice(id: 2, text: "A star"),
                        AnswerChoice(id: 3, text: "A comet tail"),
                        AnswerChoice(id: 4, text: "A galaxy by itself")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What gives the Sun its light?",
                    answers: [
                        AnswerChoice(id: 1, text: "Nuclear energy"),
                        AnswerChoice(id: 2, text: "Moonlight"),
                        AnswerChoice(id: 3, text: "Ocean waves"),
                        AnswerChoice(id: 4, text: "Wind")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does the Moon orbit?",
                    answers: [
                        AnswerChoice(id: 1, text: "Earth"),
                        AnswerChoice(id: 2, text: "Mars"),
                        AnswerChoice(id: 3, text: "The Milky Way's edge"),
                        AnswerChoice(id: 4, text: "A cloud")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a telescope used for?",
                    answers: [
                        AnswerChoice(id: 1, text: "Observing distant objects"),
                        AnswerChoice(id: 2, text: "Measuring body temperature"),
                        AnswerChoice(id: 3, text: "Cooking food"),
                        AnswerChoice(id: 4, text: "Making rain")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which object has a tail made of dust and gas?",
                    answers: [
                        AnswerChoice(id: 1, text: "A comet"),
                        AnswerChoice(id: 2, text: "A planet"),
                        AnswerChoice(id: 3, text: "A moon crater"),
                        AnswerChoice(id: 4, text: "An asteroid belt only")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Problem Solving":
            return [
                BattleQuestion(
                    prompt: "What is a good first step for a difficult problem?",
                    answers: [
                        AnswerChoice(id: 1, text: "Break it into smaller parts"),
                        AnswerChoice(id: 2, text: "Skip all instructions"),
                        AnswerChoice(id: 3, text: "Give up immediately"),
                        AnswerChoice(id: 4, text: "Erase the clues")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What should you do after trying a solution?",
                    answers: [
                        AnswerChoice(id: 1, text: "Check whether it worked"),
                        AnswerChoice(id: 2, text: "Hide the result"),
                        AnswerChoice(id: 3, text: "Change the question"),
                        AnswerChoice(id: 4, text: "Ignore mistakes")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What can a diagram help you do?",
                    answers: [
                        AnswerChoice(id: 1, text: "See relationships and steps"),
                        AnswerChoice(id: 2, text: "Remove every option"),
                        AnswerChoice(id: 3, text: "Make a problem random"),
                        AnswerChoice(id: 4, text: "Avoid reading")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "When a strategy fails, what is a useful response?",
                    answers: [
                        AnswerChoice(id: 1, text: "Try a different strategy"),
                        AnswerChoice(id: 2, text: "Repeat it forever"),
                        AnswerChoice(id: 3, text: "Blame the clues"),
                        AnswerChoice(id: 4, text: "Stop examining the problem")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does evidence help you do?",
                    answers: [
                        AnswerChoice(id: 1, text: "Support a conclusion"),
                        AnswerChoice(id: 2, text: "Remove all questions"),
                        AnswerChoice(id: 3, text: "Change a fact into a guess"),
                        AnswerChoice(id: 4, text: "Hide a solution")
                    ],
                    correctAnswerID: 1
                )
            ]
        default:
            return [question(forSubject: subject)]
        }
    }

    static func freshQuestionBatch(for level: LearningLevel, count: Int) -> [BattleQuestion] {
        freshQuestionBatch(forLevelNumber: level.number, subject: level.subject, count: count)
    }


    static func freshQuestionBatch(forLevelNumber levelNumber: Int, subject: String = "", count: Int) -> [BattleQuestion] {
        let storageKey = "shownQuestionPrompts"
        let defaults = UserDefaults.standard
        let shown = Set(defaults.stringArray(forKey: storageKey) ?? [])
        let bank = questionBank(forLevelNumber: levelNumber, subject: subject)

        var available = bank.filter { !shown.contains($0.prompt) }.shuffled()
        if available.count < count {
            available = bank.shuffled()
        }

        let selected = Array(available.prefix(count))
        var updatedShown = Array(defaults.stringArray(forKey: storageKey) ?? [])
        for question in selected where !updatedShown.contains(question.prompt) {
            updatedShown.append(question.prompt)
        }

        if updatedShown.count > 100 {
            updatedShown.removeFirst(updatedShown.count - 100)
        }
        defaults.set(updatedShown, forKey: storageKey)

        return selected.map { question in
            BattleQuestion(
                prompt: question.prompt,
                answers: question.answers.shuffled(),
                correctAnswerID: question.correctAnswerID
            )
        }
    }

    private static func question(forSubject subject: String) -> BattleQuestion {
        switch subject {
        case "Math", "Geometry":
            BattleQuestion(
                prompt: "What is 7 + 5?",
                answers: [
                    AnswerChoice(id: 1, text: "12"),
                    AnswerChoice(id: 2, text: "11"),
                    AnswerChoice(id: 3, text: "13"),
                    AnswerChoice(id: 4, text: "17")
                ],
                correctAnswerID: 1
            )
        case "Reading", "Writing":
            BattleQuestion(
                prompt: "Which word rhymes with “cat”?",
                answers: [
                    AnswerChoice(id: 1, text: "hat"),
                    AnswerChoice(id: 2, text: "cup"),
                    AnswerChoice(id: 3, text: "car"),
                    AnswerChoice(id: 4, text: "tree")
                ],
                correctAnswerID: 1
            )
        case "Science", "Nature", "Space":
            BattleQuestion(
                prompt: "Which one is a living thing?",
                answers: [
                    AnswerChoice(id: 1, text: "A tree"),
                    AnswerChoice(id: 2, text: "A rock"),
                    AnswerChoice(id: 3, text: "A cloud"),
                    AnswerChoice(id: 4, text: "A spoon")
                ],
                correctAnswerID: 1
            )
        case "Art", "Music":
            BattleQuestion(
                prompt: "Which color is made by mixing blue and yellow?",
                answers: [
                    AnswerChoice(id: 1, text: "Green"),
                    AnswerChoice(id: 2, text: "Purple"),
                    AnswerChoice(id: 3, text: "Orange"),
                    AnswerChoice(id: 4, text: "Pink")
                ],
                correctAnswerID: 1
            )
        default:
            BattleQuestion(
                prompt: "Which choice helps you solve a tricky problem?",
                answers: [
                    AnswerChoice(id: 1, text: "Try a new strategy"),
                    AnswerChoice(id: 2, text: "Give up immediately"),
                    AnswerChoice(id: 3, text: "Ignore the clues"),
                    AnswerChoice(id: 4, text: "Choose randomly")
                ],
                correctAnswerID: 1
            )
        }
    }
}

 
 
 
 
 
 
 

import Observation
import SwiftUI

@Observable
final class PrizeWheelViewModel {
    let level: LearningLevel
    let questions: [BattleQuestion]
    let prizes = WheelPrize.available

    var questionIndex = 0
    var selectedAnswerID: Int?
    var hasAnswered = false
    var correctAnswerFound = false
    var hasSpun = false
    var wonPrize: WheelPrize?

    init(level: LearningLevel) {
        self.level = level
        self.questions = Array(NormalBattleViewModel.freshQuestionBatch(forLevelNumber: 1, subject: "Topic Mix", count: 3))
    }

    var question: BattleQuestion {
        questions[questionIndex]
    }

    var questionCount: Int {
        questions.count
    }

    var attemptNumber: Int {
        questionIndex + 1
    }

    var selectedAnswer: AnswerChoice? {
        guard let selectedAnswerID else {
            return nil
        }
        return question.answers.first { $0.id == selectedAnswerID }
    }

    var answeredCorrectly: Bool {
        guard let selectedAnswer else {
            return false
        }
        return question.isCorrect(selectedAnswer)
    }

    func choose(_ answer: AnswerChoice) {
        guard !hasAnswered, !correctAnswerFound else {
            return
        }
        selectedAnswerID = answer.id
        hasAnswered = true
        if answeredCorrectly {
            correctAnswerFound = true
        }
    }

    func nextQuestion() {
        guard questionIndex + 1 < questions.count else {
            return
        }
        questionIndex += 1
        selectedAnswerID = nil
        hasAnswered = false
    }

    func spin() {

        guard correctAnswerFound, !hasSpun else {
            return
        }
        wonPrize = prizes.randomElement()
        hasSpun = true
    }
}
