import Foundation

protocol RunningGame {
    var ballResetNeeded: Bool { get }
    var visualGameState: VisualGameState { get }
    
    func announceBallResetInProgress()
    func acknowledgeBallReset()
    func consumeLevelDidChange() -> Bool
}
