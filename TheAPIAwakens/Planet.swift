//
//  Planet.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 10/1/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import Foundation

struct Planet: Entity {
    let name: String
    let diameter: String
    
    var size: Double? {
        return Double(diameter) ?? Double(diameter.stringByReplacingOccurrencesOfString(",", withString: ""))
    }
}

extension Planet: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let name = JSON["name"] as? String, diameter = JSON["diameter"] as? String else {
            return nil
        }
        
        self.name = name
        self.diameter = diameter
    }
}