import Foundation
import SwiftUI

class ViewModel {
    private let userDefaultsKey = "areaOverlaysEnabled"
    
    private var areaOverlaysEnabled: Bool {
        didSet {
            // Write to user defaults whenever the property changes
            UserDefaults.standard.set(areaOverlaysEnabled, forKey: userDefaultsKey)
        }
    }
    
    init() {
        // Read from UserDefaults on initialization
        self.areaOverlaysEnabled = UserDefaults.standard.bool(forKey: userDefaultsKey)
        
        // Set up an observation to react to external changes
        Task {
            // Continously monitor the notification on the main actor
            for await _ in NotificationCenter.default.notifications(named: UserDefaults.didChangeNotification) {
                // When UserDefaults changes, update the internal property
                // This will trigger the @Observable system to notify the views
                let newValue = UserDefaults.standard.bool(forKey: userDefaultsKey)
                if self.areaOverlaysEnabled != newValue {
                    self.areaOverlaysEnabled = newValue
                }
            }
        }
    }
    
}
