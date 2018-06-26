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

    var carType = CarType.uberPool
    
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
    
}
