//
//  StatisticTableViewCell.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 10/5/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import UIKit

extension String {
    var english: String? {
        
        guard let oldValue = Double(self) else {
            return nil
        }
        
        let formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 2
        
        return formatter.stringFromNumber(oldValue * 3.28084)
    }
    
    var usd: String? {
        guard let oldValue = Double(self) else {
            return nil
        }
        
        let formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 2
        
        return formatter.stringFromNumber(oldValue * 3.28084)
    }
}

class StatisticTableViewCell: UITableViewCell {
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
    
    var size: String?
    var cost: String?
    
    override func layoutSubviews() {
        if let size = size {
            unitsSegmentedControl.setTitle("English", forSegmentAtIndex: 0)
            unitsSegmentedControl.setTitle("Metric", forSegmentAtIndex: 1)
            valueLabel.text = unitsSegmentedControl.titleForSegmentAtIndex(unitsSegmentedControl.selectedSegmentIndex) == "English" ? (size.english ?? size) : size
            
            unitsSegmentedControl.hidden = false
        } else if let cost = cost {
            unitsSegmentedControl.setTitle("USD", forSegmentAtIndex: 0)
            unitsSegmentedControl.setTitle("Credits", forSegmentAtIndex: 1)
            valueLabel.text = unitsSegmentedControl.titleForSegmentAtIndex(unitsSegmentedControl.selectedSegmentIndex) == "USD" ? (cost.usd ?? cost) : cost
            
            unitsSegmentedControl.hidden = false
        }
    }
}
