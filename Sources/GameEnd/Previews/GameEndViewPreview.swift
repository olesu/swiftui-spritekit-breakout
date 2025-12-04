import Foundation
import SwiftUI

#if DEBUG
    #Preview {
        let gameEndViewModel = GameEndViewModel(
            screenNavigationService: GameEndPreviewScreenNavigationService(),
            gameResultService: GameEndPreviewGameResultService()
        )
        GameEndView()
            .environment(gameEndViewModel)
            .frame(width: 320 * 0.5, height: 480 * 0.5)
    }

    private class GameEndPreviewScreenNavigationService: ScreenNavigationService
    {
        func navigate(to screen: Screen) {

        }
    }

    private class GameEndPreviewGameResultService: GameResultService {
        var didWin: Bool {
            false
        }

        var score: Int {
            0
        }

        func save(didWin: Bool, score: Int) {
        }
    }
#endif
