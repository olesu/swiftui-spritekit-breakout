import Foundation
import SpriteKit
import SwiftUI

extension Notification.Name {
    static let areaOverlaysEnabledDidChange = Notification.Name("areaOverlaysEnabledDidChange")
}

struct GameView: View {
    @Environment(\.gameScale)
    private var scale
    
    @AppStorage("areaOverlaysEnabled")
    private var areaOverlaysEnabled = false
    
    @State
    private var gameViewModel = GameViewModel(
        gameConfigurationService: GameConfigurationService(loader: JsonGameConfigurationLoader())
    )

    var body: some View {
        VStack {
            SpriteView(
                scene: GameScene(
                    size: gameViewModel.sceneSize,
                    brickArea: gameViewModel.brickArea
                )
            )
            .frame(
                width: gameViewModel.sceneSize.width * scale,
                height: gameViewModel.sceneSize.height * scale
            )
            .onChange(of: areaOverlaysEnabled, initial: true) { oldValue, newValue in
                postAreaOverlaysEnabledDidChangeNotification(oldValue: oldValue, newValue: newValue)
            }
        }
    }
}

extension GameView {
    private func postAreaOverlaysEnabledDidChangeNotification(oldValue: Bool, newValue: Bool) {
        NotificationCenter.default.post(
            name: .areaOverlaysEnabledDidChange,
            object: nil,
            userInfo: ["oldValue": oldValue, "newValue": newValue]
        )
    }
}

#Preview {
    GameView()
        .environment(\.gameScale, 1.0)
}

