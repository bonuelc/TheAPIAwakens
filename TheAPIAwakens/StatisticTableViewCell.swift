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
    
    func usd(exchangeRate: Double?) -> String? {
        
        guard let oldValue = Double(self), exchangeRate = exchangeRate else {
            return nil
        }
        
        let formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 2
        
        return formatter.stringFromNumber(oldValue * exchangeRate)
    }
}

class StatisticTableViewCell: UITableViewCell {
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitsSegmentedControl: UISegmentedControl!
    
    var size: String?
    var cost: String?
    var exchangeRate: Double?
    
    override func layoutSubviews() {
        if let size = size {
            unitsSegmentedControl.setTitle("English", forSegmentAtIndex: 0)
            unitsSegmentedControl.setTitle("Metric", forSegmentAtIndex: 1)
            valueLabel.text = unitsSegmentedControl.titleForSegmentAtIndex(unitsSegmentedControl.selectedSegmentIndex) == "English" ? (size.english ?? size) : size
            
            unitsSegmentedControl.hidden = false
        } else if let cost = cost {
            unitsSegmentedControl.setTitle("USD", forSegmentAtIndex: 0)
            unitsSegmentedControl.setTitle("Credits", forSegmentAtIndex: 1)
            valueLabel.text = unitsSegmentedControl.titleForSegmentAtIndex(unitsSegmentedControl.selectedSegmentIndex) == "USD" ? (cost.usd(exchangeRate) ?? cost) : cost
            
            unitsSegmentedControl.hidden = false
        } else {
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            valueLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
        }
    }
    
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        guard let workingUnit = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex) else {
            return
        }
        
        switch workingUnit {
        case "Metric": valueLabel.text = size
        case "English": valueLabel.text = size?.english ?? size
        case "Credits": valueLabel.text = cost
        case "USD": valueLabel.text = cost?.usd(exchangeRate) ?? cost
        default: break
        }
    }
}
