//
//  MainVC.swift
//  Uber
//
//  Created by Johnny Perdomo on 6/25/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MainVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var destinationView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var carTypeDetailView: UIView!
    @IBOutlet weak var etaLbl: UILabel!
    @IBOutlet weak var fareLbl: UILabel!
    @IBOutlet weak var maxSizeLbl: UILabel!
    @IBOutlet weak var requestRideBtn: UIButton!
    @IBOutlet weak var enterDestinationLbl: UILabel!
    
    var carType = CarType.uberPool
    
    var locationManager = CLLocationManager()
    var currentLocationLatitude = CLLocationDegrees()
    var currentLocationLongitude = CLLocationDegrees()

    let regionRadius: Double = 1000
    
    
    var pickedLocations: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        checkLocationAuthorization()
        
        requestRideBtn.layer.cornerRadius = 15
        destinationView.layer.cornerRadius = 10
        segmentControl.layer.cornerRadius = 20
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.startUpdatingLocation()
        
        mapRoute()
        
        fetchPickedLocation()
        
    }
    
    func configureCarType(etaLbl: String, fareLbl: String, maxSizeLabel: String) {
        self.etaLbl.text = etaLbl
        self.fareLbl.text = fareLbl
        self.maxSizeLbl.text = maxSizeLabel
    }
    
    
    
    @IBAction func enterLocationBtnPressed(_ sender: Any) {
        let pickDestinationVC = storyboard?.instantiateViewController(withIdentifier: "PickDestinationVC")
        present(pickDestinationVC!, animated: true, completion: nil)
    }
    @IBAction func requestRideBtnPressed(_ sender: Any) {
        print("Request Ride")
    }
    
    @IBAction func carTypePicked(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            configureCarType(etaLbl: "2 Min", fareLbl: "$3.00 +", maxSizeLabel: "1 Person")
            carType = .uberPool

        } else if segmentControl.selectedSegmentIndex == 1 {
            configureCarType(etaLbl: "3 Min", fareLbl: "$8.00 +", maxSizeLabel: "2 People")
            carType = .uberX
            
        } else if segmentControl.selectedSegmentIndex == 2 {
            configureCarType(etaLbl: "5 Min", fareLbl: "$15.00 +", maxSizeLabel: "4 People")
            carType = .uberLux

        }
    }
    
    func mapRoute() {
        
        let sourceLocation = CLLocationCoordinate2D(latitude: currentLocationLatitude, longitude: currentLocationLongitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        //
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        //
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        //
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "current"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate.latitude = location.coordinate.latitude
            sourceAnnotation.coordinate.longitude = location.coordinate.longitude
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire state building"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        //
        self.mapKitView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        //
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        //
        directions.calculate { (response, error) in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapKitView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapKitView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = #colorLiteral(red: 0.2980392157, green: 0.631372549, blue: 0.9254901961, alpha: 1)
        renderer.lineWidth = 4.0
        
        return renderer
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        
        currentLocationLatitude = (location?.coordinate.latitude)!
        currentLocationLongitude = (location?.coordinate.longitude)!
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, regionRadius * 2.0 , regionRadius * 2.0 ) // we have to multiply the regionradius by 2.0 because it's only one direction but we want 1000 meters in both directions;we're gonna set how wide we want the radius to be around the center location
        mapKitView.setRegion(coordinateRegion, animated: true) //to set it
        
        locationManager.stopUpdatingLocation()
    }
    
    
    func checkLocationAuthorization() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapKitView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager.startUpdatingLocation()
    }
    
}

extension MainVC { //core data
    func fetchPickedLocation() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext //need a managed object
        let fetchRequest = NSFetchRequest <NSManagedObject>(entityName: "PickedLocation")
        
        do {
            pickedLocations = try managedContext.fetch(fetchRequest)
            
            if pickedLocations.count > 0 {
                for result in pickedLocations {
                    let address = result.value(forKey: "address") as! String
                    enterDestinationLbl.text = "\(address)"
                    enterDestinationLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    print("fetch picked location success")
                }
            } else {
                print("no picked location core data objects")
            }
        } catch {
            print("Could not fetch. \(error.localizedDescription)")
        }
        
    }
}





