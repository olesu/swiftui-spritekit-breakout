import Testing

@testable import Breakout

struct GameControllerTest {

    @Test func stepRemovesEnqueuedNodes() {
        let s = Scenario()
        
        s.advanceOneFrameWithBallInFlight()
        
        #expect(s.bricksWereRemoved() == true)
    }
    
    @Test func stepUpdatesNodes() {
        let s = Scenario()
        
        s.advanceOneFrameWithBallInFlight()
        
        #expect(s.nodesWereUpdated() == true)
    }
    
    @Test func stepNotifiesObserver() {
        let s = Scenario()
        
        s.advanceOneFrameWithBallInFlight()
        
        #expect(s.observerWasNotified() == true)
    }
    
    @Test func stepDoesNotUpdateNodesWhileBallIsResetting() {
        let s = Scenario()
        
        s.advanceOneFrameWhileBallIsResetting()
        
        #expect(s.nodesWereUpdated() == false)
    }
    
    @Test func stepResetsBallWhenRequired() {
        let s = Scenario()
        
        s.advanceOneFrameWhileBallIsResetting()
        
        #expect(s.ballResetSequenceWasPerformed() == true)
    }

}

private final class Scenario {
    private let controller: GameController
    private let nodeManager: FakeNodeManager
    private let runningGame: FakeRunningGame
    private let observer: FakeGameSessionObserver
    
    init() {
        nodeManager = FakeNodeManager()
        runningGame = FakeRunningGame()
        controller = GameController(
            paddleInputController: PaddleInputController(),
            game: runningGame,
            nodeManager: nodeManager,
        )
        
        observer = FakeGameSessionObserver()
        controller.observer = observer
    }
    
    func advanceOneFrameWithBallInFlight() {
        runningGame.resetBallOnNextStep(false)
        advanceOneFrame()
    }
    
    func advanceOneFrameWhileBallIsResetting() {
        runningGame.resetBallOnNextStep(true)
        advanceOneFrame()
    }
    
    private func advanceOneFrame() {
        controller.step(deltaTime: 1.0, sceneSize: .zero)
    }
    
    func bricksWereRemoved() -> Bool {
        nodeManager.removeEnqueuedCount > 0
    }
    
    func nodesWereUpdated() -> Bool {
        nodeManager.updateCount > 0
    }
    
    func observerWasNotified() -> Bool {
        return observer.sessionUpdateCount > 0
    }
    
    func ballResetSequenceWasPerformed() -> Bool {
        runningGame.announceCount > 0 &&
        nodeManager.resetBallCount > 0 &&
        runningGame.acknowledgeCount > 0
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
    
    func resetBallOnNextStep(_ ballResetNeeded: Bool) {
        _ballResetNeeded = ballResetNeeded
    }
}

private final class FakeGameSessionObserver: GameSessionObserver {
    private(set) var sessionUpdateCount: Int = 0
    
    func gameSessionDidUpdate() {
        sessionUpdateCount += 1
    }
    
}
