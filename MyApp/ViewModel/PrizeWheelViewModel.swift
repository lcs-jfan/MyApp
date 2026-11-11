import Observation
import SwiftUI

@Observable
final class PrizeWheelViewModel {
    let level: LearningLevel
    let questions: [BattleQuestion]
    let prizes: [WheelPrize] = [
        WheelPrize(title: "Science Coat", icon: "cross.case.fill", color: .blue, kind: .outfit(.scientist)),
        WheelPrize(title: "Spiky Hair", icon: "sparkles", color: .orange, kind: .hair(.spikes)),
        WheelPrize(title: "Cocoa Skin Tone", icon: "circle.fill", color: .brown, kind: .skinTone(.cocoa)),
        WheelPrize(title: "Artist Outfit", icon: "paintpalette.fill", color: .pink, kind: .outfit(.artist)),
        WheelPrize(title: "Explorer Outfit", icon: "binoculars.fill", color: .green, kind: .outfit(.explorer)),
        WheelPrize(title: "Curly Hair", icon: "person.crop.circle.fill", color: .purple, kind: .hair(.curly))
    ]

    var questionIndex = 0
    var selectedAnswerID: Int?
    var hasAnswered = false
    var correctAnswerFound = false
    var hasSpun = false
    var wonPrize: WheelPrize?

    init(level: LearningLevel) {
        self.level = level
        self.questions = Array(
            NormalBattleViewModel.questionBank(forLevelNumber: 1)
                .shuffled()
                .prefix(3)
        ).map { question in
            BattleQuestion(
                prompt: question.prompt,
                answers: question.answers.shuffled(),
                correctAnswerID: question.correctAnswerID
            )
        }
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
        guard correctAnswerFound, !hasSpun else {
            return
        }
        wonPrize = prizes.randomElement()
        hasSpun = true
    }
}
