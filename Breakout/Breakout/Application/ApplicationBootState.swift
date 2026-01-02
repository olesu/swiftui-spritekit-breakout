import Foundation

enum ApplicationBootState {
    case loading
    case running(AppContext)
    case failed(BootError)
}
