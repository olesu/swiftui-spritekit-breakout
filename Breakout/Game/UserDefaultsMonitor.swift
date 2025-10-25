import Foundation

final class UserDefaultsMonitor {
    
    private let key: String
    private let store: UserDefaults
    private var changeObserver: NSObjectProtocol?
    
    private let onChange: (Bool) -> Void

    init(key: String, initialValue: Bool, store: UserDefaults = .standard, using onChange: @escaping (Bool) -> Void) {
        self.key = key
        self.store = store
        self.onChange = onChange
        
        onChange(initialValue)
        startObserving()
    }
    
    deinit {
        stopObserving()
    }
    
    private func startObserving() {
        changeObserver = NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.notifyIfValueChanged()
        }
    }
    
    private func stopObserving() {
        if let observer = changeObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        changeObserver = nil
    }
    
    private func notifyIfValueChanged() {
        let newValue = store.bool(forKey: key)
        onChange(newValue)
    }
}
