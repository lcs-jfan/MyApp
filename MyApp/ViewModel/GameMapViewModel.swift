import SwiftUI
import Observation

@Observable
final class GameMapViewModel {
    var selectedRoute: AdventureRoute = .sunny
    var isRouteConfirmed = false

    func confirmRoute() {
        isRouteConfirmed = true
    }

    let levelsByRoute: [AdventureRoute: [LearningLevel]] = [
        .sunny: [
            LearningLevel(number: 1, title: "Number Meadow", subject: "Math", icon: "plus.forwardslash.minus", color: .orange, position: CGPoint(x: 150, y: 210), isBoss: false, trail: .sunny),
            LearningLevel(number: 2, title: "Shape Summit", subject: "Geometry", icon: "triangle.fill", color: .yellow, position: CGPoint(x: 370, y: 300), isBoss: false, trail: .sunny),
            LearningLevel(number: 3, title: "Word Woods", subject: "Reading", icon: "book.fill", color: .green, position: CGPoint(x: 590, y: 180), isBoss: false, trail: .sunny),
            LearningLevel(number: 4, title: "Sky Castle", subject: "Mixed Quiz", icon: "star.fill", color: .purple, position: CGPoint(x: 810, y: 260), isBoss: false, trail: .sunny)
        ],
        .forest: [
            LearningLevel(number: 5, title: "Nature Grove", subject: "Nature", icon: "leaf.fill", color: .green, position: CGPoint(x: 150, y: 450), isBoss: false, trail: .forest),
            LearningLevel(number: 6, title: "Story Village", subject: "Writing", icon: "pencil.and.outline", color: .brown, position: CGPoint(x: 370, y: 540), isBoss: false, trail: .forest),
            LearningLevel(number: 7, title: "Science Shore", subject: "Science", icon: "flask.fill", color: .blue, position: CGPoint(x: 590, y: 420), isBoss: false, trail: .forest),
            LearningLevel(number: 8, title: "Logic Lighthouse", subject: "Logic", icon: "lightbulb.fill", color: .indigo, position: CGPoint(x: 810, y: 500), isBoss: false, trail: .forest)
        ],
        .rainbow: [
            LearningLevel(number: 9, title: "Color Canyon", subject: "Art", icon: "paintpalette.fill", color: .pink, position: CGPoint(x: 150, y: 690), isBoss: false, trail: .rainbow),
            LearningLevel(number: 10, title: "Music Mountain", subject: "Music", icon: "music.note", color: .purple, position: CGPoint(x: 370, y: 780), isBoss: false, trail: .rainbow),
            LearningLevel(number: 11, title: "Space Station", subject: "Space", icon: "moon.stars.fill", color: .blue, position: CGPoint(x: 590, y: 660), isBoss: false, trail: .rainbow),
            LearningLevel(number: 12, title: "Puzzle Palace", subject: "Problem Solving", icon: "puzzlepiece.fill", color: .teal, position: CGPoint(x: 810, y: 740), isBoss: false, trail: .rainbow)
        ]
    ]

    let boss = LearningLevel(
        number: 13,
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
