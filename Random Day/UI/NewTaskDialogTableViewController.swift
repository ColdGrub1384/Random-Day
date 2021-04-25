//
//  NewTaskDialogTableViewController.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import UIKit

class NewTaskDialogTableViewController: UITableViewController, UITextFieldDelegate {
    
    var task: Task?
        
    var completionHandler: ((Task?) -> ())?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var durationPicker: UIDatePicker!
        
    @IBAction func done(_ sender: Any) {
        nameTextFieldDidChange(nameTextField)
        durationDidChange(durationPicker)
        dismiss(animated: true) {
            self.completionHandler?(self.task)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        task?.name = sender.text ?? ""
    }
    
    @IBAction func durationDidChange(_ sender: UIDatePicker) {
        task?.duration = sender.date.timeIntervalSince(Calendar.current.startOfDay(for: sender.date))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
