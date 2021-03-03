   //
   //  TableViewController.swift
   //  TableTable
   //
   //  Created by Surfa on 24.01.2021.
   //
   
   import UIKit
   import RealmSwift
   
   
   
   class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
   {
    
    private  var places: Results<Place>!
    private var assendingSort = true
    private var searchController = UISearchController(searchResultsController: nil)
    private var filteredPlaces:Results<Place>!
    private var searchBarIsEmpty : Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
        
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var sortDirectionButton: UIBarButtonItem!
    
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
        
        //        search controller setup
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        //tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if isFiltering {
            return filteredPlaces.isEmpty ? 0 : filteredPlaces.count
        }
        
        return places.isEmpty ? 0 : places.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        var place = Place()
        if isFiltering {
            place = filteredPlaces[indexPath.row]
            
        }
        else {
            place = places[indexPath.row]
        }
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
            var place = Place()
            if isFiltering {
                place = filteredPlaces[indexPath.row]
            }else {
                place = places[indexPath.row]
            }
            
            guard let currentPlaceVC = segue.destination as? NewPlaceTableViewController else {return}
            currentPlaceVC.currentPlace = place
        }
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else {return}
        newPlaceVC.savePlace()
        
        tableView.reloadData()
        
    }
    
    @IBAction func segmentControlSort(_ sender: UISegmentedControl) {
        
        sort()
    }
    
    @IBAction func directionSortChange(_ sender: Any) {
        
        assendingSort.toggle()
        
        if assendingSort {
            sortDirectionButton.image = #imageLiteral(resourceName: "AZ")
        }else {
            sortDirectionButton.image = #imageLiteral(resourceName: "ZA")
        }
        
        sort()
        
    }
    
    private func sort() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: assendingSort)
            
        }
        else
        {
            
            places = places.sorted(byKeyPath: "name", ascending: assendingSort)
        }
        
        tableView.reloadData()
    }
   }
   
   
   extension MainViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    private func filterContentForSearchText (_ searchText : String ){
        
        filteredPlaces = places.filter("name CONTAINS[c] %@ or location CONTAINS[c] %@", searchText, searchText)
        
        tableView.reloadData()
        
    }
    
   }
