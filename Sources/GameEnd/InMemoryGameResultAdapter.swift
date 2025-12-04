import Foundation

final class InMemoryGameResultAdapter: GameResultAdapter {
    private let storage: InMemoryStorage

    init(storage: InMemoryStorage) {
        self.storage = storage
    }

    var didWin: Bool {
        storage.gameResultDidWin
    }

    var score: Int {
        storage.gameResultScore
    }

    func save(didWin: Bool, score: Int) {
        storage.gameResultDidWin = didWin
        storage.gameResultScore = score
    }
}
