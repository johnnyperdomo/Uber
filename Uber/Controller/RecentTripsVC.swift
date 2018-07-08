//
//  RecentTripsVC.swift
//  Uber
//
//  Created by Johnny Perdomo on 7/6/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import CoreData

class RecentTripsVC: UIViewController {

    //IBOutlets
    @IBOutlet weak var tripsTableView: UITableView!
    
    var tripDetails: [NSManagedObject] = [] //Core Data Object
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        
        fetchTripDetails()
    }

    //IBActions
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension RecentTripsVC: UITableViewDelegate, UITableViewDataSource { //Table Views
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tripsTableView.dequeueReusableCell(withIdentifier: "tripsCell", for: indexPath) as? TripsCell else { return UITableViewCell() }
        
        let tripDetail = tripDetails[indexPath.row] //get different values
        
        //get Attribute values from Core Data Entities
        let dateTime = tripDetail.value(forKey: "dateTime") as! String
        let riders = tripDetail.value(forKey: "numberOfTravelers") as! String
        let price = tripDetail.value(forKey: "price") as! String
        let tripTime = tripDetail.value(forKey: "travelTime") as! String
        let carType = tripDetail.value(forKey: "carType") as! String
        let pickUp = tripDetail.value(forKey: "pickupLocation") as! String
        let dropOff = tripDetail.value(forKey: "dropOffLocation") as! String
        
        cell.driverImage.layer.cornerRadius = cell.driverImage.frame.height / 2

        cell.configureCell(carType: carType, dateTime: dateTime, pickUp: "From: \(pickUp)", destination: "To: \(dropOff)", tripTime: "Trip Time: \(tripTime)", riders: "Riders: \(riders)", price: "USD \(price)")
        
        cell.layer.borderColor = #colorLiteral(red: 0.02947635204, green: 0.6206935048, blue: 0.9890564084, alpha: 1)
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 13
        
        return cell
    }
}

extension RecentTripsVC { //Core Data
    func fetchTripDetails() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext //need a managed object
        let fetchRequest = NSFetchRequest <NSManagedObject>(entityName: "TripDetails")
        
        do {
            tripDetails = try managedContext.fetch(fetchRequest)
            print("fetch trip details success")
        } catch {
            print("Could not fetch. \(error.localizedDescription)")
        }
    }
}

