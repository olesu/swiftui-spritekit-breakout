import Foundation

@Observable class GameConfigurationModel {
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
    
    var frameWidth: CGFloat {
        sceneSize.width * calculatedScale
    }
    
    var frameHeight: CGFloat {
        sceneSize.height * calculatedScale
    }
    
    private var calculatedScale: CGFloat {
        service.getGameScale()
    }
    
    init(service: GameConfigurationService) {
        self.service = service
    }

}
