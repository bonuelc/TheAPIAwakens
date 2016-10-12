//
//  ConversionTableViewCell.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 10/11/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import UIKit

class ConversionTableViewCell: UITableViewCell {
    
    var lastValue: Double = 1.01

    var delegate: ExchangeRateDelegate!
    
    @IBOutlet weak var decimalPadTextField: UITextField!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        decimalPadTextField.delegate = self
        
        revertExchangeRate()
        
        setExchangeRate()
    }
    
    func setExchangeRate() {
        
        guard var delegate = delegate, let exchangeRateString = decimalPadTextField.text, exchangeRate = Double(exchangeRateString) else {
            revertExchangeRate()
            return
        }
        
        delegate.exchangeRate = exchangeRate
    }
    
    func revertExchangeRate() {
        decimalPadTextField.text = "\(lastValue)"
    }
}

extension ConversionTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        // save the last input in case user enters nothing for the exchange rate
        lastValue = Double(textField.text!)!
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        setExchangeRate()
    }
}