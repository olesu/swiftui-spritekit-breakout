import Foundation
import CoreGraphics

@testable import Breakout

struct FakeGameConfigurationService: GameConfigurationService {
    func getGameConfiguration() -> GameConfiguration {
        GameConfiguration.defaultValue()
    }

    func getGameScale() -> CGFloat {
        1.0
    }
}
