//
//  ViewController.swift
//  Task manager
//
//  Created by Vladimir Beliakov on 01.07.2022.
//

import UIKit

class TaskManagerViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "One"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Two"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Three"
        itemArray.append(newItem3)
        
        print("Hello world")
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
        
        let item = itemArray[indexPath.row]                                                     // Creating new constant to minimize code.
        
        cell.textLabel?.text = item.title                                                       // Text of Item.title goes to cell
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none                                     // Setting cell accessory checkmark or none.
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done                          //Reversing for check on/off
        
        tableView.reloadData()                                                                  //Reloads data IRL* for correct displaying
        
        // deselect cell after click on it
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new Items
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert) //Creating Alert frame
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in //Creating button "Add item"
            //What will happen when pressed
            let newItem = Item()                                    // Initializating our new item as Item class item =)
            newItem.title = textField.text!                         // Getting text of item to Item()
            newItem.done = false                                    // Getting property done of iten to Item()
            self.itemArray.append(newItem)                          // Adding new item to itemArray.
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

