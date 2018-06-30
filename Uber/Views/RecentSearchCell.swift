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
    @IBOutlet weak var recentImageIcon: UIImageView!
    
    
    func configureCell(addressLbl: String, recentImageIcon: UIImage) {
        self.addressLbl.text = addressLbl
        self.recentImageIcon.image = recentImageIcon
    }

}
