//
//  ViewController.swift
//  rosivda
//
//  Created by Fabian on 21/04/2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var suggestionsView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomSheet: DetailView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    let suggestions: [String] = ["mc donalds paris", "auchan paris"]
    
    let cellReuseIdentifier = "cell"
    
    private var search: String = ""
    
    let locationManager = CLLocationManager()
    
    private var data: Locations? {
        willSet {
            //print(newValue ?? "")
            let annotations = mapView.annotations.filter({ !($0 is MKUserLocation) })
            mapView.removeAnnotations(annotations)
        }
        
        didSet {
            if let locations = data {
                for location in locations {
                    let annotations = MyPointAnnotation(location: location)
                    mapView.addAnnotation(annotations)
              }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        fetchLocation(searchText: "mcdonalds%20paris")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    func fetchLocation(searchText: String){
        APIManager.shared.locations(search: searchText, completion: { (locations) -> (Void) in
            if let locations = locations {
                self.data = locations
                
            } else {
                print("Could not fetch locations")
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
       
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            self.mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show alert
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
        
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // the user didn't turn it on
            print("Please turn on location services.")
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        if let annotation = view.annotation as? MyPointAnnotation{
            self.bottomSheet.initLabels(location: annotation.data)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.bottomSheet.handleDisplay()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search = searchText.isEmpty ? "" : searchText.replacingOccurrences(of: " ", with: "%20")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.fetchLocation(searchText: self.search)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.suggestionsView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestions.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        
        // set the text from the data model
        cell.textLabel?.text = self.suggestions[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = self.suggestions[indexPath.row]
        self.fetchLocation(searchText: text)
        self.suggestionsView.isHidden = true
    }

}

