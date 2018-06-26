//
//  MainVC.swift
//  Uber
//
//  Created by Johnny Perdomo on 6/25/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import MapKit

class MainVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var carType = CarType.uberPool
    
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var destinationView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var carTypeDetailView: UIView!
    @IBOutlet weak var etaLbl: UILabel!
    @IBOutlet weak var fareLbl: UILabel!
    @IBOutlet weak var maxSizeLbl: UILabel!
    @IBOutlet weak var requestRideBtn: UIButton!
    



    var locationManager = CLLocationManager()
    let regionRadius: Double = 1000
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self
        locationManager.delegate = self
        centerMapOnUserLocation()
        checkLocationAuthorization()
        requestRideBtn.layer.cornerRadius = 15
        destinationView.layer.cornerRadius = 10
        segmentControl.layer.cornerRadius = 20
    }

    func configureCarType(etaLbl: String, fareLbl: String, maxSizeLabel: String) {
        self.etaLbl.text = etaLbl
        self.fareLbl.text = fareLbl
        self.maxSizeLbl.text = maxSizeLabel
    }
    
    
    
    @IBAction func enterLocationBtnPressed(_ sender: Any) {
        print("Enter Location")
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
    
    
    
    
    func centerMapOnUserLocation() { //center the map on the user's location
        guard let coordinate = locationManager.location?.coordinate else { return } //if we have location, show coordinates, if not, return
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0 , regionRadius * 2.0 ) // we have to multiply the regionradius by 2.0 because it's only one direction but we want 1000 meters in both directions;we're gonna set how wide we want the radius to be around the center location
        mapKitView.setRegion(coordinateRegion, animated: true) //to set it
    }
    
    
    func checkLocationAuthorization() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapKitView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
    
}




