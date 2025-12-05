import Foundation
import SwiftUI

struct IdleView: View {
    @Environment(IdleViewModel.self) private var viewModel: IdleViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                IdleBackground()

                GameButton(title: "PLAY", action: {
                    isFocused = false
                    viewModel.startNewGame()
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
                viewModel.startNewGame()
                return .handled
            }
            #endif
        }
    }
}

