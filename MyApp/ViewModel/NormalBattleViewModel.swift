import Foundation
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
        self.questions = Array(Self.freshQuestionBatch(for: level, count: 5))
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

    static func questionBank(for level: LearningLevel) -> [BattleQuestion] {
        questionBank(forLevelNumber: level.number, subject: level.subject)
    }

    static func questionBank(forLevelNumber levelNumber: Int, subject: String = "") -> [BattleQuestion] {
        if levelNumber == 1 {
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
                ),
                BattleQuestion(
                    prompt: "What is the safest way to handle an unknown powder?",
                    answers: [
                        AnswerChoice(id: 1, text: "Do not touch it and alert a trusted adult"),
                        AnswerChoice(id: 2, text: "Taste a small amount"),
                        AnswerChoice(id: 3, text: "Pour it into a drink"),
                        AnswerChoice(id: 4, text: "Rub it on your skin")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does dose mean in toxicology?",
                    answers: [
                        AnswerChoice(id: 1, text: "The amount of a substance exposed to the body"),
                        AnswerChoice(id: 2, text: "The color of a substance"),
                        AnswerChoice(id: 3, text: "The shape of a container"),
                        AnswerChoice(id: 4, text: "The temperature outside")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Why should chemicals stay in their labeled containers?",
                    answers: [
                        AnswerChoice(id: 1, text: "Labels help people know the hazards and safe use"),
                        AnswerChoice(id: 2, text: "Labels make the chemical taste better"),
                        AnswerChoice(id: 3, text: "Labels stop the container from melting"),
                        AnswerChoice(id: 4, text: "Labels remove the chemical")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is the correct first action after breathing harmful fumes?",
                    answers: [
                        AnswerChoice(id: 1, text: "Move to fresh air and get adult help"),
                        AnswerChoice(id: 2, text: "Breathe more deeply"),
                        AnswerChoice(id: 3, text: "Continue working"),
                        AnswerChoice(id: 4, text: "Hide the fumes")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which item gives the clearest warning about a chemical?",
                    answers: [
                        AnswerChoice(id: 1, text: "Its hazard label"),
                        AnswerChoice(id: 2, text: "Its smell"),
                        AnswerChoice(id: 3, text: "Its price"),
                        AnswerChoice(id: 4, text: "Its container size")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Why should chemical splash goggles be worn?",
                    answers: [
                        AnswerChoice(id: 1, text: "They protect the eyes"),
                        AnswerChoice(id: 2, text: "They make liquids disappear"),
                        AnswerChoice(id: 3, text: "They remove bad odors"),
                        AnswerChoice(id: 4, text: "They keep glasses warm")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What role does a whale's tail fluke play?",
                    answers: [
                        AnswerChoice(id: 1, text: "It helps propel the whale through water"),
                        AnswerChoice(id: 2, text: "It filters sunlight"),
                        AnswerChoice(id: 3, text: "It makes the whale breathe underwater"),
                        AnswerChoice(id: 4, text: "It digests fish")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a whale's blowhole used for?",
                    answers: [
                        AnswerChoice(id: 1, text: "Breathing at the water surface"),
                        AnswerChoice(id: 2, text: "Filtering sand"),
                        AnswerChoice(id: 3, text: "Seeing underwater"),
                        AnswerChoice(id: 4, text: "Holding eggs")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "How does a whale breathe?",
                    answers: [
                        AnswerChoice(id: 1, text: "It comes to the surface and uses lungs"),
                        AnswerChoice(id: 2, text: "It extracts air with gills"),
                        AnswerChoice(id: 3, text: "It absorbs air through its fins"),
                        AnswerChoice(id: 4, text: "It never needs oxygen")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What do whales use echolocation to help with?",
                    answers: [
                        AnswerChoice(id: 1, text: "Finding objects and prey"),
                        AnswerChoice(id: 2, text: "Growing a shell"),
                        AnswerChoice(id: 3, text: "Making fresh water"),
                        AnswerChoice(id: 4, text: "Changing colors")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What keeps many marine mammals warm?",
                    answers: [
                        AnswerChoice(id: 1, text: "Blubber"),
                        AnswerChoice(id: 2, text: "Leaf scales"),
                        AnswerChoice(id: 3, text: "Dry sand"),
                        AnswerChoice(id: 4, text: "Seaweed shells")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which organism begins many marine food chains?",
                    answers: [
                        AnswerChoice(id: 1, text: "Photosynthetic plankton"),
                        AnswerChoice(id: 2, text: "A blue whale"),
                        AnswerChoice(id: 3, text: "A shark"),
                        AnswerChoice(id: 4, text: "An octopus")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is rhythm in music?",
                    answers: [
                        AnswerChoice(id: 1, text: "A pattern of long and short sounds"),
                        AnswerChoice(id: 2, text: "The brightness of a tone"),
                        AnswerChoice(id: 3, text: "The number of instruments"),
                        AnswerChoice(id: 4, text: "The size of the stage")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does a musical clef help show?",
                    answers: [
                        AnswerChoice(id: 1, text: "The pitch range of notes on a staff"),
                        AnswerChoice(id: 2, text: "The speed of a performance"),
                        AnswerChoice(id: 3, text: "The name of the audience"),
                        AnswerChoice(id: 4, text: "How much a song costs")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What happens when a musical beat is played faster?",
                    answers: [
                        AnswerChoice(id: 1, text: "The tempo increases"),
                        AnswerChoice(id: 2, text: "The pitch always drops"),
                        AnswerChoice(id: 3, text: "The melody disappears"),
                        AnswerChoice(id: 4, text: "The dynamics become silence")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which symbol commonly indicates silence in music?",
                    answers: [
                        AnswerChoice(id: 1, text: "A rest"),
                        AnswerChoice(id: 2, text: "A treble clef"),
                        AnswerChoice(id: 3, text: "A time signature"),
                        AnswerChoice(id: 4, text: "A measure line")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a melody?",
                    answers: [
                        AnswerChoice(id: 1, text: "A sequence of notes that is heard as a tune"),
                        AnswerChoice(id: 2, text: "Only the rhythm of a drum"),
                        AnswerChoice(id: 3, text: "A silent pause"),
                        AnswerChoice(id: 4, text: "A written list of instruments")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which term describes several notes played together?",
                    answers: [
                        AnswerChoice(id: 1, text: "Chord"),
                        AnswerChoice(id: 2, text: "Rest"),
                        AnswerChoice(id: 3, text: "Tempo"),
                        AnswerChoice(id: 4, text: "Coda")
                    ],
                    correctAnswerID: 1
                )
            ]
        }

        if levelNumber == 2 {
            return [
                BattleQuestion(
                    prompt: "How many sides does a triangle have?",
                    answers: [
                        AnswerChoice(id: 1, text: "Three"),
                        AnswerChoice(id: 2, text: "Four"),
                        AnswerChoice(id: 3, text: "Five"),
                        AnswerChoice(id: 4, text: "Six")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which shape has four equal sides?",
                    answers: [
                        AnswerChoice(id: 1, text: "Square"),
                        AnswerChoice(id: 2, text: "Triangle"),
                        AnswerChoice(id: 3, text: "Circle"),
                        AnswerChoice(id: 4, text: "Oval")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is the perimeter of a square with 3 cm sides?",
                    answers: [
                        AnswerChoice(id: 1, text: "12 cm"),
                        AnswerChoice(id: 2, text: "9 cm"),
                        AnswerChoice(id: 3, text: "6 cm"),
                        AnswerChoice(id: 4, text: "15 cm")
                    ],
                    correctAnswerID: 1
                )
            ]
        }

        switch subject {
        case "Nature":
            return [
                BattleQuestion(
                    prompt: "What do plants need to make food?",
                    answers: [
                        AnswerChoice(id: 1, text: "Sunlight"),
                        AnswerChoice(id: 2, text: "Plastic"),
                        AnswerChoice(id: 3, text: "Metal"),
                        AnswerChoice(id: 4, text: "Sound")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which animal is an herbivore?",
                    answers: [
                        AnswerChoice(id: 1, text: "Deer"),
                        AnswerChoice(id: 2, text: "Tiger"),
                        AnswerChoice(id: 3, text: "Hawk"),
                        AnswerChoice(id: 4, text: "Shark")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a habitat?",
                    answers: [
                        AnswerChoice(id: 1, text: "A place where an organism lives"),
                        AnswerChoice(id: 2, text: "A type of weather"),
                        AnswerChoice(id: 3, text: "A kind of rock"),
                        AnswerChoice(id: 4, text: "A food chain only")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What do bees help many flowering plants do?",
                    answers: [
                        AnswerChoice(id: 1, text: "Reproduce through pollination"),
                        AnswerChoice(id: 2, text: "Freeze their roots"),
                        AnswerChoice(id: 3, text: "Change into trees"),
                        AnswerChoice(id: 4, text: "Make sunlight")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which resource can be renewed naturally?",
                    answers: [
                        AnswerChoice(id: 1, text: "Wind"),
                        AnswerChoice(id: 2, text: "Coal"),
                        AnswerChoice(id: 3, text: "Plastic"),
                        AnswerChoice(id: 4, text: "Gasoline")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Writing":
            return [
                BattleQuestion(
                    prompt: "What does a verb show?",
                    answers: [
                        AnswerChoice(id: 1, text: "An action or state"),
                        AnswerChoice(id: 2, text: "A color"),
                        AnswerChoice(id: 3, text: "A number only"),
                        AnswerChoice(id: 4, text: "A paragraph's length")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which sentence uses a capital letter correctly?",
                    answers: [
                        AnswerChoice(id: 1, text: "Monday is my favorite day."),
                        AnswerChoice(id: 2, text: "monday is my favorite day."),
                        AnswerChoice(id: 3, text: "MONday is my favorite day."),
                        AnswerChoice(id: 4, text: "monday Is my favorite day.")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is the main idea?",
                    answers: [
                        AnswerChoice(id: 1, text: "The most important point"),
                        AnswerChoice(id: 2, text: "The last word"),
                        AnswerChoice(id: 3, text: "A character's name"),
                        AnswerChoice(id: 4, text: "The page number")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which word is an adjective?",
                    answers: [
                        AnswerChoice(id: 1, text: "Bright"),
                        AnswerChoice(id: 2, text: "Run"),
                        AnswerChoice(id: 3, text: "Quickly"),
                        AnswerChoice(id: 4, text: "And")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What should a conclusion do?",
                    answers: [
                        AnswerChoice(id: 1, text: "Wrap up the main ideas"),
                        AnswerChoice(id: 2, text: "Introduce a random topic"),
                        AnswerChoice(id: 3, text: "Delete the evidence"),
                        AnswerChoice(id: 4, text: "Start a new title")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Science":
            return [
                BattleQuestion(
                    prompt: "What force pulls objects toward Earth?",
                    answers: [
                        AnswerChoice(id: 1, text: "Gravity"),
                        AnswerChoice(id: 2, text: "Magnetism only"),
                        AnswerChoice(id: 3, text: "Sound"),
                        AnswerChoice(id: 4, text: "Light")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What gas do humans need to breathe?",
                    answers: [
                        AnswerChoice(id: 1, text: "Oxygen"),
                        AnswerChoice(id: 2, text: "Helium"),
                        AnswerChoice(id: 3, text: "Smoke"),
                        AnswerChoice(id: 4, text: "Steam")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is matter made of?",
                    answers: [
                        AnswerChoice(id: 1, text: "Particles"),
                        AnswerChoice(id: 2, text: "Only light"),
                        AnswerChoice(id: 3, text: "Ideas"),
                        AnswerChoice(id: 4, text: "Weather")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which state of matter keeps its own shape?",
                    answers: [
                        AnswerChoice(id: 1, text: "Solid"),
                        AnswerChoice(id: 2, text: "Liquid"),
                        AnswerChoice(id: 3, text: "Gas"),
                        AnswerChoice(id: 4, text: "Vapor only")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What tool measures temperature?",
                    answers: [
                        AnswerChoice(id: 1, text: "Thermometer"),
                        AnswerChoice(id: 2, text: "Compass"),
                        AnswerChoice(id: 3, text: "Ruler"),
                        AnswerChoice(id: 4, text: "Scale")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Logic":
            return [
                BattleQuestion(
                    prompt: "What should you do first when solving a puzzle?",
                    answers: [
                        AnswerChoice(id: 1, text: "Identify the clues"),
                        AnswerChoice(id: 2, text: "Ignore the rules"),
                        AnswerChoice(id: 3, text: "Guess every answer"),
                        AnswerChoice(id: 4, text: "Hide the puzzle")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a pattern?",
                    answers: [
                        AnswerChoice(id: 1, text: "A repeated or predictable arrangement"),
                        AnswerChoice(id: 2, text: "A random mistake"),
                        AnswerChoice(id: 3, text: "A single dot"),
                        AnswerChoice(id: 4, text: "An unrelated fact")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "If all blue keys open doors and this key is blue, what follows?",
                    answers: [
                        AnswerChoice(id: 1, text: "This key opens a door"),
                        AnswerChoice(id: 2, text: "The key is broken"),
                        AnswerChoice(id: 3, text: "No doors exist"),
                        AnswerChoice(id: 4, text: "The key is red")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which strategy helps test an idea?",
                    answers: [
                        AnswerChoice(id: 1, text: "Check it against the evidence"),
                        AnswerChoice(id: 2, text: "Change the evidence"),
                        AnswerChoice(id: 3, text: "Avoid all clues"),
                        AnswerChoice(id: 4, text: "Choose without thinking")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a sequence?",
                    answers: [
                        AnswerChoice(id: 1, text: "Items arranged in an order"),
                        AnswerChoice(id: 2, text: "A shape with no sides"),
                        AnswerChoice(id: 3, text: "A color blend"),
                        AnswerChoice(id: 4, text: "A sound level")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Art":
            return [
                BattleQuestion(
                    prompt: "Which colors are primary colors?",
                    answers: [
                        AnswerChoice(id: 1, text: "Red, yellow, and blue"),
                        AnswerChoice(id: 2, text: "Green, purple, and orange"),
                        AnswerChoice(id: 3, text: "Black, white, and gray"),
                        AnswerChoice(id: 4, text: "Pink, brown, and teal")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does texture describe?",
                    answers: [
                        AnswerChoice(id: 1, text: "How something feels or looks like it feels"),
                        AnswerChoice(id: 2, text: "How fast music is"),
                        AnswerChoice(id: 3, text: "How long a story is"),
                        AnswerChoice(id: 4, text: "How heavy a color is")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a sculpture?",
                    answers: [
                        AnswerChoice(id: 1, text: "Three-dimensional artwork"),
                        AnswerChoice(id: 2, text: "A musical beat"),
                        AnswerChoice(id: 3, text: "A written paragraph"),
                        AnswerChoice(id: 4, text: "A weather pattern")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does symmetry mean?",
                    answers: [
                        AnswerChoice(id: 1, text: "Parts balance or mirror each other"),
                        AnswerChoice(id: 2, text: "A picture has no colors"),
                        AnswerChoice(id: 3, text: "A drawing is unfinished"),
                        AnswerChoice(id: 4, text: "A shape has no pattern")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which tool is commonly used to paint?",
                    answers: [
                        AnswerChoice(id: 1, text: "Brush"),
                        AnswerChoice(id: 2, text: "Compass"),
                        AnswerChoice(id: 3, text: "Thermometer"),
                        AnswerChoice(id: 4, text: "Whistle")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Music":
            return [
                BattleQuestion(
                    prompt: "What is rhythm?",
                    answers: [
                        AnswerChoice(id: 1, text: "A pattern of beats"),
                        AnswerChoice(id: 2, text: "A type of paint"),
                        AnswerChoice(id: 3, text: "A story setting"),
                        AnswerChoice(id: 4, text: "A kind of instrument case")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does melody describe?",
                    answers: [
                        AnswerChoice(id: 1, text: "A sequence of musical notes"),
                        AnswerChoice(id: 2, text: "The volume knob"),
                        AnswerChoice(id: 3, text: "The stage lights"),
                        AnswerChoice(id: 4, text: "The audience size")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which instrument has keys and strings?",
                    answers: [
                        AnswerChoice(id: 1, text: "Piano"),
                        AnswerChoice(id: 2, text: "Trumpet"),
                        AnswerChoice(id: 3, text: "Drum"),
                        AnswerChoice(id: 4, text: "Flute")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does a rest mean in music?",
                    answers: [
                        AnswerChoice(id: 1, text: "A period of silence"),
                        AnswerChoice(id: 2, text: "A faster beat"),
                        AnswerChoice(id: 3, text: "A louder note"),
                        AnswerChoice(id: 4, text: "A new instrument")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which family does the violin belong to?",
                    answers: [
                        AnswerChoice(id: 1, text: "Strings"),
                        AnswerChoice(id: 2, text: "Brass"),
                        AnswerChoice(id: 3, text: "Percussion"),
                        AnswerChoice(id: 4, text: "Woodwind")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Space":
            return [
                BattleQuestion(
                    prompt: "What is Earth?",
                    answers: [
                        AnswerChoice(id: 1, text: "A planet"),
                        AnswerChoice(id: 2, text: "A star"),
                        AnswerChoice(id: 3, text: "A comet tail"),
                        AnswerChoice(id: 4, text: "A galaxy by itself")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What gives the Sun its light?",
                    answers: [
                        AnswerChoice(id: 1, text: "Nuclear energy"),
                        AnswerChoice(id: 2, text: "Moonlight"),
                        AnswerChoice(id: 3, text: "Ocean waves"),
                        AnswerChoice(id: 4, text: "Wind")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does the Moon orbit?",
                    answers: [
                        AnswerChoice(id: 1, text: "Earth"),
                        AnswerChoice(id: 2, text: "Mars"),
                        AnswerChoice(id: 3, text: "The Milky Way's edge"),
                        AnswerChoice(id: 4, text: "A cloud")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What is a telescope used for?",
                    answers: [
                        AnswerChoice(id: 1, text: "Observing distant objects"),
                        AnswerChoice(id: 2, text: "Measuring body temperature"),
                        AnswerChoice(id: 3, text: "Cooking food"),
                        AnswerChoice(id: 4, text: "Making rain")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "Which object has a tail made of dust and gas?",
                    answers: [
                        AnswerChoice(id: 1, text: "A comet"),
                        AnswerChoice(id: 2, text: "A planet"),
                        AnswerChoice(id: 3, text: "A moon crater"),
                        AnswerChoice(id: 4, text: "An asteroid belt only")
                    ],
                    correctAnswerID: 1
                )
            ]
        case "Problem Solving":
            return [
                BattleQuestion(
                    prompt: "What is a good first step for a difficult problem?",
                    answers: [
                        AnswerChoice(id: 1, text: "Break it into smaller parts"),
                        AnswerChoice(id: 2, text: "Skip all instructions"),
                        AnswerChoice(id: 3, text: "Give up immediately"),
                        AnswerChoice(id: 4, text: "Erase the clues")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What should you do after trying a solution?",
                    answers: [
                        AnswerChoice(id: 1, text: "Check whether it worked"),
                        AnswerChoice(id: 2, text: "Hide the result"),
                        AnswerChoice(id: 3, text: "Change the question"),
                        AnswerChoice(id: 4, text: "Ignore mistakes")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What can a diagram help you do?",
                    answers: [
                        AnswerChoice(id: 1, text: "See relationships and steps"),
                        AnswerChoice(id: 2, text: "Remove every option"),
                        AnswerChoice(id: 3, text: "Make a problem random"),
                        AnswerChoice(id: 4, text: "Avoid reading")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "When a strategy fails, what is a useful response?",
                    answers: [
                        AnswerChoice(id: 1, text: "Try a different strategy"),
                        AnswerChoice(id: 2, text: "Repeat it forever"),
                        AnswerChoice(id: 3, text: "Blame the clues"),
                        AnswerChoice(id: 4, text: "Stop examining the problem")
                    ],
                    correctAnswerID: 1
                ),
                BattleQuestion(
                    prompt: "What does evidence help you do?",
                    answers: [
                        AnswerChoice(id: 1, text: "Support a conclusion"),
                        AnswerChoice(id: 2, text: "Remove all questions"),
                        AnswerChoice(id: 3, text: "Change a fact into a guess"),
                        AnswerChoice(id: 4, text: "Hide a solution")
                    ],
                    correctAnswerID: 1
                )
            ]
        default:
            return [question(forSubject: subject)]
        }
    }

    static func freshQuestionBatch(for level: LearningLevel, count: Int) -> [BattleQuestion] {
        freshQuestionBatch(forLevelNumber: level.number, subject: level.subject, count: count)
    }

    static func freshQuestionBatch(forLevelNumber levelNumber: Int, subject: String = "", count: Int) -> [BattleQuestion] {
        let storageKey = "shownQuestionPrompts"
        let defaults = UserDefaults.standard
        let shown = Set(defaults.stringArray(forKey: storageKey) ?? [])
        let bank = questionBank(forLevelNumber: levelNumber, subject: subject)

        var available = bank.filter { !shown.contains($0.prompt) }.shuffled()
        if available.count < count {
            available = bank.shuffled()
        }

        let selected = Array(available.prefix(count))
        var updatedShown = Array(defaults.stringArray(forKey: storageKey) ?? [])
        for question in selected where !updatedShown.contains(question.prompt) {
            updatedShown.append(question.prompt)
        }
        if updatedShown.count > 100 {
            updatedShown.removeFirst(updatedShown.count - 100)
        }
        defaults.set(updatedShown, forKey: storageKey)

        return selected.map { question in
            BattleQuestion(
                prompt: question.prompt,
                answers: question.answers.shuffled(),
                correctAnswerID: question.correctAnswerID
            )
        }
    }

    private static func question(forSubject subject: String) -> BattleQuestion {
        switch subject {
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
