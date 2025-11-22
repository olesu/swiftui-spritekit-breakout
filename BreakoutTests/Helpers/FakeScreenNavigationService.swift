@testable import Breakout

class FakeScreenNavigationService: ScreenNavigationService {
    var navigatedTo: Screen?

    func navigate(to screen: Screen) {
        navigatedTo = screen
    }
}
