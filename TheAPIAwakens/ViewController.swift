//
//  ViewController.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 8/19/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var charactersButton: UIButton!
    @IBOutlet weak var vehiclesButton: UIButton!
    @IBOutlet weak var starshipsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let statisticsVC = segue.destinationViewController as? StatisticsViewController, sender = sender as? UIButton else {
            return
        }
        
        switch sender {
        case charactersButton: statisticsVC.entityTypePicked = .Characters
        case vehiclesButton: statisticsVC.entityTypePicked = .Vehicles
        case starshipsButton: statisticsVC.entityTypePicked = .Starships
        default: fatalError()
        }
    }
}

