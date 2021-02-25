   //
//  TableViewController.swift
//  TableTable
//
//  Created by Surfa on 24.01.2021.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  

    // MARK: - Table view data source

    var places: Results<Place>!
    //var tableView : TableViewController
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)

        
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.isEmpty ? 0 : places.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let place = places[indexPath.row]
        cell.nameLabel.text = place.name
        cell.typeLabel.text = place.type
        cell.locationLabel.text = place.location
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        

        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height/2
        cell.imageOfPlace.clipsToBounds = true

                return cell
    }
    // MARK: - Table View Delegate
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    // MARK: - Table View Delegate
    
    
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            
            let place = self.places[indexPath.row]
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath] , with: .automatic)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
  
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let place = places[indexPath.row]
            guard let currentPlaceVC = segue.destination as? NewPlaceTableViewController else {return}
            currentPlaceVC.currentPlace = place
        }
    }
   
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else {return}
        newPlaceVC.savePlace()
     
        tableView.reloadData
        
    }
 
}
