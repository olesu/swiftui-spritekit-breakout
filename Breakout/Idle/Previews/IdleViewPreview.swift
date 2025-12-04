import SwiftUI
import Foundation

#if DEBUG
#Preview {
    let idleViewModel = IdleViewModel(
        screenNavigationService: IdleViewPreviewScreenNavigationService()
    )
    IdleView()
        .environment(idleViewModel)
        .frame(width: 320 * 0.5, height: 480 * 0.5)
}

@Observable
class IdleViewPreviewScreenNavigationService: ScreenNavigationService {
    func navigate(to screen: Screen) {

    }
}
#endif
