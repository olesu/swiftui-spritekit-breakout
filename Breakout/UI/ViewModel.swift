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
    
    var brickArea: CGRect {
        configurationModel.brickArea
    }

}
