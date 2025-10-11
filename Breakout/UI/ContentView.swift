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
        GameView(autoPaddleConfig: $autoPaddleConfig)
    }
}

#Preview {
    @Previewable @State var autoPaddleConfig = AutoPaddleConfig()
    ContentView(autoPaddleConfig: $autoPaddleConfig)
}
