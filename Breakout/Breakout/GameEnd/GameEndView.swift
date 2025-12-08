import Foundation
import SwiftUI

struct GameEndView: View {
    @Environment(GameEndViewModel.self) private var viewModel: GameEndViewModel
    @FocusState private var isFocused: Bool

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
                        isFocused = false
                        viewModel.playAgain()
                    }, geometry: geometry)
                }
            }
            .focusable()
            .focused($isFocused)
            .task {
                isFocused = true
            }
            #if os(macOS)
            .onKeyPress(.space) {
                isFocused = false
                viewModel.playAgain()
                return .handled
            }
            #endif
        }
    }
}
