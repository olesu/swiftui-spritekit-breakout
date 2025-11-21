internal struct LivesCard {
    private(set) internal var remaining: Int
    internal var gameOver: Bool { remaining <= 0 }

    internal init(_ livesToBeginWith: Int) {
        self.remaining = livesToBeginWith
    }

    internal mutating func lifeWasLost() {
        self.remaining -= 1
    }
}
