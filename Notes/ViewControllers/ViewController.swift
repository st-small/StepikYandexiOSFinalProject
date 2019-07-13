//
//  ViewController.swift
//  Notes
//
//  Created by Станислав Шияновский on 6/25/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let logger = LoggerService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if LOGGER
        logger.message(state: String(describing: ViewController.self), description: "First view controller did load")
        #endif
    }
}

public enum MyError: Error {
    case RuntimeError(message: String)
}

public extension Double {
    
    func reverseSinus() throws -> Double {
        if (abs(self) < Double.ulpOfOne) {
            throw MyError.RuntimeError(message: "Could not evaluate reverse for zero value")
        }
        
        return sin(1 / self)
    }
    
}

public extension Array where Element: Comparable {
    func bubbleSort() -> Array<Element> {
        
        guard self.count > 1 else {
            return self
        }
        
        var output: Array<Element> = self
        for primaryIndex in 0..<self.count {
            let passes = (output.count - 1) - primaryIndex
            for secondaryIndex in 0..<passes {
                let key = output[secondaryIndex]
                // compare / swap positions
                if (key > output[secondaryIndex + 1]) {
                    output.swapAt(secondaryIndex, secondaryIndex + 1)
                } }
        }
        return output
    }
}
