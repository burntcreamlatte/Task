//
//  TaskController.swift
//  Task
//
//  Created by Aaron Shackelford on 11/13/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    //singleton method for TaskController class; passing methods through globally
    static let sharedInstance = TaskController()
    
    //creating frc under NSFRC to fetch Task as result type; SoT
    let fetchedResultsController: NSFetchedResultsController<Task>
    
    //frc init
    init() {
        
        //create Task request FRC uses
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        //create sort descriptor; needed or app crashes when fetching data, telling it to sort by name property on Task class
        let isCompleteSortDescriptor = NSSortDescriptor(key: "isComplete", ascending: true)
        let dueSortDescriptor = NSSortDescriptor(key: "due", ascending: true)
        
        //assign descriptors to fetchRequest
        fetchRequest.sortDescriptors = [isCompleteSortDescriptor, dueSortDescriptor]
        
        //return the NSFetchedResultsController that we promised
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
        //DONT FORGET TO INITIALIZE THE FRC AT THE END
        do{
            try fetchedResultsController.performFetch()
        } catch {
            print(error, error.localizedDescription)
        }
    }
    
    
    // MARK: - CRUD Functions
    //POTENTIAL OPTIONAL
    func addNew(taskWithName name: String, notes: String?, due: Date?) {
        _ = Task(name: name, notes: notes, due: due)
        saveToPersistentStore()
    }
    func updateTask(task: Task, name: String, notes: String?, due: Date?) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistentStore()
    }
    func removeTask(task: Task) {
        let moc = CoreDataStack.context
        moc.delete(task)
        saveToPersistentStore()
    }
    
    func toggleIsCompletedFor(task: Task) {
        //toggling isComplete boolean per task passed through
        task.isComplete = !task.isComplete
        saveToPersistentStore()
    }
    
    
    // MARK: Persistence Methods
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.context
        
        do {
            try moc.save()
        } catch {
            print("ERROR saving to persistent store: \(error.localizedDescription)")
        }
    }
}
