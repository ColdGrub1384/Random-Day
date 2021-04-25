//
//  TaskCategoriesTableViewController.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import UIKit
import SwiftUI

class TaskCategoriesTableViewController: UITableViewController {
    
    let manager = DatabaseManager.shared
    
    @objc func addTask(_ sender: Any) {
        let alert = UIAlertController(title: "Agregar categoría", message: "Puedes organizar actividades en diferentes categorías. Escribe el nombre de la categoría que quieres agregar.", preferredStyle: .alert)
        
        var textField: UITextField?
        
        alert.addTextField { (_textField) in
            textField = _textField
            textField?.placeholder = "Nombre"
        }
        
        alert.addAction(UIAlertAction(title: "Crear", style: .default, handler: { (_) in
            
            self.manager.database.taskCategories.insert(TaskCategory(name: textField!.text!, tasks: []), at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.database.taskCategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = manager.database.taskCategories[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = category.name
        cell.detailTextLabel?.text = "\(category.tasks.count) actividad\(category.tasks.count != 1 ? "es" : "")"
        cell.imageView?.image = UIImage(systemName: "folder")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            manager.database.taskCategories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let category = manager.database.taskCategories[indexPath.row]
        
        let vc = TasksTableViewController(category: category, index: indexPath.row)
        show(vc, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var categories = manager.database.taskCategories
        let item = categories[sourceIndexPath.row]
        categories.remove(at: sourceIndexPath.row)
        categories.insert(item, at: destinationIndexPath.row)
        
        manager.database.taskCategories = categories
    }
}

struct TaskCategoriesView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UINavigationController {
        let vc = TaskCategoriesTableViewController(style: ProcessInfo.processInfo.isMacCatalystApp ? .plain : .grouped)
        vc.title = "Actividades"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.prefersLargeTitles = true
        return navVC
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}

struct TaskCategoriesScreen: View {
    
    var body: some View {
        TaskCategoriesView().ignoresSafeArea().navigationTitle("Actividades")
    }
}

struct TaskCategories_Previews: PreviewProvider {
    static var previews: some View {
        TaskCategoriesScreen().ignoresSafeArea().onAppear {
            DatabaseManager.shared.database.taskCategories = previewCategories
        }
    }
}
