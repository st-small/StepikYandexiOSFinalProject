//
//  BubbleSortTestCase.swift
//  NotesTests
//
//  Created by Станислав Шияновский on 6/29/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import XCTest

class BubbleSortTestCase: XCTestCase {
    func testBubbleSortWithNormalArray() {
        let array = [1, 2, 8, 4, 5].bubbleSort()
        for i in 1...array.count-1 {
            XCTAssertTrue(array[i-1] < array[i])
        }
    }
    
    func testBubbleSortWithDuplicatesElementsArray() {
        let array = [2, 2, 1].bubbleSort()
        for i in 1...array.count-1 {
            XCTAssertTrue(array[i-1] < array[i] || array[i-1] == array[i])
        }
    }
    
    func testBubbleSortWithSingleElementArray() {
        let array = [1].bubbleSort()
        XCTAssertTrue(array.count == 1)
    }
    
    func testBubbleSortWithEmptyArray() {
        let emptyArray = [Int]()
        let array = emptyArray.bubbleSort()
        XCTAssertTrue(array.isEmpty)
    }
}
