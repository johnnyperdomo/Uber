//
//  PickDestinationVC.swift
//  Uber
//
//  Created by Johnny Perdomo on 6/27/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class PickDestinationVC: UIViewController {

    //IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var quickAccessView: UIView!
    @IBOutlet weak var homeBtnView: UIView!
    @IBOutlet weak var workBtnView: UIView!
    @IBOutlet weak var homeAddressLabel: UILabel!
    @IBOutlet weak var workAddressLabel: UILabel!
    @IBOutlet weak var recentTableView: UITableView!
    @IBOutlet weak var recentSearchesLabel: UILabel!
    
    //Core Data Objects
    var homeLocation: [NSManagedObject] = []
    var workLocation: [NSManagedObject] = []
    var recentSearches: [NSManagedObject] = []
    var pickedLocations: [NSManagedObject] = []
    
    //Local Search
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchCompleter.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        recentTableView.delegate = self
        recentTableView.dataSource = self
        
        homeBtnView.layer.cornerRadius = 15
        workBtnView.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchHomeFavorite()
        fetchWorkFavorite()
        fetchRecentSearches()
        
        self.recentSearches =  recentSearches.reversed()
        recentTableView.reloadData()
        
        if recentSearches.count == 0 {
            recentSearchesLabel.isHidden = true
        } else {
            recentSearchesLabel.isHidden = false
        }

    }
    
    //IBActions
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        
        if homeAddressLabel.text == "Set a Destination" {
            let setHomeVC = storyboard?.instantiateViewController(withIdentifier: "SetHomeVC")
            present(setHomeVC!, animated: true, completion: nil)
            fetchHomeFavorite()
        } else {
            searchBar.text = homeAddressLabel.text
            print("home favorite address clicked")
            savePickedLocations(address: searchBar.text!)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func workBtnPressed(_ sender: Any) {
        
        if workAddressLabel.text == "Set a Destination" {
            let setWorkVC = storyboard?.instantiateViewController(withIdentifier: "SetWorkVC")
            present(setWorkVC!, animated: true, completion: nil)
            fetchWorkFavorite()
        } else {
            searchBar.text = workAddressLabel.text
            print("work favorite address clicked")
            savePickedLocations(address: searchBar.text!)
            dismiss(animated: true, completion: nil)
        }
    }
    
}
    

extension PickDestinationVC { //Core data Functions
    
    func fetchHomeFavorite() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext //need a managed object
        let fetchRequest = NSFetchRequest <NSManagedObject>(entityName: "HomeFavorite")
        
        do {
            homeLocation = try managedContext.fetch(fetchRequest)
            
            if homeLocation.count > 0 {
                for result in homeLocation {
                    let address = result.value(forKey: "address") as! String
                    homeAddressLabel.text = "\(address)"
                    print("fetch home location success")
                }
            } else {
                print("no home core data objects")
            }
            
        } catch {
            print("Could not fetch. \(error.localizedDescription)")
        }
        
    }
    
    func fetchRecentSearches() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext //need a managed object
        let fetchRequest = NSFetchRequest <NSManagedObject>(entityName: "RecentSearches")
        
        do {
            recentSearches = try managedContext.fetch(fetchRequest)
        } catch {
            print("Could not fetch. \(error.localizedDescription)")
        }
        
    }
    
    func fetchWorkFavorite() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext //need a managed object
        let fetchRequest = NSFetchRequest <NSManagedObject>(entityName: "WorkFavorite")
        
        do {
            workLocation = try managedContext.fetch(fetchRequest)
            
            if workLocation.count > 0 {
                for result in workLocation {
                    let address = result.value(forKey: "address") as! String
                    workAddressLabel.text = "\(address)"
                    print("fetch work location success")
                }
            } else {
                print("no work core data objects")
            }
            
        } catch {
            print("Could not fetch. \(error.localizedDescription)")
        }
        
    }
    
    func saveRecentSearch(address: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RecentSearches", in: managedContext)
        let recentSearch = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        recentSearch.setValue(address, forKey: "address")
        
        do {
            try managedContext.save()
            recentSearches.append(recentSearch) //add it to array
            print("save recent Search Success")
        } catch {
            print("Could not save. \(error.localizedDescription)")
        }
        
    }
    
    func savePickedLocations(address: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PickedLocation", in: managedContext)
        let pickedAddress = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        pickedAddress.setValue(address, forKey: "address")
        
        do {
            try managedContext.save()
            pickedLocations.append(pickedAddress) //add it to array
            print("save Picked Location Success")
        } catch {
            print("Could not save. \(error.localizedDescription)")
        }
    }
    
}

