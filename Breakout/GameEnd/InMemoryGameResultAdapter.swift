import Foundation

import BreakoutInfrastructure

final class InMemoryGameResultAdapter: GameResultAdapter {
    private let storage: InMemoryStorage

    init(storage: InMemoryStorage) {
        self.storage = storage
    }

    var didWin: Bool {
        storage.didWinGame
    }

    var score: Int {
        storage.finalScore
    }

    func save(didWin: Bool, score: Int) {
        storage.didWinGame = didWin
        storage.finalScore = score
    }
}
