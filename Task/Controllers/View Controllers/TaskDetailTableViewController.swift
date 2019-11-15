//
//  TaskDetailTableViewController.swift
//  Task
//
//  Created by Aaron Shackelford on 11/13/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    var task: Task? {
        //didSet observer to ensure the view updates WITH the updated values
        didSet {
            updateViews()
        }
    }
    var dueDateValue: Date? //update enable?
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskNotesTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dueDateTextField.inputView = dueDatePicker
        //updateviews after assigning the date picker view?
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
    }
    
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        updateTask()
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        //almost forgot to assign the sender as a UIDatePicker can't call date property of the sender if it comes as in from Any
        self.dueDateTextField.text =  sender.date.stringValue()
        self.dueDateValue = sender.date
    }
    @IBAction func userTappedView(_ sender: UITapGestureRecognizer) {
        taskNameTextField.resignFirstResponder()
        taskNotesTextField.resignFirstResponder()
        dueDateTextField.resignFirstResponder()
    }
    
    
    
    // MARK: - Private Class Methods
    private func updateTask() {
        guard let name = taskNameTextField.text, name.isEmpty == false,
            let notes = taskNotesTextField.text
            else { return }
        //due is an optional, not required to be able to save a task, not necessary to guard against it being empty
        let due = dueDateValue
        if let task = self.task {
            TaskController.sharedInstance.updateTask(task: task, name: name, notes: notes, due: due)
        } else {
            TaskController.sharedInstance.addNew(taskWithName: name, notes: notes, due: due)
        }
        //putting popVC here to guard against failed save/nil values
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        loadViewIfNeeded()
        //set title of the view to the name of the task if present
        title = task?.name
        taskNameTextField.text = task?.name
        //TODO need to unwrap??? this seems off
        dueDateTextField.text = (task?.due as Date?)?.stringValue()
        taskNotesTextField.text = task?.notes
    }
    
}

