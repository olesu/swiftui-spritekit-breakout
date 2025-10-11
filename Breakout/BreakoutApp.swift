//
//  BreakoutApp.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 23/08/2025.
//

import Foundation
import SwiftUI

@main
struct BreakoutApp: App {
    @State private var autoPaddleConfig = AutoPaddleConfig()

    var body: some Scene {
        WindowGroup {
            ContentView(autoPaddleConfig: $autoPaddleConfig)
                .environment(\.gameConfiguration, GameConfiguration.shared)
        }
        #if os(macOS)
        Settings {
            GamePreferencesView(autoPaddleConfig: $autoPaddleConfig)
        }
        #endif
    }
}
