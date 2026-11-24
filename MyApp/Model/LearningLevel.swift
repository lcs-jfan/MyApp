//  LearningLevel.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//  GitHub Copilot helped align level identity with route-based map progression.

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

    // Include the route in the ID so each route's copy of a level is distinct.
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
