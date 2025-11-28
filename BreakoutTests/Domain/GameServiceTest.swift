import Foundation
import Testing

@testable import Breakout

struct GameServiceTest {
    let service = BreakoutGameService()
    
    @Test func testStartGame_transitionsFromIdleToPlaying() {
        let state = GameState.initial

        let newState = service.startGame(state: state)

        #expect(newState.status == .playing)
    }

    @Test func testStartGame_whenAlreadyPlaying_returnsUnchangedState() {
        let state = GameState.initial.with(status: .playing)

        let newState = service.startGame(state: state)

        #expect(newState.status == .playing)
        #expect(newState == state)
    }

    @Test func testStartGame_whenGameWon_returnsUnchangedState() {
        let state = GameState.initial.with(status: .won)

        let newState = service.startGame(state: state)

        #expect(newState.status == .won)
        #expect(newState == state)
    }

    @Test func testStartGame_whenGameOver_returnsUnchangedState() {
        let state = GameState.initial.with(status: .gameOver)

        let newState = service.startGame(state: state)

        #expect(newState.status == .gameOver)
        #expect(newState == state)
    }

    @Test func testProcessBrickHit_whenPlaying_removesBrick() {
        let brick = Brick(id: BrickId(of: "1"), color: .red)
        let bricks: [BrickId: Brick] = [brick.id: brick]
        let state = GameState.initial
            .with(status: .playing)
            .with(bricks: bricks)

        let newState = service.processEvent(.brickHit(brickID: brick.id), state: state)

        #expect(newState.bricks.isEmpty)
    }

    @Test func testProcessBrickHit_whenPlaying_addsScoreBasedOnColor_red() {
        let brick = Brick(id: BrickId(of: "1"), color: .red)
        let bricks: [BrickId: Brick] = [brick.id: brick]
        let state = GameState.initial
            .with(status: .playing)
            .with(bricks: bricks)

        let newState = service.processEvent(.brickHit(brickID: brick.id), state: state)

        #expect(newState.score == 7)
    }

    @Test func testProcessBrickHit_whenPlaying_addsScoreBasedOnColor_orange() {
        let brick = Brick(id: BrickId(of: "1"), color: .orange)
        let bricks: [BrickId: Brick] = [brick.id: brick]
        let state = GameState.initial
            .with(status: .playing)
            .with(bricks: bricks)

        let newState = service.processEvent(.brickHit(brickID: brick.id), state: state)

        #expect(newState.score == 7)
    }

    @Test func testProcessBrickHit_whenPlaying_addsScoreBasedOnColor_yellow() {
        let brick = Brick(id: BrickId(of: "1"), color: .yellow)
        let bricks: [BrickId: Brick] = [brick.id: brick]
        let state = GameState.initial
            .with(status: .playing)
            .with(bricks: bricks)

        let newState = service.processEvent(.brickHit(brickID: brick.id), state: state)

        #expect(newState.score == 4)
    }

    @Test func testProcessBrickHit_whenPlaying_addsScoreBasedOnColor_green() {
        let brick = Brick(id: BrickId(of: "1"), color: .green)
        let bricks: [BrickId: Brick] = [brick.id: brick]
        let state = GameState.initial
            .with(status: .playing)
            .with(bricks: bricks)

        let newState = service.processEvent(.brickHit(brickID: brick.id), state: state)

        #expect(newState.score == 1)
    }

    @Test func testProcessBrickHit_whenLastBrick_setsStatusToWon() {
        let brick = Brick(id: BrickId(of: "1"), color: .red)
        let bricks: [BrickId: Brick] = [brick.id: brick]
        let state = GameState.initial
            .with(status: .playing)
            .with(bricks: bricks)

        let newState = service.processEvent(.brickHit(brickID: brick.id), state: state)

        #expect(newState.status == .won)
    }

    @Test func testProcessBrickHit_whenNotPlaying_returnsUnchangedState() {
        let brick = Brick(id: BrickId(of: "1"), color: .red)
        let bricks: [BrickId: Brick] = [brick.id: brick]
        let state = GameState.initial
            .with(status: .idle)
            .with(bricks: bricks)

        let newState = service.processEvent(.brickHit(brickID: brick.id), state: state)

        #expect(newState == state)
    }

    @Test func testProcessBrickHit_whenBrickDoesNotExist_returnsUnchangedState() {
        let brick = Brick(id: BrickId(of: "1"), color: .red)
        let bricks: [BrickId: Brick] = [brick.id: brick]
        let nonExistentBrickId = BrickId(of: "999")
        let state = GameState.initial
            .with(status: .playing)
            .with(bricks: bricks)

        let newState = service.processEvent(.brickHit(brickID: nonExistentBrickId), state: state)

        #expect(newState == state)
    }
}
