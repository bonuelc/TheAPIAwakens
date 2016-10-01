//
//  Starship.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 10/1/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import Foundation

struct Starship {
    let name: String
    let make: String
    let cost: String
    let length: String
    let `class`: String
    let crew: String
}

extension Starship: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let name = JSON["name"] as? String, make = JSON["model"] as? String, cost = JSON["cost_in_credits"] as? String, length = JSON["length"] as? String, `class` = JSON["starship_class"] as? String, crew = JSON["crew"] as? String else {
            return nil
        }
        
        self.name = name
        self.make = make
        self.cost = cost
        self.length = length
        self.`class` = `class`
        self.crew = crew
    }
}