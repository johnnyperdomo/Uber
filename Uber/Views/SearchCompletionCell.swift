//
//  SearchCompletionCell.swift
//  Uber
//
//  Created by Johnny Perdomo on 6/27/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

class SearchCompletionCell: UITableViewCell {

    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var detailTxtLbl: UILabel!
    
    func configureCell(textLabel: String, detailTxtLabel: String) {
        self.textLbl.text = textLabel
        self.detailTxtLbl.text = detailTxtLabel
        
    }
    
}
