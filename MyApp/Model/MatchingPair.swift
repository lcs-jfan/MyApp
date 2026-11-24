//  MatchingPair.swift
//  MyApp
//
//  Created by Fan Yiming on 2026-11-04.
//  GitHub Copilot helped build the boss battle's concept-and-definition matching experience.

struct MatchingPair: Identifiable, Hashable {
    let id: String
    let term: String
    let definition: String

    // The boss battle shuffles these shared IDs into separate term and definition columns.
    static let bossPairs = [
        MatchingPair(
            id: "dose",
            term: "Dose",
            definition: "The amount of a substance that enters the body"
        ),
        MatchingPair(
            id: "tempo",
            term: "Tempo",
            definition: "How fast or slow a piece of music is performed"
        ),
        MatchingPair(
            id: "blubber",
            term: "Blubber",
            definition: "A whale's thick layer of fat that helps it stay warm"
        ),
        MatchingPair(
            id: "toxicity",
            term: "Toxicity",
            definition: "How harmful a substance can be to a living thing"
        )
    ]
}
