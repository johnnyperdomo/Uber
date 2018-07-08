//
//  ViewController.swift
//  Uber
//
//  Created by Johnny Perdomo on 6/24/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import SideMenu
import CoreData

class SideMenuController: UIViewController {

    let sideMenu = SideMenuManager.default
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var homeSubLocationLbl: UILabel!
    @IBOutlet weak var workSubLocationLbl: UILabel!
    
    var homeLocation: [NSManagedObject] = []
    var workLocation: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuCustom()
        imageView.layer.cornerRadius = imageView.frame.height / 2
        
        fetchHomeFavorite()
        fetchWorkFavorite()
    }
    
    @IBAction func homeLocationBtnPressed(_ sender: Any) {
        let setHomeVC = storyboard?.instantiateViewController(withIdentifier: "SetHomeVC")
        present(setHomeVC!, animated: true, completion: nil)
    }
    
    @IBAction func workLocationBtnPressed(_ sender: Any) {
        let setWorkVC = storyboard?.instantiateViewController(withIdentifier: "SetWorkVC")
        present(setWorkVC!, animated: true, completion: nil)
    }
    
    @IBAction func recentTripsBtnPressed(_ sender: Any) { 
        let recentTripsVC = storyboard?.instantiateViewController(withIdentifier: "RecentTripsVC")
        present(recentTripsVC!, animated: true, completion: nil)
    }
    
    func sideMenuCustom() { //Draws the menuAnimationBackgroundColor behind the status bar. Default is true.
        sideMenu.menuFadeStatusBar = false
    }
    
}

extension SideMenuController { //Core Data Functions
    
    func fetchHomeFavorite() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext //need a managed object
        let fetchRequest = NSFetchRequest <NSManagedObject>(entityName: "HomeFavorite")
        
        do {
            homeLocation = try managedContext.fetch(fetchRequest)
            
            if homeLocation.count > 0 {
                for result in homeLocation {
                    let address = result.value(forKey: "address") as! String
                    homeSubLocationLbl.text = "\(address)"
                    print("fetch home location success")
                }
            } else {
                print("no home core data objects")
            }
            
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
                    workSubLocationLbl.text = "\(address)"
                    print("fetch work location success")
                }
            } else {
                print("no work core data objects")
            }
            
        } catch {
            print("Could not fetch. \(error.localizedDescription)")
        }
        
    }
    
}

