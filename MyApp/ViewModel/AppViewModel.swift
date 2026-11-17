import Observation

@Observable
final class AppViewModel {
    var avatar = PlayerAvatar()
    var showsMap = false
    var collectedPrizes: [WheelPrize] = []

    func enterMap() {
        showsMap = true
    }

    func openWardrobe() {
        showsMap = false
    }

    func collect(prize: WheelPrize) {
        if !collectedPrizes.contains(where: { $0.title == prize.title }) {
            collectedPrizes.append(prize)
        }

        switch prize.kind {
        case .outfit(let outfit):
            avatar.outfit = outfit
        case .hair(let hair):
            avatar.hair = hair
        case .skinTone(let skinTone):
            avatar.skinTone = skinTone
        }
    }

    func isUnlocked(_ outfit: Outfit) -> Bool {
        outfit == .explorer || collectedPrizes.contains {
            guard case .outfit(let unlockedOutfit) = $0.kind else {
                return false
            }
            return unlockedOutfit == outfit
        }
    }

    func isUnlocked(_ hair: HairStyle) -> Bool {
        hair == .curly || collectedPrizes.contains {
            guard case .hair(let unlockedHair) = $0.kind else {
                return false
            }
            return unlockedHair == hair
        }
    }

    func isUnlocked(_ skinTone: SkinTone) -> Bool {
        skinTone == .sunny || collectedPrizes.contains {
            guard case .skinTone(let unlockedSkinTone) = $0.kind else {
                return false
            }
            return unlockedSkinTone == skinTone
        }
    }
}
