//
//  ViewController.swift
//  Task manager
//
//  Created by Vladimir Beliakov on 01.07.2022.
//

import UIKit

class TaskManagerViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }
    
    //MARK: - TableView Datasource Methods
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskManagerCell", for: indexPath)     // Creating cell. Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
        let item = itemArray[indexPath.row]                                                             // Creating new constant to minimize code.
        cell.textLabel?.text = item.title                                                               // Text of Item.title goes to cell
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none                                             // Setting cell accessory checkmark or none.
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done                          //Reversing for check on/off.
        saveItems()                                                                             // Calling function to save data.
        tableView.deselectRow(at: indexPath, animated: true)                                    // deselect cell after click on it
        
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
            self.saveItems()                                        // Call function for save items.
        }
        alert.addTextField { (alertTextField) in                    // What will be printed in text field
            alertTextField.placeholder = "Create new item"          // Gray text in text field
            textField = alertTextField                              // Store what printed in textField variably
        }
        alert.addAction(action)                                     // Creating button "Add button"
        present(alert, animated: true, completion: nil)             // Show adding window.
        
    }
    
    //MARK: - Model manipulation methods.
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()                         // Initializing An object that encodes instances of data types to a property list.
        do {                                                        // Because .encode and .write throws an error we need do-catch block here.
            let data = try encoder.encode(itemArray)                // Also we must type "try" because it throws an error.
            try data.write(to: dataFilePath!)                       // Also we must type "try" because it throws an error.
        } catch {
            print("Error encoding item array, \(error)")
        }
        tableView.reloadData()                                      // Shows data IRL on screen
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {                    // Creating constant that has our data storaged in .plis file - dataFilePath.
            let decoder = PropertyListDecoder()                                 // To represent data we need to decode it. Same as in saveItems function.
            do {                                                                // Because decoder.decode can throw, we need to place it in do-catch block.
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}
