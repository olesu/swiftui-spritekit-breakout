import Foundation

protocol RunningGame {
    var ballResetNeeded: Bool { get }
    
    func announceBallResetInProgress()
    func acknowledgeBallReset()
    func consumeLevelDidChange() -> Bool
}
