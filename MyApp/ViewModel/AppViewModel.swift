import Observation

@Observable
final class AppViewModel {
    var avatar = PlayerAvatar()
    var showsMap = false

    func enterMap() {
        showsMap = true
    }

    func openWardrobe() {
        showsMap = false
    }

    func apply(prize: WheelPrize) {
        switch prize.kind {
        case .outfit(let outfit):
            avatar.outfit = outfit
        case .hair(let hair):
            avatar.hair = hair
        case .skinTone(let skinTone):
            avatar.skinTone = skinTone
        }
    }
}
