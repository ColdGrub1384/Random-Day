//
//  TasksScreen.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import UIKit
import SwiftUI

class TasksTableViewController: UITableViewController {
    
    let manager = DatabaseManager.shared
    
    var category: TaskCategory?
    
    var index: Int?
    
    init(category: TaskCategory, index: Int) {
        super.init(style: .grouped)
        
        self.category = category
        self.index = index
        
        title = category.name
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addTask(_ sender: Any) {
        let task = Task(name: "", duration: 1)
        
        guard let vc = UIStoryboard(name: "NewTaskDialog", bundle: .main).instantiateInitialViewController() as? NewTaskDialogTableViewController else {
            return
        }
        
        vc.navigationItem.title = "Agregar actividad"
        vc.task = task
        vc.completionHandler = { task in
            guard var category = self.category, let index = self.index, let task = task else {
                return
            }
            
            category.tasks.insert(task, at: 0)
            
            self.manager.database.taskCategories.remove(at: index)
            self.manager.database.taskCategories.insert(category, at: index)
            
            self.category = category
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.prefersLargeTitles = false
        present(navVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask(_:)))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.tasks.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        if let task = category?.tasks[indexPath.row] {
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .short
            formatter.maximumUnitCount = 2

            let time = formatter.string(from: task.duration)!
            
            cell.textLabel?.text = task.name
            cell.detailTextLabel?.text = time
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete, let index = index, var category = category {
            category.tasks.remove(at: indexPath.row)
            manager.database.taskCategories.remove(at: index)
            manager.database.taskCategories.insert(category, at: index)
            self.category = category
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        guard var category = category, let index = index else {
            return
        }
        
        var tasks = category.tasks
        let item = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(item, at: destinationIndexPath.row)
        
        category.tasks = tasks
        
        manager.database.taskCategories.remove(at: index)
        manager.database.taskCategories.insert(category, at: index)
        
        self.category = category
    }
}
