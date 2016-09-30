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
}

