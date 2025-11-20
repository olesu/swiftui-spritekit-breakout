//
//  BricksTest.swift
//  BreakoutTests
//
//  Created by Ole Kristian Sunde on 01/10/2025.
//

import Foundation

@testable import Breakout
import Testing

struct BricksTest {
    @Test func canBeAdded() {
        var bricks = Bricks()
        let exampleBrick = Brick(id: BrickId(of: "some-id"))

        bricks.add(exampleBrick)

        #expect(bricks.someRemaining == true)
    }

    @Test func canBeRemoved() {
        var bricks = Bricks()
        let exampleBrick = Brick(id: BrickId(of: "some-id"))

        bricks.add(exampleBrick)
        bricks.remove(withId: BrickId(of: "some-id"))

        #expect(bricks.someRemaining == false)
    }
}
