struct ScoreCard {
    var scores: [Int] = []

    var total: Int {
        scores.reduce(0, +)
    }

    mutating func score(_ score: Int) {
        scores.append(score)
    }
}
