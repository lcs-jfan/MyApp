//  PrizeWheelViewModel.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//  GitHub Copilot connected prize-wheel rounds to fresh, non-repeating topic questions.

import Observation
import SwiftUI

@Observable
final class PrizeWheelViewModel {
    let level: LearningLevel
    let questions: [BattleQuestion]
    let prizes = WheelPrize.available

    var questionIndex = 0
    var selectedAnswerID: Int?
    var hasAnswered = false
    var correctAnswerFound = false
    var hasSpun = false
    var wonPrize: WheelPrize?

    init(level: LearningLevel) {
        self.level = level
        self.questions = Array(NormalBattleViewModel.freshQuestionBatch(forLevelNumber: 1, subject: "Topic Mix", count: 3))
    }

    var question: BattleQuestion {
        questions[questionIndex]
    }

    var questionCount: Int {
        questions.count
    }

    var attemptNumber: Int {
        questionIndex + 1
    }

    var selectedAnswer: AnswerChoice? {
        guard let selectedAnswerID else {
            return nil
        }
        return question.answers.first { $0.id == selectedAnswerID }
    }

    var answeredCorrectly: Bool {
        guard let selectedAnswer else {
            return false
        }
        return question.isCorrect(selectedAnswer)
    }

    func choose(_ answer: AnswerChoice) {
        guard !hasAnswered, !correctAnswerFound else {
            return
        }
        selectedAnswerID = answer.id
        hasAnswered = true
        if answeredCorrectly {
            correctAnswerFound = true
        }
    }

    func nextQuestion() {
        guard questionIndex + 1 < questions.count else {
            return
        }
        questionIndex += 1
        selectedAnswerID = nil
        hasAnswered = false
    }

    func spin() {
        // A prize can be awarded only once, and only after a correct response.
        guard correctAnswerFound, !hasSpun else {
            return
        }
        wonPrize = prizes.randomElement()
        hasSpun = true
    }
}
