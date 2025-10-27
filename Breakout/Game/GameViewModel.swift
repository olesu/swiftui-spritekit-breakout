import Foundation
import SwiftUI

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
    
}
