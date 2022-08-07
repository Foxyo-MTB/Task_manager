//
//  ViewController.swift
//  Task manager
//
//  Created by Vladimir Beliakov on 01.07.2022.
//

import UIKit
import CoreData


class TaskManagerViewController: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext                                               //Because CoreData is in AppDelegate we need to grab data from there. We need object - UIApplication is that object. We downcast it as AppDelegate because file is AppDelegate. We use viewContext in persistentContainer attribute.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")) //Location of .plist file for userDefaults saving items.
        
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
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
            let newItem = Item(context: self.context)               // Initializating our new item as Item class item =)
            newItem.title = textField.text!                         // Getting text of item to Item()
            newItem.done = false                                    // Getting property done of iten to Item()
            self.itemArray.append(newItem)                          // Adding new item to itemArray.
            self.saveItems()                                        // Call function for save items.
        }
        alert.addTextField { (alertTextField) in                    // What will be printed in text field.
            alertTextField.placeholder = "Create new item"          // Gray text in text field.
            textField = alertTextField                              // Store what printed in textField variably.
        }
        alert.addAction(action)                                     // Creating button "Add button"
        present(alert, animated: true, completion: nil)             // Show adding window.
        
    }
    
    //MARK: - Model manipulation methods.
    
    func saveItems() {
        
        do {
            try context.save()                                      // Do-catch block for .save because this method throws an error.
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()                                      // Shows data IRL on screen.
    }
    
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
    }
}
