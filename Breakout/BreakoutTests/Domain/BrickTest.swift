import Testing

@testable import Breakout

internal struct ColorAndValue {
    let color: BrickColor
    let value: Int
}

struct BrickTest {
    @Test(arguments: [
        ColorAndValue(color: BrickColor.red, value: 7),
        ColorAndValue(color: BrickColor.orange, value: 7),
        ColorAndValue(color: BrickColor.yellow, value: 4),
        ColorAndValue(color: BrickColor.green, value: 1)
    ])
    func hasValueForColor(_ args: ColorAndValue) {
        let brick = Brick(id: BrickId(of: "1"), color: args.color, position: .zero)

        #expect(brick.value == args.value)
    }

}
