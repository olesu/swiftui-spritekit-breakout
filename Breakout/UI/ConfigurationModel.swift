import Foundation

@Observable class ConfigurationModel {
    let service: GameConfigurationService

    var brickArea: CGRect {
        let r = service.getGameConfiguration()
        return CGRect(
            x: r.brickArea.x,
            y: r.brickArea.y,
            width: r.brickArea.width,
            height: r.brickArea.height
        )
    }
    
    var sceneSize: CGSize {
        let r = service.getGameConfiguration()
        return CGSize(width: r.sceneWidth, height: r.sceneHeight)
    }
    
    init(using service: GameConfigurationService) {
        self.service = service
    }

}
