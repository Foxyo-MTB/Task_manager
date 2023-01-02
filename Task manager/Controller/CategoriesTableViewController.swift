//
//  CategoriesTableViewController.swift
//  Task manager
//
//  Created by Vladimir Beliakov on 11.08.2022.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {                  // When we created super class SwipeTableViewCOntroller we can change declaration from UITableViewController to our super class.
    
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
        //let cell = super.tableView(tableView, cellForRowAt: indexPath)                                             // Creating cell using super view. From SwipeTableViewController class. Deleted from project.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell     // Returns a reusable table-view cell object after locating it by its identifier.
        let category = categoriesArray[indexPath.row]                                                                // Creating new constant to minimize code.
        cell.customLabelOutlet.text = category.name                                                                  // Adding text to custom cell and limit to 20 characters.
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.context.delete(self.categoriesArray[indexPath.row])                                                // Delete from Core Data.
            self.categoriesArray.remove(at: indexPath.row)                                                          // Delete from Array.
            do {
                try self.context.save()                                                                             //Renew of our Core Data.
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
    
    //MARK: - Info button.
    
    
    @IBAction func infoButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: InfoModel.rules, message: "", preferredStyle: .alert) //Creating Alert frame
        let action = UIAlertAction(title: "Понятно", style: .default) { (action) in //Creating action
        }
        alert.addAction(action)                                                              // Creating button
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()                                      // Do-catch block for .save because this method throws an error.
        } catch {
            print("Error saving context, \(error)")
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
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Добавить новую категорию", message: "", preferredStyle: .alert) //Creating Alert frame
        let action = UIAlertAction(title: "Добавить категорию", style: .default) { (action) in //Creating button "Add category"
            //What will happen when pressed
            let newCategory = Categories(context: self.context)                             // Initializating our new item as Categories class item =)
            newCategory.name = textField.text                                               // Getting text of category to Categories()
            self.categoriesArray.append(newCategory)                                         // Adding new category to categoriesArray.
            self.saveCategories()                                                           // Call function for save categories.
        }
        action.isEnabled = false
        alert.addTextField { (alertTextField) in                                                    // What will be printed in text field.
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alertTextField, queue: OperationQueue.main, using:
                                                    {_ in
                alertTextField.delegate = self
                // Being in this block means that something fired the UITextFieldTextDidChange notification.
                // Access the textField object from alertController.addTextField(configurationHandler:) above and get the character count of its non whitespace characters
                let textCount = alertTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty = textCount > 0
                // If the text contains non whitespace characters, enable the OK Button
                action.isEnabled = textIsNotEmpty
                
            })
            alertTextField.placeholder = "Создайте новую категорию"                               // Gray text in text field.
            textField = alertTextField                                                           // Store what printed in textField variably.
            textField.autocapitalizationType = .sentences                                        // Making First letter capital.
        }
        alert.addAction(action)                                                                // Creating button "Add category".
        present(alert, animated: true, completion: nil)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        
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
extension CategoriesTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length + range.location > textField.text!.count {
            return false
        }
        let newString = (textField.text!) + string
        return newString.count <= 20
    }
}


