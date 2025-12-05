import Foundation

protocol GameResultAdapter {
    var didWin: Bool { get }
    var score: Int { get }
    func save(didWin: Bool, score: Int)
}
