import Observation

@Observable
final class NormalBattleViewModel {
    let level: LearningLevel
    private let questions: [BattleQuestion]
    var questionIndex = 0
    var selectedAnswerID: Int?
    var hasAnswered = false

    init(level: LearningLevel) {
        self.level = level
        self.questions = Array(Self.questionBank(for: level).shuffled().prefix(5))
    }

    var question: BattleQuestion {
        questions[questionIndex]
    }

    var isLastQuestion: Bool {
        questionIndex == questions.count - 1
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

    func advanceToNextQuestion() {
        guard !isLastQuestion else {
            return
        }
        questionIndex += 1
        tryAgain()
    }

    private static func questionBank(for level: LearningLevel) -> [BattleQuestion] {
        if level.number == 1 {
            return [
                BattleQuestion(
                    prompt: "What does “toxic” mean?",
                    answers: [
                        AnswerChoice(id: 1, text: "Able to harm the body"),
                        AnswerChoice(id: 2, text: "Very colorful"),
                        AnswerChoice(id: 3, text: "Easy to carry"),
                        AnswerChoice(id: 4, text: "Helpful for every person")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which animal is a marine mammal?",
                    answers: [
                        AnswerChoice(id: 1, text: "Dolphin"),
                        AnswerChoice(id: 2, text: "Shark"),
                        AnswerChoice(id: 3, text: "Seaweed"),
                        AnswerChoice(id: 4, text: "Jellyfish")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which instrument usually has black and white keys?",
                    answers: [
                        AnswerChoice(id: 1, text: "Piano"),
                        AnswerChoice(id: 2, text: "Drum"),
                        AnswerChoice(id: 3, text: "Trumpet"),
                        AnswerChoice(id: 4, text: "Violin")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Why should you never taste an unknown chemical?",
                    answers: [
                        AnswerChoice(id: 1, text: "It could be toxic"),
                        AnswerChoice(id: 2, text: "It might be too cold"),
                        AnswerChoice(id: 3, text: "It might be too loud"),
                        AnswerChoice(id: 4, text: "It could change color")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which animal breathes air through lungs?",
                    answers: [
                        AnswerChoice(id: 1, text: "Whale"),
                        AnswerChoice(id: 2, text: "Seaweed"),
                        AnswerChoice(id: 3, text: "Clam"),
                        AnswerChoice(id: 4, text: "Starfish")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What do marine biologists study?",
                    answers: [
                        AnswerChoice(id: 1, text: "Life in oceans and seas"),
                        AnswerChoice(id: 2, text: "Only mountain rocks"),
                        AnswerChoice(id: 3, text: "Only weather balloons"),
                        AnswerChoice(id: 4, text: "Only musical instruments")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which part of music keeps a steady pattern?",
                    answers: [
                        AnswerChoice(id: 1, text: "Rhythm"),
                        AnswerChoice(id: 2, text: "Paint"),
                        AnswerChoice(id: 3, text: "Gravity"),
                        AnswerChoice(id: 4, text: "Temperature")
                    ],
                    correctAnswerID: 1
                )
            ]
        }

        return [question(for: level)]
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
