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
        }
    }
    
    var vehicles: [Vehicle] = [] {
        didSet {
        }
    }
    
    var starships: [Starship] = [] {
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = entityTypePicked.rawValue
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
