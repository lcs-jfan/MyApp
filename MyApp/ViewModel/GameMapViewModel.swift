import SwiftUI
import Observation

@Observable
final class GameMapViewModel {
    var selectedRoute: AdventureRoute = .sunny

    let levels = [
        LearningLevel(number: 1, title: "Number Meadow", subject: "Math", icon: "plus.forwardslash.minus", color: .orange, position: CGPoint(x: 150, y: 510), isBoss: false),
        LearningLevel(number: 2, title: "Word Woods", subject: "Reading", icon: "book.fill", color: .green, position: CGPoint(x: 390, y: 350), isBoss: false),
        LearningLevel(number: 3, title: "Science Shore", subject: "Science", icon: "flask.fill", color: .blue, position: CGPoint(x: 620, y: 500), isBoss: false),
        LearningLevel(number: 4, title: "Sky Castle", subject: "Mixed Quiz", icon: "star.fill", color: .purple, position: CGPoint(x: 790, y: 220), isBoss: false)
    ]

    let boss = LearningLevel(
        number: 5,
        title: "Quiz Dragon",
        subject: "Final Challenge",
        icon: "flame.fill",
        color: .red,
        position: CGPoint(x: 960, y: 115),
        isBoss: true
    )
}
