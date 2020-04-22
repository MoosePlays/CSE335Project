//
//  LocationListController.swift
//  simonson_matt_335Project
//
//  Created by Michael Figueroa on 4/15/20.
//  Copyright © 2020 mjsimons. All rights reserved.
//

import UIKit
import CoreData

class LocationListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Vars
    @IBOutlet weak var locationTable: UITableView!
    var locations: [NSManagedObject] = []
    let coreData = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTable.delegate = self
        locationTable.dataSource = self
        locations = coreData.fetchLocations()
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        cell.layer.borderWidth = 1.0
        
        // set name for new cell
        cell.nameLabel.text = locations[indexPath.row].value(forKey: "name") as? String
        
        return cell
    }
    
    //MARK: - add location
    @IBAction func addLocation(_ sender: Any) {
        let addAlert = UIAlertController(title: "Add Location", message: "", preferredStyle: .alert)
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        addAlert.addTextField(configurationHandler: {textField in
            textField.placeholder = "Enter full name of new location here"
        })
        
        addAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: {action in
            if let name = addAlert.textFields?.first?.text{
                print("new location: \(name)")
                
                self.coreData.addLocation(name: name)
                self.locations = self.coreData.fetchLocations()
                print("Number of entries: \(self.locations.count)")
                self.locationTable.reloadData()
            }
        }))
        
        self.present(addAlert, animated: true)
    }
    

    // MARK: - Segue Config
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndex: IndexPath = self.locationTable.indexPath(for: sender as! UITableViewCell)!
        let location = locations[selectedIndex.row]
        
        if(segue.identifier == "goToGym"){
            if let viewController: GymController = segue.destination as? GymController{
                viewController.location = location
            }
        }
    }

}
