import Foundation
import Observation

@Observable
final class AppViewModel {
    private enum StorageKey {
        static let collectedPrizeTitles = "collectedPrizeTitles"
        static let avatarSkinTone = "avatarSkinTone"
        static let avatarHair = "avatarHair"
        static let avatarOutfit = "avatarOutfit"
        static let roundNumber = "roundNumber"
    }

    var avatar = PlayerAvatar()
    var showsMap = false
    var collectedPrizes: [WheelPrize] = []
    private(set) var roundNumber = 1

    init() {
        let defaults = UserDefaults.standard

        if let rawValue = defaults.string(forKey: StorageKey.avatarSkinTone),
           let skinTone = SkinTone(rawValue: rawValue) {
            avatar.skinTone = skinTone
        }
        if let rawValue = defaults.string(forKey: StorageKey.avatarHair),
           let hair = HairStyle(rawValue: rawValue) {
            avatar.hair = hair
        }
        if let rawValue = defaults.string(forKey: StorageKey.avatarOutfit),
           let outfit = Outfit(rawValue: rawValue) {
            avatar.outfit = outfit
        }

        let savedTitles = Set(defaults.stringArray(forKey: StorageKey.collectedPrizeTitles) ?? [])
        collectedPrizes = WheelPrize.available.filter { savedTitles.contains($0.title) }
        roundNumber = max(1, defaults.integer(forKey: StorageKey.roundNumber))
    }

    func enterMap() {
        showsMap = true
    }

    func openWardrobe() {
        showsMap = false
    }

    func startNewRound() {
        roundNumber += 1
        showsMap = false
        UserDefaults.standard.set(roundNumber, forKey: StorageKey.roundNumber)
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

        let defaults = UserDefaults.standard
        defaults.set(collectedPrizes.map(\.title), forKey: StorageKey.collectedPrizeTitles)
        defaults.set(avatar.skinTone.rawValue, forKey: StorageKey.avatarSkinTone)
        defaults.set(avatar.hair.rawValue, forKey: StorageKey.avatarHair)
        defaults.set(avatar.outfit.rawValue, forKey: StorageKey.avatarOutfit)
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
