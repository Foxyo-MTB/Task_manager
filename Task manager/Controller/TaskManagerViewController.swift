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
    var selectedCategory : Categories? {
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext                                               //Because CoreData is in AppDelegate we need to grab data from there. We need object - UIApplication is that object. We downcast it as AppDelegate because file is AppDelegate. We use viewContext in persistentContainer attribute.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") ?? "No .plist founded") //Location of .plist file for userDefaults saving items.
        
        
    }
    
    //MARK: - TableView Datasource Methods.
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskManagerCell", for: indexPath)     // Creating cell. Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
        let item = itemArray[indexPath.row]                                                             // Creating new constant to minimize code.
        cell.textLabel?.text = item.title                                                               // Text of Item.title goes to cell.
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none                                             // Setting cell accessory checkmark or none.
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done                          //Reversing for check on/off.
        saveItems()                                                                             // Calling function to save data.
        tableView.deselectRow(at: indexPath, animated: true)                                    // deselect cell after click on it.
        
    }
    
    //MARK: - Add new Items
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert) //Creating Alert frame.
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in //Creating button "Add item".
            //What will happen when pressed
            let newItem = Item(context: self.context)               // Initializating our new item as Item class item =).
            newItem.title = textField.text!                         // Getting text of item to Item().
            newItem.done = false                                    // Getting property done of iten to Item().
            newItem.parentCategory = self.selectedCategory          // Setting category for created item to correct display in right category.
            self.itemArray.append(newItem)                          // Adding new item to itemArray.
            self.saveItems()                                        // Call function for save items.
        }
        alert.addTextField { (alertTextField) in                    // What will be printed in text field.
            alertTextField.placeholder = "Create new item"          // Gray text in text field.
            textField = alertTextField                              // Store what printed in textField variably.
        }
        alert.addAction(action)                                     // Creating button "Add button".
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
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {                   // With - external parameter, request - internal parameter. = Item.fetchRequest() is a default value here. Same for predicate.
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)                  // Here we filter Items list to display filtered results that matches category we select.
        if let additionalPredicate = predicate {                                                                                // Functionallity that allows us to display correct items in each category and search filters in each category.
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)                                                                              // Do-catch block for .fetch because this method throws an error.
        } catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search bar methods.

extension TaskManagerViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0 {                                                                 // Won't search empty field.
            let request : NSFetchRequest<Item> = Item.fetchRequest()                                    // Specifying type of request, because a lot of different data fetches. <Return an array of items> - meaning.
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)               // We will filter with this line of code. It says "title CONTAINS -from searchBar.text!-. "title CONTAINS[cd] %@" = how we want to query. [cd] - case and diacritic insensitive.
            request.predicate = predicate                                                               // Adding our query to our request.
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)                        // Creating sort descriptor. How we will sort.
            request.sortDescriptors = [sortDescriptor]                                                  // Adding sort descriptor to our request. This property is plural because it expects an array of descriptors. In our case it's just one descriptor - single sort rule.
            loadItems(with: request, predicate: predicate)                                                                    // Loading items after searching.
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {                                                                  // DispatchQueue - is the tool to help us do another threads to do job parallel. Main - means main thread. async  - do it ascynchronously.
                searchBar.resignFirstResponder()
            }
        }
    }
}
