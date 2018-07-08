//
//  SetHomeVC.swift
//  Uber
//
//  Created by Johnny Perdomo on 6/27/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class SetHomeVC: UIViewController  {

    //IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    //Local Search
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    var homeLocation: [NSManagedObject] = [] //Core Data Object
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchCompleter.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }

    //IBActions
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SetHomeVC { //Core Data
    
    func saveAddress(address: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "HomeFavorite", in: managedContext)
        let homeFavorite = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        homeFavorite.setValue(address, forKey: "address")
        
        do {
            try managedContext.save()
            homeLocation.append(homeFavorite) //add it to array
            print("save homeFavorite Success")
        } catch {
            print("Could not save. \(error.localizedDescription)")
        }
        
    }
}


extension SetHomeVC: UITableViewDelegate, UITableViewDataSource { //Table Views
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCompletionCell", for: indexPath) as? SearchCompletionCell else {return UITableViewCell()}
        let searchResult = searchResults[indexPath.row]
        
        cell.textLbl.text = searchResult.title
        cell.detailTxtLbl.text = searchResult.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! SearchCompletionCell
        
        let detailTxt = currentCell.detailTxtLbl.text
        searchBar.text = detailTxt
        
        self.saveAddress(address: searchBar.text!)
        
        print("save home data")
        dismiss(animated: true, completion: nil)
    }
}


extension SetHomeVC: MKLocalSearchCompleterDelegate { //Local Search Completer for search bar: Auto completes locations / addresses that user starts typing
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchTableView.reloadData()
    }
}

extension SetHomeVC: UISearchBarDelegate { // Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            searchCompleter.queryFragment = searchBar.text!
        }
    }
}






