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
}
