//
//  ShowcaseTableView.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 10/6/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import UIKit

class ShowcaseTableView: UITableView {
    var smallest: Entity?
    var largest: Entity?
}

extension ShowcaseTableView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? StatisticTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = "Smallest"
            cell.valueLabel.text = smallest?.name ?? ""
        case 1:
            cell.keyLabel.text = "Largest"
            cell.valueLabel.text = largest?.name ?? ""
        default: break
        }
        
        return cell
    }
}
