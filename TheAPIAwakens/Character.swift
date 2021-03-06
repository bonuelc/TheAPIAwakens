//
//  Character.swift
//  TheAPIAwakens
//
//  Created by Christopher Bonuel on 9/30/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

import Foundation

struct Character: Entity {
    let name: String
    let born: String
    let home: String
    let height: String
    let eyes: String
    let hair: String
    let vehicleEndpoints: [String]
    let starshipEndpoints: [String]
    
    var size: Double? {
        return Double(height) ?? Double(height.stringByReplacingOccurrencesOfString(",", withString: ""))
    }
}

extension Character: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let name = JSON["name"] as? String, born = JSON["birth_year"] as? String, homeworld = JSON["homeworld"] as? String, height = JSON["height"] as? String, centimeters = Double(height), eyes = JSON["eye_color"] as? String, hair = JSON["hair_color"] as? String, vehicleEndpoints = JSON["vehicles"] as? [String], starshipsEndpoints = JSON["starships"] as? [String] else {
            return nil
        }
        
        let heightInMeters = "\(centimeters / 100.0)"
        
        self.name = name
        self.born = born
        self.home = homeworld
        self.height = heightInMeters
        self.eyes = eyes
        self.hair = hair
        self.vehicleEndpoints = vehicleEndpoints
        self.starshipEndpoints = starshipsEndpoints
    }
}
