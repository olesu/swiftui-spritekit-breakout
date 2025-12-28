import Foundation
import Testing

@testable import Breakout

@MainActor
struct GameReducerTest {
    private let initial = GameState.initial(startingLives: 3)
    let reducer = GameReducer()

    // MARK: - Start Game

    @Test func startingAGameFromIdleBeginsPlay() {
        let state = initial

        let newState = reducer.start(state)

        #expect(newState.status == .playing)
    }

    @Test func startingAGameWhenAlreadyPlayingHasNoEffect() {
        let state = initial.with(status: .playing)

        let newState = reducer.start(state)

        #expect(newState == state)
    }

    @Test func startingAGameWhenAlreadyWonDoesNothing() {
        let state = initial.with(status: .won)

        let newState = reducer.start(state)

        #expect(newState == state)
    }

    @Test func startingAGameWhenGameOverDoesNothing() {
        let state = initial.with(status: .gameOver)

        let newState = reducer.start(state)

        #expect(newState == state)
    }

    // MARK: - Brick Hit

    @Test func hittingABrickRemovesItFromTheBoard() {
        let brick = Brick(id: BrickId(of: "1"), color: .red, position: .zero)
        let state = initial
            .with(status: .playing)
            .with(bricks: [brick.id: brick])

        let newState = reducer.reduce(state, event: .brickHit(brickID: brick.id))

        #expect(newState.bricks.isEmpty)
    }

    @Test func hittingABrickAddsScoreBasedOnColor_red() {
        let brick = Brick(id: BrickId(of: "1"), color: .red, position: .zero)
        let state = initial
            .with(status: .playing)
            .with(bricks: [brick.id: brick])

        let newState = reducer.reduce(state, event: .brickHit(brickID: brick.id))

        #expect(newState.score == 7)
    }

    @Test func hittingABrickAddsScoreBasedOnColor_orange() {
        let brick = Brick(id: BrickId(of: "1"), color: .orange, position: .zero)
        let state = initial
            .with(status: .playing)
            .with(bricks: [brick.id: brick])

        let newState = reducer.reduce(state, event: .brickHit(brickID: brick.id))

        #expect(newState.score == 7)
    }

    @Test func hittingABrickAddsScoreBasedOnColor_yellow() {
        let brick = Brick(id: BrickId(of: "1"), color: .yellow, position: .zero)
        let state = initial
            .with(status: .playing)
            .with(bricks: [brick.id: brick])

        let newState = reducer.reduce(state, event: .brickHit(brickID: brick.id))

        #expect(newState.score == 4)
    }

    @Test func hittingABrickAddsScoreBasedOnColor_green() {
        let brick = Brick(id: BrickId(of: "1"), color: .green, position: .zero)
        let state = initial
            .with(status: .playing)
            .with(bricks: [brick.id: brick])

        let newState = reducer.reduce(state, event: .brickHit(brickID: brick.id))

        #expect(newState.score == 1)
    }

    @Test func hittingTheLastBrickEndsTheGameAsWon() {
        let brick = Brick(id: BrickId(of: "1"), color: .red, position: .zero)
        let state = initial
            .with(status: .playing)
            .with(bricks: [brick.id: brick])

        let newState = reducer.reduce(state, event: .brickHit(brickID: brick.id))

        #expect(newState.status == .won)
    }

    @Test func hittingABrickWhenNotPlayingHasNoEffect() {
        let brick = Brick(id: BrickId(of: "1"), color: .red, position: .zero)
        let state = initial
            .with(status: .idle)
            .with(bricks: [brick.id: brick])

        let newState = reducer.reduce(state, event: .brickHit(brickID: brick.id))

        #expect(newState == state)
    }

    @Test func hittingANonexistentBrickHasNoEffect() {
        let brick = Brick(id: BrickId(of: "1"), color: .red, position: .zero)
        let nonExistent = BrickId(of: "999")
        let state = initial
            .with(status: .playing)
            .with(bricks: [brick.id: brick])

        let newState = reducer.reduce(state, event: .brickHit(brickID: nonExistent))

        #expect(newState == state)
    }

    // MARK: - Ball Lost

    @Test func losingABallReducesRemainingLives() {
        let state = initial
            .with(status: .playing)
            .with(lives: 3)

        let newState = reducer.reduce(state, event: .ballLost)

        #expect(newState.lives == 2)
    }

    @Test func losingABallTriggersBallResetWhenLivesRemain() {
        let state = initial
            .with(status: .playing)
            .with(lives: 3)

        let newState = reducer.reduce(state, event: .ballLost)

        #expect(newState.ballResetNeeded == true)
    }

    @Test func losingTheFinalBallEndsTheGame() {
        let state = initial
            .with(status: .playing)
            .with(lives: 1)

        let newState = reducer.reduce(state, event: .ballLost)

        #expect(newState.status == .gameOver)
        #expect(newState.lives == 0)
    }

    @Test func losingTheFinalBallDoesNotRequestBallReset() {
        let state = initial
            .with(status: .playing)
            .with(lives: 1)

        let newState = reducer.reduce(state, event: .ballLost)

        #expect(newState.ballResetNeeded == false)
    }

    @Test func losingABallWhenNotPlayingHasNoEffect() {
        let state = initial
            .with(status: .idle)
            .with(lives: 3)

        let newState = reducer.reduce(state, event: .ballLost)

        #expect(newState == state)
    }

    // MARK: - Ball Reset Acknowledgment
    
    @Test func announcedBallResetInProgressClearsResetFlag() {
        let state = initial.with(ballResetNeeded: true)

        let newState = reducer.announcedBallResetInProgress(state)

        #expect(newState.ballResetNeeded == false)
    }

    @Test func acknowledgingBallResetClearsResetInProgressFlag() {
        let state = initial.with(ballResetInProgress: true)

        let newState = reducer.acknowledgeBallReset(state)

        #expect(newState.ballResetInProgress == false)
    }
    
    @Test func cannotAnnounceBallResetInProgressUnlessResetIsWanted() {
        let state = initial.with(ballResetNeeded: false)

        let newState = reducer.announcedBallResetInProgress(state)

        #expect(newState.ballResetInProgress == false)
    }
    

}
