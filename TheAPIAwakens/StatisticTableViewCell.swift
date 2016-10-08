//
//  StatisticTableViewCell.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 10/5/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import UIKit

class StatisticTableViewCell: UITableViewCell {
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
    
    var size: String?
    var cost: String?
}
