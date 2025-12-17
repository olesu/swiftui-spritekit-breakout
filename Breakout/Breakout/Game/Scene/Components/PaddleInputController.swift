import SpriteKit

final class PaddleInputController {
    struct KeyState {
        var left = false
        var right = false

        var movement: Movement {
            if left && !right { return .left }
            if right && !left { return .right }
            return .none
        }

        enum Movement {
            case none
            case left
            case right
        }
    }

    private var keyState = KeyState()

    func pressLeft() {
        keyState.left = true
    }

    func releaseLeft() {
        keyState.left = false
    }

    func pressRight() {
        keyState.right = true
    }

    func releaseRight() {
        keyState.right = false
    }

    func movement() -> KeyState.Movement {
        keyState.movement
    }

}
