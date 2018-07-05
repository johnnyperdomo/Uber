//
//  TripCompletionVC.swift
//  Uber
//
//  Created by Johnny Perdomo on 7/5/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

class TripCompletionVC: UIViewController {


    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var starsLbl: UILabel!
    @IBOutlet weak var uberType: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var tripView: UIView!
    @IBOutlet weak var tripTimeLbl: UILabel!
    @IBOutlet weak var numberOfTravelersLbl: UILabel!
    @IBOutlet weak var pickupLbl: UILabel!
    @IBOutlet weak var dropoffLbl: UILabel!
    
    var riders = String()
    var price = String()
    var tripTime = String()
    var carType = String()
    var pickUp = String()
    var dropOff = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tripView.layer.cornerRadius = 20
        completeBtn.layer.cornerRadius = 15
        driverImage.layer.cornerRadius = driverImage.frame.height / 2
        
        numberOfTravelersLbl.text = "Riders: \(riders)"
        priceLbl.text = "USD \(price)"
        tripTimeLbl.text = "Trip Time: \(tripTime)"
        uberType.text = "Car: \(carType)"
        pickupLbl.text = "From: \(pickUp)"
        dropoffLbl.text = "To: \(dropOff)"
    }

    @IBAction func completeBtnPressed(_ sender: Any) {
         
    }
    
    func initTripDetails(riders: String, price: String, tripTime: String, carType: String, pickUp: String, dropOff: String) {
        self.riders = riders
        self.price = price
        self.tripTime = tripTime
        self.carType = carType
        self.pickUp = pickUp
        self.dropOff = dropOff
    }
    
    
    
    
}
