//  GameState.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//  GitHub Copilot did not make direct changes to this file.

import Observation

@Observable
final class GameState {
    let maximumHP = 10
    private(set) var hp = 10

    // Clamp health at zero and the maximum so gameplay actions cannot exceed valid bounds.
    func loseHP() {
        hp = max(0, hp - 1)
    }

    func restoreHP(by amount: Int) {
        hp = min(maximumHP, hp + max(0, amount))
    }
}
