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
    var body: some Scene {
        WindowGroup {
            GameView()
                .environment(\.gameConfiguration, GameConfiguration.shared)
        }
    }
}
