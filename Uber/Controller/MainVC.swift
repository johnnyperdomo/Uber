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

class MainVC: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var destinationView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var carTypeDetailView: UIView!
    @IBOutlet weak var etaLbl: UILabel!
    @IBOutlet weak var fareLbl: UILabel!
    @IBOutlet weak var maxSizeLbl: UILabel!
    @IBOutlet weak var requestRideBtn: UIButton!
    @IBOutlet weak var enterDestinationLbl: UILabel!
    
    var carType: CarType = .uberPool //CarType Enum
    
    var locationManager = CLLocationManager() //Manages User Location
    var currentLocationAddressName = String() //Name of Current Location: String

    var routeDistance = Double() //Distance of Route
    var routeETA = Double() //Travel Time of Route
    
    //Coordinates of Locations
    var currentLocationLatitude = CLLocationDegrees()
    var currentLocationLongitude = CLLocationDegrees()
    var destinationLocationLatitude = CLLocationDegrees()
    var destinationLocationLongitude = CLLocationDegrees()

    let regionRadius: Double = 1000
    
    var pickedLocations: [NSManagedObject] = [] //Core Data Object

    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        requestRideBtn.layer.cornerRadius = 15
        destinationView.layer.cornerRadius = 10
        segmentControl.layer.cornerRadius = 20
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.startUpdatingLocation() //Starts the generation of updates that report the user’s current location.
        
        fetchPickedLocation { (success) in
            
            if success {
                self.convertAddress()
                self.mapRoute()
                self.convertCoordinates()
                print("success")
            } else {
                self.userLocationAnnotationView()
                print("error")
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorization()
    }
    
    func configureCarType(etaLbl: String, fareLbl: String, maxSizeLabel: String) {
        self.etaLbl.text = etaLbl
        self.fareLbl.text = fareLbl
        self.maxSizeLbl.text = maxSizeLabel
    }
    
    //IBActions
    @IBAction func enterLocationBtnPressed(_ sender: Any) {
        let pickDestinationVC = storyboard?.instantiateViewController(withIdentifier: "PickDestinationVC")
        present(pickDestinationVC!, animated: true, completion: nil)
        
        if mapKitView.overlays.count > 0 {
            mapKitView.removeOverlays(mapKitView.overlays)
            mapKitView.removeAnnotations(mapKitView.annotations)
        }
        
    }
    
    @IBAction func requestRideBtnPressed(_ sender: Any) {
        
        if etaLbl.text != "TBD" && etaLbl.text != "0 Mins" {
            guard let tripCompletionVC = storyboard?.instantiateViewController(withIdentifier: "TripCompletionVC") as? TripCompletionVC else { return }
            tripCompletionVC.initTripDetails(riders: maxSizeLbl.text!, price: fareLbl.text!, tripTime: etaLbl.text!, carType: carType.rawValue, pickUp: currentLocationAddressName, dropOff: enterDestinationLbl.text!)
            present(tripCompletionVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func carTypePicked(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            
            if enterDestinationLbl.text == "Enter Destination" {
                configureCarType(etaLbl: "TBD", fareLbl: "$3.00 +", maxSizeLabel: "1 Person")
                carType = .uberPool
            } else {
                configureCarType(etaLbl: "\(String(format: "%.0f", routeETA)) Mins", fareLbl: "$\(String(format: "%.2f", (routeDistance * 0.005) + 3))", maxSizeLabel: "1 Person")
                carType = .uberPool
            }
            
        } else if segmentControl.selectedSegmentIndex == 1 {
            
            if enterDestinationLbl.text == "Enter Destination" {
                configureCarType(etaLbl: "TBD", fareLbl: "$8.00 +", maxSizeLabel: "2 People")
                carType = .uberX
            } else {
                configureCarType(etaLbl: "\(String(format: "%.0f", routeETA)) Mins", fareLbl: "$\(String(format: "%.2f", (routeDistance * 0.005) + 8))", maxSizeLabel: "2 People")
                carType = .uberX
            }
            
        } else if segmentControl.selectedSegmentIndex == 2 {
            
            if enterDestinationLbl.text == "Enter Destination" {
                configureCarType(etaLbl: "TBD", fareLbl: "$15.00 +", maxSizeLabel: "4 People")
                carType = .uberLux
            } else {
                configureCarType(etaLbl: "\(String(format: "%.0f", routeETA)) Mins", fareLbl: "$\(String(format: "%.2f", (routeDistance * 0.005) + 15))", maxSizeLabel: "4 People")
                carType = .uberLux
            }

        }
    }
}

extension MainVC: CLLocationManagerDelegate, MKMapViewDelegate { //Maps
    func mapRoute() {
        
        let sourceLocation = CLLocationCoordinate2D(latitude: currentLocationLatitude, longitude: currentLocationLongitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: destinationLocationLatitude, longitude: destinationLocationLongitude)
        //
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        //
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        //
        let sourceAnnotation = CustomPointAnnotation()
        sourceAnnotation.title = "\(currentLocationAddressName)"
        sourceAnnotation.subtitle = "Pick Up Location"
        sourceAnnotation.pinCustomImageName = "pickuppin"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
            
        }

        let destinationAnnotation = CustomPointAnnotation()
        destinationAnnotation.title = "\(enterDestinationLbl.text ?? "Drop Off Location")" //provide a default value just in case address text isn't available
        destinationAnnotation.subtitle = "Drop Off Location"
        destinationAnnotation.pinCustomImageName = "destinationpin"
        
        //custom annotation
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        //
        self.mapKitView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        //
        let directionRequest = MKDirectionsRequest() //The start and end points of a route, along with the planned mode of transportation.
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
            
            self.routeDistance = route.distance //distance of route in meters
            self.routeETA = route.expectedTravelTime / 60 //in seconds, so divide by 60
            
            let rect = route.polyline.boundingMapRect
            self.mapKitView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    func userLocationAnnotationView() {
        let userLocation = CLLocationCoordinate2D(latitude: currentLocationLatitude, longitude: currentLocationLongitude)
        let userPlaceMark = MKPlacemark(coordinate: userLocation, addressDictionary: nil)
        
        let userAnnotation = CustomPointAnnotation()
        userAnnotation.pinCustomImageName = "pickuppin"
        
        if let location = userPlaceMark.location {
            userAnnotation.coordinate = location.coordinate
        }
        
        mapKitView.showAnnotations([userAnnotation], animated: true)
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
    
    func convertCoordinates() { //convert coordinates into friendly names
        let geoCoder = CLGeocoder()
        
        var locationName = String()
        var cityName = String()
        var zipNum = String()
        var countryName = String()
        
        let location = CLLocation(latitude: currentLocationLatitude, longitude: currentLocationLongitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            //Place Details
            var placemark: CLPlacemark!
            placemark = placemarks?[0]
            
            //Location Name
            if let location = placemark.name{
                locationName = location
            }
            
            //city
            if let city = placemark.locality {
                cityName = city
            }
            
            //zipcode
            if let zip = placemark.postalCode {
                zipNum = zip
            }
            
            //country
            if let country = placemark.country {
                countryName = country
            }
            
            self.currentLocationAddressName = "\(locationName), \(cityName), \(zipNum), \(countryName)"
            print(self.currentLocationAddressName)
            
        }
    }
    
    
    func convertAddress() { //An interface for converting between geographic coordinates and place names.
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(enterDestinationLbl.text!) { (placemarks, error) in
            
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    return
            }
            
            self.destinationLocationLatitude = location.coordinate.latitude
            self.destinationLocationLongitude = location.coordinate.longitude
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { //custom annotation
        
        let reuseIdentifier = "pin"
        var annotationView = mapKitView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if let customPointAnnotation = annotation as? CustomPointAnnotation {
            annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
        }
        
        return annotationView
    }
}

extension MainVC { //Core Data
    func fetchPickedLocation(complete: @escaping (_ status: Bool) -> ()) {
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
        
        complete(true)
    }
}





