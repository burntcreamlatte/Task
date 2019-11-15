//
//  ButtonTableViewCell.swift
//  Task
//
//  Created by Aaron Shackelford on 11/13/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

//protocol
protocol ButtonTableViewCellDelegate {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell)
}

import UIKit

class ButtonTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var delegate: ButtonTableViewCellDelegate?
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func buttonTapped(_ sender: Any) {
        //tell the delegate to perform function; logic outside of custom view, all logic for protocols/delegates done in controllers
        print("check button tapped")
        delegate?.buttonCellButtonTapped(self)
    }
    
    
    //func to update button image; swap between complete and incomplete depending on isComplete bool
    func updateButton(_ isComplete: Bool) {
        //change image
        let imageName = isComplete ? "complete" : "incomplete"
        //converting from string to UIImage here
        let image = UIImage(named: imageName)
        completeButton.setImage(image, for: .normal)
    }
}
//extension for updating button to populate specific task
extension ButtonTableViewCell {
    
    func update(withTask task: Task) {
        primaryLabel.text = task.name
        updateButton(task.isComplete)
    }
}
