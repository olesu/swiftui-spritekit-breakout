import SwiftUI

struct RootView: View {
    let context: AppContext

    init(_ context: AppContext) {
        self.context = context
    }

    var body: some View {
        ZStack {
            switch context.navigationCoordinator.currentScreen {
            case .idle:
                IdleView()
                    .environment(context.idleViewModel)
            case .game:
                GameView(sceneBuilder: context.sceneBuilder)
                    .environment(context.gameViewModel)
            case .gameEnd:
                GameEndView()
                    .environment(context.gameEndViewModel)
            }
        }
        .frame(
            width: context.applicationConfiguration.windowWidth,
            height: context.applicationConfiguration.windowHeight
        )

    }
}
