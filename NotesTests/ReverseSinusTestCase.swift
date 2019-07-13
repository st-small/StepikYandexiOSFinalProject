//
//  ReverseSinusTestCase.swift
//  NotesTests
//
//  Created by Станислав Шияновский on 6/29/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import XCTest
@testable import Notes

class ReverseSinusTestCase: XCTestCase {
    func testReverseSinus() {
        let value = try! 1.0.reverseSinus()
        XCTAssertTrue(abs(0.8414709848078965 - value) < Double.ulpOfOne)
    }
}
