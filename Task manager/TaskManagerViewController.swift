//
//  ViewController.swift
//  Task manager
//
//  Created by Vladimir Beliakov on 01.07.2022.
//

import UIKit

class TaskManagerViewController: UITableViewController {
    
    var itemArray = ["One","Two","Three"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TableView Datasource Methods
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskManagerCell", for: indexPath)
        // Configure the cell’s contents.
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Add/Delete checkmark to a cell
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        // deselect cell after click on it
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new Items
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert) //Creating Alert frame
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in //Creating button "Add item"
            //What will happen when pressed
            self.itemArray.append(textField.text ?? "Something went wrong added =)")
            self.tableView.reloadData()                             //Reloads data IRT*
        }
        alert.addTextField { (alertTextField) in                    //What will be printed in text field
            alertTextField.placeholder = "Create new item"          //Gray text in text field
            textField = alertTextField                              //Store what printed in textField variably
        }
        alert.addAction(action)                                     //Creating button "Add button"
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

