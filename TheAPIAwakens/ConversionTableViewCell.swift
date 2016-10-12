//
//  ConversionTableViewCell.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 10/11/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import UIKit

class ConversionTableViewCell: UITableViewCell {

    var delegate: ExchangeRateDelegate!
    
    @IBOutlet weak var decimalPadTextField: UITextField!
}