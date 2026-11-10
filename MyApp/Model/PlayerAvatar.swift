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
