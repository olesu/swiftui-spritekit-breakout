import Foundation
import SwiftUI

struct IdleViewWrapper: View {
    @Environment(IdleModel.self) private var idleModel: IdleModel

    var body: some View {
        IdleView(viewModel: idleModel)
    }

}

struct IdleView: View {
    private var viewModel: IdleViewModel

    init(viewModel: IdleModel) {
        self.viewModel = IdleViewModel(model: viewModel)
    }

    var body: some View {
        Button(viewModel.startGameButtonText) {
            Task {
                await viewModel.startGameButtonPressed()
            }
        }
    }
}

#Preview {
    IdleViewWrapper()
        .frame(width: 320 * 0.5, height: 480 * 0.5)
        .environment(
            IdleModel(
                gameStateService: PreviewGameStateService()
            )
        )
}

private class PreviewGameStateService: GameStateService {
    func transitionToPlaying() {
        
    }
    
    func getState() -> GameState {
        .idle
    }
    

}
