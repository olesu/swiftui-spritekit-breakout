internal struct ScoreCard {
    private(set) internal var scores: [Int] = []

    internal var total: Int {
        scores.reduce(0, +)
    }

    internal mutating func score(_ score: Int) {
        scores.append(score)
    }
}
