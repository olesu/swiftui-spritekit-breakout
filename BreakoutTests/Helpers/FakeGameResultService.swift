@testable import Breakout

class FakeGameResultService: GameResultService {
    private var _didWin: Bool = false
    private var _score: Int = 0

    var didWin: Bool {
        _didWin
    }

    var score: Int {
        _score
    }

    func save(didWin: Bool, score: Int) {
        _didWin = didWin
        _score = score
    }
}
