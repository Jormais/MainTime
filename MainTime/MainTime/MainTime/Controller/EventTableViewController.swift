//
//  EventTableViewController.swift
//  MainTime
//
//  Created by Jonay Brito Hernández on 26/02/2020.
//  Copyright © 2020 Jonay Brito Hernández. All rights reserved.
//

import UIKit

class EventTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var eventTable : UITableView!
    var events = ["Proyecto 1","Proyecto 2"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellEvent
        if indexPath.row == 0{
            
        }
        if indexPath.row == 0 {
            cell.textLabel?.text = events[indexPath.row]
        } else if indexPath.row == 1 {
             cell.textLabel?.text = events[indexPath.row]
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "timeController") as! UIViewController
        show(vc, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventTable.delegate = self
        self.eventTable.dataSource = self
    }
}
