//
//  PickDestinationVC.swift
//  Uber
//
//  Created by Johnny Perdomo on 6/27/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import MapKit

class PickDestinationVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var quickAccessView: UIView!
    @IBOutlet weak var homeBtnView: UIView!
    @IBOutlet weak var workBtnView: UIView!
    @IBOutlet weak var homeAddressLabel: UILabel!
    @IBOutlet weak var workAddressLabel: UILabel!
    @IBOutlet weak var recentTableView: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchCompleter.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        homeBtnView.layer.cornerRadius = 15
        workBtnView.layer.cornerRadius = 15
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func goBtnPressed(_ sender: Any) {
        print("btn works")
    }
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        print("1")
    }
    
    @IBAction func workBtnPressed(_ sender: Any) {
        print("2")
    }
    
    
}

extension PickDestinationVC: UITableViewDelegate, UITableViewDataSource {
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
    }
}


extension PickDestinationVC: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchTableView.reloadData()
    }
}

extension PickDestinationVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            searchCompleter.queryFragment = searchBar.text!
            searchTableView.isHidden = false
            goBtn.isHidden = false
            quickAccessView.isHidden = true
        } else {
            searchTableView.isHidden = true
            goBtn.isHidden = true
            quickAccessView.isHidden = false
        }
    }
}
