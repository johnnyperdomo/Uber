//
//  ViewController.swift
//  Uber
//
//  Created by Johnny Perdomo on 6/24/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuController: UIViewController {

    let sideMenu = SideMenuManager.default
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var homeLocationLbl: UILabel!
    @IBOutlet weak var workLocationLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuCustom()
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
    
    
    func sideMenuCustom() {
        sideMenu.menuFadeStatusBar = false
    }
    
    
    @IBAction func homeLocationBtnPressed(_ sender: Any) {
        let setHomeVC = storyboard?.instantiateViewController(withIdentifier: "SetHomeVC")
        present(setHomeVC!, animated: true, completion: nil)
    }
    
    @IBAction func workLocationBtnPressed(_ sender: Any) {
        print("work pressed")
    }
    
}

