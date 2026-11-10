import SwiftUI

struct AvatarView: View {
    let avatar: PlayerAvatar
    var size: CGFloat = 150

    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.35))
                .frame(width: size, height: size)

            VStack(spacing: -size * 0.04) {
                ZStack {
                    Circle()
                        .fill(avatar.skinColor)
                        .frame(width: size * 0.42, height: size * 0.42)

                    Image(systemName: avatar.hair.symbol)
                        .font(.system(size: size * 0.22, weight: .bold))
                        .foregroundStyle(avatar.hairColor)
                        .offset(y: -size * 0.16)
                }

                RoundedRectangle(cornerRadius: size * 0.12)
                    .fill(avatar.outfitColor)
                    .frame(width: size * 0.42, height: size * 0.38)
                    .overlay {
                        Image(systemName: avatar.outfit.symbol)
                            .font(.system(size: size * 0.16, weight: .bold))
                            .foregroundStyle(.white)
                    }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(avatar.outfit.rawValue) outfit with \(avatar.hair.rawValue.lowercased()) hair")
    }
}
