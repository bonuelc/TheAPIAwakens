//
//  RidesViewController.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 10/12/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import UIKit

class RidesViewController: UIViewController {
    
    let swapiClient = SWAPIClient()
    
    var character: Character!
    
    var rides: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RidesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "\(rides[indexPath.row])"
        
        return cell
    }
}
