//
//  EventTableViewController.swift
//  MainTime
//
//  Created by Jonay Brito Hernández on 26/02/2020.
//  Copyright © 2020 Jonay Brito Hernández. All rights reserved.
//

import UIKit

class EventTableViewController : UIViewController, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellEvent
        if indexPath.row == 0{
            
        }
        cell.textLabel?.text = "Prueba"
        return cell
    }
    

//            let vc = storyboard?.instantiateViewController(withIdentifier: "timeController") as! UIViewController
//            show(vc, sender: self)
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        if indexPath.row == 1 {
//            self.performSegue(withIdentifier: "seguePrueba", sender: nil)
//            print("pasa algo1")
//        } else if indexPath.row == 0 {
//            self.performSegue(withIdentifier: "seguePrueba", sender: nil)
//            
//            print("pasa algo2")
//        }
//        print("pasa algo3")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
