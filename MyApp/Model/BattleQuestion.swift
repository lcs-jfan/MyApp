//  BattleQuestion.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//  GitHub Copilot helped expand the shared Biomedical Toxicity, Marine Biology, and Music question rounds.

struct BattleQuestion {
    let prompt: String
    let answers: [AnswerChoice]
    let correctAnswerID: Int

    // Compare stable answer IDs so shuffling the choices does not change correctness.
    func isCorrect(_ answer: AnswerChoice) -> Bool {
        answer.id == correctAnswerID
    }
}

struct AnswerChoice: Identifiable {
    let id: Int
    let text: String
}
