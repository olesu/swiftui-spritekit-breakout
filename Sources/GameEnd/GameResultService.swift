import Foundation

protocol GameResultService {
    var didWin: Bool { get }
    var score: Int { get }
    func save(didWin: Bool, score: Int)
}
