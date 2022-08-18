////
////  SwipeTableViewController.swift
////  Task manager
////
////  Created by Vladimir Beliakov on 12.08.2022.
////
//
//import UIKit
//import SwipeCellKit
//
//class SwipeTableViewController: UITableViewController /*, SwipeTableViewCellDelegate*/  {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.rowHeight = 80
//    }
//    
//    //MARK: - TableView Datasource Methods
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Creating a prototype cell for any child class.
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell            // Creating cell. Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table. Downcast it to SwipeCellKit.
//            //cell.delegate = self                                                     // Implementing delegate.
//        return cell
//    }
//    
//    
////    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {            // Delegate method from SwipeCellKit documentation.
////        guard orientation == .right else { return nil }
////
////        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
////            // Deleting itself.
////            self.updateModel(at: indexPath)
////        }
////        // customize the action appearance
////        deleteAction.image = UIImage(named: "Delete-icon")                                                                                                      // Adding to Assets new icon and using it for display.
////
////        return [deleteAction]
////    }
////
////    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
////        var options = SwipeOptions()
////        options.expansionStyle = .destructive
////
////        return options
////    }
//    
//    
//    func updateModel(at indexPath: IndexPath) {
//        // Updata Data Model.
//    }
//       
// 
//    
//}
//
//
