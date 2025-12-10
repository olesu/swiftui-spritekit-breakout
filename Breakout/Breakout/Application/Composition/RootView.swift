import SwiftUI

struct RootView: View {
    let deps: RootDependencies

    init(_ deps: RootDependencies) {
        self.deps = deps
    }

    var body: some View {
        ZStack {
            switch deps.navigationCoordinator.currentScreen {
            case .idle:
                IdleView()
                    .environment(deps.idleViewModel)
            case .game:
                GameView(sceneBuilder: deps.sceneBuilder)
                    .environment(deps.gameViewModel)
            case .gameEnd:
                GameEndView()
                    .environment(deps.gameEndViewModel)
            }
        }
        .frame(
            width: deps.applicationConfiguration.windowWidth,
            height: deps.applicationConfiguration.windowHeight
        )

    }
}
