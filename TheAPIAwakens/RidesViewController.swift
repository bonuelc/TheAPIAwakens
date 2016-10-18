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
        
        navigationItem.title = "\(character.name)'s Rides"
        
        tableView.dataSource = self
        
        fetchRides()
    }
    
    func fetchRides() {
        fetchVehicles()
        fetchStarships()
    }
    
    func fetchVehicles() {
        
        for endpoint in character.vehicleEndpoints {
            
            guard let apiIndexString = endpoint.componentsSeparatedByString("/").secondToLast, apiIndex = Int(apiIndexString) else {
                continue
            }
            
            swapiClient.fetchVehicle(apiIndex) { result in
                
                switch result {
                case .Success(let vehicle): self.rides.append(vehicle.name)
                case .Failure(let error as NSError): print("Unable to retrieve \(endpoint). \(error.localizedDescription)")
                default: break
                }
                
            }
        }
    }
    
    func fetchStarships() {
        
        for endpoint in character.starshipEndpoints {
            
            guard let apiIndexString = endpoint.componentsSeparatedByString("/").secondToLast, apiIndex = Int(apiIndexString) else {
                continue
            }
            
            swapiClient.fetchStarship(apiIndex) { result in
                
                switch result {
                case .Success(let starship): self.rides.append(starship.name)
                case .Failure(let error as NSError): print("Unable to retrieve \(endpoint). \(error.localizedDescription)")
                default: break
                }
                
            }
        }
    }
}

extension RidesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rides.count > 0 ? rides.count : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = rides.count > 0 ? "\(rides[indexPath.row])" : "None"
        
        return cell
    }
}
