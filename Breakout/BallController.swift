//
//  BallController.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 31/08/2025.
//

import SpriteKit

class BallController: SKSpriteNode {
    init(paddlePosition: CGPoint) {
        let ballSize = CGSize(width: 12, height: 12)
        let ballPosition = CGPoint(
            x: paddlePosition.x,
            y: paddlePosition.y + 20
        )
        
        super.init(texture: nil, color: .white, size: ballSize)
        
        self.position = ballPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
