//
//  CategoryViewController.swift
//  DoIt
//
//  Created by Coder on 6/26/18.
//  Copyright © 2018 Coder. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let segueName = "ToDoCategoryCell"
    let identifier = "goToItems"
    
    var categories = [Catetegory]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: segueName, for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: identifier, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC =  segue.destination as? ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC?.selectedCategory = categories[indexPath.row]
        }
        
    }
    


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertControllerTitle = "Add new category "
        let alertControllerMessage = ""
        let alertActionTitle = "Add"
        
        let alert = UIAlertController(title: alertControllerTitle, message: alertControllerMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertActionTitle, style: .default) { (action) in
            
            if let newContext = self.context {
                
                let newCategory = Catetegory(context: newContext)
                
                if let stringItem = textField.text {
                    
                    newCategory.name = stringItem
                }
                
                self.categories.append(newCategory)
                
            }
            
            self.saveData()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            
            textField = alertTextField
            alertTextField.placeholder = "Create new category"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData () {
        
        do {
            
            try context?.save()
        } catch {
            
            print("Error \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    
    func loadData() {
        
        let request : NSFetchRequest<Catetegory> = Catetegory.fetchRequest()
        
        do {
            if let outputCategory = try context?.fetch(request) {
                
                categories = outputCategory
            }
        }
        catch {
            print("Error fetching data \(error)")
        }
        
        tableView.reloadData()
    }
}
