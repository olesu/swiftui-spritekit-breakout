//
//  GameServiceTests.swift
//  BreakoutTests
//
//  Created by Ole Kristian Sunde on 23/08/2025.
//

import Testing

@testable import Breakout
import Foundation

struct GameServiceTests {
    @Test func startsInReadyState() {
        let gameService = AGameService()
        
        #expect(gameService.state == .ready)
    }
    
    @Test func launchingABallTransitionsToPlayingState() {
        let gameService = AGameService(remainingLives: 3)
        
        gameService.launchBall()
        
        #expect(gameService.state == .playing)
    }
    
    @Test func losingABallTransitionsToReadyState() {
        let gameService = AGameService(remainingLives: 3)
        
        gameService.launchBall()
        gameService.ballHitBottom()
        
        #expect(gameService.state == .ready)
    }
    
    @Test func launchingBallWhenOutOfLivesChangesStateToGameOver() {
        let gameService = AGameService(remainingLives: 0)
        
        gameService.launchBall()
        
        #expect(gameService.state == .gameOver)
    }
    
    @Test func launchingABallFromGameOverDoesNotAffectState() {
        let gameService = AGameService(remainingLives: 0)
        
        gameService.launchBall()
        gameService.ballHitBottom()
        
        gameService.launchBall()
        
        #expect(gameService.state == .gameOver)
    }
    
    @Test func losingABallReducesRemainingLives() {
        let gameService = AGameService(remainingLives: 3)
            
        gameService.launchBall()
        gameService.ballHitBottom()

        #expect(gameService.remainingLives == 2)
        
    }
    
    @Test func losingTheLastBallTransitionsToGameOverState() {
        let gameService = AGameService(remainingLives: 1)
        
        gameService.launchBall()
        gameService.ballHitBottom()
        
        #expect(gameService.state == .gameOver)
    }
    
    @Test func theGameIsWonWhenAllBricksAreDestroyed() {
        let brick = Brick(id: UUID())
        let gameService = AGameService(
            remainingLives: 1,
            bricks: [brick]
        )
        
        gameService.launchBall()
        gameService.ballHitBrick(brick)
        
        #expect(gameService.state == .won)
    }
    
    @Test func canOnlyHitBricksInPlayingState() {
        let brick = Brick(id: UUID())
        let gameService = AGameService(remainingLives: 1)
        
        gameService.ballHitBottom()
        gameService.ballHitBrick(brick)
        
        #expect(gameService.state == .gameOver)
    }
    
    @Test func scoreIsIncrementedWhenABrickIsHit() {
        let brick1 = Brick(id: UUID())
        let brick2 = Brick(id: UUID())
        
        let gameService = AGameService(
            remainingLives: 3,
            bricks: [brick1, brick2]
        )
        
        gameService.launchBall()
        gameService.ballHitBrick(brick1)
        gameService.ballHitBrick(brick2)

        #expect(gameService.score == 2)
    }
    
    @Test func scoreIsNotIncrementedWhenBrickIsNotInBricksArray() {
        let unknownBrick = Brick(id: UUID())
        let brick = Brick(id: UUID())
        
        let gameService = AGameService(
            remainingLives: 3,
            bricks: [brick]
        )
        
        gameService.launchBall()
        gameService.ballHitBrick(unknownBrick)
        gameService.ballHitBrick(brick)

        #expect(gameService.score == 1)
    }
}
