//  MapRoute.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//  GitHub Copilot used route names, icons, and colors in the map route-selection overlay.

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
