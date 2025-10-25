import Foundation
import SpriteKit
import SwiftUI

extension Notification.Name {
    static let areaOverlaysEnabledDidChange = Notification.Name("areaOverlaysEnabledDidChange")
}

struct ContentView: View {
    @Environment(\.gameScale)
    private var scale
    
    @Environment(ConfigurationModel.self)
    private var config: ConfigurationModel
    
    @State private var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        VStack {
            SpriteView(
                scene: GameScene(
                    size: config.sceneSize,
                    brickArea: config.brickArea
                )
            )
            .frame(
                width: config.sceneSize.width * scale,
                height: config.sceneSize.height * scale
            )
        }
    }
}

extension ContentView {
    private func postAreaOverlaysEnabledDidChangeNotification(oldValue: Bool, newValue: Bool) {
        NotificationCenter.default.post(
            name: .areaOverlaysEnabledDidChange,
            object: nil,
            userInfo: ["oldValue": oldValue, "newValue": newValue]
        )
    }
}

#Preview {
    ContentView()
        .environment(\.gameScale, 1.0)
        .environment(ConfigurationModel(using: MockConfigurationService()))
}

class MockConfigurationService: GameConfigurationService {
    func getGameConfiguration() -> GameConfiguration {
        GameConfiguration(
            sceneWidth: 320,
            sceneHeight: 480,
            brickArea: BrickArea(x: 20, y: 330, width: 280, height: 120))
    }
    
}
