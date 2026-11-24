//  WheelPrize.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//  GitHub Copilot helped persist collected prizes and show new unlocks in the backpack.

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

    // Keep each prize's display details and unlock effect together for both reward activities.
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
