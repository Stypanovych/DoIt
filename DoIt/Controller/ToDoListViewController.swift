//
//  ViewController.swift
//  DoIt
//
//  Created by Coder on 6/20/18.
//  Copyright © 2018 Coder. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let key = "ToDoListArray"
    let segueName = "ToDoItemCell"
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newItem = Item()
        newItem.titleOfAction = "NewItem"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.titleOfAction = "NewItem1"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.titleOfAction = "NewItem2"
        itemArray.append(newItem2)
        
        if let items = defaults.array(forKey: key) as? [Item] {
            itemArray = items
        }
        
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: segueName, for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.titleOfAction
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
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
            //what will happen when the user clics the Add Item button on our UIAllert
            
            let newItem = Item()
            
            if let stringItem = textField.text  {
                
                newItem.titleOfAction = stringItem
                
            }

            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: self.key)
            
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    

}

