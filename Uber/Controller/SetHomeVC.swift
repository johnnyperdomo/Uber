//
//  SetHomeVC.swift
//  Uber
//
//  Created by Johnny Perdomo on 6/27/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import MapKit

class SetHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchCompleter.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }

    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func setBtnPressed(_ sender: Any) {
        
    }
    
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
    
    
    
}

extension SetHomeVC: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchTableView.reloadData()
        print("results successful")
    }
}

extension SetHomeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            searchCompleter.queryFragment = searchBar.text!
        }
    }
}






