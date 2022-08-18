//
//  CategoriesTableViewController.swift
//  Task manager
//
//  Created by Vladimir Beliakov on 11.08.2022.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController /*SwipeTableViewController*/ {                  // When we created super class SwipeTableViewCOntroller we can change declaration from UITableViewController to our super class.
    
    var categoryFilled = ""
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
        //let cell = super.tableView(tableView, cellForRowAt: indexPath)                                          // Creating cell using super view. From SwipeTableViewController class.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let category = categoriesArray[indexPath.row]                                                           // Creating new constant to minimize code.
        cell.customLabelOutlet.text = category.name?.maxLength(length: 20)                                      // Adding text to custom cell and limit to 20 characters.
        return cell
        
    }
    
       

    //MARK: - Info button.
    
    
    @IBAction func infoButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: InfoModel.rules, message: "", preferredStyle: .alert) //Creating Alert frame
        let action = UIAlertAction(title: "OK.", style: .default) { (action) in //Creating action
        }
        alert.addAction(action)                                                              // Creating button
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        if categoryFilled != "" {
            do {
                try context.save()                                      // Do-catch block for .save because this method throws an error.
            } catch {
                print("Error saving context, \(error)")
            }
        } else {
            self.context.delete(self.categoriesArray.last!)
            self.categoriesArray.removeLast()
            do {                                                        // method saveCategories() doesn't work. Error causes tableView.ReloadData(). Reason of this error is unknown. Maybe swipe is reloading data by itself.
                try context.save()
            } catch {
                print(error)
            }
        }
        tableView.reloadData()                                      // Shows data IRL on screen
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
    
    //MARK: - Delete Data from Swipe.
    
     func updateModel(at indexPath: IndexPath) {
        self.context.delete(self.categoriesArray[indexPath.row])
        self.categoriesArray.remove(at: indexPath.row)
        do {                                                        // method saveCategories() doesn't work. Error causes tableView.ReloadData(). Reason of this error is unknown. Maybe swipe is reloading data by itself.
            try context.save()
        } catch {
            print(error)
        }
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert) //Creating Alert frame
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in //Creating button "Add category"
            //What will happen when pressed
            let newCategory = Categories(context: self.context)                             // Initializating our new item as Categories class item =)
            newCategory.name = textField.text!                                              // Getting text of category to Categories()
            self.categoryFilled = newCategory.name!
            self.categoriesArray.append(newCategory)                                         // Adding new category to categoriesArray.
            self.saveCategories()                                                           // Call function for save categories.
        }
        alert.addTextField { (alertTextField) in                                                    // What will be printed in text field.
            alertTextField.placeholder = "Create new category"                               // Gray text in text field.
            textField = alertTextField                                                           // Store what printed in textField variably.
        }
        alert.addAction(action)                                                                // Creating button "Add category".
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

//MARK: - Extenstion to limit maximum number of symbols in category name.

extension String {
   func maxLength(length: Int) -> String {
       var str = self
       let nsString = str as NSString
       if nsString.length >= length {
           str = nsString.substring(with:
               NSRange(
                location: 0,
                length: nsString.length > length ? length : nsString.length)
           )
       }
       return  str
   }
}
