//
//  GameViewModelTest.swift
//  BreakoutTests
//
//  Created by Ole Kristian Sunde on 19/10/2025.
//

import Testing
import Foundation

@testable import Breakout

struct ConfigurationModelTest {

    @Test func holdsTheModel() async throws {
        let m = ConfigurationModel(using: FakeGameConfigurationService())
        
        #expect(m.sceneSize == CGSize(width: 0, height: 0))
        #expect(m.brickArea == CGRect(x: 0, y: 0, width: 0, height: 0))
    }

}

class FakeGameConfigurationService: GameConfigurationService {
    func getGameConfiguration() -> GameConfiguration {
        GameConfiguration(
            sceneWidth: 0, sceneHeight: 0, brickArea: BrickArea(x: 0, y: 0, width: 0, height: 0)
        )
    }
    
}
