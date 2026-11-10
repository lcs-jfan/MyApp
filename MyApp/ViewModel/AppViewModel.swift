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
}
