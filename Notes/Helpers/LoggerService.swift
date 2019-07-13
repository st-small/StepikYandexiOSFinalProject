//
//  LoggerService.swift
//  Notes
//
//  Created by Станислав Шияновский on 6/28/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public class LoggerService {
    
    public static let shared = LoggerService()
    
    private var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    public func message(state: String, description: String) {
        let message = "-------------------------\n- *** - Logger: \(date)\n- *** - \(state)\n- *** - \(description)\n-------------------------\n"
        print(message)
    }
}
