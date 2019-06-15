//
//  TripCollectionViewController.swift
//  PackList
//
//  Created by jp on 2019-06-13.
//  Copyright © 2019 Jordan Perrella. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

private let reuseIdentifier = "Cell"


class TripCollectionViewController: UICollectionViewController {

  
  @IBOutlet weak var addTripButton: UIBarButtonItem!
  
  var trips = [Trip]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//  var colorArray = NSArray(ofColorsWith:ColorScheme.analogous, with:UIColor.green, flatScheme:true)
  

    override func viewDidLoad() {
      
//      var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//      print("file path \(dataFilePath)")
      
      super.viewDidLoad()
      
      self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

      self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      self.navigationController?.navigationBar.shadowImage = UIImage()
      self.navigationController?.navigationBar.isTranslucent = true
      loadTrips()
    }

  
    // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! ItemTableViewController
    
    if let indexPath = collectionView.indexPathsForSelectedItems {
      destinationVC.selectedTrip = trips[indexPath[0].row]
    }
  }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return trips.count
      
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
      cell.setCell(text: trips[indexPath.row].name!, color: (UIColor.flatBlack()?.withAlphaComponent(0.98))!)
 
      return cell
    }
  
  

  // MARK: UICollectionViewDelegateMethods
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: "itemListSegue", sender: self)
  }
  
  
  // MARK: Data Manipulation
  
  func saveTrips(){
    do {
      try context.save()
    } catch {
      print("error saving trips \(error)")
    }
    loadTrips()
  }
  
  func loadTrips() {
    let request: NSFetchRequest<Trip> = Trip.fetchRequest()
    
    do {
      trips = try context.fetch(request)
    }catch{
      print ("error loading trips \(error)")
    }
    collectionView.reloadData()
  }
  
  @IBAction func AddTripButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add Trip", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
    alert.view.tintColor = UIColor.black
      if textField.text != "" {
        let newTrip = Trip(context: self.context)
        newTrip.name = textField.text!
        self.trips.append(newTrip)
        self.saveTrips()
      }else{
        action.isEnabled = false
      }
    }
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Add Trip"
      textField = alertTextField
    }
    
    alert.addAction(action)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(alert, animated: true, completion: nil)
    alert.view.tintColor = UIColor.flatNavyBlueColorDark()
  }
  
}
