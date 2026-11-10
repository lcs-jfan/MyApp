import Observation

@Observable
final class NormalBattleViewModel {
    let level: LearningLevel
    let question: BattleQuestion
    var selectedAnswerID: Int?
    var hasAnswered = false

    init(level: LearningLevel) {
        self.level = level
        self.question = Self.question(for: level)
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
        guard !hasAnswered else {
            return
        }
        selectedAnswerID = answer.id
        hasAnswered = true
    }

    func tryAgain() {
        selectedAnswerID = nil
        hasAnswered = false
    }

    private static func question(for level: LearningLevel) -> BattleQuestion {
        switch level.subject {
        case "Math", "Geometry":
            BattleQuestion(
                prompt: "What is 7 + 5?",
                answers: [
                    AnswerChoice(id: 1, text: "12"),
                    AnswerChoice(id: 2, text: "11"),
                    AnswerChoice(id: 3, text: "13"),
                    AnswerChoice(id: 4, text: "17")
                ],
                correctAnswerID: 1
            )
        case "Reading", "Writing":
            BattleQuestion(
                prompt: "Which word rhymes with “cat”?",
                answers: [
                    AnswerChoice(id: 1, text: "hat"),
                    AnswerChoice(id: 2, text: "cup"),
                    AnswerChoice(id: 3, text: "car"),
                    AnswerChoice(id: 4, text: "tree")
                ],
                correctAnswerID: 1
            )
        case "Science", "Nature", "Space":
            BattleQuestion(
                prompt: "Which one is a living thing?",
                answers: [
                    AnswerChoice(id: 1, text: "A tree"),
                    AnswerChoice(id: 2, text: "A rock"),
                    AnswerChoice(id: 3, text: "A cloud"),
                    AnswerChoice(id: 4, text: "A spoon")
                ],
                correctAnswerID: 1
            )
        case "Art", "Music":
            BattleQuestion(
                prompt: "Which color is made by mixing blue and yellow?",
                answers: [
                    AnswerChoice(id: 1, text: "Green"),
                    AnswerChoice(id: 2, text: "Purple"),
                    AnswerChoice(id: 3, text: "Orange"),
                    AnswerChoice(id: 4, text: "Pink")
                ],
                correctAnswerID: 1
            )
        default:
            BattleQuestion(
                prompt: "Which choice helps you solve a tricky problem?",
                answers: [
                    AnswerChoice(id: 1, text: "Try a new strategy"),
                    AnswerChoice(id: 2, text: "Give up immediately"),
                    AnswerChoice(id: 3, text: "Ignore the clues"),
                    AnswerChoice(id: 4, text: "Choose randomly")
                ],
                correctAnswerID: 1
            )
        }
    }
}
