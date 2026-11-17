import Observation

@Observable
final class GameState {
    let maximumHP = 10
    private(set) var hp = 10

    func loseHP() {
        hp = max(0, hp - 1)
    }

    func restoreHP(by amount: Int) {
        hp = min(maximumHP, hp + max(0, amount))
    }
}
