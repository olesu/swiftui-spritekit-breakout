import Foundation

@Observable internal final class GameConfigurationModel {
    internal let service: GameConfigurationService
    private let configuration: GameConfiguration
    private let scale: CGFloat

    internal var brickArea: CGRect {
        CGRect(
            x: configuration.brickArea.x,
            y: configuration.brickArea.y,
            width: configuration.brickArea.width,
            height: configuration.brickArea.height
        )
    }

    internal var sceneSize: CGSize {
        CGSize(width: configuration.sceneWidth, height: configuration.sceneHeight)
    }

    internal var frameWidth: CGFloat {
        sceneSize.width * scale
    }

    internal var frameHeight: CGFloat {
        sceneSize.height * scale
    }

    internal init(service: GameConfigurationService) {
        self.service = service
        self.configuration = service.getGameConfiguration()
        self.scale = service.getGameScale()
    }

}
