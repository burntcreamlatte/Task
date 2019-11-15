//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Aaron Shackelford on 11/13/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController, ButtonTableViewCellDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate = self goes here to be able to load in views
        TaskController.sharedInstance.fetchedResultsController.delegate = self
    }

    // MARK: - Table view data source

    //do not need numberOfSections(in:) normally with single section apps, here we are having an Incomplete and Complete section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TaskController.sharedInstance.fetchedResultsController.sections?.count ?? 0

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = TaskController.sharedInstance.fetchedResultsController.sections else { return 0 }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell
        let task = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
    
        //telling cell to update itself with custom method created in custom view
        cell?.update(withTask: task)
        cell?.delegate = self
        
        //returns initialized button cell if nil
        return cell ?? ButtonTableViewCell()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionTitle = TaskController.sharedInstance.fetchedResultsController.sectionIndexTitles[section]
        return sectionTitle == "0" ? "Incomplete" : "Complete"

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
            TaskController.sharedInstance.removeTask(task: taskToDelete)
        }
    }
    
    
    // MARK: - Delegate Method
    
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let task = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
        TaskController.sharedInstance.toggleIsCompletedFor(task: task)
        sender.update(withTask: task)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //identifier
        if segue.identifier == "toTaskDetailTVC" {
            //index
            if let indexPath = tableView.indexPathForSelectedRow {
            //fixed from previous
                if let destinationVC = segue.destination as? TaskDetailTableViewController {
                    let taskToSend = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
                    //selected task property on said VC to grab the task
                    destinationVC.task = taskToSend
                    
                }
            }
        }
    }
}
// MARK: - Fetched Results Controller Delegate

extension TaskListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
            
        default: return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath
                else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath
                else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath
                else { return }
            tableView.reloadRows(at: [indexPath], with: .none)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath
                else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            fatalError("NSFetchedResultsChangeType has new unhandled cases")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
