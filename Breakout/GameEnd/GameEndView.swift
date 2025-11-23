import Foundation
import SwiftUI

struct GameEndView: View {
    @State private var viewModel: GameEndViewModel

    init(screenNavigationService: ScreenNavigationService, gameResultService: GameResultService) {
        self._viewModel = State(initialValue: GameEndViewModel(
            screenNavigationService: screenNavigationService,
            gameResultService: gameResultService
        ))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                IdleBackground()

                VStack(spacing: geometry.size.height * 0.05) {
                    Text(viewModel.message)
                        .font(.system(size: geometry.size.width * 0.12, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .red.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                        .shadow(color: .red.opacity(0.6), radius: 8, x: 0, y: 0)

                    Text("Score: \(viewModel.score)")
                        .font(.system(size: geometry.size.width * 0.06, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    GameButton(title: "PLAY AGAIN", action: {
                        Task {
                            await viewModel.playAgain()
                        }
                    }, geometry: geometry)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    GameEndView(
        screenNavigationService: PreviewScreenNavigationService(),
        gameResultService: PreviewGameResultService()
    )
    .frame(width: 320 * 0.5, height: 480 * 0.5)
}

private class PreviewScreenNavigationService: ScreenNavigationService {
    func navigate(to screen: Screen) {

    }
}

private class PreviewGameResultService: GameResultService {
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
