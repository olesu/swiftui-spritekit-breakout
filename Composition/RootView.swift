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
                let viewModel = GameViewModel(
                    service: BreakoutGameService(),
                    repository: InMemoryGameStateRepository(),
                    configurationService: deps.gameConfigurationService,
                    screenNavigationService: deps.screenNavigationService,
                    gameResultService: deps.gameResultService
                )
                GameView()
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
