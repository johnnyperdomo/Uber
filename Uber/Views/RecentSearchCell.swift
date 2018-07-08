//
//  RecentSearchCell.swift
//  Uber
//
//  Created by Johnny Perdomo on 6/29/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

class RecentSearchCell: UITableViewCell {

    @IBOutlet weak var addressLbl: UILabel!
    
    func configureCell(addressLbl: String) {
        self.addressLbl.text = addressLbl
    }

}
