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
        WheelPrize(title: "Artist Outfit", icon: "paintpalette.fill", color: .pink, kind: .outfit(.artist)),
        WheelPrize(title: "Explorer Outfit", icon: "binoculars.fill", color: .green, kind: .outfit(.explorer)),
        WheelPrize(title: "Curly Hair", icon: "person.crop.circle.fill", color: .purple, kind: .hair(.curly))
    ]
}
