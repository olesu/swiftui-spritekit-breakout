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
                IdleView(screenNavigationService: deps.screenNavigationService)
            case .game:
                GameView(
                    configurationService: deps.gameConfigurationService,
                    screenNavigationService: deps.screenNavigationService,
                    storage: deps.gameStateStorage,
                    gameResultService: deps.gameResultService
                )
            case .gameEnd:
                GameEndView(
                    screenNavigationService: deps.screenNavigationService,
                    gameResultService: deps.gameResultService
                )
            }
        }
        .frame(
            width: deps.applicationConfiguration.windowWidth,
            height: deps.applicationConfiguration.windowHeight
        )

    }
}
