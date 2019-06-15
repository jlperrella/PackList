//
//  ItemViewController.swift
//  PackList
//
//  Created by jp on 2019-06-14.
//  Copyright © 2019 Jordan Perrella. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var itemsTableView: UITableView!
  
  
  var items = [Item]()
  
  var selectedTrip: Trip?{
    didSet{
      loadItems()
    }
  }
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    itemsTableView.delegate = self
    itemsTableView.dataSource = self
    
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
    
    return cell
  }
  
  // MARK: UITableViewDelegateMethods
  
  
  
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
    self.itemsTableView.reloadData()
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
}
  

  

