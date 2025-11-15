import Foundation

@Observable class GameConfigurationModel {
    let service: GameConfigurationService
    private let configuration: GameConfiguration
    private let scale: CGFloat

    var brickArea: CGRect {
        CGRect(
            x: configuration.brickArea.x,
            y: configuration.brickArea.y,
            width: configuration.brickArea.width,
            height: configuration.brickArea.height
        )
    }

    var sceneSize: CGSize {
        CGSize(width: configuration.sceneWidth, height: configuration.sceneHeight)
    }

    var frameWidth: CGFloat {
        sceneSize.width * scale
    }

    var frameHeight: CGFloat {
        sceneSize.height * scale
    }

    init(service: GameConfigurationService) {
        self.service = service
        self.configuration = service.getGameConfiguration()
        self.scale = service.getGameScale()
    }

}
