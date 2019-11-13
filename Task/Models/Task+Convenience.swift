//
//  Task+Convenience.swift
//  Task
//
//  Created by Aaron Shackelford on 11/13/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    convenience init(name: String, notes: String, due: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.notes = notes
        self.due = due
    }
}
