//
//  StatisticsViewController.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 9/30/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberStatisticsTableView: UITableView!
    @IBOutlet weak var showcaseTableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var entityTypePicked: EntityType!
    
    let swapiClient = SWAPIClient()
    
    var characters: [Character] = [] {
        didSet {
            pickerView.reloadAllComponents()
            nameLabel.text = characters[pickerView.selectedRowInComponent(0)].name
        }
    }
    
    var vehicles: [Vehicle] = [] {
        didSet {
            pickerView.reloadAllComponents()
            nameLabel.text = vehicles[pickerView.selectedRowInComponent(0)].name
        }
    }
    
    var starships: [Starship] = [] {
        didSet {
            pickerView.reloadAllComponents()
            nameLabel.text = starships[pickerView.selectedRowInComponent(0)].name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = entityTypePicked.rawValue
        
        // 'guard let' necessary b/c of Xcode compiler bug
        guard let entityTypePicked = entityTypePicked else { fatalError() }
        
        switch entityTypePicked {
        case .Characters:
            swapiClient.fetchCharacters { result in
                switch result {
                case .Success(let characters): self.characters.appendContentsOf(characters)
                case .Failure(let error): print(error)
                }
            }
        case .Vehicles:
            swapiClient.fetchVehicles { result in
                switch result {
                case .Success(let vehicles): self.vehicles.appendContentsOf(vehicles)
                case .Failure(let error): print(error)
                }
            }
        case .Starships:
            swapiClient.fetchStarships { result in
                switch result {
                case .Success(let starships): self.starships.appendContentsOf(starships)
                case .Failure(let error): print(error)
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
