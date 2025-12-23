import Foundation
import SwiftUI

struct ErrorView: View {
    let error: BootError

    var body: some View {
        VStack {
            Text("Application failed to start")

            #if DEBUG
            Text(String(describing: error))
                .font(.footnote)
                .foregroundStyle(.secondary)
            #endif
        }
    }
}
