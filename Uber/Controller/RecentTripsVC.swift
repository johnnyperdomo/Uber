//
//  RecentTripsVC.swift
//  Uber
//
//  Created by Johnny Perdomo on 7/6/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

class RecentTripsVC: UIViewController {

    @IBOutlet weak var tripsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
    }

}

extension RecentTripsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tripsTableView.dequeueReusableCell(withIdentifier: "tripsCell", for: indexPath) as? TripsCell else { return UITableViewCell() }
        
        cell.driverImage.layer.cornerRadius = cell.driverImage.frame.height / 2

        cell.configureCell(carType: "1", dateTime: "2", pickUp: "3", destination: "4", tripTime: "5", riders: "6", price: "6")
        
        return cell
    }
}
