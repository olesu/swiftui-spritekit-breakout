//
//  ContentView.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 23/08/2025.
//

import SwiftUI
import SpriteKit

class GameController: ObservableObject {
    let gameService: GameService
    let scene: GameScene
    
    init() {
        let bricks = [
            Brick(id: UUID()),
            Brick(id: UUID())
        ]
        let service = AGameService(remainingLives: 3, bricks: bricks)
        self.gameService = service
        self.scene = GameScene(gameService: service, size: CGSize(width: 400, height: 600))
    }
    
    func hitBrick() {
        if let brick = gameService.bricks.first {
            scene.brickHit(brick)
        }
    }
    
    func loseBall() {
        scene.ballHitBottom()
    }
}

struct ContentView: View {
    @StateObject private var gameController = GameController()

    var body: some View {
        VStack {
            SpriteView(scene: gameController.scene)
                .frame(width: 400, height: 600)
                .ignoresSafeArea()
            HStack {
                Button("Hit Brick") {
                    gameController.hitBrick()
                }
                Button("Lose Ball") {
                    gameController.loseBall()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
