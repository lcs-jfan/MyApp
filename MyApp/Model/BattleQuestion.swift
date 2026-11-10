struct BattleQuestion {
    let prompt: String
    let answers: [AnswerChoice]
    let correctAnswerID: Int

    func isCorrect(_ answer: AnswerChoice) -> Bool {
        answer.id == correctAnswerID
    }
}

struct AnswerChoice: Identifiable {
    let id: Int
    let text: String
}
