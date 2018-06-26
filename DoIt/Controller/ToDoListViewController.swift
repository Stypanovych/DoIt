//
//  ViewController.swift
//  DoIt
//
//  Created by Coder on 6/20/18.
//  Copyright © 2018 Coder. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    let pathComponentName = "Item.plist"
    let key = "ToDoListArray"
    let segueName = "ToDoItemCell"
    
    var itemArray = [Item]()
    let dataFileMPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
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
        
        saveItems()

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
            
            self.saveItems()
           
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(itemArray)
            
            if let filePath = dataFileMPath {
                try data.write(to: filePath)
            }
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
        
    }

    func loadItems() {
        
        if let pathItem = dataFileMPath {
            
            if let data = try? Data(contentsOf: pathItem) {
                
                let decoder = PropertyListDecoder()
                do {
                    
                itemArray = try decoder.decode([Item].self, from: data)
                    
                }
                catch{
                    print("Error decoding \(error)")
                }
            }
        }
    }

}

