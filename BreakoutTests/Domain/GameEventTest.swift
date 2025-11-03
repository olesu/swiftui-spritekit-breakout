//
//  GameEventTest.swift
//  BreakoutTests
//
//  Created by Ole Kristian Sunde on 03/11/2025.
//

import Testing
import Foundation

@testable import Breakout

struct GameEventTest {

    /*
     TDD Task List for GameEvent:
     
     Basic Event Creation & Properties:
     [ ] Can create .brickHit event with UUID
     [ ] Can create .ballLost event
     [ ] Can create .gameStarted event 
     [ ] Can create .gamePaused event
     [ ] Can create .gameResumed event
     [ ] Events with same data are equal (for testing)
     [ ] Events store associated data correctly
     
     Event Validation:
     [ ] .brickHit events require valid UUID
     [ ] Events can be compared for equality
     [ ] Events are hashable (if needed for collections)
     
     Future Event Processing (later iterations):
     [ ] Invalid events in wrong game state are ignored
     [ ] Events maintain order when processed in sequence
     [ ] Event processing is thread-safe
     
     Next: Start with simplest - creating basic events
     */
    
    @Test func canCreateBrickHitEvent() async throws {
        // Arrange
        let brickID = UUID()
        
        // Act
        let event = GameEvent.brickHit(brickID: brickID)
        
        // Assert
        #expect(event == .brickHit(brickID: brickID))
    }
    
    @Test func canCreateBallLostEvent() async throws {
        // Act
        let event = GameEvent.ballLost
        
        // Assert
        #expect(event == .ballLost)
    }
    
    @Test func eventsWithSameDataAreEqual() async throws {
        // Arrange
        let brickID = UUID()
        let event1 = GameEvent.brickHit(brickID: brickID)
        let event2 = GameEvent.brickHit(brickID: brickID)
        
        // Act & Assert
        #expect(event1 == event2)
        #expect(GameEvent.ballLost == GameEvent.ballLost)
    }

}
