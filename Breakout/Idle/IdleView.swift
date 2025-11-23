import Foundation
import SwiftUI

struct IdleView: View {
    @State private var viewModel: IdleViewModel

    init(screenNavigationService: ScreenNavigationService) {
        self._viewModel = State(initialValue: IdleViewModel(
            screenNavigationService: screenNavigationService
        ))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("IdleScreenBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()

                GameButton(title: "PLAY", action: {
                    Task {
                        await viewModel.startNewGame()
                    }
                }, geometry: geometry)
            }
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
