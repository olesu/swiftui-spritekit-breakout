import Foundation

enum ApplicationBootState {
    case running(AppContext)
    case failed(BootError)
}
