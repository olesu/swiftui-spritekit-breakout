import Foundation
import SwiftUI

struct IdleView: View {
    @State private var viewModel: IdleViewModel
    @FocusState private var isFocused: Bool

    init(screenNavigationService: ScreenNavigationService) {
        self._viewModel = State(initialValue: IdleViewModel(
            screenNavigationService: screenNavigationService
        ))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                IdleBackground()

                GameButton(title: "PLAY", action: {
                    isFocused = false
                    Task {
                        await viewModel.startNewGame()
                    }
                }, geometry: geometry)
            }
            .focusable()
            .focused($isFocused)
            .task {
                try? await Task.sleep(for: .milliseconds(100))
                isFocused = true
            }
            #if os(macOS)
            .onKeyPress(.space) {
                isFocused = false
                Task {
                    await viewModel.startNewGame()
                }
                return .handled
            }
            #endif
        }
    }
}

#if DEBUG
#Preview {
    IdleView(screenNavigationService: PreviewScreenNavigationService())
        .frame(width: 320 * 0.5, height: 480 * 0.5)
}

private class PreviewScreenNavigationService: ScreenNavigationService {
    func navigate(to screen: Screen) {

    }
}
#endif
