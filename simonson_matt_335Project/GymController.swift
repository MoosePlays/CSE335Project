//
//  GymController.swift
//  simonson_matt_335Project
//
//  Created by Michael Figueroa on 4/16/20.
//  Copyright © 2020 mjsimons. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class GymController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate{
    //MARK: - Vars
    let coreData: CoreDataManager = CoreDataManager()
    var localSearchResponse:MKLocalSearch.Response!
    var location: NSManagedObject!
    var routes: [NSManagedObject] = []
    @IBOutlet weak var gymMap: MKMapView!
    @IBOutlet weak var gymNav: UINavigationItem!
    @IBOutlet weak var routeTable: UITableView!
    
    
    //MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        routeTable.delegate = self
        routeTable.dataSource = self
        gymMap.delegate = self
        
        routes = coreData.fetchRoutes(location: location.value(forKey: "name") as! String)
        if (location.value(forKey: "lat") as! Double == 0 && location.value(forKey: "long") as! Double == 0) {
            // if lat/long not set yet, set and update location var
            print("finding coords")
            findCoords(name: location.value(forKey: "name") as! String)
            location = coreData.fetchLocation(name: location.value(forKey: "name") as! String)
            setMap(lat: location.value(forKey: "lat") as! Double, long: location.value(forKey: "long") as! Double)
        } else{
            setMap(lat: location.value(forKey: "lat") as! Double, long: location.value(forKey: "long") as! Double)
        }
        
        gymNav.title = location.value(forKey: "name") as? String
        
        routes = coreData.fetchRoutes(location: location.value(forKey: "name") as! String)
        
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath) as! RouteTableViewCell
        cell.layer.borderWidth = 1.0
        
        let route = routes[indexPath.row]
        
        cell.routeName.text = route.value(forKey: "name") as? String
        cell.routeGrade.text = route.value(forKey: "grade") as? String
        
        return cell
    }
    
    
    // MARK: - Map Stuff
    func findCoords(name: String){
        let name = location.value(forKey: "name") as! String
        let localSearchRequest:MKLocalSearch.Request = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = name
        localSearchRequest.region = gymMap.region
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            if localSearchResponse == nil{
                //dont work, just return
                print("no workie")
                return
            }
            
            print("Coords found: \(localSearchResponse!.boundingRegion.center.latitude) \(localSearchResponse!.boundingRegion.center.longitude)")
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            self.location.setValue(localSearchResponse!.boundingRegion.center.latitude, forKey: "lat")
            self.location.setValue(localSearchResponse!.boundingRegion.center.longitude, forKey: "long")
            
            do{
                try context.save()
                print("saved new location")
            } catch{
                print("Couldn't save")
            }
            
        }
    }
    
    //sets view of map
    func setMap(lat: Double, long: Double){
        print("coords: \(lat) \(long)")
        
        //set annotation text and coords
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.title = location.value(forKey: "name") as? String
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        //recenter map over gym
        let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
        let span = MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
        gymMap.setRegion(region, animated: true)
        gymMap.addAnnotation(pinAnnotationView.annotation!)
    }
    
    // MARK: - Add Route
    @IBAction func addRoute(_ sender: Any) {
        let addAlert = UIAlertController(title: "Add Route", message: "", preferredStyle: .alert)
            
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
        addAlert.addTextField(configurationHandler: {textField in
            textField.placeholder = "Enter name of new route here"
        })
        
        addAlert.addTextField(configurationHandler: {textfield in
            textfield.placeholder = "Enter grade of route here (V5, 5.11a, etc)"
        })
            
        addAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: {action in
            if let name = addAlert.textFields![0].text{
                if let grade = addAlert.textFields![1].text{
                    print("new route: \(name)")
                    print("new grade \(grade)")
                    
                    self.coreData.addRoute(name: name, grade: grade, location: self.location.value(forKey: "name") as! String)
                    self.routes = self.coreData.fetchRoutes(location: self.location.value(forKey: "name") as! String)
                    print("Number of entries: \(self.routes.count)")
                    self.routeTable.reloadData()
                }
            }
            }))
            
            self.present(addAlert, animated: true)
        
    }
    
    
    // MARK: - segue management

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
