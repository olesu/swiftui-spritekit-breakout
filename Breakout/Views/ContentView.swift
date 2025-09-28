//
//  ContentView.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 23/08/2025.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @Binding var autoPaddleConfig: AutoPaddleConfig

    var body: some View {
        GameView(initialAutoPaddleConfig: autoPaddleConfig)
    }
}

#Preview {
    @Previewable @State var cfg = AutoPaddleConfig()
    ContentView(autoPaddleConfig: $cfg)
}
