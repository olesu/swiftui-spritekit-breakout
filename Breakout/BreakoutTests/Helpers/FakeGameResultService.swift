@testable import Breakout

class FakeGameResultService: GameResultService {
    var savedDidWin: Bool?
    var savedScore: Int?

    var didWin: Bool {
        savedDidWin ?? false
    }

    var score: Int {
        savedScore ?? -1
    }

    func save(didWin: Bool, score: Int) {
        savedDidWin = didWin
        savedScore = score
    }
}
