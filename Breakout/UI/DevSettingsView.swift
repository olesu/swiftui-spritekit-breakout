import Foundation
import SwiftUI

struct DevSettingsView: View {
    @AppStorage("areaOverlaysEnabled") private var areaOverlaysEnabled: Bool = false
    
    var body: some View {
        Form {
            Section {
                Toggle("Enable Area Overlays", isOn: $areaOverlaysEnabled)
            }
        }
        .navigationTitle("Developer Settings")
    }
}

#Preview {
    DevSettingsView()
        .frame(minWidth: 300, minHeight: 300)
}
