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
  var colorArray = NSArray(ofColorsWith:ColorScheme.analogous, with:UIColor.green, flatScheme:true)
  


    override func viewDidLoad() {
      
//      var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//      print("file path \(dataFilePath)")
      super.viewDidLoad()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
      //collectionView.backgroundColor = UIColor.flatCoffee()
      
      self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      self.navigationController?.navigationBar.shadowImage = UIImage()
      self.navigationController?.navigationBar.isTranslucent = true
      loadTrips()
    }
  
  override func viewDidAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isTranslucent = true
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return trips.count
      
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
      cell.setCell(text: trips[indexPath.row].name!, color: colorArray![indexPath.row] as! UIColor)
    
      return cell
    }
  
  
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
    
    
  }
  
  
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
