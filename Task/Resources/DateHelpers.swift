//
//  DateHelpers.swift
//  Task
//
//  Created by Aaron Shackelford on 11/13/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import Foundation

extension Date {
    
    //allowing a function within Date class to return a .medium formatted string of a date
    func stringValue() -> String {
        //making a value out of date formatter method
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        //returning the formatted string from taken in date
        return formatter.string(from: self)
    }
}
