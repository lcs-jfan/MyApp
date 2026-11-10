import SwiftUI

struct LearningLevel: Hashable, Identifiable {
    let number: Int
    let title: String
    let subject: String
    let icon: String
    let color: Color
    let position: CGPoint
    let isBoss: Bool

    var id: Int { number }

    static func == (lhs: LearningLevel, rhs: LearningLevel) -> Bool {
        lhs.number == rhs.number
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(number)
    }
}
