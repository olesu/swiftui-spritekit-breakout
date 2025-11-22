import Foundation
import SwiftUI

struct IdleViewWrapper: View {
    @Environment(IdleViewModel.self) private var viewModel: IdleViewModel

    var body: some View {
        IdleView(viewModel: viewModel)
    }

}

struct IdleView: View {
    var viewModel: IdleViewModel

    var body: some View {
        Button("Start Game") {
            Task {
                await viewModel.startNewGame()
            }
        }
    }
}

#if DEBUG
#Preview {
    IdleViewWrapper()
        .frame(width: 320 * 0.5, height: 480 * 0.5)
        .environment(
            IdleViewModel(
                screenNavigationService: PreviewScreenNavigationService()
            )
        )
}

private class PreviewScreenNavigationService: ScreenNavigationService {
    func navigate(to screen: Screen) {

    }
}
#endif
