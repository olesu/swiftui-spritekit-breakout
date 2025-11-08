import Foundation
import SwiftUI
import SpriteKit

@Observable class GameViewModel {
    let configurationModel: GameConfigurationModel
    private let nodeCreator: NodeCreator
    private let engineFactory: (Bricks) -> GameEngine
    private(set) var engine: GameEngine?

    init(
        configurationModel: GameConfigurationModel,
        nodeCreator: NodeCreator = SpriteKitNodeCreator(),
        engineFactory: @escaping (Bricks) -> GameEngine = { bricks in BreakoutGameEngine(bricks: bricks) }
    ) {
        self.configurationModel = configurationModel
        self.nodeCreator = nodeCreator
        self.engineFactory = engineFactory
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
        var bricks = Bricks()

        let nodes = nodeCreator.createNodes { brickId in
            bricks.add(Brick(id: BrickId(of: brickId)))
        }

        engine = engineFactory(bricks)
        engine?.start()

        return nodes
    }

}