extension PickDestinationVC: UITableViewDelegate, UITableViewDataSource { //TableViews - 2 TableViews in 1 View Controller: Specify self.TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var count: Int?
        
        if tableView == self.recentTableView {
            count = 1
        }
        
        if tableView == self.searchTableView {
            count = 1
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        
        if tableView == self.searchTableView {
            count = searchResults.count
        }

        if tableView == self.recentTableView {
            
            if recentSearches.count < 3 {
                count = recentSearches.count
            } else {
                count = 3
            }
        }
        
        return count!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cells: UITableViewCell?
        
        if tableView == self.searchTableView {
            guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCompletionCell", for: indexPath) as? SearchCompletionCell else {return UITableViewCell()}
            let searchResult = searchResults[indexPath.row]
            
            cell.textLbl.text = searchResult.title
            cell.detailTxtLbl.text = searchResult.subtitle
            cells = cell
        }
        
        if tableView == self.recentTableView {

            if recentSearches.count == 0 {
                guard let cell = recentTableView.dequeueReusableCell(withIdentifier: "recentSearchCell", for: indexPath) as? RecentSearchCell else {return UITableViewCell()}
                
                recentTableView.isHidden = true
                
                cells = cell
                
            } else if recentSearches.count > 0 {
                guard let cell = recentTableView.dequeueReusableCell(withIdentifier: "recentSearchCell", for: indexPath) as? RecentSearchCell else {return UITableViewCell()}
                
                recentTableView.isHidden = false
                
                let recentPlace = recentSearches[indexPath.row]
                let address = recentPlace.value(forKey: "address") as? String

                cell.configureCell(addressLbl: address!)

                cell.layer.cornerRadius = 15
                cell.layer.borderColor = #colorLiteral(red: 0.3764705882, green: 0.6274509804, blue: 0.9019607843, alpha: 1)
                cell.layer.borderWidth = 2
                
                cells = cell
            }
        }
    
        return cells!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.searchTableView {
            let indexPath = tableView.indexPathForSelectedRow
            let currentCell = tableView.cellForRow(at: indexPath!) as! SearchCompletionCell
            
            let detailTxt = currentCell.detailTxtLbl.text
            
            searchBar.text = detailTxt
            
            self.saveRecentSearch(address: searchBar.text!)
            savePickedLocations(address: searchBar.text!)
            
            print("search cell clicked")
            dismiss(animated: true, completion: nil)
        }
        
        if tableView == self.recentTableView {
            let indexPath = tableView.indexPathForSelectedRow
            let currentCell = tableView.cellForRow(at: indexPath!) as! RecentSearchCell
            
            let address = currentCell.addressLbl.text
            
            searchBar.text = address
            savePickedLocations(address: searchBar.text!)
            
            print("recent history cell clicked")
            dismiss(animated: true, completion: nil)
            
        }
    }
    
}


extension PickDestinationVC: MKLocalSearchCompleterDelegate { //Local Search Completer for search bar: Auto completes locations / addresses that user starts typing
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchTableView.reloadData()
    }
}

extension PickDestinationVC: UISearchBarDelegate { //Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            searchCompleter.queryFragment = searchBar.text!
            searchTableView.isHidden = false
            quickAccessView.isHidden = true
        } else {
            searchTableView.isHidden = true
            quickAccessView.isHidden = false
        }
    }
}
