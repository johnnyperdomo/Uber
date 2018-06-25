//
//  MainVC.swift
//  Uber
//
//  Created by Johnny Perdomo on 6/25/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import MapKit

class MainVC: UIViewController {

    
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var destinationView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var carTypeDetailView: UIView!
    @IBOutlet weak var etaLbl: UILabel!
    @IBOutlet weak var fareLbl: UILabel!
    @IBOutlet weak var maxSizeLbl: UILabel!
    @IBOutlet weak var requestRideBtn: UIButton!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        requestRideBtn.layer.cornerRadius = 15
        destinationView.layer.cornerRadius = 10
        segmentControl.layer.cornerRadius = 20
    }

 
    @IBAction func enterLocationBtnPressed(_ sender: Any) {
        print("Enter Location")
    }
    @IBAction func requestRideBtnPressed(_ sender: Any) {
        print("Request Ride")
    }
    
}
