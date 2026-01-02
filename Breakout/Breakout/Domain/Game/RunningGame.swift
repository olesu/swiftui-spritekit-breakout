import Foundation

protocol RunningGame {
    var ballResetNeeded: Bool { get }
//    var currentLevel: LevelId { get }
    
    func announceBallResetInProgress()
    func acknowledgeBallReset()
}
