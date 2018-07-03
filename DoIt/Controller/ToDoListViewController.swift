//
//  ViewController.swift
//  DoIt
//
//  Created by Coder on 6/20/18.
//  Copyright © 2018 Coder. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let key = "ToDoListArray"
    let segueName = "ToDoItemCell"
    
    var toDoItems: Results<Item>?
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    let realm = try! Realm()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: segueName, for: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.isDone ? .checkmark : .none
            
        } else {
            
            cell.textLabel?.text = "No Items Added"
        }
       
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.isDone = !item.isDone
                }
                
            } catch {
                    print("Error saving done status \(error)")
                
            }
        }
        
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alertControllerTitle = "Add new DoIt Item"
        let alertControllerMessage = ""
        let alertActionTitle = "Add Item"

        let alert = UIAlertController(title: alertControllerTitle, message: alertControllerMessage, preferredStyle: .alert)

        let action = UIAlertAction(title: alertActionTitle, style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                
                if let stringItem = textField.text  {
                    
                    do {
                        
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = stringItem
                            newItem.dataCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                        
                    } catch{
                        
                        print("Error of saving Items \(error)")
                    }
                    
                }
            }
            
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    

    func loadItems() {
        
        let columnName = "title"
        let ascending = true
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: columnName, ascending: ascending)
        
        tableView.reloadData()
    }

}

extension ToDoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let columnName = "dataCreated"
        let ascending = true
        
        let query =  "title CONTAINS[cd] %@"
        if let newSearchBar = searchBar.text {
            
            toDoItems = toDoItems?.filter(query, newSearchBar).sorted(byKeyPath: columnName, ascending: ascending)

        }
        tableView.reloadData()
    }

    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {

                searchBar.resignFirstResponder()
            }
        }
    }
}

