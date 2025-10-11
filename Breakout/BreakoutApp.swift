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
    @State private var scoreCard = ScoreCard()
    @State private var livesCard = LivesCard(3)

    var body: some Scene {
        WindowGroup {
            GameView(
                autoPaddleConfig: $autoPaddleConfig,
                scoreCard: $scoreCard,
                livesCard: $livesCard
            )
            .environment(\.gameConfiguration, GameConfiguration.shared)
        }
        #if os(macOS)
            Settings {
                GamePreferencesView(autoPaddleConfig: $autoPaddleConfig)
            }
        #endif
    }
}
