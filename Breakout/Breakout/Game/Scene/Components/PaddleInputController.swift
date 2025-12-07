import SpriteKit

final class PaddleInputController {
    private let motion: PaddleMotionController
    
    init(motion: PaddleMotionController) {
        self.motion = motion
    }
    
    private struct KeyState {
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
        applyKeyState()
    }

    func releaseLeft() {
        keyState.left = false
        applyKeyState()
    }

    func pressRight() {
        keyState.right = true
        applyKeyState()
    }

    func releaseRight() {
        keyState.right = false
        applyKeyState()
    }

    private func applyKeyState() {
        switch keyState.movement {
        case .left:
            motion.startLeft()
        case .right:
            motion.startRight()
        case .none:
            motion.stop()
        }
    }

    func movePaddle(to location: CGPoint) {
        motion.overridePosition(x: location.x)
    }
    func endPaddleOverride() { motion.endOverride() }

}
