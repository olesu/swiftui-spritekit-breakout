import Testing

@testable import Breakout

struct GameControllerTest {

    @Test func stepRemovesEnqueuedNodes() {
        let nm = FakeNodeManager()
        let g = GameController(
            paddleInputController: PaddleInputController(),
            game: FakeRunningGame(),
            nodeManager: nm,
        )
        
        g.step(deltaTime: 1.0, sceneSize: .zero)
        
        #expect(nm.removeEnqueuedCount == 1)
    }

}

private final class FakeRunningGame: RunningGame {
    private var _ballResetNeeded: Bool
    var ballResetNeeded: Bool {
        _ballResetNeeded
    }
    
    init () {
        self._ballResetNeeded = false
    }
    
    var announceCount: Int = 0
    var acknowledgeCount: Int = 0
    
    func announceBallResetInProgress() {
        announceCount += 1
    }
    
    func acknowledgeBallReset() {
        acknowledgeCount += 1
    }
    
    
}
