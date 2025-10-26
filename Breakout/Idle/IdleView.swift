import Foundation
import SwiftUI

@Observable class IdleViewModel {
    let startGameButtonText = "Start Game"

    func startGame() {
        print("start game...")
    }
}

struct IdleViewWrapper: View {
    var body: some View {
        IdleView()
    }
    
}

struct IdleView: View {
    @State private var viewModel = IdleViewModel()
    
    var body: some View {
        Button(viewModel.startGameButtonText) {
            viewModel.startGame()
        }
    }
}

#Preview {
    IdleViewWrapper()
        .frame(width: 320 * 0.5, height: 480 * 0.5)
}
