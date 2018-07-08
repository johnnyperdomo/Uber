//
//  TripsCell.swift
//  Uber
//
//  Created by Johnny Perdomo on 7/6/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

class TripsCell: UITableViewCell {

    @IBOutlet weak var carTypeLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var pickUpLbl: UILabel!
    @IBOutlet weak var destinationLbl: UILabel!
    @IBOutlet weak var tripTimeLbl: UILabel!
    @IBOutlet weak var ridersLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var driverImage: UIImageView!
    
    func configureCell(carType: String, dateTime: String, pickUp: String, destination: String, tripTime: String, riders: String, price: String) {
        self.carTypeLbl.text = carType
        self.dateTimeLbl.text = dateTime
        self.pickUpLbl.text = pickUp
        self.destinationLbl.text = destination
        self.tripTimeLbl.text = tripTime
        self.ridersLbl.text = riders
        self.priceLbl.text = price
    }
}
