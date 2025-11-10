//
//  BricksTest.swift
//  BreakoutTests
//
//  Created by Ole Kristian Sunde on 01/10/2025.
//

import Foundation
import AppKit

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

struct BrickColorTest {
    @Test func mapsRedNSColorToBrickColor() {
        let color = BrickColor(from: .red)

        #expect(color == .red)
    }

    @Test func mapsOrangeNSColorToBrickColor() {
        let color = BrickColor(from: .orange)

        #expect(color == .orange)
    }

    @Test func mapsYellowNSColorToBrickColor() {
        let color = BrickColor(from: .yellow)

        #expect(color == .yellow)
    }

    @Test func mapsGreenNSColorToBrickColor() {
        let color = BrickColor(from: .green)

        #expect(color == .green)
    }

    @Test func returnsNilForUnmappedColors() {
        let color = BrickColor(from: .blue)

        #expect(color == nil)
    }
}
