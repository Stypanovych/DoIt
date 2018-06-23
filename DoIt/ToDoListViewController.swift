//
//  ViewController.swift
//  DoIt
//
//  Created by Coder on 6/20/18.
//  Copyright © 2018 Coder. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Smth"]
    
    let key = "ToDoListArray"
    let segueName = "ToDoItemCell"
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = defaults.array(forKey: key) as? [String] {
            itemArray = item
        }
        
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: segueName, for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }


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

            guard let unwrapped = textField.text
                else {
                    print("The string is empty")
                    return
            }

            self.itemArray.append(unwrapped)
            
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

