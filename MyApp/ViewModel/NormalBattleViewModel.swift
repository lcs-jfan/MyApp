import Observation

@Observable
final class NormalBattleViewModel {
    let level: LearningLevel
    private let questions: [BattleQuestion]
    var questionIndex = 0
    var selectedAnswerID: Int?
    var hasAnswered = false
    private(set) var answeredQuestionCount = 0

    init(level: LearningLevel) {
        self.level = level
        self.questions = Array(
            Self.questionBank(for: level)
                .shuffled()
                .prefix(5)
                .map { question in
                    BattleQuestion(
                        prompt: question.prompt,
                        answers: question.answers.shuffled(),
                        correctAnswerID: question.correctAnswerID
                    )
                }
        )
    }

    var question: BattleQuestion {
        questions[questionIndex]
    }

    var isLastQuestion: Bool {
        questionIndex == questions.count - 1
    }

    var questionCount: Int {
        questions.count
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
        if answeredCorrectly {
            answeredQuestionCount += 1
        }
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
                    prompt: "Which statement about a toxic substance is most accurate?",
                    answers: [
                        AnswerChoice(id: 1, text: "It can harm the body at some dose"),
                        AnswerChoice(id: 2, text: "It is always dangerous to touch"),
                        AnswerChoice(id: 3, text: "It only affects grown-ups"),
                        AnswerChoice(id: 4, text: "It is safe if it has no smell")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which evidence shows that a whale is a mammal?",
                    answers: [
                        AnswerChoice(id: 1, text: "It breathes air and feeds milk to its young"),
                        AnswerChoice(id: 2, text: "It lives in salt water"),
                        AnswerChoice(id: 3, text: "It has fins and a tail"),
                        AnswerChoice(id: 4, text: "It swims faster than many fish")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which musical feature tells how high or low a note sounds?",
                    answers: [
                        AnswerChoice(id: 1, text: "Pitch"),
                        AnswerChoice(id: 2, text: "Tempo"),
                        AnswerChoice(id: 3, text: "Dynamics"),
                        AnswerChoice(id: 4, text: "Rhythm")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What can change how harmful a substance is?",
                    answers: [
                        AnswerChoice(id: 1, text: "The amount that enters the body"),
                        AnswerChoice(id: 2, text: "The color of its container"),
                        AnswerChoice(id: 3, text: "Whether it has a strong smell"),
                        AnswerChoice(id: 4, text: "How expensive it is")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is the safest response to an unlabeled bottle?",
                    answers: [
                        AnswerChoice(id: 1, text: "Do not touch it and tell a trusted adult"),
                        AnswerChoice(id: 2, text: "Smell it from very close"),
                        AnswerChoice(id: 3, text: "Mix a tiny amount with water"),
                        AnswerChoice(id: 4, text: "Taste a drop to identify it")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Why are algae important in many ocean food webs?",
                    answers: [
                        AnswerChoice(id: 1, text: "They make food using sunlight"),
                        AnswerChoice(id: 2, text: "They keep every ocean animal warm"),
                        AnswerChoice(id: 3, text: "They turn salt water into fresh water"),
                        AnswerChoice(id: 4, text: "They are the largest ocean predators")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does tempo tell us about a piece of music?",
                    answers: [
                        AnswerChoice(id: 1, text: "How fast or slow it should be"),
                        AnswerChoice(id: 2, text: "How loud or soft it should be"),
                        AnswerChoice(id: 3, text: "Which instruments are playing"),
                        AnswerChoice(id: 4, text: "How many notes are in the song")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Why can warm ocean water be harmful to coral reefs?",
                    answers: [
                        AnswerChoice(id: 1, text: "Coral can lose the algae that help feed it"),
                        AnswerChoice(id: 2, text: "Coral instantly turns into a fish"),
                        AnswerChoice(id: 3, text: "Warm water contains no oxygen at all"),
                        AnswerChoice(id: 4, text: "Coral can only live in freshwater")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which feature helps a seal stay warm in cold water?",
                    answers: [
                        AnswerChoice(id: 1, text: "A thick layer of blubber"),
                        AnswerChoice(id: 2, text: "Bright scales that reflect sunlight"),
                        AnswerChoice(id: 3, text: "Long roots under the seafloor"),
                        AnswerChoice(id: 4, text: "A shell that opens and closes")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does dynamics describe in music?",
                    answers: [
                        AnswerChoice(id: 1, text: "Changes in loudness and softness"),
                        AnswerChoice(id: 2, text: "The speed of the beat"),
                        AnswerChoice(id: 3, text: "The distance between instruments"),
                        AnswerChoice(id: 4, text: "The number of verses")
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
