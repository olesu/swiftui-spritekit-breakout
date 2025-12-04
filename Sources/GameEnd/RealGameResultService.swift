import Foundation

@Observable
final class RealGameResultService: GameResultService {
    private let adapter: GameResultAdapter

    init(adapter: GameResultAdapter) {
        self.adapter = adapter
    }

    var didWin: Bool {
        adapter.didWin
    }

    var score: Int {
        adapter.score
    }

    func save(didWin: Bool, score: Int) {
        adapter.save(didWin: didWin, score: score)
    }
}
