//
//  ViewController.swift
//  DoIt
//
//  Created by Coder on 6/20/18.
//  Copyright © 2018 Coder. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    let key = "ToDoListArray"
    let segueName = "ToDoItemCell"
    
    var itemArray = [Item]()
    
    var selectedCategory : Catetegory?{
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: segueName, for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.titleOfAction
        
        cell.accessoryType = item.isDone ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context?.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        
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
            
            if let newContext = self.context{
            
                let newItem = Item(context: newContext)
                
                
                if let stringItem = textField.text  {
                
                    newItem.titleOfAction = stringItem
                    newItem.isDone = false
                    newItem.parentCategory = self.selectedCategory
                }

                self.itemArray.append(newItem)
                
            }
            
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
        do {
            
            try context?.save()
            
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
        
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let format = "parentCategory.name MATCHES %@"
        
        if let additionalCategory = selectedCategory?.name {
            
            let categotyPredicate = NSPredicate(format : format, additionalCategory)
        
            if let additionalPredicate = predicate {
            
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categotyPredicate, additionalPredicate])
                
            } else {
                
                request.predicate = categotyPredicate
                
            }
        }
        
        do {
            if let outputItem = try context?.fetch(request) {
                
                itemArray = outputItem
            }
        }
        catch {
            print("Error fetching data \(error)")
        }
        
        tableView.reloadData()
    }

}

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let column = "titleOfAction"
        
        let query = column + " CONTAINS[cd] %@"
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        if let newSearchBar = searchBar.text {
        
        let predicate = NSPredicate(format: query, newSearchBar)

            request.sortDescriptors = [NSSortDescriptor(key: column, ascending: true)]
            
            loadItems(with: request, predicate: predicate)
            
        }
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

