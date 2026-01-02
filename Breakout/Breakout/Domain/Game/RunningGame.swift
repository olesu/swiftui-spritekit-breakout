import Foundation

protocol RunningGame {
    var ballResetNeeded: Bool { get }
    var levelDidChange: Bool { get }
    
    func announceBallResetInProgress()
    func acknowledgeBallReset()
}
