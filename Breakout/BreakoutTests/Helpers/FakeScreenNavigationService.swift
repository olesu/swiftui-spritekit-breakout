@testable import Breakout

class FakeScreenNavigationService: ScreenNavigationService {
    var didNavigateTo: Screen?

    func navigate(to screen: Screen) {
        didNavigateTo = screen
    }
}
