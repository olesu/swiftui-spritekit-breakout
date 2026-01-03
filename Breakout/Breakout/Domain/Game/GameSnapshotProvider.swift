import Foundation

protocol GameSnapshotProvider {
    func snapshot() -> GameSessionSnapshot
}
