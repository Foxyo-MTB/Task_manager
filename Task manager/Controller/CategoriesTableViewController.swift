//
//  CategoriesTableViewController.swift
//  Task manager
//
//  Created by Vladimir Beliakov on 11.08.2022.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {
    
    var categoriesArray = [Categories]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   //Because CoreData is in AppDelegate we need to grab data from there. We need object - UIApplication is that object. We downcast it as AppDelegate because file is AppDelegate. We use viewContext in persistentContainer attribute.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    //MARK: - TableView Datasource Methods
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoriesArray.count
        
    }
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath)              // Creating cell. Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
        let category = categoriesArray[indexPath.row]                                                           // Creating new constant to minimize code.
        cell.textLabel?.text = category.name                                                                    // Text of categories.name goes to cell.
        return cell
        
    }
    



    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()                                      // Do-catch block for .save because this method throws an error.
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()                                      // Shows data IRL on screen.
    }
    
    func loadCategories(with request: NSFetchRequest<Categories> = Categories.fetchRequest()) {            // With - external parameter, request - internal parameter. = Categories.fetchRequest() is a default value here.
        //let request : NSFetchRequest<Categories> = Categories.fetchRequest()    // Specifying type of request, because a lot of different data fetches. <Return an array of items> - meaning. Commented after refactoring code and adding external/internal parameter on string above.
        do {
            categoriesArray = try context.fetch(request)                  // Do-catch block for .fetch because this method throws an error.
        } catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert) //Creating Alert frame
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in //Creating button "Add category"
            //What will happen when pressed
            let newCategory = Categories(context: self.context)               // Initializating our new item as Categories class item =)
            newCategory.name = textField.text!                         // Getting text of category to Categories()
            self.categoriesArray.append(newCategory)                          // Adding new category to categoriesArray.
            self.saveCategories()                                        // Call function for save categories.
        }
        alert.addTextField { (alertTextField) in                    // What will be printed in text field.
            alertTextField.placeholder = "Create new category"          // Gray text in text field.
            textField = alertTextField                              // Store what printed in textField variably.
        }
        alert.addAction(action)                                     // Creating button "Add category".
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ItemsSegue", sender: self)                                        //Performing segue to Items view.
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TaskManagerViewController                             // Setting destination view controllew
        
        if let indexPath = tableView.indexPathForSelectedRow   {                                        // That's how i know which category i pressed.
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
    
}
