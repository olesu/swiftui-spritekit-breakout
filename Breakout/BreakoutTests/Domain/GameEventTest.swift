import Testing
import Foundation

@testable import Breakout

@MainActor
struct GameEventTest {
    @Test func canCreateBrickHitEvent() {
        let brickID = BrickId(of: UUID().uuidString)
        
        let event = GameEvent.brickHit(brickID: brickID)
        
        #expect(event == .brickHit(brickID: brickID))
    }
    
    @Test func canCreateBallLostEvent() {
        let event = GameEvent.ballLost
        
        #expect(event == .ballLost)
    }
    
    @Test func eventsWithSameDataAreEqual() {
        let brickID = BrickId(of: UUID().uuidString)
        let event1 = GameEvent.brickHit(brickID: brickID)
        let event2 = GameEvent.brickHit(brickID: brickID)
        
        #expect(event1 == event2)
        #expect(GameEvent.ballLost == GameEvent.ballLost)
    }

}
