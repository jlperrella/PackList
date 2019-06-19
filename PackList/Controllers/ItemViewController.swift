//
//  ItemViewController.swift
//  PackList
//
//  Created by jp on 2019-06-14.
//  Copyright © 2019 Jordan Perrella. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var itemsTableView: UITableView!
  
  
  var items = [Item]()
  
  var selectedTrip: Trip?{
    didSet{
      loadItems()
    }
  }
  
  let attributes: [NSAttributedString.Key: Any] =
    [NSAttributedString.Key.strikethroughStyle: 2]
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    itemsTableView.delegate = self
    itemsTableView.dataSource = self
    itemsTableView.rowHeight = 60.0
    loadItems()
    
    
    
    
  }
  
  // MARK: UITableview datasource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
    let item = items[indexPath.row]
    cell.textLabel?.text = item.name
    
    cell.textLabel?.attributedText = item.isPacked ? NSAttributedString(string: item.name!, attributes: attributes) : NSAttributedString(string: item.name!, attributes: .none)
    
    
    return cell
  }
  
  // MARK: UITableViewDelegateMethods
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { (ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
      self.context.delete(self.items[indexPath.row])
      self.items.remove(at: indexPath.row)
      self.saveItems()
      success(true)
    })
    
    deleteAction.image = UIImage(named: "Trash-Icon")
    deleteAction.backgroundColor = UIColor.flatRed()
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
  
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let packedAction = UIContextualAction(style: .normal, title: "Packed", handler: { (ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
      self.items[indexPath.row].isPacked = !self.items[indexPath.row].isPacked
      self.saveItems()
      success(true)
    })
    
    packedAction.image = UIImage(named: "Flag-Icon")
    packedAction.backgroundColor = UIColor.flatBlue()
    
    
    return UISwipeActionsConfiguration(actions: [packedAction])
  }
  
  
  
  
  //MARK: Data Manipulation Methods
  
  @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Add Item"
      textField = alertTextField
    }
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      
      if textField.text != "" {
        let newItem = Item(context: self.context)
        newItem.name = textField.text
        newItem.isPacked = false
        newItem.isRemoved = false
        newItem.parentTrip = self.selectedTrip
        
        self.items.append(newItem)
        
        self.saveItems()
      } else{
        action.isEnabled = false
      }
    }
    
    alert.addAction(action)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(alert, animated: true, completion: nil)
    alert.view.tintColor = UIColor.flatNavyBlueColorDark()
  }
  
  
  func saveItems() {
    do {
      try context.save()
    } catch{
      print("Error saving context \(error)")
    }
    itemsTableView.reloadData()
  }
  
  func loadItems() {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    let predicate = NSPredicate(format: "parentTrip.name MATCHES %@", selectedTrip!.name!)
    request.predicate = predicate
    
    do {
      items = try context.fetch(request)
    } catch{
      print("Error loading items \(error)")
    }
  }
  
  @IBAction func deleteTripButtonPressed(_ sender: Any) {
    
    let alert = UIAlertController(title: "Delete Trip", message: "Are you sure you want to delete this entire trip?", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Delete", style: .destructive) { (action) in
      
      let request: NSFetchRequest<Item> = Item.fetchRequest()
      let predicate = NSPredicate(format: "parentTrip.name MATCHES %@", self.selectedTrip!.name!)
      
      request.predicate = predicate
      
      do {
        self.items = try self.context.fetch(request)
        
        for item in self.items{
          let i = self.items.firstIndex(of:item)!
          self.context.delete(self.items[i])
          self.items.remove(at: i)
        }
        
        self.context.delete(self.selectedTrip!)
        _ = self.navigationController?.popToRootViewController(animated: true)
        
        
      } catch{
        print("Error deleting trip \(error)")
      }
      self.saveItems()
    }
    
    alert.addAction(action)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.view.tintColor = UIColor.flatNavyBlueColorDark()
    present(alert, animated: true, completion: nil)
    
  }
  
}
  

  

