import Foundation
import SwiftUI

@Observable class ViewModel {
    let configurationModel: ConfigurationModel
    
    init(configurationModel: ConfigurationModel) {
        self.configurationModel = configurationModel
    }

    var sceneSize: CGSize {
        configurationModel.sceneSize
    }
    
    var frameWidth: CGFloat {
        configurationModel.sceneSize.width * configurationModel.calculatedScale
    }
    
    var frameHeight: CGFloat {
        configurationModel.sceneSize.height * configurationModel.calculatedScale
    }
    
    var brickArea: CGRect {
        configurationModel.brickArea
    }
    
}
