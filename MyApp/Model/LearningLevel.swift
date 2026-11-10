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
