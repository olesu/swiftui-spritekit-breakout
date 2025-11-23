import Foundation

protocol GameResultService {
    var didWin: Bool { get }
    var score: Int { get }
}
