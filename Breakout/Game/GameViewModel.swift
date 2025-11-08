import Foundation
import SwiftUI
import SpriteKit

@Observable class GameViewModel {
    let configurationModel: GameConfigurationModel

    init(configurationModel: GameConfigurationModel) {
        self.configurationModel = configurationModel
    }

    var sceneSize: CGSize {
        configurationModel.sceneSize
    }

    var frameWidth: CGFloat {
        configurationModel.frameWidth
    }

    var frameHeight: CGFloat {
        configurationModel.frameHeight
    }

    var brickArea: CGRect {
        configurationModel.brickArea
    }

    func createNodes() -> [NodeNames: SKNode] {
        let onBrickAdded = { (brickId: String) in
            // TODO: Register brick with engine
        }
        return initNodes(onBrickAdded: onBrickAdded)
    }

}
